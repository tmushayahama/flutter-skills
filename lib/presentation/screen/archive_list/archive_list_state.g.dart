// GENERATED CODE - DO NOT MODIFY BY HAND

part of archive_list_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ArchiveListState extends ArchiveListState {
  @override
  final BuiltList<CardEntity> archivedCards;
  @override
  final Task clearTask;

  factory _$ArchiveListState([void updates(ArchiveListStateBuilder b)]) =>
      (new ArchiveListStateBuilder()..update(updates)).build();

  _$ArchiveListState._({this.archivedCards, this.clearTask}) : super._() {
    if (archivedCards == null) {
      throw new BuiltValueNullFieldError('ArchiveListState', 'archivedCards');
    }
    if (clearTask == null) {
      throw new BuiltValueNullFieldError('ArchiveListState', 'clearTask');
    }
  }

  @override
  ArchiveListState rebuild(void updates(ArchiveListStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  ArchiveListStateBuilder toBuilder() =>
      new ArchiveListStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ArchiveListState &&
        archivedCards == other.archivedCards &&
        clearTask == other.clearTask;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, archivedCards.hashCode), clearTask.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArchiveListState')
          ..add('archivedCards', archivedCards)
          ..add('clearTask', clearTask))
        .toString();
  }
}

class ArchiveListStateBuilder
    implements Builder<ArchiveListState, ArchiveListStateBuilder> {
  _$ArchiveListState _$v;

  ListBuilder<CardEntity> _archivedCards;
  ListBuilder<CardEntity> get archivedCards =>
      _$this._archivedCards ??= new ListBuilder<CardEntity>();
  set archivedCards(ListBuilder<CardEntity> archivedCards) =>
      _$this._archivedCards = archivedCards;

  Task _clearTask;
  Task get clearTask => _$this._clearTask;
  set clearTask(Task clearTask) => _$this._clearTask = clearTask;

  ArchiveListStateBuilder();

  ArchiveListStateBuilder get _$this {
    if (_$v != null) {
      _archivedCards = _$v.archivedCards?.toBuilder();
      _clearTask = _$v.clearTask;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ArchiveListState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ArchiveListState;
  }

  @override
  void update(void updates(ArchiveListStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$ArchiveListState build() {
    _$ArchiveListState _$result;
    try {
      _$result = _$v ??
          new _$ArchiveListState._(
              archivedCards: archivedCards.build(), clearTask: clearTask);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'archivedCards';
        archivedCards.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'ArchiveListState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
