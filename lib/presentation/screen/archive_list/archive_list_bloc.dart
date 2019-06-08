import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';
import 'package:mt/presentation/app.dart';
import 'package:rxdart/rxdart.dart';

import 'archive_list_actions.dart';
import 'archive_list_state.dart';

class ArchiveListBloc {
  Sink get actions => _actions;
  final _actions = StreamController();

  ArchiveListState get initialState => _state.value;
  Stream<ArchiveListState> get state => _state.stream.distinct();
  final _state = BehaviorSubject<ArchiveListState>.seeded(
    ArchiveListState(),
  );

  StreamSubscription<List<CardEntity>> _archivedCards;
  StreamSubscription<Task> _clearTask;

  ArchiveListBloc() {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case ClearArchive:
          _onClearArchive();
          break;
        default:
          assert(false);
      }
    });

    _archivedCards = dependencies.cardInteractor.finished.listen((cards) {
      cards.sort((a, b) => a.finishedDate.compareTo(b.finishedDate));

      _state.add(_state.value.rebuild(
        (b) => b..archivedCards = ListBuilder(cards),
      ));
    });
  }

  void dispose() {
    _actions.close();
    _state.close();

    _archivedCards?.cancel();
    _clearTask?.cancel();
  }

  void _onClearArchive() {
    if (_state.value.clearTask == Task.running()) {
      return;
    }

    _clearTask?.cancel();
    _clearTask = dependencies.cardInteractor.clearArchive().listen((task) {
      _state.add(_state.value.rebuild(
        (b) => b..clearTask = task,
      ));
    });
  }
}
