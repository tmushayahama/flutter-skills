import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:mt/data/dao/in_memory.dart';
import 'package:mt/data/json/card_json.dart';
import 'package:mt/data/mapper/card_mapper.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardDao {
  Stream<List<CardEntity>> get all =>
      _data.stream().asBroadcastStream().map((it) => it.toList());

  Stream<List<CardEntity>> get active => _data.stream().asBroadcastStream().map(
        (it) => it.where((e) => e.status == CardStatus.active).toList(),
      );

  Stream<List<CardEntity>> get finished =>
      _data.stream().asBroadcastStream().map(
            (it) => it.where((e) => e.status == CardStatus.finished).toList(),
          );

  Stream<String> get filter => _filter.stream();

  final _data = InMemory<BuiltList<CardEntity>>(seedValue: BuiltList());
  final _filter = InMemory<String>();

  CardDao() {
    _loadFromDisk();
    _filter.add('All');
    _filter.seedValue = 'All';
  }

  void setFilter(String value) {
    _filter.add(value);
  }

  void _loadFromDisk() async {
    var cardsFromDisk = List<CardEntity>();
    final prefs = await SharedPreferences.getInstance();

    try {
      final data = prefs.getStringList('cards');

      if (data != null) {
        cardsFromDisk = data.map((task) {
          final decodedTask = json.decode(task);
          final cardJson = CardJson.parse(decodedTask);
          return CardMapper.fromJson(cardJson);
        }).toList();
      }
    } catch (e) {
      print('LoadFromDisk error: $e');
    }

    final list = BuiltList<CardEntity>(cardsFromDisk);
    _data.add(list);
    _data.seedValue = list;
  }

  Future<bool> _saveToDisk() async {
    var result = false;
    final prefs = await SharedPreferences.getInstance();
    final data = _data?.value?.toList();

    try {
      final jsonList = data.map((card) {
        final cardJson = CardMapper.toJson(card);
        final encodedCard = cardJson.encode();
        return json.encode(encodedCard);
      }).toList();

      result = await prefs.setStringList('cards', jsonList);
    } catch (e) {
      print('SaveToDisk error: $e');
    }

    return result;
  }

  Future<bool> add(CardEntity card) {
    final data = _data.value.toBuilder();
    int index =
        _data.value.lastIndexWhere((it) => it.status == CardStatus.active) + 1;

    data.insert(index, card);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> remove(CardEntity card) {
    final data = _data.value.toBuilder();
    data.remove(card);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> update(CardEntity card) async {
    if (_data.value == null) {
      return false;
    }

    // addedDate serves as a unique key here
    final current =
        _data.value.where((it) => it.addedDate.compareTo(card.addedDate) == 0);
    if (current.isEmpty) {
      return false;
    }

    final data = _data.value.toBuilder();
    data[_data.value.indexOf(current.first)] = card;
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> pushUpdatedBottom(CardEntity card) async {
    if (_data.value == null) {
      return false;
    }

    final current = _data.value.firstWhere(
        (it) => it.addedDate.compareTo(card.addedDate) == 0,
        orElse: null);
    if (current == null) {
      return false;
    }

    final data = _data.value.toBuilder();
    data.remove(current);
    data.add(card);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> reorder(int oldIndex, int newIndex) async {
    final data = _data.value.toBuilder();
    final currentFilter = await filter.first;
    newIndex = newIndex < oldIndex ? newIndex : newIndex - 1;
    var oldId;
    var newId;

    if (currentFilter == 'All') {
      final currentList =
          _data.value.where((it) => it.status == CardStatus.active);
      oldId = _data.value.indexOf(currentList.elementAt(oldIndex));
      newId = _data.value.indexOf(currentList.elementAt(newIndex));
    } else if (currentFilter == 'Favorite') {
      final currentList = _data.value
          .where((it) => it.isFavorite && it.status == CardStatus.active);
      oldId = _data.value.indexOf(currentList.elementAt(oldIndex));
      newId = _data.value.indexOf(currentList.elementAt(newIndex));
    } else {
      final currentList = _data.value.where((it) =>
          it.tags.contains(currentFilter) && it.status == CardStatus.active);
      oldId = _data.value.indexOf(currentList.elementAt(oldIndex));
      newId = _data.value.indexOf(currentList.elementAt(newIndex));
    }

    final card = data[oldId];

    data.removeAt(oldId);
    data.insert(newId, card);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> clearFinished() {
    final data = _data.value.toBuilder();
    data.removeWhere((e) => e.status == CardStatus.finished);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> clearDailyFinished(DateTime day) {
    final data = _data.value.toBuilder();
    data.removeWhere(
        (e) => e.status == CardStatus.finished && e.dueDate == day);
    _data.add(data.build());

    return _saveToDisk();
  }

  Future<bool> clearNotifications() async {
    bool cacheDirty = false;
    final data = _data.value.toBuilder();

    data.map((e) {
      final clear = e.notificationDate?.isBefore(DateTime.now()) ?? false;
      if (clear) {
        cacheDirty = true;
        return e.rebuild((b) => b..notificationDate = null);
      } else {
        return e;
      }
    });

    if (cacheDirty) {
      final list = data.build();
      _data.add(list);
      _data.seedValue = list;
      return _saveToDisk();
    } else {
      return false;
    }
  }
}
