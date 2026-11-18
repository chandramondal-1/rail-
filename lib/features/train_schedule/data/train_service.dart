import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/shared/models/route_station.dart';
import 'package:railpulse/shared/models/train_summary.dart';

class TrainService {
  const TrainService(this._client);

  final ApiClient _client;

  Future<ApiResult<TrainDetail>> detail(String number) async {
    final payload = await _client.get('/api/trains/$number');
    final train = TrainSummary.fromJson(asMap(payload.json['train']));
    final route = asMapList(payload.json['route'])
        .map(RouteStation.fromJson)
        .toList(growable: false);
    return ApiResult(
      data: TrainDetail(train: train, route: route),
      isDemo: payload.isDemo,
    );
  }

  Future<ApiResult<List<TrainSummary>>> popular() async {
    final payload = await _client.get('/api/popular');
    final trains = asMapList(payload.json['trains'])
        .map(TrainSummary.fromJson)
        .where((train) => train.number.isNotEmpty)
        .toList(growable: false);
    return ApiResult(data: trains, isDemo: payload.isDemo);
  }
}
