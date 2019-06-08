import 'package:mt/domain/entity/tags.dart';
import 'package:mt/domain/entity/card_entity.dart';
import 'package:mt/presentation/colorful_app.dart';
import 'package:mt/presentation/screen/archive_list/archive_list_screen.dart';
import 'package:mt/presentation/screen/card_detail/card_detail_screen.dart';
import 'package:mt/presentation/screen/card_list/card_list_actions.dart';
import 'package:mt/presentation/shared/widgets/box_decoration.dart';
import 'package:mt/presentation/shared/widgets/dismissible.dart';
import 'package:mt/presentation/shared/widgets/dropdown.dart' as CustomDropdown;
import 'package:mt/presentation/shared/widgets/label.dart';
import 'package:mt/presentation/shared/widgets/card_adder.dart';
import 'package:mt/presentation/shared/widgets/card_tile.dart';
import 'package:mt/utils/notification_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'card_list_bloc.dart';
import 'card_list_state.dart';

class CardListScreen extends StatefulWidget {
  @override
  _CardListScreenState createState() => _CardListScreenState();
}

class _CardListScreenState extends State<CardListScreen> {
  // Place variables here
  CardListBloc _bloc;
  TextEditingController _cardNameController;
  ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    _bloc = CardListBloc();
    _cardNameController = TextEditingController();
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  void _archiveCard(CardEntity card) {
    cancelNotification(card);
    _bloc.actions.add(PerformOnCard(operation: Operation.archive, card: card));
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

  void _showDetails(CardEntity card) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CardDetailScreen(card: card, editable: true),
    ));
  }

  void _showArchive() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ArchiveListScreen(),
    ));
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

  Widget _buildUI(CardListState state) {
    // Build your root view here
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorfulApp.of(context).colors.dark),
        title: Text('All Cards'),
        centerTitle: true,
        bottom: _buildFilter(state),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done_all),
            tooltip: 'Archive',
            onPressed: _showArchive,
          ),
        ],
      ),
      body: SafeArea(top: true, bottom: true, child: _buildBody(state)),
    );
  }

  Widget _buildFilter(CardListState state) {
    final filters = presetTags.toList();
    filters.insertAll(0, ['All', 'Favorite']);

    return PreferredSize(
      preferredSize: const Size.fromHeight(40.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Filter by:'),
              const SizedBox(width: 8.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: roundedShape(context),
                child: CustomDropdown.DropdownButtonHideUnderline(
                  child: CustomDropdown.DropdownButton<String>(
                    isDense: true,
                    value: state.filter,
                    items: filters
                        .map((f) => CustomDropdown.DropdownMenuItem<String>(
                              child: Text(f),
                              value: f,
                            ))
                        .toList(),
                    onChanged: (filter) =>
                        _bloc.actions.add(FilterBy(filter: filter)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CardListState state) {
    return Container(
      decoration: BoxDecoration(
          gradient: ColorfulApp.of(context).colors.brightGradient),
      child: Column(
        children: <Widget>[
          Expanded(
            child: state.cards.length == 0
                ? Center(
                    child: SingleChildScrollView(
                      child: buildCentralLabel(
                          text: 'Card list is empty!', context: context),
                    ),
                  )
                : ListView.builder(
                    controller: _listScrollController,
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      final card = state.cards[index];
                      return Dismissible(
                        key: Key(card.addedDate.toIso8601String()),
                        background: buildDismissibleBackground(
                            context: context, leftToRight: true),
                        secondaryBackground: buildDismissibleBackground(
                            context: context, leftToRight: false),
                        onDismissed: (_) => _archiveCard(card),
                        child: CardTile(
                          card: card,
                          onTileTap: () => _showDetails(card),
                          onFavoriteTap: () => _favoriteCard(card),
                        ),
                      );
                    },
                  ),
          ),
          CardAdder(
            onAdd: _addCard,
            showError: state.cardNameHasError,
            cardNameController: _cardNameController,
          ),
        ],
      ),
    );
  }
}

// For disabling scroll 'glow'. Wrap the `ListView` with `ScrollConfiguration`
//----------
// class _NoHighlightBehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
//     return child;
//   }
// }
