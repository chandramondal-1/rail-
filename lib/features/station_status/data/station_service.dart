import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/features/station_status/models/station_board.dart';
import 'package:railpulse/shared/models/station_summary.dart';

class StationService {
  const StationService(this._client);

  final ApiClient _client;

  Future<ApiResult<List<StationSummary>>> search(String query) async {
    final payload = await _client.get(
      '/api/stations/search',
      query: {'q': query.trim()},
    );
    final results = asMapList(payload.json['results'])
        .map(StationSummary.fromJson)
        .where((station) => station.code.isNotEmpty)
        .toList(growable: false);
    return ApiResult(data: results, isDemo: payload.isDemo);
  }

  Future<ApiResult<StationBoard>> board(String code, int hours) async {
    final payload = await _client.get(
      '/api/stations/$code/board',
      query: {'hours': '$hours'},
    );
    return ApiResult(
      data: StationBoard.fromJson(asMap(payload.json['board'])),
      isDemo: payload.isDemo,
    );
  }
}
