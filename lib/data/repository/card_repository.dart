import 'package:mt/data/dao/card_dao.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';
import 'package:flutter/foundation.dart';

class CardRepository {
  final CardDao dao;

  CardRepository({
    @required this.dao,
  }) : assert(dao != null);

  Stream<List<CardEntity>> get all => dao.all;
  Stream<List<CardEntity>> get active => dao.active;
  Stream<List<CardEntity>> get finished => dao.finished;
  Stream<String> get filter => dao.filter;

  void setFilter(String value) {
    dao.setFilter(value);
  }

  Future<Task> add(CardEntity card) async {
    final result = await dao.add(card);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> remove(CardEntity card) async {
    final result = await dao.remove(card);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> update(CardEntity card) async {
    final result = await dao.update(card);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> restoreCard(CardEntity card) async {
    final result = await dao.pushUpdatedBottom(card);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> archiveCard(CardEntity card) async {
    final result = await dao.pushUpdatedBottom(card);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> reorder(int oldIndex, int newIndex) async {
    final result = await dao.reorder(oldIndex, newIndex);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> clearArchive() async {
    final result = await dao.clearFinished();
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> clearDailyArchive(DateTime day) async {
    final result = await dao.clearDailyFinished(day);
    return result ? Task.successful() : Task.failed();
  }

  Future<Task> clearNotifications() async {
    final result = await dao.clearNotifications();
    return result ? Task.successful() : Task.failed();
  }
}
