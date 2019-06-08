// GENERATED CODE - DO NOT MODIFY BY HAND

part of card_list_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardListState extends CardListState {
  @override
  final BuiltList<CardEntity> cards;
  @override
  final bool cardNameHasError;
  @override
  final String filter;
  @override
  final Task diskAccessTask;

  factory _$CardListState([void updates(CardListStateBuilder b)]) =>
      (new CardListStateBuilder()..update(updates)).build();

  _$CardListState._(
      {this.cards, this.cardNameHasError, this.filter, this.diskAccessTask})
      : super._() {
    if (cards == null) {
      throw new BuiltValueNullFieldError('CardListState', 'cards');
    }
    if (cardNameHasError == null) {
      throw new BuiltValueNullFieldError('CardListState', 'cardNameHasError');
    }
    if (filter == null) {
      throw new BuiltValueNullFieldError('CardListState', 'filter');
    }
    if (diskAccessTask == null) {
      throw new BuiltValueNullFieldError('CardListState', 'diskAccessTask');
    }
  }

  @override
  CardListState rebuild(void updates(CardListStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardListStateBuilder toBuilder() => new CardListStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardListState &&
        cards == other.cards &&
        cardNameHasError == other.cardNameHasError &&
        filter == other.filter &&
        diskAccessTask == other.diskAccessTask;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, cards.hashCode), cardNameHasError.hashCode),
            filter.hashCode),
        diskAccessTask.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardListState')
          ..add('cards', cards)
          ..add('cardNameHasError', cardNameHasError)
          ..add('filter', filter)
          ..add('diskAccessTask', diskAccessTask))
        .toString();
  }
}

class CardListStateBuilder
    implements Builder<CardListState, CardListStateBuilder> {
  _$CardListState _$v;

  ListBuilder<CardEntity> _cards;
  ListBuilder<CardEntity> get cards =>
      _$this._cards ??= new ListBuilder<CardEntity>();
  set cards(ListBuilder<CardEntity> cards) => _$this._cards = cards;

  bool _cardNameHasError;
  bool get cardNameHasError => _$this._cardNameHasError;
  set cardNameHasError(bool cardNameHasError) =>
      _$this._cardNameHasError = cardNameHasError;

  String _filter;
  String get filter => _$this._filter;
  set filter(String filter) => _$this._filter = filter;

  Task _diskAccessTask;
  Task get diskAccessTask => _$this._diskAccessTask;
  set diskAccessTask(Task diskAccessTask) =>
      _$this._diskAccessTask = diskAccessTask;

  CardListStateBuilder();

  CardListStateBuilder get _$this {
    if (_$v != null) {
      _cards = _$v.cards?.toBuilder();
      _cardNameHasError = _$v.cardNameHasError;
      _filter = _$v.filter;
      _diskAccessTask = _$v.diskAccessTask;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardListState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardListState;
  }

  @override
  void update(void updates(CardListStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardListState build() {
    _$CardListState _$result;
    try {
      _$result = _$v ??
          new _$CardListState._(
              cards: cards.build(),
              cardNameHasError: cardNameHasError,
              filter: filter,
              diskAccessTask: diskAccessTask);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'cards';
        cards.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardListState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
