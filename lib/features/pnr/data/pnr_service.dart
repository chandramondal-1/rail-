import 'package:railpulse/core/network/api_client.dart';
import 'package:railpulse/core/network/json_utils.dart';
import 'package:railpulse/features/pnr/models/pnr_result.dart';

class PnrService {
  const PnrService(this._client);

  final ApiClient _client;

  Future<ApiResult<PnrResult>> fetch(String pnr) async {
    final payload = await _client.get('/api/pnr/$pnr');
    return ApiResult(
      data: PnrResult.fromJson(asMap(payload.json['pnr'])),
      isDemo: payload.isDemo,
    );
  }
}
