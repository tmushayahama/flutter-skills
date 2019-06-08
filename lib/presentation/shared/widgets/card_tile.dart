import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/shared/widgets/card_avatar.dart';
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final CardEntity card;
  final VoidCallback onTileTap;
  final VoidCallback onFavoriteTap;
  final bool showNotification;
  final bool isFinished;

  const CardTile({
    Key key,
    @required this.card,
    @required this.onTileTap,
    this.onFavoriteTap,
    this.showNotification,
    this.isFinished = false,
  })  : assert(card != null),
        assert(onTileTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = [
      const SizedBox(width: 12.0),
      CardAvatar(
        text: card.name,
        isLarge: false,
        showNotification: showNotification ?? card.notificationDate != null,
        isFinished: isFinished,
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: Text(
          card.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];

    if (onFavoriteTap != null) {
      children.add(_Favorite(
        initialState: card.isFavorite,
        onTap: onFavoriteTap,
      ));
    } else {
      children.add(const SizedBox(width: 12.0));
    }

    return GestureDetector(
      onTap: onTileTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 56.0,
        child: Row(children: children),
      ),
    );
  }
}

class _Favorite extends StatefulWidget {
  final bool initialState;
  final VoidCallback onTap;

  _Favorite({
    Key key,
    this.initialState = false,
    @required this.onTap,
  })  : assert(onTap != null),
        super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<_Favorite> {
  bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.initialState;
  }

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(milliseconds: 250);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isActive = !_isActive;
        });

        // Handle onTap callback when animation is finished
        Future.delayed(duration, widget.onTap);
      },
      child: Container(
        // Tap area
        padding: const EdgeInsets.all(12.0),
        child: AnimatedCrossFade(
          firstChild: _buildIcon(Icons.star_border),
          secondChild: _buildIcon(Icons.star),
          duration: duration,
          crossFadeState:
              _isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      size: 26.0,
      color: _isActive
          ? ColorfulApp.of(context).colors.medium
          : ColorfulApp.of(context).colors.bright,
    );
  }
}
