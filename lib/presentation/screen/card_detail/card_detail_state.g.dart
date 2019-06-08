// GENERATED CODE - DO NOT MODIFY BY HAND

part of card_detail_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardDetailState extends CardDetailState {
  @override
  final CardEntity card;
  @override
  final Task updateTask;

  factory _$CardDetailState([void updates(CardDetailStateBuilder b)]) =>
      (new CardDetailStateBuilder()..update(updates)).build();

  _$CardDetailState._({this.card, this.updateTask}) : super._() {
    if (card == null) {
      throw new BuiltValueNullFieldError('CardDetailState', 'card');
    }
    if (updateTask == null) {
      throw new BuiltValueNullFieldError('CardDetailState', 'updateTask');
    }
  }

  @override
  CardDetailState rebuild(void updates(CardDetailStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardDetailStateBuilder toBuilder() =>
      new CardDetailStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardDetailState &&
        card == other.card &&
        updateTask == other.updateTask;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, card.hashCode), updateTask.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardDetailState')
          ..add('card', card)
          ..add('updateTask', updateTask))
        .toString();
  }
}

class CardDetailStateBuilder
    implements Builder<CardDetailState, CardDetailStateBuilder> {
  _$CardDetailState _$v;

  CardEntityBuilder _card;
  CardEntityBuilder get card => _$this._card ??= new CardEntityBuilder();
  set card(CardEntityBuilder card) => _$this._card = card;

  Task _updateTask;
  Task get updateTask => _$this._updateTask;
  set updateTask(Task updateTask) => _$this._updateTask = updateTask;

  CardDetailStateBuilder();

  CardDetailStateBuilder get _$this {
    if (_$v != null) {
      _card = _$v.card?.toBuilder();
      _updateTask = _$v.updateTask;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardDetailState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardDetailState;
  }

  @override
  void update(void updates(CardDetailStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardDetailState build() {
    _$CardDetailState _$result;
    try {
      _$result = _$v ??
          new _$CardDetailState._(card: card.build(), updateTask: updateTask);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardDetailState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
