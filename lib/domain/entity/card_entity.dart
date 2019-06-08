library card_entity;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:mt/domain/entity/bullet_entity.dart';

part 'card_entity.g.dart';

abstract class CardEntity implements Built<CardEntity, CardEntityBuilder> {
  String get name;
  String get description;
  BuiltList<BulletEntity> get bulletPoints;
  BuiltList<String> get tags;
  CardStatus get status;
  bool get isFavorite;
  String get imagePath;
  @nullable
  DateTime get addedDate;
  @nullable
  DateTime get dueDate;
  @nullable
  DateTime get finishedDate;
  @nullable
  DateTime get notificationDate;

  CardEntity._();
  factory CardEntity({
    String name = '',
    String description = '',
    BuiltList<BulletEntity> bulletPoints,
    BuiltList<String> tags,
    CardStatus status = CardStatus.active,
    bool isFavorite = false,
    String imagePath = '',
    DateTime addedDate,
    DateTime dueDate,
    DateTime finishedDate,
    DateTime notificationDate,
  }) =>
      _$CardEntity._(
        name: name,
        description: description,
        bulletPoints: bulletPoints ?? BuiltList(),
        tags: tags ?? BuiltList(),
        status: status,
        isFavorite: isFavorite,
        imagePath: imagePath,
        addedDate: addedDate,
        dueDate: dueDate,
        finishedDate: finishedDate,
        notificationDate: notificationDate,
      );
}

enum CardStatus { active, finished }

CardStatus parse(String input) {
  switch (input) {
    case 'active':
      return CardStatus.active;
      break;
    case 'finished':
      return CardStatus.finished;
      break;
    default:
      assert(false);
      return null;
  }
}
