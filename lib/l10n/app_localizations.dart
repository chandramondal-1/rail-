import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'RailPulse'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your Train. Your Journey. Live.'**
  String get tagline;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Where is your train?'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live running status, routes and platforms — all in one place.'**
  String get homeSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Train number or name'**
  String get searchHint;

  /// No description provided for @searchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// No description provided for @searchMinChars.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters.'**
  String get searchMinChars;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No trains found'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try a train number like 12951, or a name like Rajdhani.'**
  String get searchEmptyBody;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @searchFor.
  ///
  /// In en, this message translates to:
  /// **'Search trains'**
  String get searchFor;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get recentSearches;

  /// No description provided for @noRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Your recent searches will appear here.'**
  String get noRecentSearches;

  /// No description provided for @popularServices.
  ///
  /// In en, this message translates to:
  /// **'Popular services'**
  String get popularServices;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick access'**
  String get quickAccess;

  /// No description provided for @liveTrainStatus.
  ///
  /// In en, this message translates to:
  /// **'Live status'**
  String get liveTrainStatus;

  /// No description provided for @liveTrainStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where is it right now?'**
  String get liveTrainStatusSubtitle;

  /// No description provided for @pnrStatus.
  ///
  /// In en, this message translates to:
  /// **'PNR status'**
  String get pnrStatus;

  /// No description provided for @pnrStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your booking'**
  String get pnrStatusSubtitle;

  /// No description provided for @trainSchedule.
  ///
  /// In en, this message translates to:
  /// **'Train route'**
  String get trainSchedule;

  /// No description provided for @trainScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every stop and time'**
  String get trainScheduleSubtitle;

  /// No description provided for @stationStatus.
  ///
  /// In en, this message translates to:
  /// **'Station board'**
  String get stationStatus;

  /// No description provided for @stationStatusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Arrivals and departures'**
  String get stationStatusSubtitle;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @favouritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved trains'**
  String get favouritesSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @demoBadge.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get demoBadge;

  /// No description provided for @demoNotice.
  ///
  /// In en, this message translates to:
  /// **'Sample data from RailPulse demo mode. Live railway data is not connected.'**
  String get demoNotice;

  /// No description provided for @demoPnrHint.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — any 10-digit PNR shows sample data.'**
  String get demoPnrHint;

  /// No description provided for @liveBadge.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveBadge;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get dataSource;

  /// No description provided for @dataSourceDemo.
  ///
  /// In en, this message translates to:
  /// **'Demo mode — sample data'**
  String get dataSourceDemo;

  /// No description provided for @dataSourceLive.
  ///
  /// In en, this message translates to:
  /// **'Live railway data via a secure proxy'**
  String get dataSourceLive;

  /// No description provided for @backendUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the RailPulse server'**
  String get backendUnreachable;

  /// No description provided for @backendUnreachableBody.
  ///
  /// In en, this message translates to:
  /// **'Start the local API proxy, then try again.'**
  String get backendUnreachableBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnection;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @minAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String minAgo(int minutes);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @trainNumber.
  ///
  /// In en, this message translates to:
  /// **'Train number'**
  String get trainNumber;

  /// No description provided for @runsOn.
  ///
  /// In en, this message translates to:
  /// **'Runs on'**
  String get runsOn;

  /// No description provided for @runsDaily.
  ///
  /// In en, this message translates to:
  /// **'Runs daily'**
  String get runsDaily;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get source;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get destination;

  /// No description provided for @departure.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get departure;

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @platformNumber.
  ///
  /// In en, this message translates to:
  /// **'PF {number}'**
  String platformNumber(String number);

  /// No description provided for @halt.
  ///
  /// In en, this message translates to:
  /// **'Halt'**
  String get halt;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayNumber(int number);

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String km(String value);

  /// No description provided for @journeyDate.
  ///
  /// In en, this message translates to:
  /// **'Journey date'**
  String get journeyDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select journey date'**
  String get selectDate;

  /// No description provided for @liveStatus.
  ///
  /// In en, this message translates to:
  /// **'Live status'**
  String get liveStatus;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @routeAndSchedule.
  ///
  /// In en, this message translates to:
  /// **'Route & schedule'**
  String get routeAndSchedule;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedAt(String time);

  /// No description provided for @delayBy.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min late'**
  String delayBy(int minutes);

  /// No description provided for @onTime.
  ///
  /// In en, this message translates to:
  /// **'On time'**
  String get onTime;

  /// No description provided for @delay.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get delay;

  /// No description provided for @currentStation.
  ///
  /// In en, this message translates to:
  /// **'Current station'**
  String get currentStation;

  /// No description provided for @nextStation.
  ///
  /// In en, this message translates to:
  /// **'Next station'**
  String get nextStation;

  /// No description provided for @expectedArrival.
  ///
  /// In en, this message translates to:
  /// **'Expected arrival'**
  String get expectedArrival;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Journey progress'**
  String get progress;

  /// No description provided for @distanceCovered.
  ///
  /// In en, this message translates to:
  /// **'Covered'**
  String get distanceCovered;

  /// No description provided for @distanceRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get distanceRemaining;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @showAllStations.
  ///
  /// In en, this message translates to:
  /// **'Show all stations'**
  String get showAllStations;

  /// No description provided for @hideStations.
  ///
  /// In en, this message translates to:
  /// **'Show fewer stations'**
  String get hideStations;

  /// No description provided for @allStops.
  ///
  /// In en, this message translates to:
  /// **'All stops'**
  String get allStops;

  /// No description provided for @coachPosition.
  ///
  /// In en, this message translates to:
  /// **'Coach position'**
  String get coachPosition;

  /// No description provided for @addFavourite.
  ///
  /// In en, this message translates to:
  /// **'Add to favourites'**
  String get addFavourite;

  /// No description provided for @removeFavourite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get removeFavourite;

  /// No description provided for @addedToFavourites.
  ///
  /// In en, this message translates to:
  /// **'Added to favourites'**
  String get addedToFavourites;

  /// No description provided for @removedFromFavourites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favourites'**
  String get removedFromFavourites;

  /// No description provided for @noLiveData.
  ///
  /// In en, this message translates to:
  /// **'Live status unavailable'**
  String get noLiveData;

  /// No description provided for @noLiveDataBody.
  ///
  /// In en, this message translates to:
  /// **'This train may not be running on the selected date.'**
  String get noLiveDataBody;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started yet'**
  String get notStarted;

  /// No description provided for @journeyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Journey completed'**
  String get journeyCompleted;

  /// No description provided for @stopsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stops'**
  String stopsCount(int count);

  /// No description provided for @trainNotFound.
  ///
  /// In en, this message translates to:
  /// **'Train not found'**
  String get trainNotFound;

  /// No description provided for @selectTrainFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a train to track'**
  String get selectTrainFirst;

  /// No description provided for @trackTrain.
  ///
  /// In en, this message translates to:
  /// **'Track a train'**
  String get trackTrain;

  /// No description provided for @trackTrainBody.
  ///
  /// In en, this message translates to:
  /// **'Search a train number or name to see its live position.'**
  String get trackTrainBody;

  /// No description provided for @liveTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get liveTabTitle;

  /// No description provided for @pnrNumber.
  ///
  /// In en, this message translates to:
  /// **'PNR number'**
  String get pnrNumber;

  /// No description provided for @pnrHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit PNR'**
  String get pnrHint;

  /// No description provided for @pnrInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit PNR number.'**
  String get pnrInvalid;

  /// No description provided for @checkPnr.
  ///
  /// In en, this message translates to:
  /// **'Check PNR status'**
  String get checkPnr;

  /// No description provided for @pnrResult.
  ///
  /// In en, this message translates to:
  /// **'PNR status'**
  String get pnrResult;

  /// No description provided for @chartStatus.
  ///
  /// In en, this message translates to:
  /// **'Chart status'**
  String get chartStatus;

  /// No description provided for @bookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Booking status'**
  String get bookingStatus;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get currentStatus;

  /// No description provided for @passenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get passenger;

  /// No description provided for @passengerNumber.
  ///
  /// In en, this message translates to:
  /// **'Passenger {number}'**
  String passengerNumber(int number);

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @berth.
  ///
  /// In en, this message translates to:
  /// **'Berth'**
  String get berth;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @quota.
  ///
  /// In en, this message translates to:
  /// **'Quota'**
  String get quota;

  /// No description provided for @boardingPoint.
  ///
  /// In en, this message translates to:
  /// **'Boarding point'**
  String get boardingPoint;

  /// No description provided for @bookingFare.
  ///
  /// In en, this message translates to:
  /// **'Booking fare'**
  String get bookingFare;

  /// No description provided for @pnrNotFound.
  ///
  /// In en, this message translates to:
  /// **'PNR not found'**
  String get pnrNotFound;

  /// No description provided for @pnrNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Check the number and try again.'**
  String get pnrNotFoundBody;

  /// No description provided for @pnrEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your PNR'**
  String get pnrEmptyTitle;

  /// No description provided for @pnrEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your 10-digit PNR to see coach, berth and chart status.'**
  String get pnrEmptyBody;

  /// No description provided for @recentPnr.
  ///
  /// In en, this message translates to:
  /// **'Recent PNRs'**
  String get recentPnr;

  /// No description provided for @stationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Station name or code'**
  String get stationSearchHint;

  /// No description provided for @liveStationBoard.
  ///
  /// In en, this message translates to:
  /// **'Live station board'**
  String get liveStationBoard;

  /// No description provided for @stationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Station not found'**
  String get stationNotFound;

  /// No description provided for @stationNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'Try a station code like NDLS or a name like New Delhi.'**
  String get stationNotFoundBody;

  /// No description provided for @stationEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a station'**
  String get stationEmptyTitle;

  /// No description provided for @stationEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Search any station to see live arrivals and departures.'**
  String get stationEmptyBody;

  /// No description provided for @nextHours.
  ///
  /// In en, this message translates to:
  /// **'Next {hours} hours'**
  String nextHours(int hours);

  /// No description provided for @arrivals.
  ///
  /// In en, this message translates to:
  /// **'Arrivals'**
  String get arrivals;

  /// No description provided for @departures.
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get departures;

  /// No description provided for @expected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @startsHere.
  ///
  /// In en, this message translates to:
  /// **'Starts here'**
  String get startsHere;

  /// No description provided for @endsHere.
  ///
  /// In en, this message translates to:
  /// **'Ends here'**
  String get endsHere;

  /// No description provided for @searchStation.
  ///
  /// In en, this message translates to:
  /// **'Search station'**
  String get searchStation;

  /// No description provided for @popularStations.
  ///
  /// In en, this message translates to:
  /// **'Popular stations'**
  String get popularStations;

  /// No description provided for @noFavourites.
  ///
  /// In en, this message translates to:
  /// **'No saved trains yet'**
  String get noFavourites;

  /// No description provided for @noFavouritesBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on any train to keep it here.'**
  String get noFavouritesBody;

  /// No description provided for @savedTrains.
  ///
  /// In en, this message translates to:
  /// **'Saved trains'**
  String get savedTrains;

  /// No description provided for @clearRecents.
  ///
  /// In en, this message translates to:
  /// **'Clear recent searches'**
  String get clearRecents;

  /// No description provided for @recentsCleared.
  ///
  /// In en, this message translates to:
  /// **'Recent searches cleared'**
  String get recentsCleared;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageBengali;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Journey reminders and delay alerts'**
  String get notificationsBody;

  /// No description provided for @notificationsNote.
  ///
  /// In en, this message translates to:
  /// **'Preference is saved on this device. Push delivery needs Firebase setup.'**
  String get notificationsNote;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & privacy'**
  String get dataAndPrivacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About RailPulse'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'A simple, fast and beautiful Indian railway companion. RailPulse is an independent app and is not affiliated with IRCTC or Indian Railways.'**
  String get aboutBody;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'RailPulse stores favourites, recent searches and preferences only on your device. Train data requests are sent to your configured RailPulse proxy, which may cache responses briefly. No personal data is sold or shared.'**
  String get privacyBody;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get help;

  /// No description provided for @helpBody.
  ///
  /// In en, this message translates to:
  /// **'For help, contact support@railpulse.in. Always check the official railway display at your station before travelling.'**
  String get helpBody;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear cached data'**
  String get clearCache;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cached data cleared'**
  String get cacheCleared;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @apiServer.
  ///
  /// In en, this message translates to:
  /// **'API server'**
  String get apiServer;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Data disclaimer'**
  String get disclaimer;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Live data depends on the connected railway provider and may be delayed or unavailable. Always confirm at the station.'**
  String get disclaimerBody;

  /// No description provided for @offlineNote.
  ///
  /// In en, this message translates to:
  /// **'Previously loaded schedules stay available offline.'**
  String get offlineNote;

  /// No description provided for @trains.
  ///
  /// In en, this message translates to:
  /// **'Trains'**
  String get trains;

  /// No description provided for @stations.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stations;

  /// No description provided for @changeTrain.
  ///
  /// In en, this message translates to:
  /// **'Change train'**
  String get changeTrain;

  /// No description provided for @trackedTrain.
  ///
  /// In en, this message translates to:
  /// **'Tracked train'**
  String get trackedTrain;

  /// No description provided for @autoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto-refresh'**
  String get autoRefresh;

  /// No description provided for @autoRefreshNote.
  ///
  /// In en, this message translates to:
  /// **'Live status refreshes automatically every 60 seconds.'**
  String get autoRefreshNote;

  /// No description provided for @autoRefreshOn.
  ///
  /// In en, this message translates to:
  /// **'Live updates on'**
  String get autoRefreshOn;

  /// No description provided for @autoRefreshOff.
  ///
  /// In en, this message translates to:
  /// **'Live updates paused'**
  String get autoRefreshOff;

  /// No description provided for @passengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get passengers;

  /// No description provided for @noTrainsWindow.
  ///
  /// In en, this message translates to:
  /// **'No trains found in this window'**
  String get noTrainsWindow;

  /// No description provided for @noTrainsWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Try a longer time window or choose another station.'**
  String get noTrainsWindowBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'This removes recent searches and the last tracked train from this device.'**
  String get clearCacheConfirm;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// No description provided for @liveData.
  ///
  /// In en, this message translates to:
  /// **'Live data'**
  String get liveData;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get navLive;

  /// No description provided for @navPnr.
  ///
  /// In en, this message translates to:
  /// **'PNR'**
  String get navPnr;

  /// No description provided for @navFavourites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navFavourites;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @apiServerBody.
  ///
  /// In en, this message translates to:
  /// **'Address of the RailPulse proxy. Leave blank to use the build default.'**
  String get apiServerBody;

  /// No description provided for @apiServerHint.
  ///
  /// In en, this message translates to:
  /// **'http://192.168.1.10:8787'**
  String get apiServerHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get reset;

  /// No description provided for @serverSaved.
  ///
  /// In en, this message translates to:
  /// **'Server address saved'**
  String get serverSaved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
