import 'dart:io';

import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/screen/card_edit/card_edit_screen.dart';
import 'package:mt/presentation/shared/helper/date_formatter.dart';
import 'package:mt/presentation/shared/widgets/box.dart';
import 'package:mt/presentation/shared/widgets/bullet_list.dart';
import 'package:mt/presentation/shared/widgets/buttons.dart';
import 'package:mt/presentation/shared/widgets/image_file.dart';
import 'package:mt/presentation/shared/widgets/card_avatar.dart';
import 'package:mt/utils/notification_utils.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tuple/tuple.dart';

import 'card_detail_actions.dart';
import 'card_detail_bloc.dart';
import 'card_detail_state.dart';

class CardDetailScreen extends StatefulWidget {
  final CardEntity card;
  final bool editable;

  const CardDetailScreen({
    Key key,
    @required this.card,
    @required this.editable,
  })  : assert(card != null),
        assert(editable != null),
        super(key: key);

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  // Place variables here
  CardDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CardDetailBloc(card: widget.card);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _edit(CardEntity card) async {
    final updatedCard =
        await Navigator.of(context).push<CardEntity>(MaterialPageRoute(
      builder: (context) => CardEditScreen(card: card),
    ));

    if (updatedCard != null) {
      _bloc.actions
          .add(PerformOnCard(operation: Operation.update, card: updatedCard));
    }
  }

  void _restore(CardEntity card) async {
    final reschedule = card.notificationDate?.isAfter(DateTime.now()) ?? false;
    if (reschedule) {
      scheduleNotification(card);
      _bloc.actions
          .add(PerformOnCard(operation: Operation.restore, card: card));
    } else {
      _bloc.actions
          .add(PerformOnCard(operation: Operation.cleanRestore, card: card));
    }

    Navigator.of(context).pop();
  }

  void _delete(CardEntity card) {
    _bloc.actions.add(PerformOnCard(operation: Operation.delete, card: card));
    Navigator.of(context).pop();
  }

  void _zoomImage(File image) {
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PhotoView(imageProvider: FileImage(image))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.initialState,
      stream: _bloc.state,
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      },
    );
  }

  Widget _buildUI(CardDetailState state) {
    // Build your root view here
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorfulApp.of(context).colors.bleak),
        centerTitle: true,
        title: Text('Card\'s details'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(CardDetailState state) {
    final children = [_buildName(state)];

    if (!isBlank(state.card.description)) {
      children.add(_buildDescription(state));
    }

    if (state.card.tags.isNotEmpty) {
      children.add(_buildTags(state));
    }

    if (state.card.bulletPoints.isNotEmpty) {
      children.add(_buildBulletPoints(state));
    }

    if (!isBlank(state.card.imagePath)) {
      final file = File(state.card.imagePath);

      if (file.existsSync()) {
        children.add(_buildImage(file));
      }
    }

    if (state.card.notificationDate != null && widget.editable) {
      children.add(_buildNotification(state));
    }

    children.addAll([
      _buildDate(state),
      _buildFooterLabel(),
    ]);

    return SafeArea(
      top: true,
      bottom: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView(children: children),
          ),
          _buildBottomBox(state),
        ],
      ),
    );
  }

  Widget _buildName(CardDetailState state) {
    return ShadedBox(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12.0),
          CardAvatar(
            text: state.card.name,
            isLarge: true,
            showNotification:
                state.card.notificationDate != null && widget.editable,
            isFinished: !widget.editable,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              state.card.name,
              textAlign: TextAlign.center,
              style: TextStyle().copyWith(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _buildDescription(CardDetailState state) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Description:',
            style: TextStyle().copyWith(
                fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              state.card.description,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(CardDetailState state) {
    final children =
        state.card.tags.map((tag) => _TagChip(title: tag)).toList();

    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Tags',
            style: TextStyle().copyWith(
                color: ColorfulApp.of(context).colors.bleak, fontSize: 12.0),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16.0,
              runSpacing: 12.0,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoints(CardDetailState state) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Bullet points:',
            style: TextStyle().copyWith(
                fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: BulletList(entries: state.card.bulletPoints.toList()),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(File file) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Image:',
            style: TextStyle().copyWith(
                fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
          ),
          const SizedBox(height: 12.0),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _zoomImage(file),
              child: imageFile(file),
            ),
          ),
          const SizedBox(height: 4.0),
        ],
      ),
    );
  }

  Widget _buildNotification(CardDetailState state) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Notification:',
            style: TextStyle().copyWith(
                fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              const SizedBox(width: 20.0),
              Text(
                DateFormatter.safeFormatDays(state.card.notificationDate),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  DateFormatter.safeFormatFullWithTime(
                      state.card.notificationDate),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDate(CardDetailState state) {
    final children = [
      Text(
        'Added:',
        style: TextStyle().copyWith(
            fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
      ),
      const SizedBox(height: 8.0),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(width: 20.0),
          Text(
            DateFormatter.safeFormatDays(state.card.addedDate),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              DateFormatter.safeFormatFull(state.card.addedDate),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24.0),
      Text(
        'Due:',
        style: TextStyle().copyWith(
            fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
      ),
      const SizedBox(height: 8.0),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const SizedBox(width: 20.0),
          Text(
            DateFormatter.safeFormatDays(state.card.dueDate),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              DateFormatter.safeFormatFull(state.card.dueDate),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    ];

    if (state.card.finishedDate != null) {
      children.addAll([
        const SizedBox(height: 24.0),
        Text(
          'Finished on:',
          style: TextStyle().copyWith(
              fontSize: 12.0, color: ColorfulApp.of(context).colors.bleak),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(width: 20.0),
            Text(
              DateFormatter.safeFormatDays(state.card.finishedDate),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                DateFormatter.safeFormatFull(state.card.finishedDate),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ]);
    }

    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildFooterLabel() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24.0),
        Center(
          child: Text(
            'Edit this Card to add more sections',
            style: TextStyle().copyWith(
              color: ColorfulApp.of(context).colors.bleak,
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildBottomBox(CardDetailState state) {
    if (widget.editable) {
      return BottomButton(
        text: 'Edit',
        onPressed: () => _edit(state.card),
      );
    } else {
      return BottomButtonRow(
        buttonsData: [
          Tuple2('Restore', () => _restore(state.card)),
          Tuple2('Delete', () => _delete(state.card)),
        ],
      );
    }
  }
}

class _TagChip extends StatelessWidget {
  final String title;

  const _TagChip({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        border:
            Border.all(color: ColorfulApp.of(context).colors.bleak, width: 0.5),
        color: ColorfulApp.of(context).colors.pale,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(title),
    );
  }
}
