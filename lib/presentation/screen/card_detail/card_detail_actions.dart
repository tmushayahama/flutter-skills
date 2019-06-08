import 'package:mt/domain/entity/card_entity.dart';
import 'package:flutter/foundation.dart';

class PerformOnCard {
  final CardEntity card;
  final Operation operation;

  PerformOnCard({
    @required this.card,
    @required this.operation,
  })  : assert(card != null),
        assert(operation != null);
}

enum Operation {
  update,
  restore,
  cleanRestore,
  delete,
}
