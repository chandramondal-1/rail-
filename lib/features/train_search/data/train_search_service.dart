import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/shared/models/train_summary.dart';

class TrainSearchService {
  const TrainSearchService(this._client);

  final ApiClient _client;

  Future<ApiResult<List<TrainSummary>>> search(String query) async {
    final payload = await _client.get(
      '/api/trains/search',
      query: {'q': query.trim()},
    );
    final results = asMapList(payload.json['results'])
        .map(TrainSummary.fromJson)
        .where((train) => train.number.isNotEmpty)
        .toList(growable: false);
    return ApiResult(data: results, isDemo: payload.isDemo);
  }
}
