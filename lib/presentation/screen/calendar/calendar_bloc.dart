import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/app.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:rxdart/rxdart.dart';

import 'calendar_actions.dart';
import 'calendar_state.dart';

class CalendarBloc {
  Sink get actions => _actions;
  final _actions = StreamController();

  CalendarState get initialState => _state.value;
  Stream<CalendarState> get state => _state.stream.distinct();

  final _state = BehaviorSubject<CalendarState>.seeded(
    CalendarState(
      selectedDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    ),
  );

  StreamSubscription<List<CardEntity>> _cardsSubscription;

  CalendarBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case UpdateField:
          _onUpdateField(action);
          break;
        case PerformOnCard:
          _onPerform(action);
          break;
        case ToggleArchive:
          _onToggle();
          break;
        case ClearDailyArchive:
          _onClearDailyArchive();
          break;
        default:
          assert(false);
      }
    });

    _cardsSubscription = dependencies.cardInteractor.all.listen((data) {
      final cards = data.where((card) => card.dueDate != null);
      final active = cards.where((card) => card.status == CardStatus.active);
      final archived =
          cards.where((card) => card.status == CardStatus.finished);

      final activeEvents = groupBy(active, (CardEntity card) => card.dueDate);
      final archivedEvents =
          groupBy(archived, (CardEntity card) => card.dueDate);

      _state.add(_state.value.rebuild(
        (b) => b
          ..activeEvents = MapBuilder(activeEvents)
          ..archivedEvents = MapBuilder(archivedEvents),
      ));
    });

    state.listen((data) {
      _state.add(_state.value.rebuild(
        (b) => b
          ..activeCards = ListBuilder(b.activeEvents[b.selectedDate] ?? [])
          ..archivedCards = ListBuilder(b.archivedEvents[b.selectedDate] ?? []),
      ));
    });
  }

  void dispose() {
    _actions.close();
    _state.close();
    _cardsSubscription.cancel();
  }

  void _onUpdateField(UpdateField action) {
    final state = _state.value.toBuilder();

    switch (action.field) {
      case Field.selectedDate:
        state.selectedDate = action.value;
        break;
      case Field.calendarFormat:
        state.calendarFormat = action.value;
        break;
      case Field.calendarVisible:
        state.calendarVisible = action.value;
        break;
      default:
        assert(false);
    }

    _state.add(state.build());
  }

  void _onPerform(PerformOnCard action) {
    switch (action.operation) {
      case Operation.add:
        _onAdd(action.card);
        break;
      case Operation.favorite:
        _onFavorite(action.card);
        break;
      case Operation.archive:
        _onArchive(action.card);
        break;
      default:
        assert(false);
    }
  }

  void _onAdd(CardEntity card) {
    _state.add(_state.value.rebuild(
      (b) => b..cardNameHasError = isBlank(card.name),
    ));

    if (_state.value.cardNameHasError) {
      return;
    }

    dependencies.cardInteractor.add(card);
  }

  void _onFavorite(CardEntity card) {
    dependencies.cardInteractor.update(
      card.rebuild((b) => b..isFavorite = !b.isFavorite),
    );
  }

  void _onArchive(CardEntity card) {
    dependencies.cardInteractor.archiveCard(
      card.rebuild(
        (b) => b
          ..status = CardStatus.finished
          ..finishedDate = DateTime.now(),
      ),
    );
  }

  void _onToggle() {
    _state.add(
        _state.value.rebuild((b) => b..archiveVisible = !b.archiveVisible));
  }

  void _onClearDailyArchive() {
    dependencies.cardInteractor.clearDailyArchive(_state.value.selectedDate);
  }
}
