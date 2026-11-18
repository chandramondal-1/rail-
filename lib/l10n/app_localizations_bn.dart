// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appName => 'RailPulse';

  @override
  String get tagline => 'আপনার ট্রেন। আপনার যাত্রা। লাইভ।';

  @override
  String get greetingMorning => 'শুভ সকাল';

  @override
  String get greetingAfternoon => 'শুভ অপরাহ্ন';

  @override
  String get greetingEvening => 'শুভ সন্ধ্যা';

  @override
  String get homeTitle => 'আপনার ট্রেন কোথায়?';

  @override
  String get homeSubtitle => 'লাইভ অবস্থা, রুট ও প্ল্যাটফর্ম — সব এক জায়গায়।';

  @override
  String get searchHint => 'ট্রেন নম্বর বা নাম';

  @override
  String get searchAction => 'খুঁজুন';

  @override
  String get searchMinChars => 'কমপক্ষে ২টি অক্ষর লিখুন।';

  @override
  String get searchEmptyTitle => 'কোনো ট্রেন পাওয়া যায়নি';

  @override
  String get searchEmptyBody =>
      '12951-এর মতো ট্রেন নম্বর বা রাজধানীর মতো নাম চেষ্টা করুন।';

  @override
  String get searchResults => 'সার্চ ফলাফল';

  @override
  String get searchFor => 'ট্রেন খুঁজুন';

  @override
  String get recentSearches => 'সাম্প্রতিক সার্চ';

  @override
  String get noRecentSearches => 'আপনার সাম্প্রতিক সার্চ এখানে দেখা যাবে।';

  @override
  String get popularServices => 'জনপ্রিয় সার্ভিস';

  @override
  String get viewAll => 'সব দেখুন';

  @override
  String get quickAccess => 'দ্রুত অ্যাক্সেস';

  @override
  String get liveTrainStatus => 'লাইভ স্ট্যাটাস';

  @override
  String get liveTrainStatusSubtitle => 'এখন কোথায়?';

  @override
  String get pnrStatus => 'PNR স্ট্যাটাস';

  @override
  String get pnrStatusSubtitle => 'আপনার বুকিং দেখুন';

  @override
  String get trainSchedule => 'ট্রেন রুট';

  @override
  String get trainScheduleSubtitle => 'প্রতিটি স্টপ ও সময়';

  @override
  String get stationStatus => 'স্টেশন বোর্ড';

  @override
  String get stationStatusSubtitle => 'আগমন ও প্রস্থান';

  @override
  String get favourites => 'প্রিয়';

  @override
  String get favouritesSubtitle => 'সংরক্ষিত ট্রেন';

  @override
  String get settings => 'সেটিংস';

  @override
  String get demoBadge => 'ডেমো ডেটা';

  @override
  String get demoNotice =>
      'RailPulse ডেমো মোডের নমুনা ডেটা। লাইভ রেলওয়ে ডেটা সংযুক্ত নয়।';

  @override
  String get demoPnrHint =>
      'ডেমো মোড — যেকোনো ১০ সংখ্যার PNR নমুনা ডেটা দেখাবে।';

  @override
  String get liveBadge => 'লাইভ';

  @override
  String get dataSource => 'ডেটা সোর্স';

  @override
  String get dataSourceDemo => 'ডেমো মোড — নমুনা ডেটা';

  @override
  String get dataSourceLive => 'RailKit-এর মাধ্যমে লাইভ রেলওয়ে ডেটা';

  @override
  String get backendUnreachable => 'RailPulse সার্ভারে পৌঁছানো যাচ্ছে না';

  @override
  String get backendUnreachableBody =>
      'লোকাল API প্রক্সি চালু করে আবার চেষ্টা করুন।';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get refresh => 'রিফ্রেশ';

  @override
  String get close => 'বন্ধ';

  @override
  String get clear => 'মুছুন';

  @override
  String get remove => 'সরান';

  @override
  String get seeAll => 'সব দেখুন';

  @override
  String get somethingWentWrong => 'কিছু ভুল হয়েছে';

  @override
  String get checkConnection => 'সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get loading => 'লোড হচ্ছে';

  @override
  String get noData => 'কোনো ডেটা নেই';

  @override
  String get updated => 'আপডেট';

  @override
  String minAgo(int minutes) {
    return '$minutes মিনিট আগে';
  }

  @override
  String get justNow => 'এইমাত্র';

  @override
  String get today => 'আজ';

  @override
  String get tomorrow => 'আগামীকাল';

  @override
  String get yesterday => 'গতকাল';

  @override
  String get trainNumber => 'ট্রেন নম্বর';

  @override
  String get runsOn => 'চলে';

  @override
  String get runsDaily => 'প্রতিদিন চলে';

  @override
  String get duration => 'সময়কাল';

  @override
  String get distance => 'দূরত্ব';

  @override
  String get source => 'থেকে';

  @override
  String get destination => 'পর্যন্ত';

  @override
  String get departure => 'প্রস্থান';

  @override
  String get arrival => 'আগমন';

  @override
  String get platform => 'প্ল্যাটফর্ম';

  @override
  String platformNumber(String number) {
    return 'PF $number';
  }

  @override
  String get halt => 'থামা';

  @override
  String get day => 'দিন';

  @override
  String dayNumber(int number) {
    return '$number নম্বর দিন';
  }

  @override
  String km(String value) {
    return '$value কিমি';
  }

  @override
  String get journeyDate => 'যাত্রার তারিখ';

  @override
  String get selectDate => 'যাত্রার তারিখ বাছুন';

  @override
  String get liveStatus => 'লাইভ স্ট্যাটাস';

  @override
  String get route => 'রুট';

  @override
  String get routeAndSchedule => 'রুট ও সময়সূচি';

  @override
  String get lastUpdated => 'শেষ আপডেট';

  @override
  String updatedAt(String time) {
    return 'আপডেট $time';
  }

  @override
  String delayBy(int minutes) {
    return '$minutes মিনিট দেরি';
  }

  @override
  String get onTime => 'সময়মতো';

  @override
  String get delay => 'দেরি';

  @override
  String get currentStation => 'বর্তমান স্টেশন';

  @override
  String get nextStation => 'পরবর্তী স্টেশন';

  @override
  String get expectedArrival => 'সম্ভাব্য আগমন';

  @override
  String get progress => 'যাত্রার অগ্রগতি';

  @override
  String get distanceCovered => 'অতিক্রান্ত';

  @override
  String get distanceRemaining => 'বাকি';

  @override
  String get completed => 'সম্পন্ন';

  @override
  String get upcoming => 'আসন্ন';

  @override
  String get showAllStations => 'সব স্টেশন দেখুন';

  @override
  String get hideStations => 'কম স্টেশন দেখুন';

  @override
  String get allStops => 'সব স্টপ';

  @override
  String get coachPosition => 'কোচ অবস্থান';

  @override
  String get addFavourite => 'প্রিয়তে যোগ করুন';

  @override
  String get removeFavourite => 'প্রিয় থেকে সরান';

  @override
  String get addedToFavourites => 'প্রিয়তে যোগ হয়েছে';

  @override
  String get removedFromFavourites => 'প্রিয় থেকে সরানো হয়েছে';

  @override
  String get noLiveData => 'লাইভ স্ট্যাটাস নেই';

  @override
  String get noLiveDataBody => 'নির্বাচিত তারিখে ট্রেনটি চলছে না।';

  @override
  String get notStarted => 'এখনও শুরু হয়নি';

  @override
  String get journeyCompleted => 'যাত্রা সম্পন্ন';

  @override
  String stopsCount(int count) {
    return '$count স্টপ';
  }

  @override
  String get trainNotFound => 'ট্রেন পাওয়া যায়নি';

  @override
  String get selectTrainFirst => 'ট্র্যাক করতে ট্রেন বাছুন';

  @override
  String get trackTrain => 'ট্রেন ট্র্যাক করুন';

  @override
  String get trackTrainBody => 'লাইভ অবস্থান দেখতে ট্রেন নম্বর বা নাম খুঁজুন।';

  @override
  String get liveTabTitle => 'লাইভ';

  @override
  String get pnrNumber => 'PNR নম্বর';

  @override
  String get pnrHint => '১০ সংখ্যার PNR';

  @override
  String get pnrInvalid => 'সঠিক ১০ সংখ্যার PNR দিন।';

  @override
  String get checkPnr => 'PNR স্ট্যাটাস দেখুন';

  @override
  String get pnrResult => 'PNR স্ট্যাটাস';

  @override
  String get chartStatus => 'চার্ট স্ট্যাটাস';

  @override
  String get bookingStatus => 'বুকিং স্ট্যাটাস';

  @override
  String get currentStatus => 'বর্তমান স্ট্যাটাস';

  @override
  String get passenger => 'যাত্রী';

  @override
  String passengerNumber(int number) {
    return 'যাত্রী $number';
  }

  @override
  String get coach => 'কোচ';

  @override
  String get berth => 'বার্থ';

  @override
  String get fare => 'ভাড়া';

  @override
  String get classLabel => 'ক্লাস';

  @override
  String get quota => 'কোটা';

  @override
  String get boardingPoint => 'বোর্ডিং পয়েন্ট';

  @override
  String get bookingFare => 'বুকিং ভাড়া';

  @override
  String get pnrNotFound => 'PNR পাওয়া যায়নি';

  @override
  String get pnrNotFoundBody => 'নম্বর পরীক্ষা করে আবার চেষ্টা করুন।';

  @override
  String get pnrEmptyTitle => 'আপনার PNR দেখুন';

  @override
  String get pnrEmptyBody =>
      'কোচ, বার্থ ও চার্ট স্ট্যাটাস দেখতে ১০ সংখ্যার PNR দিন।';

  @override
  String get recentPnr => 'সাম্প্রতিক PNR';

  @override
  String get stationSearchHint => 'স্টেশনের নাম বা কোড';

  @override
  String get liveStationBoard => 'লাইভ স্টেশন বোর্ড';

  @override
  String get stationNotFound => 'স্টেশন পাওয়া যায়নি';

  @override
  String get stationNotFoundBody =>
      'NDLS-এর মতো কোড বা নিউ দিল্লির মতো নাম চেষ্টা করুন।';

  @override
  String get stationEmptyTitle => 'স্টেশন খুঁজুন';

  @override
  String get stationEmptyBody =>
      'লাইভ আগমন ও প্রস্থান দেখতে যেকোনো স্টেশন খুঁজুন।';

  @override
  String nextHours(int hours) {
    return 'পরবর্তী $hours ঘণ্টা';
  }

  @override
  String get arrivals => 'আগমন';

  @override
  String get departures => 'প্রস্থান';

  @override
  String get expected => 'সম্ভাব্য';

  @override
  String get scheduled => 'নির্ধারিত';

  @override
  String get cancelled => 'বাতিল';

  @override
  String get startsHere => 'এখান থেকে শুরু';

  @override
  String get endsHere => 'এখানে শেষ';

  @override
  String get searchStation => 'স্টেশন খুঁজুন';

  @override
  String get popularStations => 'জনপ্রিয় স্টেশন';

  @override
  String get noFavourites => 'এখনও কোনো ট্রেন সংরক্ষিত নেই';

  @override
  String get noFavouritesBody => 'যেকোনো ট্রেনে স্টার চাপলে সেটি এখানে থাকবে।';

  @override
  String get savedTrains => 'সংরক্ষিত ট্রেন';

  @override
  String get clearRecents => 'সাম্প্রতিক সার্চ মুছুন';

  @override
  String get recentsCleared => 'সাম্প্রতিক সার্চ মুছে গেছে';

  @override
  String get appearance => 'চেহারা';

  @override
  String get theme => 'থিম';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLight => 'লাইট';

  @override
  String get themeDark => 'ডার্ক';

  @override
  String get language => 'ভাষা';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get notificationsBody => 'যাত্রার রিমাইন্ডার ও দেরির অ্যালার্ট';

  @override
  String get notificationsNote =>
      'সেটিংটি এই ডিভাইসে সংরক্ষিত থাকে। পুশ নোটিফিকেশনের জন্য Firebase সেটআপ দরকার।';

  @override
  String get dataAndPrivacy => 'ডেটা ও গোপনীয়তা';

  @override
  String get about => 'RailPulse সম্পর্কে';

  @override
  String get aboutBody =>
      'সহজ, দ্রুত ও সুন্দর ভারতীয় রেলওয়ে সঙ্গী। RailPulse একটি স্বতন্ত্র অ্যাপ এবং IRCTC বা ভারতীয় রেলের সাথে যুক্ত নয়।';

  @override
  String get privacy => 'গোপনীয়তা নীতি';

  @override
  String get privacyBody =>
      'RailPulse আপনার প্রিয় ট্রেন, সাম্প্রতিক সার্চ ও পছন্দ শুধু আপনার ডিভাইসে রাখে। ট্রেন ডেটার অনুরোধ আপনার RailPulse প্রক্সিতে যায়, যা সাময়িকভাবে ক্যাশ করতে পারে। কোনো ব্যক্তিগত ডেটা বিক্রি বা শেয়ার করা হয় না।';

  @override
  String get help => 'সহায়তা ও সমর্থন';

  @override
  String get helpBody =>
      'সহায়তার জন্য support@railpulse.in-এ যোগাযোগ করুন। যাত্রার আগে স্টেশনের সরকারি ডিসপ্লে দেখে নিন।';

  @override
  String get clearCache => 'ক্যাশ ডেটা মুছুন';

  @override
  String get cacheCleared => 'ক্যাশ ডেটা মুছে গেছে';

  @override
  String get version => 'সংস্করণ';

  @override
  String get apiServer => 'API সার্ভার';

  @override
  String get disclaimer => 'ডেটা দাবিত্যাগ';

  @override
  String get disclaimerBody =>
      'লাইভ ডেটা সংযুক্ত রেলওয়ে প্রদানকারীর উপর নির্ভর করে এবং দেরি বা অনুপলব্ধ হতে পারে। স্টেশনে নিশ্চিত করুন।';

  @override
  String get offlineNote => 'আগে লোড করা রুট অফলাইনে পাওয়া যায়।';

  @override
  String get trains => 'ট্রেন';

  @override
  String get stations => 'স্টেশন';

  @override
  String get changeTrain => 'ট্রেন বদলান';

  @override
  String get trackedTrain => 'ট্র্যাক করা ট্রেন';

  @override
  String get autoRefresh => 'স্বয়ংক্রিয় রিফ্রেশ';

  @override
  String get autoRefreshNote =>
      'লাইভ স্ট্যাটাস প্রতি ৬০ সেকেন্ডে স্বয়ংক্রিয়ভাবে রিফ্রেশ হয়।';

  @override
  String get autoRefreshOn => 'লাইভ আপডেট চালু';

  @override
  String get autoRefreshOff => 'লাইভ আপডেট বিরত';

  @override
  String get passengers => 'যাত্রী';

  @override
  String get noTrainsWindow => 'এই সময়সীমায় কোনো ট্রেন পাওয়া যায়নি';

  @override
  String get noTrainsWindowBody =>
      'দীর্ঘ সময়সীমা বেছে নিন বা অন্য স্টেশন নির্বাচন করুন।';

  @override
  String get cancel => 'বাতিল';

  @override
  String get clearCacheConfirm =>
      'এটি এই ডিভাইস থেকে সাম্প্রতিক অনুসন্ধান এবং সর্বশেষ ট্র্যাক করা ট্রেন মুছে ফেলবে।';

  @override
  String get track => 'ট্র্যাক করুন';

  @override
  String get demoMode => 'ডেমো মোড';

  @override
  String get liveData => 'লাইভ ডেটা';

  @override
  String get navHome => 'হোম';

  @override
  String get navLive => 'লাইভ';

  @override
  String get navPnr => 'PNR';

  @override
  String get navFavourites => 'সংরক্ষিত';

  @override
  String get navSettings => 'সেটিংস';

  @override
  String get apiServerBody =>
      'RailPulse প্রক্সির ঠিকানা। ডিফল্ট ব্যবহার করতে খালি রাখুন।';

  @override
  String get apiServerHint => 'http://192.168.1.10:8787';

  @override
  String get save => 'সংরক্ষণ';

  @override
  String get reset => 'ডিফল্টে ফিরুন';

  @override
  String get serverSaved => 'সার্ভার ঠিকানা সংরক্ষিত';
}
