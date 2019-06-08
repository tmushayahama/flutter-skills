library archive_list_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';

part 'archive_list_state.g.dart';

abstract class ArchiveListState
    implements Built<ArchiveListState, ArchiveListStateBuilder> {
  BuiltList<CardEntity> get archivedCards;
  Task get clearTask;

  ArchiveListState._();
  factory ArchiveListState({
    BuiltList<CardEntity> archivedCards,
    Task clearTask = const Task.idle(),
  }) =>
      _$ArchiveListState._(
        archivedCards: archivedCards ?? BuiltList(),
        clearTask: clearTask,
      );
}
