import 'package:mt/data/json/bullet_json.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:flutter/foundation.dart';

class CardJson {
  final String name;
  final String description;
  final List<BulletJson> bulletPoints;
  final List<String> tags;
  final CardStatus status;
  final bool isFavorite;
  final String imagePath;
  final DateTime addedDate;
  final DateTime dueDate;
  final DateTime finishedDate;
  final DateTime notificationDate;

  const CardJson({
    @required this.name,
    this.description,
    this.bulletPoints,
    this.tags,
    @required this.status,
    this.isFavorite,
    this.imagePath,
    @required this.addedDate,
    this.dueDate,
    this.finishedDate,
    this.notificationDate,
  })  : assert(name != null),
        assert(status != null),
        assert(addedDate != null);

  static CardJson parse(Map<String, dynamic> inputJson) {
    final stringBullets = inputJson['bulletPoints'] as List;
    final List<BulletJson> decodedBullets =
        stringBullets.map((e) => BulletJson.parse(e)).toList();
    final tags = (inputJson['tags'] as List)?.cast<String>();

    return CardJson(
      name: inputJson['name'],
      description: inputJson['description'],
      bulletPoints: inputJson['bulletPoints'] != null ? decodedBullets : null,
      tags: inputJson['tags'] != null ? tags : const [],
      status: stringToEnum(inputJson['status'], CardStatus.values),
      isFavorite: inputJson['isFavorite'],
      imagePath: inputJson['imagePath'] != null ? inputJson['imagePath'] : '',
      addedDate: DateTime.parse(inputJson['addedDate']),
      dueDate: inputJson['dueDate'] != null
          ? DateTime.parse(inputJson['dueDate'])
          : null,
      finishedDate: inputJson['finishedDate'] != null
          ? DateTime.parse(inputJson['finishedDate'])
          : null,
      notificationDate: inputJson['notificationDate'] != null
          ? DateTime.parse(inputJson['notificationDate'])
          : null,
    );
  }

  Map encode() {
    final bullets = bulletPoints.map((json) => json.encode()).toList();
    return {
      'name': name,
      'description': description,
      'bulletPoints': bullets,
      'tags': tags,
      'status': enumToString(status),
      'isFavorite': isFavorite,
      'imagePath': imagePath,
      'addedDate': addedDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'finishedDate': finishedDate?.toIso8601String(),
      'notificationDate': notificationDate?.toIso8601String(),
    };
  }
}
