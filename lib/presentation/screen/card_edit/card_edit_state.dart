library card_edit_state;

import 'dart:io';

import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/card_entity.dart';

part 'card_edit_state.g.dart';

abstract class CardEditState
    implements Built<CardEditState, CardEditStateBuilder> {
  CardEntity get card;
  @nullable
  File get image;
  bool get cardNameHasError;

  CardEditState._();
  factory CardEditState({
    CardEntity card,
    File image,
    bool cardNameHasError = false,
  }) =>
      _$CardEditState._(
        card: card,
        image: image,
        cardNameHasError: cardNameHasError,
      );
}
