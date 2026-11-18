import 'package:material_ui/material_ui.dart';
import 'package:railpulse/features/station_status/station_board_screen.dart';
import 'package:railpulse/features/train_schedule/train_screen.dart';
import 'package:railpulse/features/train_search/train_search_screen.dart';
import 'package:railpulse/shared/models/station_summary.dart';
import 'package:railpulse/shared/models/train_summary.dart';

void openTrainSearch(
  BuildContext context, {
  SearchTab tab = SearchTab.trains,
  bool openRoute = false,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => TrainSearchScreen(initialTab: tab, openRoute: openRoute),
    ),
  );
}

void openTrain(
  BuildContext context,
  TrainSummary train, {
  int initialTab = 0,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => TrainScreen(train: train, initialTab: initialTab),
    ),
  );
}

void openStationBoard(BuildContext context, [StationSummary? station]) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => StationBoardScreen(station: station),
    ),
  );
}
