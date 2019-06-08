library calendar_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:table_calendar/table_calendar.dart';

part 'calendar_state.g.dart';

abstract class CalendarState
    implements Built<CalendarState, CalendarStateBuilder> {
  DateTime get selectedDate;
  BuiltList<CardEntity> get activeCards;
  BuiltList<CardEntity> get archivedCards;
  BuiltMap<DateTime, List<CardEntity>> get activeEvents;
  BuiltMap<DateTime, List<CardEntity>> get archivedEvents;
  CalendarFormat get calendarFormat;
  bool get calendarVisible;
  bool get cardNameHasError;
  bool get archiveVisible;

  CalendarState._();
  factory CalendarState({
    DateTime selectedDate,
    BuiltList<CardEntity> activeCards,
    BuiltList<CardEntity> archivedCards,
    BuiltMap<DateTime, List<CardEntity>> activeEvents,
    BuiltMap<DateTime, List<CardEntity>> archivedEvents,
    CalendarFormat calendarFormat = CalendarFormat.week,
    bool calendarVisible = true,
    bool cardNameHasError = false,
    bool archiveVisible = false,
  }) =>
      _$CalendarState._(
        selectedDate: selectedDate,
        activeCards: activeCards ?? BuiltList(),
        archivedCards: archivedCards ?? BuiltList(),
        activeEvents: activeEvents ?? BuiltMap(),
        archivedEvents: archivedEvents ?? BuiltMap(),
        calendarFormat: calendarFormat,
        calendarVisible: calendarVisible,
        cardNameHasError: cardNameHasError,
        archiveVisible: archiveVisible,
      );
}
