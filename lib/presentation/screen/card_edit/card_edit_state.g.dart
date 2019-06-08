// GENERATED CODE - DO NOT MODIFY BY HAND

part of card_edit_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CardEditState extends CardEditState {
  @override
  final CardEntity card;
  @override
  final File image;
  @override
  final bool cardNameHasError;

  factory _$CardEditState([void updates(CardEditStateBuilder b)]) =>
      (new CardEditStateBuilder()..update(updates)).build();

  _$CardEditState._({this.card, this.image, this.cardNameHasError})
      : super._() {
    if (card == null) {
      throw new BuiltValueNullFieldError('CardEditState', 'card');
    }
    if (cardNameHasError == null) {
      throw new BuiltValueNullFieldError('CardEditState', 'cardNameHasError');
    }
  }

  @override
  CardEditState rebuild(void updates(CardEditStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  CardEditStateBuilder toBuilder() => new CardEditStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CardEditState &&
        card == other.card &&
        image == other.image &&
        cardNameHasError == other.cardNameHasError;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, card.hashCode), image.hashCode), cardNameHasError.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CardEditState')
          ..add('card', card)
          ..add('image', image)
          ..add('cardNameHasError', cardNameHasError))
        .toString();
  }
}

class CardEditStateBuilder
    implements Builder<CardEditState, CardEditStateBuilder> {
  _$CardEditState _$v;

  CardEntityBuilder _card;
  CardEntityBuilder get card => _$this._card ??= new CardEntityBuilder();
  set card(CardEntityBuilder card) => _$this._card = card;

  File _image;
  File get image => _$this._image;
  set image(File image) => _$this._image = image;

  bool _cardNameHasError;
  bool get cardNameHasError => _$this._cardNameHasError;
  set cardNameHasError(bool cardNameHasError) =>
      _$this._cardNameHasError = cardNameHasError;

  CardEditStateBuilder();

  CardEditStateBuilder get _$this {
    if (_$v != null) {
      _card = _$v.card?.toBuilder();
      _image = _$v.image;
      _cardNameHasError = _$v.cardNameHasError;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CardEditState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CardEditState;
  }

  @override
  void update(void updates(CardEditStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$CardEditState build() {
    _$CardEditState _$result;
    try {
      _$result = _$v ??
          new _$CardEditState._(
              card: card.build(),
              image: image,
              cardNameHasError: cardNameHasError);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'card';
        card.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CardEditState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
