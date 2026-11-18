import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/features/live_status/data/live_status_service.dart';
import 'package:railpulse/features/pnr/data/pnr_service.dart';
import 'package:railpulse/features/settings/data/health_service.dart';
import 'package:railpulse/features/station_status/data/station_service.dart';
import 'package:railpulse/features/train_schedule/data/train_service.dart';
import 'package:railpulse/features/train_search/data/train_search_service.dart';

class AppServices {
  AppServices(ApiClient client)
    : client = client,
      search = TrainSearchService(client),
      trains = TrainService(client),
      live = LiveStatusService(client),
      pnr = PnrService(client),
      stations = StationService(client),
      health = HealthService(client);

  final ApiClient client;
  final TrainSearchService search;
  final TrainService trains;
  final LiveStatusService live;
  final PnrService pnr;
  final StationService stations;
  final HealthService health;
}
