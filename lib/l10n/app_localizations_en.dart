// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RailPulse';

  @override
  String get tagline => 'Your Train. Your Journey. Live.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeTitle => 'Where is your train?';

  @override
  String get homeSubtitle =>
      'Live running status, routes and platforms — all in one place.';

  @override
  String get searchHint => 'Train number or name';

  @override
  String get searchAction => 'Search';

  @override
  String get searchMinChars => 'Type at least 2 characters.';

  @override
  String get searchEmptyTitle => 'No trains found';

  @override
  String get searchEmptyBody =>
      'Try a train number like 12951, or a name like Rajdhani.';

  @override
  String get searchResults => 'Search results';

  @override
  String get searchFor => 'Search trains';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get noRecentSearches => 'Your recent searches will appear here.';

  @override
  String get popularServices => 'Popular services';

  @override
  String get viewAll => 'View all';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get liveTrainStatus => 'Live status';

  @override
  String get liveTrainStatusSubtitle => 'Where is it right now?';

  @override
  String get pnrStatus => 'PNR status';

  @override
  String get pnrStatusSubtitle => 'Check your booking';

  @override
  String get trainSchedule => 'Train route';

  @override
  String get trainScheduleSubtitle => 'Every stop and time';

  @override
  String get stationStatus => 'Station board';

  @override
  String get stationStatusSubtitle => 'Arrivals and departures';

  @override
  String get favourites => 'Favourites';

  @override
  String get favouritesSubtitle => 'Saved trains';

  @override
  String get settings => 'Settings';

  @override
  String get demoBadge => 'Demo data';

  @override
  String get demoNotice =>
      'Sample data from RailPulse demo mode. Live railway data is not connected.';

  @override
  String get demoPnrHint => 'Demo mode — any 10-digit PNR shows sample data.';

  @override
  String get liveBadge => 'Live';

  @override
  String get dataSource => 'Data source';

  @override
  String get dataSourceDemo => 'Demo mode — sample data';

  @override
  String get dataSourceLive => 'Live railway data via a secure proxy';

  @override
  String get backendUnreachable => 'Cannot reach the RailPulse server';

  @override
  String get backendUnreachableBody =>
      'Start the local API proxy, then try again.';

  @override
  String get retry => 'Try again';

  @override
  String get refresh => 'Refresh';

  @override
  String get close => 'Close';

  @override
  String get clear => 'Clear';

  @override
  String get remove => 'Remove';

  @override
  String get seeAll => 'See all';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get checkConnection => 'Check your connection and try again.';

  @override
  String get loading => 'Loading';

  @override
  String get noData => 'No data available';

  @override
  String get updated => 'Updated';

  @override
  String minAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get trainNumber => 'Train number';

  @override
  String get runsOn => 'Runs on';

  @override
  String get runsDaily => 'Runs daily';

  @override
  String get duration => 'Duration';

  @override
  String get distance => 'Distance';

  @override
  String get source => 'From';

  @override
  String get destination => 'To';

  @override
  String get departure => 'Departure';

  @override
  String get arrival => 'Arrival';

  @override
  String get platform => 'Platform';

  @override
  String platformNumber(String number) {
    return 'PF $number';
  }

  @override
  String get halt => 'Halt';

  @override
  String get day => 'Day';

  @override
  String dayNumber(int number) {
    return 'Day $number';
  }

  @override
  String km(String value) {
    return '$value km';
  }

  @override
  String get journeyDate => 'Journey date';

  @override
  String get selectDate => 'Select journey date';

  @override
  String get liveStatus => 'Live status';

  @override
  String get route => 'Route';

  @override
  String get routeAndSchedule => 'Route & schedule';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String updatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String delayBy(int minutes) {
    return '$minutes min late';
  }

  @override
  String get onTime => 'On time';

  @override
  String get delay => 'Delay';

  @override
  String get currentStation => 'Current station';

  @override
  String get nextStation => 'Next station';

  @override
  String get expectedArrival => 'Expected arrival';

  @override
  String get progress => 'Journey progress';

  @override
  String get distanceCovered => 'Covered';

  @override
  String get distanceRemaining => 'Remaining';

  @override
  String get completed => 'Completed';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get showAllStations => 'Show all stations';

  @override
  String get hideStations => 'Show fewer stations';

  @override
  String get allStops => 'All stops';

  @override
  String get coachPosition => 'Coach position';

  @override
  String get addFavourite => 'Add to favourites';

  @override
  String get removeFavourite => 'Remove from favourites';

  @override
  String get addedToFavourites => 'Added to favourites';

  @override
  String get removedFromFavourites => 'Removed from favourites';

  @override
  String get noLiveData => 'Live status unavailable';

  @override
  String get noLiveDataBody =>
      'This train may not be running on the selected date.';

  @override
  String get notStarted => 'Not started yet';

  @override
  String get journeyCompleted => 'Journey completed';

  @override
  String stopsCount(int count) {
    return '$count stops';
  }

  @override
  String get trainNotFound => 'Train not found';

  @override
  String get selectTrainFirst => 'Select a train to track';

  @override
  String get trackTrain => 'Track a train';

  @override
  String get trackTrainBody =>
      'Search a train number or name to see its live position.';

  @override
  String get liveTabTitle => 'Live';

  @override
  String get pnrNumber => 'PNR number';

  @override
  String get pnrHint => '10-digit PNR';

  @override
  String get pnrInvalid => 'Enter a valid 10-digit PNR number.';

  @override
  String get checkPnr => 'Check PNR status';

  @override
  String get pnrResult => 'PNR status';

  @override
  String get chartStatus => 'Chart status';

  @override
  String get bookingStatus => 'Booking status';

  @override
  String get currentStatus => 'Current status';

  @override
  String get passenger => 'Passenger';

  @override
  String passengerNumber(int number) {
    return 'Passenger $number';
  }

  @override
  String get coach => 'Coach';

  @override
  String get berth => 'Berth';

  @override
  String get fare => 'Fare';

  @override
  String get classLabel => 'Class';

  @override
  String get quota => 'Quota';

  @override
  String get boardingPoint => 'Boarding point';

  @override
  String get bookingFare => 'Booking fare';

  @override
  String get pnrNotFound => 'PNR not found';

  @override
  String get pnrNotFoundBody => 'Check the number and try again.';

  @override
  String get pnrEmptyTitle => 'Check your PNR';

  @override
  String get pnrEmptyBody =>
      'Enter your 10-digit PNR to see coach, berth and chart status.';

  @override
  String get recentPnr => 'Recent PNRs';

  @override
  String get stationSearchHint => 'Station name or code';

  @override
  String get liveStationBoard => 'Live station board';

  @override
  String get stationNotFound => 'Station not found';

  @override
  String get stationNotFoundBody =>
      'Try a station code like NDLS or a name like New Delhi.';

  @override
  String get stationEmptyTitle => 'Find a station';

  @override
  String get stationEmptyBody =>
      'Search any station to see live arrivals and departures.';

  @override
  String nextHours(int hours) {
    return 'Next $hours hours';
  }

  @override
  String get arrivals => 'Arrivals';

  @override
  String get departures => 'Departures';

  @override
  String get expected => 'Expected';

  @override
  String get scheduled => 'Scheduled';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get startsHere => 'Starts here';

  @override
  String get endsHere => 'Ends here';

  @override
  String get searchStation => 'Search station';

  @override
  String get popularStations => 'Popular stations';

  @override
  String get noFavourites => 'No saved trains yet';

  @override
  String get noFavouritesBody => 'Tap the star on any train to keep it here.';

  @override
  String get savedTrains => 'Saved trains';

  @override
  String get clearRecents => 'Clear recent searches';

  @override
  String get recentsCleared => 'Recent searches cleared';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsBody => 'Journey reminders and delay alerts';

  @override
  String get notificationsNote =>
      'Preference is saved on this device. Push delivery needs Firebase setup.';

  @override
  String get dataAndPrivacy => 'Data & privacy';

  @override
  String get about => 'About RailPulse';

  @override
  String get aboutBody =>
      'A simple, fast and beautiful Indian railway companion. RailPulse is an independent app and is not affiliated with IRCTC or Indian Railways.';

  @override
  String get privacy => 'Privacy policy';

  @override
  String get privacyBody =>
      'RailPulse stores favourites, recent searches and preferences only on your device. Train data requests are sent to your configured RailPulse proxy, which may cache responses briefly. No personal data is sold or shared.';

  @override
  String get help => 'Help & support';

  @override
  String get helpBody =>
      'For help, contact support@railpulse.in. Always check the official railway display at your station before travelling.';

  @override
  String get clearCache => 'Clear cached data';

  @override
  String get cacheCleared => 'Cached data cleared';

  @override
  String get version => 'Version';

  @override
  String get apiServer => 'API server';

  @override
  String get disclaimer => 'Data disclaimer';

  @override
  String get disclaimerBody =>
      'Live data depends on the connected railway provider and may be delayed or unavailable. Always confirm at the station.';

  @override
  String get offlineNote =>
      'Previously loaded schedules stay available offline.';

  @override
  String get trains => 'Trains';

  @override
  String get stations => 'Stations';

  @override
  String get changeTrain => 'Change train';

  @override
  String get trackedTrain => 'Tracked train';

  @override
  String get autoRefresh => 'Auto-refresh';

  @override
  String get autoRefreshNote =>
      'Live status refreshes automatically every 60 seconds.';

  @override
  String get autoRefreshOn => 'Live updates on';

  @override
  String get autoRefreshOff => 'Live updates paused';

  @override
  String get passengers => 'Passengers';

  @override
  String get noTrainsWindow => 'No trains found in this window';

  @override
  String get noTrainsWindowBody =>
      'Try a longer time window or choose another station.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clearCacheConfirm =>
      'This removes recent searches and the last tracked train from this device.';

  @override
  String get track => 'Track';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get liveData => 'Live data';

  @override
  String get navHome => 'Home';

  @override
  String get navLive => 'Live';

  @override
  String get navPnr => 'PNR';

  @override
  String get navFavourites => 'Saved';

  @override
  String get navSettings => 'Settings';

  @override
  String get apiServerBody =>
      'Address of the RailPulse proxy. Leave blank to use the build default.';

  @override
  String get apiServerHint => 'http://192.168.1.10:8787';

  @override
  String get save => 'Save';

  @override
  String get reset => 'Reset to default';

  @override
  String get serverSaved => 'Server address saved';
}
