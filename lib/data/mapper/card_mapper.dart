import 'package:built_collection/built_collection.dart';
import 'package:mt/data/json/bullet_json.dart';
import 'package:mt/data/json/card_json.dart';
import 'package:mt/domain/entity/bullet_entity.dart';
import 'package:mt/domain/entity/card_entity.dart';

class CardMapper {
  CardMapper._();

  static CardJson toJson(CardEntity card) {
    return CardJson(
      name: card.name,
      description: card.description,
      bulletPoints: card.bulletPoints.map(bulletToJson).toList(),
      tags: card.tags.asList(),
      status: card.status,
      isFavorite: card.isFavorite,
      imagePath: card.imagePath,
      addedDate: card.addedDate,
      dueDate: card.dueDate,
      finishedDate: card.finishedDate,
      notificationDate: card.notificationDate,
    );
  }

  static CardEntity fromJson(CardJson json) {
    return CardEntity(
      name: json.name,
      description: json.description,
      bulletPoints:
          BuiltList<BulletEntity>(json.bulletPoints.map(bulletFromJson)),
      tags: BuiltList<String>(json.tags),
      status: json.status,
      isFavorite: json.isFavorite,
      imagePath: json.imagePath,
      addedDate: json.addedDate,
      dueDate: json.dueDate,
      finishedDate: json.finishedDate,
      notificationDate: json.notificationDate,
    );
  }

  static BulletJson bulletToJson(BulletEntity entity) {
    return BulletJson(
      text: entity.text,
      checked: entity.checked,
    );
  }

  static BulletEntity bulletFromJson(BulletJson json) {
    return BulletEntity(
      text: json.text,
      checked: json.checked,
    );
  }
}
