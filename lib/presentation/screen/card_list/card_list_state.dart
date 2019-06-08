library card_list_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';

part 'card_list_state.g.dart';

abstract class CardListState
    implements Built<CardListState, CardListStateBuilder> {
  BuiltList<CardEntity> get cards;
  bool get cardNameHasError;
  String get filter;
  Task get diskAccessTask;

  CardListState._();
  factory CardListState({
    BuiltList<CardEntity> cards,
    bool cardNameHasError = false,
    String filter = 'All',
    Task diskAccessTask = const Task.idle(),
  }) =>
      _$CardListState._(
        cards: cards ?? BuiltList(),
        cardNameHasError: cardNameHasError,
        filter: filter,
        diskAccessTask: diskAccessTask,
      );
}
