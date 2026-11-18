import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:railpulse/core/storage/app_preferences.dart';
import 'package:railpulse/shared/models/saved_train.dart';
import 'package:railpulse/shared/models/train_summary.dart';

class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _themeMode = _readThemeMode();
    _locale = _readLocale();
    _notificationsEnabled = _prefs.read(_kNotifications) == 'true';
    _favourites = _readTrains(_kFavourites);
    _recents = _readTrains(_kRecents);
    _recentPnrs = _readStrings(_kRecentPnrs);
    _lastTracked = _readLastTracked();
    _apiBaseUrl = _readApiBaseUrl();
  }

  static const _kTheme = 'theme_mode';
  static const _kLocale = 'locale';
  static const _kNotifications = 'notifications';
  static const _kFavourites = 'favourite_trains';
  static const _kRecents = 'recent_trains';
  static const _kRecentPnrs = 'recent_pnrs';
  static const _kLastTracked = 'last_tracked';
  static const _kApiBaseUrl = 'api_base_url';

  final AppPreferences _prefs;

  late ThemeMode _themeMode;
  late Locale _locale;
  late bool _notificationsEnabled;
  late List<SavedTrain> _favourites;
  late List<SavedTrain> _recents;
  late List<String> _recentPnrs;
  SavedTrain? _lastTracked;
  String? _apiBaseUrl;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;
  List<SavedTrain> get favourites => List.unmodifiable(_favourites);
  List<SavedTrain> get recents => List.unmodifiable(_recents);
  List<String> get recentPnrs => List.unmodifiable(_recentPnrs);
  SavedTrain? get lastTracked => _lastTracked;

  /// Custom proxy address saved from Settings; null means use the build default.
  String? get apiBaseUrl => _apiBaseUrl;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.write(_kTheme, mode.name);
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == _locale.languageCode) return;
    _locale = locale;
    notifyListeners();
    await _prefs.write(_kLocale, locale.languageCode);
  }

  Future<void> setNotifications(bool enabled) async {
    if (enabled == _notificationsEnabled) return;
    _notificationsEnabled = enabled;
    notifyListeners();
    await _prefs.write(_kNotifications, '$enabled');
  }

  Future<void> setApiBaseUrl(String? value) async {
    final trimmed = value?.trim().replaceAll(RegExp(r'/+$'), '') ?? '';
    final next = trimmed.isEmpty ? null : trimmed;
    if (next == _apiBaseUrl) return;
    _apiBaseUrl = next;
    notifyListeners();
    if (next == null) {
      await _prefs.remove(_kApiBaseUrl);
    } else {
      await _prefs.write(_kApiBaseUrl, next);
    }
  }

  bool isFavourite(String number) =>
      _favourites.any((train) => train.number == number);

  /// Returns true when the train was added, false when it was removed.
  Future<bool> toggleFavourite(TrainSummary train) async {
    final index = _favourites.indexWhere((entry) => entry.number == train.number);
    final added = index < 0;
    if (added) {
      _favourites = [SavedTrain.fromTrain(train), ..._favourites];
    } else {
      _favourites = [..._favourites]..removeAt(index);
    }
    notifyListeners();
    await _persistTrains(_kFavourites, _favourites);
    return added;
  }

  Future<void> addRecent(TrainSummary train) async {
    _recents = [
      SavedTrain.fromTrain(train),
      ..._recents.where((entry) => entry.number != train.number),
    ].take(8).toList();
    notifyListeners();
    await _persistTrains(_kRecents, _recents);
  }

  Future<void> removeFavourite(String number) async {
    _favourites = _favourites
        .where((entry) => entry.number != number)
        .toList(growable: false);
    notifyListeners();
    await _persistTrains(_kFavourites, _favourites);
  }

  Future<void> clearRecents() async {
    _recents = [];
    notifyListeners();
    await _prefs.remove(_kRecents);
  }

  Future<void> setLastTracked(TrainSummary train) async {
    _lastTracked = SavedTrain.fromTrain(train);
    await _prefs.write(_kLastTracked, jsonEncode(_lastTracked!.toJson()));
  }

  Future<void> addRecentPnr(String pnr) async {
    final trimmed = pnr.trim();
    if (trimmed.isEmpty) return;
    _recentPnrs = [
      trimmed,
      ..._recentPnrs.where((entry) => entry != trimmed),
    ].take(5).toList();
    notifyListeners();
    await _prefs.write(_kRecentPnrs, jsonEncode(_recentPnrs));
  }

  Future<void> clearCache() async {
    _recents = [];
    _recentPnrs = [];
    _lastTracked = null;
    notifyListeners();
    await _prefs.remove(_kRecents);
    await _prefs.remove(_kRecentPnrs);
    await _prefs.remove(_kLastTracked);
  }

  Future<void> clearLocalData() async {
    _recents = [];
    _recentPnrs = [];
    _lastTracked = null;
    notifyListeners();
    await _prefs.remove(_kRecents);
    await _prefs.remove(_kRecentPnrs);
    await _prefs.remove(_kLastTracked);
  }

  ThemeMode _readThemeMode() {
    return switch (_prefs.read(_kTheme)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Locale _readLocale() {
    return switch (_prefs.read(_kLocale)) {
      'hi' => const Locale('hi'),
      'bn' => const Locale('bn'),
      _ => const Locale('en'),
    };
  }

  List<SavedTrain> _readTrains(String key) {
    final raw = _prefs.read(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(SavedTrain.fromJson)
          .where((train) => train.number.isNotEmpty)
          .toList(growable: false);
    } on FormatException {
      return [];
    }
  }

  String? _readApiBaseUrl() {
    final raw = _prefs.read(_kApiBaseUrl)?.trim();
    return (raw == null || raw.isEmpty) ? null : raw;
  }

  SavedTrain? _readLastTracked() {
    final raw = _prefs.read(_kLastTracked);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final train = SavedTrain.fromJson(decoded);
      return train.number.isEmpty ? null : train;
    } on FormatException {
      return null;
    }
  }

  List<String> _readStrings(String key) {
    final raw = _prefs.read(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded.whereType<String>().toList(growable: false);
    } on FormatException {
      return [];
    }
  }

  Future<void> _persistTrains(String key, List<SavedTrain> trains) {
    return _prefs.write(
      key,
      jsonEncode(trains.map((train) => train.toJson()).toList()),
    );
  }
}
