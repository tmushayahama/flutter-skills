import 'package:mt/domain/entity/card_entity.dart';
import 'package:flutter/foundation.dart';

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

class ReorderCard {
  final int oldIndex;
  final int newIndex;

  const ReorderCard({
    @required this.oldIndex,
    @required this.newIndex,
  })  : assert(oldIndex != null),
        assert(newIndex != null);
}

class FilterBy {
  final String filter;

  const FilterBy({@required this.filter}) : assert(filter != null);
}
