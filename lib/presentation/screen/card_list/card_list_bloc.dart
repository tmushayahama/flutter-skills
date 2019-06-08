import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';
import 'package:mt/presentation/app.dart';
import 'package:mt/presentation/screen/card_list/card_list_actions.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import 'card_list_state.dart';

class CardListBloc {
  Sink get actions => _actions;
  final _actions = StreamController();

  CardListState get initialState => _state.value;
  Stream<CardListState> get state => _state.stream.distinct();
  final _state = BehaviorSubject<CardListState>.seeded(
    CardListState(),
  );

  StreamSubscription<Task> _diskAccessSubscription;
  StreamSubscription<Tuple2<String, List<CardEntity>>> _cardsSubscription;
  StreamSubscription _notificationSubscription;

  CardListBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case PerformOnCard:
          _onPerform(action);
          break;
        case ReorderCard:
          _onReorder(action);
          break;
        case FilterBy:
          _onFilterBy(action);
          break;
        default:
          assert(false);
      }
    });

    _cardsSubscription = Observable.combineLatest2(
      dependencies.cardInteractor.filter,
      dependencies.cardInteractor.active,
      (a, b) => Tuple2<String, List<CardEntity>>(a, b),
    ).listen((data) {
      List<CardEntity> list = [];
      if (data.item1 == 'All') {
        list = data.item2;
      } else if (data.item1 == 'Favorite') {
        list = data.item2.where((e) => e.isFavorite).toList();
      } else {
        list = data.item2.where((e) => e.tags.contains(data.item1)).toList();
      }

      _state.add(_state.value.rebuild((b) => b..cards = ListBuilder(list)));
    });

    Future.delayed(Duration(milliseconds: 500), () {
      dependencies.cardInteractor.clearNotifications();
    });

    _notificationSubscription =
        Observable.periodic(Duration(seconds: 15)).listen(
      (_) => dependencies.cardInteractor.clearNotifications(),
    );
  }

  void _onPerform(PerformOnCard action) {
    final card = action.card;
    final operation = action.operation;

    switch (operation) {
      case Operation.add:
        _onAdd(card);
        break;
      case Operation.archive:
        _onArchive(card);
        break;
      case Operation.favorite:
        _onFavorite(card);
        break;
    }
  }

  void _onAdd(CardEntity card) {
    _state.add(
        _state.value.rebuild((b) => b..cardNameHasError = isBlank(card.name)));

    if (_state.value.cardNameHasError) {
      return;
    }

    _diskAccessSubscription?.cancel();
    _diskAccessSubscription =
        dependencies.cardInteractor.add(card).listen((task) {
      _state.add(_state.value.rebuild((b) => b..diskAccessTask = task));
    });
  }

  void _onArchive(CardEntity card) {
    final cardBuilder = card.toBuilder();
    cardBuilder.status = CardStatus.finished;
    cardBuilder.finishedDate = DateTime.now();

    _diskAccessSubscription?.cancel();
    _diskAccessSubscription = dependencies.cardInteractor
        .archiveCard(cardBuilder.build())
        .listen((task) {
      _state.add(_state.value.rebuild((b) => b..diskAccessTask = task));
    });
  }

  void _onFavorite(CardEntity card) {
    final cardBuilder = card.toBuilder();
    cardBuilder.isFavorite = !card.isFavorite;

    _diskAccessSubscription?.cancel();
    _diskAccessSubscription =
        dependencies.cardInteractor.update(cardBuilder.build()).listen((task) {
      _state.add(_state.value.rebuild((b) => b..diskAccessTask = task));
    });
  }

  void _onReorder(ReorderCard action) {
    _diskAccessSubscription?.cancel();
    _diskAccessSubscription = dependencies.cardInteractor
        .reorder(action.oldIndex, action.newIndex)
        .listen((task) {
      _state.add(_state.value.rebuild((b) => b..diskAccessTask = task));
    });
  }

  void _onFilterBy(FilterBy action) {
    final filter = action.filter;

    _state.add(_state.value.rebuild((b) => b..filter = filter));
    dependencies.cardInteractor.setFilter(filter);
  }

  void dispose() {
    _actions.close();
    _state.close();

    _cardsSubscription?.cancel();
    _diskAccessSubscription?.cancel();
    _notificationSubscription?.cancel();
  }
}
