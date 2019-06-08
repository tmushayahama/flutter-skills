import 'package:mt/domain/entity/card_entity.dart';
import 'package:flutter/foundation.dart';

class UpdateField {
  UpdateField({
    @required this.field,
    @required this.value,
  }) : assert(field != null);

  final Field field;
  final dynamic value;
}

enum Field { selectedDate, calendarFormat, calendarVisible }

class PerformOnCard {
  final CardEntity card;
  final Operation operation;

  const PerformOnCard({
    @required this.card,
    @required this.operation,
  })  : assert(card != null),
        assert(operation != null);
}

enum Operation { add, archive, favorite }

class ToggleArchive {}

class ClearDailyArchive {}
