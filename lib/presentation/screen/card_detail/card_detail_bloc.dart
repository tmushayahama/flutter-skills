import 'dart:async';

import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';
import 'package:mt/presentation/app.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'card_detail_actions.dart';
import 'card_detail_state.dart';

class CardDetailBloc {
  Sink get actions => _actions;
  final _actions = StreamController();

  CardDetailState get initialState => _state.value;
  Stream<CardDetailState> get state => _state.stream.distinct();
  final BehaviorSubject<CardDetailState> _state;

  StreamSubscription<Task> _updateSubscription;
  StreamSubscription _notificationSubscription;

  CardDetailBloc({@required CardEntity card})
      : _state = BehaviorSubject<CardDetailState>.seeded(
          CardDetailState(card: card),
        ) {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case PerformOnCard:
          _onPerform(action);
          break;
        default:
          assert(false);
      }
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _clearNotification();
    });

    _notificationSubscription = Stream.periodic(Duration(seconds: 15)).listen(
      (_) => _clearNotification(),
    );
  }

  void _clearNotification() {
    final rebuild =
        _state.value.card.notificationDate?.isBefore(DateTime.now()) ?? false;

    if (rebuild) {
      final cardBuilder = _state.value.card.toBuilder();
      cardBuilder.notificationDate = null;

      dependencies.cardInteractor.update(cardBuilder.build());
      _state.add(_state.value.rebuild((b) => b..card = cardBuilder));
    }
  }

  void dispose() {
    _actions.close();
    _state.close();

    _updateSubscription?.cancel();
    _notificationSubscription?.cancel();
  }

  void _onPerform(PerformOnCard action) {
    switch (action.operation) {
      case Operation.update:
        _onUpdateCard(action.card);
        break;
      case Operation.restore:
        _onRestoreCard(action.card);
        break;
      case Operation.cleanRestore:
        _onCleanRestoreCard(action.card);
        break;
      case Operation.delete:
        _onDeleteCard(action.card);
        break;
      default:
        assert(false);
    }
  }

  void _onUpdateCard(CardEntity card) {
    _updateSubscription?.cancel();
    _updateSubscription =
        dependencies.cardInteractor.update(card).listen((task) {
      _state.add(_state.value.rebuild(
        (b) => b..updateTask = task,
      ));
    });

    _state.add(_state.value.rebuild(
      (b) => b..card = card.toBuilder(),
    ));
  }

  void _onCleanRestoreCard(CardEntity card) {
    final updatedCard = card.rebuild(
      (b) => b
        ..status = CardStatus.active
        ..notificationDate = null
        ..finishedDate = null,
    );

    dependencies.cardInteractor.restoreCard(updatedCard);
  }

  void _onRestoreCard(CardEntity card) {
    final updatedCard = card.rebuild(
      (b) => b
        ..status = CardStatus.active
        ..finishedDate = null,
    );

    dependencies.cardInteractor.restoreCard(updatedCard);
  }

  void _onDeleteCard(CardEntity card) {
    dependencies.cardInteractor.remove(card);
  }
}
