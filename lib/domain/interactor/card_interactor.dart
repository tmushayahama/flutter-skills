import 'package:mt/data/repository/card_repository.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/domain/interactor/task.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CardInteractor {
  final CardRepository cardRepository;

  CardInteractor({
    @required this.cardRepository,
  }) : assert(cardRepository != null);

  Stream<List<CardEntity>> get all => cardRepository.all;
  Stream<List<CardEntity>> get active => cardRepository.active;
  Stream<List<CardEntity>> get finished => cardRepository.finished;
  Stream<String> get filter => cardRepository.filter;

  void setFilter(String value) {
    cardRepository.setFilter(value);
  }

  Stream<Task> add(CardEntity card) {
    return Observable.fromFuture(cardRepository.add(card))
        .startWith(Task.running());
  }

  Stream<Task> remove(CardEntity card) {
    return Observable.fromFuture(cardRepository.remove(card))
        .startWith(Task.running());
  }

  Stream<Task> update(CardEntity card) {
    return Observable.fromFuture(cardRepository.update(card))
        .startWith(Task.running());
  }

  Stream<Task> restoreCard(CardEntity card) {
    return Observable.fromFuture(cardRepository.restoreCard(card))
        .startWith(Task.running());
  }

  Stream<Task> archiveCard(CardEntity card) {
    return Observable.fromFuture(cardRepository.archiveCard(card))
        .startWith(Task.running());
  }

  Stream<Task> reorder(int oldIndex, int newIndex) {
    return Observable.fromFuture(cardRepository.reorder(oldIndex, newIndex))
        .startWith(Task.running());
  }

  Stream<Task> clearArchive() {
    return Observable.fromFuture(cardRepository.clearArchive())
        .startWith(Task.running());
  }

  Stream<Task> clearDailyArchive(DateTime day) {
    return Observable.fromFuture(cardRepository.clearDailyArchive(day))
        .startWith(Task.running());
  }

  Stream<Task> clearNotifications() {
    return Observable.fromFuture(cardRepository.clearNotifications())
        .startWith(Task.running());
  }
}
