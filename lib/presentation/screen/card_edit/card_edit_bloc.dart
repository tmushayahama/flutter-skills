import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'card_edit_actions.dart';
import 'card_edit_state.dart';

class CardEditBloc {
  Sink get actions => _actions;
  final _actions = StreamController();

  CardEditState get initialState => _state.value;
  Stream<CardEditState> get state => _state.stream.distinct();
  final BehaviorSubject<CardEditState> _state;

  CardEditBloc({@required CardEntity card})
      : _state = BehaviorSubject<CardEditState>.seeded(
          CardEditState(card: card),
        ) {
    _actions.stream.listen((action) {
      switch (action.runtimeType) {
        case UpdateField:
          _onUpdateField(action);
          break;
        case ToggleTag:
          _onToggleTag(action);
          break;
        case SetImage:
          _onSetImage(action);
          break;
      }
    });
  }

  void dispose() {
    _actions.close();
    _state.close();
  }

  void _onUpdateField(UpdateField action) {
    final state = _state.value.toBuilder();

    switch (action.key) {
      case FieldKey.name:
        state.card.name = action.value;
        state.cardNameHasError = isBlank(state.card.name);
        break;
      case FieldKey.description:
        state.card.description = action.value;
        break;
      case FieldKey.bulletPoints:
        state.card.bulletPoints = ListBuilder(action.value);
        break;
      case FieldKey.dueDate:
        state.card.dueDate = action.value;
        break;
      case FieldKey.notificationDate:
        state.card.notificationDate = action.value;
        break;
    }

    _state.add(state.build());
  }

  void _onToggleTag(ToggleTag action) {
    final tag = action.tag;
    final state = _state.value.toBuilder();
    final tags = state.card.tags;

    if (_state.value.card.tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }

    tags.sort();
    _state.add(state.build());
  }

  void _onSetImage(SetImage action) {
    final state = _state.value.toBuilder();
    state.image = action.image;
    state.card.imagePath = action.image?.path ?? '';

    _state.add(state.build());
  }
}
