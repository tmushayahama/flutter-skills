import 'package:flutter/foundation.dart';
import 'package:mt/data/dao/dao.dart';
import 'package:mt/data/repository/card_repository.dart';
import 'package:mt/domain/interactor/card_interactor.dart';

class Dependencies {
  final CardInteractor cardInteractor;

  const Dependencies({
    @required this.cardInteractor,
  });

  static Dependencies standard() {
    final dao = Dao();
    final cardRepository = CardRepository(dao: dao.cardDao);

    return Dependencies(
      cardInteractor: CardInteractor(cardRepository: cardRepository),
    );
  }
}
