import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.code,
    this.statusCode,
  });

  final String message;
  final String? code;
  final int? statusCode;

  bool get isNetworkError => code == 'network_error';

  @override
  String toString() => message;
}

class ApiPayload {
  const ApiPayload({required this.json, required this.source});

  final Map<String, dynamic> json;
  final String source;

  bool get isDemo => source == 'demo';
}

class ApiResult<T> {
  const ApiResult({required this.data, required this.isDemo});

  final T data;
  final bool isDemo;
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 25),
  }) : _client = client ?? http.Client();

  /// Server address used for every request. Settings can change this at
  /// runtime, so the value is intentionally mutable.
  String baseUrl;
  final Duration timeout;
  final http.Client _client;

  void updateBaseUrl(String value) {
    final trimmed = value.trim().replaceAll(RegExp(r'/+$'), '');
    if (trimmed.isNotEmpty) baseUrl = trimmed;
  }

  Future<ApiPayload> get(
    String path, {
    Map<String, String?> query = const {},
  }) async {
    final params = <String, String>{
      for (final entry in query.entries)
        if (entry.value != null && entry.value!.isNotEmpty)
          entry.key: entry.value!,
    };

    final uri = Uri.parse('$baseUrl$path').replace(
      queryParameters: params.isEmpty ? null : params,
    );

    try {
      final response = await _client
          .get(uri, headers: const {'accept': 'application/json'})
          .timeout(timeout);

      Map<String, dynamic>? body;
      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map<String, dynamic>) body = decoded;
      } on FormatException {
        body = null;
      }

      if (response.statusCode >= 400) {
        throw ApiException(
          _errorMessage(body) ?? 'Request failed (${response.statusCode}).',
          code: _errorCode(body),
          statusCode: response.statusCode,
        );
      }

      if (body == null) {
        throw const ApiException('The server returned an unreadable response.');
      }

      return ApiPayload(
        json: body,
        source: body['source'] as String? ?? 'unknown',
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'The request timed out. Check your connection and try again.',
        code: 'network_error',
      );
    } on SocketException {
      throw const ApiException(
        'Could not reach the RailPulse server.',
        code: 'network_error',
      );
    } on http.ClientException {
      throw const ApiException(
        'Could not reach the RailPulse server.',
        code: 'network_error',
      );
    }
  }

  String? _errorMessage(Map<String, dynamic>? body) {
    final error = body?['error'];
    if (error is String && error.trim().isNotEmpty) return error;
    if (error is Map<String, dynamic>) {
      final message = error['message'];
      if (message is String && message.trim().isNotEmpty) return message;
    }
    return null;
  }

  String? _errorCode(Map<String, dynamic>? body) {
    final error = body?['error'];
    if (error is Map<String, dynamic> && error['code'] is String) {
      return error['code'] as String;
    }
    return null;
  }
}
