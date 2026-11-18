import 'package:railpulse/core/network/api_client.dart';

class ProviderHealth {
  const ProviderHealth({
    required this.mode,
    required this.provider,
    required this.isDemo,
  });

  final String mode;
  final String provider;
  final bool isDemo;
}

class HealthService {
  const HealthService(this._client);

  final ApiClient _client;

  Future<ProviderHealth> check() async {
    final payload = await _client.get('/api/health');
    return ProviderHealth(
      mode: payload.json['mode'] as String? ?? payload.source,
      provider: payload.json['provider'] as String? ?? 'unknown',
      isDemo: payload.json['demo'] as bool? ?? payload.isDemo,
    );
  }
}
