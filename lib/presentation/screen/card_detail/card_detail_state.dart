library card_detail_state;

import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';

part 'card_detail_state.g.dart';

abstract class CardDetailState
    implements Built<CardDetailState, CardDetailStateBuilder> {
  CardEntity get card;
  Task get updateTask;

  CardDetailState._();
  factory CardDetailState({
    CardEntity card,
    Task updateTask = const Task.idle(),
  }) =>
      _$CardDetailState._(
        card: card,
        updateTask: updateTask,
      );
}
