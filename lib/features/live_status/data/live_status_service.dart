import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/features/live_status/models/live_status.dart';

class LiveStatusService {
  const LiveStatusService(this._client);

  final ApiClient _client;

  Future<ApiResult<LiveStatus>> fetch(String number, String date) async {
    final payload = await _client.get(
      '/api/trains/$number/live',
      query: {'date': date},
    );
    return ApiResult(
      data: LiveStatus.fromJson(asMap(payload.json['live'])),
      isDemo: payload.isDemo,
    );
  }
}
