import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/screen/calendar/calendar_actions.dart';
import 'package:mt/presentation/screen/calendar/calendar_bloc.dart';
import 'package:mt/presentation/screen/calendar/calendar_state.dart';
import 'package:mt/presentation/screen/card_detail/card_detail_screen.dart';
import 'package:mt/presentation/shared/helper/date_formatter.dart';
import 'package:mt/presentation/shared/widgets/box.dart';
import 'package:mt/presentation/shared/widgets/buttons.dart';
import 'package:mt/presentation/shared/widgets/dialogs.dart';
import 'package:mt/presentation/shared/widgets/dismissible.dart';
import 'package:mt/presentation/shared/widgets/label.dart';
import 'package:mt/presentation/shared/widgets/card_adder.dart';
import 'package:mt/presentation/shared/widgets/card_tile.dart';
import 'package:mt/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Place variables here
  CalendarBloc _bloc;
  TextEditingController _cardNameController;
  ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    _bloc = CalendarBloc();
    _cardNameController = TextEditingController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date, _) {
    _bloc.actions.add(UpdateField(field: Field.selectedDate, value: date));
  }

  void _onVisibleDaysChanged(_, __, CalendarFormat format) {
    _bloc.actions.add(UpdateField(field: Field.calendarFormat, value: format));
  }

  void _showDetails(CardEntity card, {bool editable = true}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CardDetailScreen(card: card, editable: editable),
    ));
  }

  void _addCard(CardEntity card) {
    _bloc.actions.add(PerformOnCard(operation: Operation.add, card: card));

    // Auto-scrolls to bottom of the ListView
    if (card.name.trim().isNotEmpty) {
      // Because sometimes last item is skipped (see below)
      final lastItemExtent = 60.0;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        _listScrollController.animateTo(
          _listScrollController.position.maxScrollExtent + lastItemExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _favoriteCard(CardEntity card) {
    _bloc.actions.add(PerformOnCard(operation: Operation.favorite, card: card));
  }

  void _archiveCard(CardEntity card) {
    cancelNotification(card);
    _bloc.actions.add(PerformOnCard(operation: Operation.archive, card: card));
  }

  void _onCardAdderFormatChanged(CardAdderFormat format) {
    _bloc.actions.add(UpdateField(
      field: Field.calendarVisible,
      value: format == CardAdderFormat.folded,
    ));
  }

  void _onDateHeaderTapped(bool calendarVisible) {
    if (calendarVisible) {
      _bloc.actions.add(ToggleArchive());
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => RoundedAlertDialog(
            title: 'Do you want to clear the Archive?',
            actions: <Widget>[
              FlatRoundButton(
                  text: 'Yes',
                  onTap: () {
                    Navigator.pop(context);
                    _bloc.actions.add(ClearDailyArchive());
                  }),
              FlatRoundButton(
                text: 'No',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
    );
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

  Widget _buildUI(CalendarState state) {
    // Build your root view here
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorfulApp.of(context).colors.dark),
        title: Text('Calendar View'),
        centerTitle: true,
      ),
      body: SafeArea(top: true, bottom: true, child: _buildBody(state)),
    );
  }

  Widget _buildBody(CalendarState state) {
    final List<Widget> children = [];

    if (state.calendarVisible) {
      children.addAll([
        _buildCalendar(state),
        const SizedBox(height: 4.0),
      ]);
    }

    children.addAll([
      _buildDateHeader(state),
      const SizedBox(height: 2.0),
      Expanded(
        child: _buildContent(
          state,
          bottomVisible: state.calendarFormat != CalendarFormat.month,
        ),
      ),
    ]);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildCalendar(CalendarState state) {
    return TableCalendar(
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      events: state.activeEvents?.toMap(),
      calendarStyle: CalendarStyle(
        selectedColor: ColorfulApp.of(context).colors.medium,
        todayColor: ColorfulApp.of(context).colors.pale,
        markersColor: ColorfulApp.of(context).colors.bleak,
        weekendStyle:
            TextStyle().copyWith(color: ColorfulApp.of(context).colors.medium),
        outsideWeekendStyle: TextStyle().copyWith(
            color: ColorfulApp.of(context).colors.bright.withOpacity(0.8)),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: ColorfulApp.of(context).colors.bright),
      ),
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(Icons.chevron_left,
            color: ColorfulApp.of(context).colors.dark),
        rightChevronIcon: Icon(Icons.chevron_right,
            color: ColorfulApp.of(context).colors.dark),
        formatButtonVisible: false,
        centerHeaderTitle: true,
      ),
      selectedDay: state.selectedDate,
      initialCalendarFormat: state.calendarFormat,
    );
  }

  Widget _buildDateHeader(CalendarState state) {
    final highlightStyle =
        TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.bold);

    return GestureDetector(
      onTap: () => _onDateHeaderTapped(state.calendarVisible),
      child: Container(
        height: 50.0,
        child: ShadedBox(
          padding: null,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 16,
                left: 0,
                right: 0,
                child: Text(
                  DateFormatter.formatFull(state.selectedDate),
                  style: TextStyle().copyWith(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: 6,
                left: 12,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: ColorfulApp.of(context).colors.bleak),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '${state.archiveVisible ? 'Active' : 'Archive'}',
                    style: TextStyle().copyWith(fontSize: 13.0),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${state.activeCards.length}',
                      style:
                          state.archiveVisible ? TextStyle() : highlightStyle,
                    ),
                    Text(' / '),
                    Text(
                      '${state.archivedCards.length}',
                      style:
                          state.archiveVisible ? highlightStyle : TextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(CalendarState state, {bool bottomVisible = true}) {
    List<Widget> children = [];

    if (state.archiveVisible) {
      children.add(
        Expanded(
          child: state.archivedCards.length == 0
              ? _buildPlaceholder('Archive is empty!')
              : _buildArchivedList(state),
        ),
      );
    } else {
      children.add(
        Expanded(
          child: state.activeCards.length == 0
              ? _buildPlaceholder('Card list is empty!')
              : _buildActiveList(state),
        ),
      );
    }

    if (bottomVisible) {
      children.add(_buildBottom(state));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: ColorfulApp.of(context).colors.brightGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildBottom(CalendarState state) {
    if (state.archiveVisible) {
      return BottomButton(
        text: 'Clear',
        onPressed: _showConfirmationDialog,
      );
    } else {
      return CardAdder(
        onAdd: _addCard,
        onFormatChanged: _onCardAdderFormatChanged,
        showError: state.cardNameHasError,
        cardNameController: _cardNameController,
        scheduledDate: state.selectedDate,
      );
    }
  }

  Widget _buildPlaceholder(String text) {
    return Center(
      child: SingleChildScrollView(
        child: buildCentralLabel(text: text, context: context),
      ),
    );
  }

  Widget _buildActiveList(CalendarState state) {
    return ListView.builder(
      controller: _listScrollController,
      itemCount: state.activeCards.length,
      itemBuilder: (context, index) {
        final card = state.activeCards[index];
        return Dismissible(
          key: Key(card.addedDate.toIso8601String()),
          background:
              buildDismissibleBackground(context: context, leftToRight: true),
          secondaryBackground:
              buildDismissibleBackground(context: context, leftToRight: false),
          onDismissed: (_) => _archiveCard(card),
          child: CardTile(
            card: card,
            onTileTap: () => _showDetails(card),
            onFavoriteTap: () => _favoriteCard(card),
          ),
        );
      },
    );
  }

  Widget _buildArchivedList(CalendarState state) {
    return ListView.builder(
      controller: _listScrollController,
      itemCount: state.archivedCards.length,
      itemBuilder: (context, index) {
        final card = state.archivedCards[index];
        return CardTile(
          card: card,
          onTileTap: () => _showDetails(card, editable: false),
          showNotification: false,
          isFinished: true,
        );
      },
    );
  }
}
