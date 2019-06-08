// GENERATED CODE - DO NOT MODIFY BY HAND

part of calendar_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CalendarState extends CalendarState {
  @override
  final DateTime selectedDate;
  @override
  final BuiltList<CardEntity> activeCards;
  @override
  final BuiltList<CardEntity> archivedCards;
  @override
  final BuiltMap<DateTime, List<CardEntity>> activeEvents;
  @override
  final BuiltMap<DateTime, List<CardEntity>> archivedEvents;
  @override
  final CalendarFormat calendarFormat;
  @override
  final bool calendarVisible;
  @override
  final bool cardNameHasError;
  @override
  final bool archiveVisible;

  factory _$CalendarState([void updates(CalendarStateBuilder b)]) =>
      (new CalendarStateBuilder()..update(updates)).build();

  _$CalendarState._(
      {this.selectedDate,
      this.activeCards,
      this.archivedCards,
      this.activeEvents,
      this.archivedEvents,
      this.calendarFormat,
      this.calendarVisible,
      this.cardNameHasError,
      this.archiveVisible})
      : super._() {
    if (selectedDate == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'selectedDate');
    }
    if (activeCards == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'activeCards');
    }
    if (archivedCards == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'archivedCards');
    }
    if (activeEvents == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'activeEvents');
    }
    if (archivedEvents == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'archivedEvents');
    }
    if (calendarFormat == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'calendarFormat');
    }
    if (calendarVisible == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'calendarVisible');
    }
    if (cardNameHasError == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'cardNameHasError');
    }
    if (archiveVisible == null) {
      throw new BuiltValueNullFieldError('CalendarState', 'archiveVisible');
    }
  }

  @override
  CalendarState rebuild(void updates(CalendarStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CalendarStateBuilder toBuilder() => new CalendarStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CalendarState &&
        selectedDate == other.selectedDate &&
        activeCards == other.activeCards &&
        archivedCards == other.archivedCards &&
        activeEvents == other.activeEvents &&
        archivedEvents == other.archivedEvents &&
        calendarFormat == other.calendarFormat &&
        calendarVisible == other.calendarVisible &&
        cardNameHasError == other.cardNameHasError &&
        archiveVisible == other.archiveVisible;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc($jc(0, selectedDate.hashCode),
                                    activeCards.hashCode),
                                archivedCards.hashCode),
                            activeEvents.hashCode),
                        archivedEvents.hashCode),
                    calendarFormat.hashCode),
                calendarVisible.hashCode),
            cardNameHasError.hashCode),
        archiveVisible.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CalendarState')
          ..add('selectedDate', selectedDate)
          ..add('activeCards', activeCards)
          ..add('archivedCards', archivedCards)
          ..add('activeEvents', activeEvents)
          ..add('archivedEvents', archivedEvents)
          ..add('calendarFormat', calendarFormat)
          ..add('calendarVisible', calendarVisible)
          ..add('cardNameHasError', cardNameHasError)
          ..add('archiveVisible', archiveVisible))
        .toString();
  }
}

class CalendarStateBuilder
    implements Builder<CalendarState, CalendarStateBuilder> {
  _$CalendarState _$v;

  DateTime _selectedDate;
  DateTime get selectedDate => _$this._selectedDate;
  set selectedDate(DateTime selectedDate) =>
      _$this._selectedDate = selectedDate;

  ListBuilder<CardEntity> _activeCards;
  ListBuilder<CardEntity> get activeCards =>
      _$this._activeCards ??= new ListBuilder<CardEntity>();
  set activeCards(ListBuilder<CardEntity> activeCards) =>
      _$this._activeCards = activeCards;

  ListBuilder<CardEntity> _archivedCards;
  ListBuilder<CardEntity> get archivedCards =>
      _$this._archivedCards ??= new ListBuilder<CardEntity>();
  set archivedCards(ListBuilder<CardEntity> archivedCards) =>
      _$this._archivedCards = archivedCards;

  MapBuilder<DateTime, List<CardEntity>> _activeEvents;
  MapBuilder<DateTime, List<CardEntity>> get activeEvents =>
      _$this._activeEvents ??= new MapBuilder<DateTime, List<CardEntity>>();
  set activeEvents(MapBuilder<DateTime, List<CardEntity>> activeEvents) =>
      _$this._activeEvents = activeEvents;

  MapBuilder<DateTime, List<CardEntity>> _archivedEvents;
  MapBuilder<DateTime, List<CardEntity>> get archivedEvents =>
      _$this._archivedEvents ??= new MapBuilder<DateTime, List<CardEntity>>();
  set archivedEvents(MapBuilder<DateTime, List<CardEntity>> archivedEvents) =>
      _$this._archivedEvents = archivedEvents;

  CalendarFormat _calendarFormat;
  CalendarFormat get calendarFormat => _$this._calendarFormat;
  set calendarFormat(CalendarFormat calendarFormat) =>
      _$this._calendarFormat = calendarFormat;

  bool _calendarVisible;
  bool get calendarVisible => _$this._calendarVisible;
  set calendarVisible(bool calendarVisible) =>
      _$this._calendarVisible = calendarVisible;

  bool _cardNameHasError;
  bool get cardNameHasError => _$this._cardNameHasError;
  set cardNameHasError(bool cardNameHasError) =>
      _$this._cardNameHasError = cardNameHasError;

  bool _archiveVisible;
  bool get archiveVisible => _$this._archiveVisible;
  set archiveVisible(bool archiveVisible) =>
      _$this._archiveVisible = archiveVisible;

  CalendarStateBuilder();

  CalendarStateBuilder get _$this {
    if (_$v != null) {
      _selectedDate = _$v.selectedDate;
      _activeCards = _$v.activeCards?.toBuilder();
      _archivedCards = _$v.archivedCards?.toBuilder();
      _activeEvents = _$v.activeEvents?.toBuilder();
      _archivedEvents = _$v.archivedEvents?.toBuilder();
      _calendarFormat = _$v.calendarFormat;
      _calendarVisible = _$v.calendarVisible;
      _cardNameHasError = _$v.cardNameHasError;
      _archiveVisible = _$v.archiveVisible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CalendarState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CalendarState;
  }

  @override
  void update(void updates(CalendarStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CalendarState build() {
    _$CalendarState _$result;
    try {
      _$result = _$v ??
          new _$CalendarState._(
              selectedDate: selectedDate,
              activeCards: activeCards.build(),
              archivedCards: archivedCards.build(),
              activeEvents: activeEvents.build(),
              archivedEvents: archivedEvents.build(),
              calendarFormat: calendarFormat,
              calendarVisible: calendarVisible,
              cardNameHasError: cardNameHasError,
              archiveVisible: archiveVisible);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'activeCards';
        activeCards.build();
        _$failedField = 'archivedCards';
        archivedCards.build();
        _$failedField = 'activeEvents';
        activeEvents.build();
        _$failedField = 'archivedEvents';
        archivedEvents.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CalendarState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
