import 'dart:io';

import 'package:mt/domain/entity/tags.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/screen/card_edit/card_edit_actions.dart';
import 'package:mt/presentation/screen/card_edit/card_edit_bloc.dart';
import 'package:mt/presentation/screen/card_edit/card_edit_state.dart';
import 'package:mt/presentation/shared/helper/date_formatter.dart';
import 'package:mt/presentation/shared/resources.dart';
import 'package:mt/presentation/shared/widgets/box.dart';
import 'package:mt/presentation/shared/widgets/buttons.dart';
import 'package:mt/presentation/shared/widgets/dialogs.dart';
import 'package:mt/presentation/shared/widgets/editable_bullet_list.dart';
import 'package:mt/presentation/shared/widgets/image_file.dart';
import 'package:mt/presentation/shared/widgets/tag_action_chip.dart';
import 'package:mt/utils/notification_utils.dart';
import 'package:mt/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class CardEditScreen extends StatefulWidget {
  final CardEntity card;

  CardEditScreen({Key key, @required this.card})
      : assert(card != null),
        super(key: key);

  @override
  _CardEditScreenState createState() => _CardEditScreenState();
}

class _CardEditScreenState extends State<CardEditScreen> {
  CardEditBloc _bloc;

  FocusNode _nameFocusNode;
  FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    _bloc = CardEditBloc(card: widget.card);

    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _selectDate(CardEditState state) async {
    // set initialDate to tomorrow by default
    final now = DateTime.now();
    final tomorrow =
        DateTime(now.year, now.month, now.day).add(Duration(days: 1));

    final date = await showDatePicker(
      context: context,
      initialDate: state.card.dueDate ?? tomorrow,
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    // Null check prevents user from resetting dueDate.
    // I've decided the reset is a wanted feature.
    // if (date != null) {
    _bloc.actions.add(UpdateField(key: FieldKey.dueDate, value: date));
  }

  void _setupNotification(CardEditState state) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.card.notificationDate ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2050),
    );

    if (date == null) {
      // clear when dialog is dismissed
      _bloc.actions
          .add(UpdateField(key: FieldKey.notificationDate, value: null));
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(state.card.notificationDate ?? DateTime.now()),
    );

    if (time == null) {
      _bloc.actions
          .add(UpdateField(key: FieldKey.notificationDate, value: null));
      return;
    }

    final notificationDate =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    _bloc.actions.add(
        UpdateField(key: FieldKey.notificationDate, value: notificationDate));
  }

  void _chooseImageSource() async {
    final ImageSource source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => RoundedAlertDialog(
            title: 'Choose the image source',
            actions: <Widget>[
              FlatRoundButton(
                text: 'Gallery',
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              FlatRoundButton(
                text: 'Camera',
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
    );

    if (source != null) {
      _pickImage(source);
    }
  }

  void _pickImage(ImageSource source) async {
    final File image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      _bloc.actions.add(SetImage(image: image));
    }
  }

  void _zoomImage(File image) {
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoView(imageProvider: FileImage(image)),
        ),
      );
    }
  }

  void _showRemoveImageDialog() {
    showDialog(
      context: context,
      builder: (context) => RoundedAlertDialog(
            title: 'Do you want to remove this image?',
            actions: <Widget>[
              FlatRoundButton(
                  text: 'Remove',
                  onTap: () {
                    _bloc.actions.add(SetImage(image: null));
                    Navigator.pop(context);
                  }),
              FlatRoundButton(
                  text: 'Cancel', onTap: () => Navigator.pop(context)),
            ],
          ),
    );
  }

  File _getImageSrc(CardEditState state) {
    if (state.image != null) {
      return state.image;
    } else if (!isBlank(state.card.imagePath)) {
      return File(state.card.imagePath);
    } else {
      return null;
    }
  }

  void _submit(CardEditState state) async {
    if (!state.cardNameHasError) {
      if (state.card.notificationDate == null) {
        cancelNotification(state.card);
      } else if (widget.card.notificationDate == null ||
          widget.card.notificationDate.compareTo(state.card.notificationDate) !=
              0) {
        // Schedule a notification only when date has been set to a new (different) value
        scheduleNotification(state.card);
      }

      Navigator.of(context).pop(state.card);
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

  Widget _buildUI(CardEditState state) {
    return WillPopScope(
      onWillPop: () async {
        _nameFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: ColorfulApp.of(context).colors.bleak),
          centerTitle: true,
          title: Text('Edit Card'),
        ),
        body: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(CardEditState state) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              _buildName(state),
              _buildDescription(state),
              _buildTags(state),
              _buildBulletPoints(state),
              _buildImage(state),
              _buildNotification(state),
              _buildDate(state),
            ],
          ),
        ),
        BottomButton(
          text: 'Save',
          onPressed: () => _submit(state),
        ),
      ],
    );
  }

  Widget _buildName(CardEditState state) {
    return ShadedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
        child: _TextField(
          focusNode: _nameFocusNode,
          showError: state.cardNameHasError,
          value: state.card.name,
          textAlign: TextAlign.center,
          inputAction: TextInputAction.done,
          maxLength: 50,
          maxLengthEnforced: true,
          maxLines: null,
          fontSize: 20.0,
          hint:
              state.cardNameHasError ? 'Name can\'t be empty' : 'Card\'s name',
          onChanged: (value) =>
              _bloc.actions.add(UpdateField(key: FieldKey.name, value: value)),
        ),
      ),
    );
  }

  Widget _buildDescription(CardEditState state) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle().copyWith(
                color: ColorfulApp.of(context).colors.bleak, fontSize: 12.0),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _TextField(
              focusNode: _descriptionFocusNode,
              maxLines: null,
              value: state.card.description,
              hint: 'Card\'s description',
              onChanged: (value) => _bloc.actions
                  .add(UpdateField(key: FieldKey.description, value: value)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(CardEditState state) {
    final children = presetTags
        .map((tag) => TagActionChip(
              title: tag,
              initiallySelected: state.card.tags.contains(tag),
              onTap: () => _bloc.actions.add(ToggleTag(tag: tag)),
            ))
        .toList();

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

  Widget _buildBulletPoints(CardEditState state) {
    return ShadedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Bullet points',
            style: TextStyle().copyWith(
                color: ColorfulApp.of(context).colors.bleak, fontSize: 12.0),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: EditableBulletList(
              initialBulletPoints: state.card.bulletPoints.toList(),
              onChanged: (bullets) => _bloc.actions
                  .add(UpdateField(key: FieldKey.bulletPoints, value: bullets)),
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget _buildImage(CardEditState state) {
    final src = _getImageSrc(state);
    final hasImage = src != null && src.existsSync();
    final image = hasImage ? imageFile(src) : imageFilePlaceholder();

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
              onTap: () => hasImage ? _zoomImage(src) : _chooseImageSource(),
              onLongPress: () {
                if (hasImage) {
                  HapticFeedback.vibrate();
                  _showRemoveImageDialog();
                }
              },
              child: image,
            ),
          ),
          const SizedBox(height: 4.0),
        ],
      ),
    );
  }

  Widget _buildNotification(CardEditState state) {
    return ShadedBox(
      child: GestureDetector(
        onTap: () => _setupNotification(state),
        behavior: HitTestBehavior.opaque,
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
      ),
    );
  }

  Widget _buildDate(CardEditState state) {
    return ShadedBox(
      child: GestureDetector(
        onTap: () => _selectDate(state),
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextInputAction inputAction;
  final TextAlign textAlign;
  final String value;
  final String hint;
  final double fontSize;
  final int maxLines;
  final int maxLength;
  final bool maxLengthEnforced;
  final bool showError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _TextField({
    Key key,
    this.focusNode,
    this.inputAction,
    this.textAlign = TextAlign.start,
    this.value,
    this.hint,
    this.fontSize = 14.0,
    this.maxLines = 1,
    this.maxLength,
    this.maxLengthEnforced = false,
    this.showError = false,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  TextEditingValue _value;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController.fromValue(
      _value?.copyWith(text: widget.value) ??
          TextEditingValue(text: widget.value),
    );

    controller.addListener(() {
      _value = controller.value;
      widget.onChanged(controller.value.text);
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(widget.focusNode),
      child: TextField(
        focusNode: widget.focusNode,
        textInputAction: widget.inputAction,
        controller: controller,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforced: widget.maxLengthEnforced,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle().copyWith(
          color: AppColors.black1,
          fontSize: widget.fontSize,
        ),
        decoration: InputDecoration.collapsed(
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle().copyWith(
            color: widget.showError
                ? ColorfulApp.of(context).colors.dark
                : ColorfulApp.of(context).colors.medium,
            fontSize: widget.fontSize,
          ),
        ),
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
