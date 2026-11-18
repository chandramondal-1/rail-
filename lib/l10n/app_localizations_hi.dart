// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'RailPulse';

  @override
  String get tagline => 'आपकी ट्रेन। आपकी यात्रा। लाइव।';

  @override
  String get greetingMorning => 'सुप्रभात';

  @override
  String get greetingAfternoon => 'नमस्कार';

  @override
  String get greetingEvening => 'शुभ संध्या';

  @override
  String get homeTitle => 'आपकी ट्रेन कहाँ है?';

  @override
  String get homeSubtitle => 'लाइव स्थिति, रूट और प्लेटफ़ॉर्म — सब एक जगह।';

  @override
  String get searchHint => 'ट्रेन नंबर या नाम';

  @override
  String get searchAction => 'खोजें';

  @override
  String get searchMinChars => 'कम से कम 2 अक्षर लिखें।';

  @override
  String get searchEmptyTitle => 'कोई ट्रेन नहीं मिली';

  @override
  String get searchEmptyBody =>
      '12951 जैसा ट्रेन नंबर या राजधानी जैसा नाम आज़माएँ।';

  @override
  String get searchResults => 'खोज परिणाम';

  @override
  String get searchFor => 'ट्रेन खोजें';

  @override
  String get recentSearches => 'हाल की खोजें';

  @override
  String get noRecentSearches => 'आपकी हाल की खोजें यहाँ दिखेंगी।';

  @override
  String get popularServices => 'लोकप्रिय सेवाएँ';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get quickAccess => 'तुरंत पहुँच';

  @override
  String get liveTrainStatus => 'लाइव स्थिति';

  @override
  String get liveTrainStatusSubtitle => 'अभी कहाँ है?';

  @override
  String get pnrStatus => 'PNR स्थिति';

  @override
  String get pnrStatusSubtitle => 'अपनी बुकिंग देखें';

  @override
  String get trainSchedule => 'ट्रेन रूट';

  @override
  String get trainScheduleSubtitle => 'हर स्टेशन और समय';

  @override
  String get stationStatus => 'स्टेशन बोर्ड';

  @override
  String get stationStatusSubtitle => 'आगमन और प्रस्थान';

  @override
  String get favourites => 'पसंदीदा';

  @override
  String get favouritesSubtitle => 'सहेजी गई ट्रेनें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get demoBadge => 'डेमो डेटा';

  @override
  String get demoNotice =>
      'RailPulse डेमो मोड का नमूना डेटा। लाइव रेलवे डेटा कनेक्ट नहीं है।';

  @override
  String get demoPnrHint =>
      'डेमो मोड — कोई भी 10 अंकों का PNR नमूना डेटा दिखाएगा।';

  @override
  String get liveBadge => 'लाइव';

  @override
  String get dataSource => 'डेटा स्रोत';

  @override
  String get dataSourceDemo => 'डेमो मोड — नमूना डेटा';

  @override
  String get dataSourceLive => 'RailKit के ज़रिए लाइव रेलवे डेटा';

  @override
  String get backendUnreachable => 'RailPulse सर्वर से संपर्क नहीं हो रहा';

  @override
  String get backendUnreachableBody =>
      'लोकल API प्रॉक्सी शुरू करें, फिर कोशिश करें।';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get refresh => 'रिफ़्रेश';

  @override
  String get close => 'बंद करें';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get remove => 'हटाएँ';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get somethingWentWrong => 'कुछ गड़बड़ हो गई';

  @override
  String get checkConnection => 'अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get updated => 'अपडेट';

  @override
  String minAgo(int minutes) {
    return '$minutes मिनट पहले';
  }

  @override
  String get justNow => 'अभी-अभी';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get yesterday => 'कल';

  @override
  String get trainNumber => 'ट्रेन नंबर';

  @override
  String get runsOn => 'चलती है';

  @override
  String get runsDaily => 'रोज़ चलती है';

  @override
  String get duration => 'अवधि';

  @override
  String get distance => 'दूरी';

  @override
  String get source => 'से';

  @override
  String get destination => 'तक';

  @override
  String get departure => 'प्रस्थान';

  @override
  String get arrival => 'आगमन';

  @override
  String get platform => 'प्लेटफ़ॉर्म';

  @override
  String platformNumber(String number) {
    return 'PF $number';
  }

  @override
  String get halt => 'ठहराव';

  @override
  String get day => 'दिन';

  @override
  String dayNumber(int number) {
    return 'दिन $number';
  }

  @override
  String km(String value) {
    return '$value किमी';
  }

  @override
  String get journeyDate => 'यात्रा तिथि';

  @override
  String get selectDate => 'यात्रा तिथि चुनें';

  @override
  String get liveStatus => 'लाइव स्थिति';

  @override
  String get route => 'रूट';

  @override
  String get routeAndSchedule => 'रूट और समय-सारणी';

  @override
  String get lastUpdated => 'अंतिम अपडेट';

  @override
  String updatedAt(String time) {
    return 'अपडेट $time';
  }

  @override
  String delayBy(int minutes) {
    return '$minutes मिनट देरी';
  }

  @override
  String get onTime => 'समय पर';

  @override
  String get delay => 'देरी';

  @override
  String get currentStation => 'वर्तमान स्टेशन';

  @override
  String get nextStation => 'अगला स्टेशन';

  @override
  String get expectedArrival => 'अनुमानित आगमन';

  @override
  String get progress => 'यात्रा प्रगति';

  @override
  String get distanceCovered => 'तय';

  @override
  String get distanceRemaining => 'शेष';

  @override
  String get completed => 'पूरा';

  @override
  String get upcoming => 'आगामी';

  @override
  String get showAllStations => 'सभी स्टेशन दिखाएँ';

  @override
  String get hideStations => 'कम स्टेशन दिखाएँ';

  @override
  String get allStops => 'सभी स्टॉप';

  @override
  String get coachPosition => 'कोच स्थिति';

  @override
  String get addFavourite => 'पसंदीदा में जोड़ें';

  @override
  String get removeFavourite => 'पसंदीदा से हटाएँ';

  @override
  String get addedToFavourites => 'पसंदीदा में जोड़ा गया';

  @override
  String get removedFromFavourites => 'पसंदीदा से हटाया गया';

  @override
  String get noLiveData => 'लाइव स्थिति उपलब्ध नहीं';

  @override
  String get noLiveDataBody => 'चुनी गई तिथि पर यह ट्रेन शायद नहीं चल रही।';

  @override
  String get notStarted => 'अभी शुरू नहीं हुई';

  @override
  String get journeyCompleted => 'यात्रा पूरी';

  @override
  String stopsCount(int count) {
    return '$count स्टॉप';
  }

  @override
  String get trainNotFound => 'ट्रेन नहीं मिली';

  @override
  String get selectTrainFirst => 'ट्रैक करने के लिए ट्रेन चुनें';

  @override
  String get trackTrain => 'ट्रेन ट्रैक करें';

  @override
  String get trackTrainBody =>
      'लाइव स्थिति देखने के लिए ट्रेन नंबर या नाम खोजें।';

  @override
  String get liveTabTitle => 'लाइव';

  @override
  String get pnrNumber => 'PNR नंबर';

  @override
  String get pnrHint => '10 अंकों का PNR';

  @override
  String get pnrInvalid => 'सही 10 अंकों का PNR दर्ज करें।';

  @override
  String get checkPnr => 'PNR स्थिति देखें';

  @override
  String get pnrResult => 'PNR स्थिति';

  @override
  String get chartStatus => 'चार्ट स्थिति';

  @override
  String get bookingStatus => 'बुकिंग स्थिति';

  @override
  String get currentStatus => 'वर्तमान स्थिति';

  @override
  String get passenger => 'यात्री';

  @override
  String passengerNumber(int number) {
    return 'यात्री $number';
  }

  @override
  String get coach => 'कोच';

  @override
  String get berth => 'बर्थ';

  @override
  String get fare => 'किराया';

  @override
  String get classLabel => 'क्लास';

  @override
  String get quota => 'कोटा';

  @override
  String get boardingPoint => 'बोर्डिंग पॉइंट';

  @override
  String get bookingFare => 'बुकिंग किराया';

  @override
  String get pnrNotFound => 'PNR नहीं मिला';

  @override
  String get pnrNotFoundBody => 'नंबर जाँचें और फिर कोशिश करें।';

  @override
  String get pnrEmptyTitle => 'अपना PNR देखें';

  @override
  String get pnrEmptyBody =>
      'कोच, बर्थ और चार्ट स्थिति देखने के लिए 10 अंकों का PNR दर्ज करें।';

  @override
  String get recentPnr => 'हाल के PNR';

  @override
  String get stationSearchHint => 'स्टेशन नाम या कोड';

  @override
  String get liveStationBoard => 'लाइव स्टेशन बोर्ड';

  @override
  String get stationNotFound => 'स्टेशन नहीं मिला';

  @override
  String get stationNotFoundBody =>
      'NDLS जैसा कोड या नई दिल्ली जैसा नाम आज़माएँ।';

  @override
  String get stationEmptyTitle => 'स्टेशन खोजें';

  @override
  String get stationEmptyBody =>
      'लाइव आगमन और प्रस्थान देखने के लिए कोई स्टेशन खोजें।';

  @override
  String nextHours(int hours) {
    return 'अगले $hours घंटे';
  }

  @override
  String get arrivals => 'आगमन';

  @override
  String get departures => 'प्रस्थान';

  @override
  String get expected => 'अनुमानित';

  @override
  String get scheduled => 'निर्धारित';

  @override
  String get cancelled => 'रद्द';

  @override
  String get startsHere => 'यहाँ से शुरू';

  @override
  String get endsHere => 'यहाँ समाप्त';

  @override
  String get searchStation => 'स्टेशन खोजें';

  @override
  String get popularStations => 'लोकप्रिय स्टेशन';

  @override
  String get noFavourites => 'अभी कोई ट्रेन सहेजी नहीं';

  @override
  String get noFavouritesBody => 'किसी भी ट्रेन पर स्टार दबाकर उसे यहाँ रखें।';

  @override
  String get savedTrains => 'सहेजी गई ट्रेनें';

  @override
  String get clearRecents => 'हाल की खोजें साफ़ करें';

  @override
  String get recentsCleared => 'हाल की खोजें साफ़ हो गईं';

  @override
  String get appearance => 'रूप';

  @override
  String get theme => 'थीम';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get language => 'भाषा';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get notificationsBody => 'यात्रा रिमाइंडर और देरी अलर्ट';

  @override
  String get notificationsNote =>
      'यह सेटिंग इस डिवाइस पर सहेजी जाती है। पुश सूचनाओं के लिए Firebase सेटअप चाहिए।';

  @override
  String get dataAndPrivacy => 'डेटा और गोपनीयता';

  @override
  String get about => 'RailPulse के बारे में';

  @override
  String get aboutBody =>
      'एक सरल, तेज़ और सुंदर भारतीय रेलवे साथी। RailPulse एक स्वतंत्र ऐप है और IRCTC या भारतीय रेलवे से संबद्ध नहीं है।';

  @override
  String get privacy => 'गोपनीयता नीति';

  @override
  String get privacyBody =>
      'RailPulse आपकी पसंदीदा ट्रेनें, हाल की खोजें और सेटिंग्स केवल आपके डिवाइस पर रखता है। ट्रेन डेटा अनुरोध आपके RailPulse प्रॉक्सी को भेजे जाते हैं, जो जवाब थोड़ी देर कैश कर सकता है। कोई व्यक्तिगत डेटा बेचा या साझा नहीं किया जाता।';

  @override
  String get help => 'सहायता और समर्थन';

  @override
  String get helpBody =>
      'सहायता के लिए support@railpulse.in पर संपर्क करें। यात्रा से पहले स्टेशन पर आधिकारिक डिस्प्ले ज़रूर देखें।';

  @override
  String get clearCache => 'कैश डेटा साफ़ करें';

  @override
  String get cacheCleared => 'कैश डेटा साफ़ हो गया';

  @override
  String get version => 'संस्करण';

  @override
  String get apiServer => 'API सर्वर';

  @override
  String get disclaimer => 'डेटा अस्वीकरण';

  @override
  String get disclaimerBody =>
      'लाइव डेटा जुड़े रेलवे प्रदाता पर निर्भर है और देर से या अनुपलब्ध हो सकता है। स्टेशन पर पुष्टि करें।';

  @override
  String get offlineNote => 'पहले लोड किए गए रूट ऑफ़लाइन उपलब्ध रहते हैं।';

  @override
  String get trains => 'ट्रेनें';

  @override
  String get stations => 'स्टेशन';

  @override
  String get changeTrain => 'ट्रेन बदलें';

  @override
  String get trackedTrain => 'ट्रैक की गई ट्रेन';

  @override
  String get autoRefresh => 'स्वतः रीफ़्रेश';

  @override
  String get autoRefreshNote =>
      'लाइव स्थिति हर 60 सेकंड में स्वतः रीफ़्रेश होती है।';

  @override
  String get autoRefreshOn => 'लाइव अपडेट चालू';

  @override
  String get autoRefreshOff => 'लाइव अपडेट रुके हुए';

  @override
  String get passengers => 'यात्री';

  @override
  String get noTrainsWindow => 'इस अवधि में कोई ट्रेन नहीं मिली';

  @override
  String get noTrainsWindowBody => 'लंबी समय अवधि चुनें या दूसरा स्टेशन चुनें।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get clearCacheConfirm =>
      'यह इस डिवाइस से हाल की खोजें और अंतिम ट्रैक की गई ट्रेन हटा देगा।';

  @override
  String get track => 'ट्रैक करें';

  @override
  String get demoMode => 'डेमो मोड';

  @override
  String get liveData => 'लाइव डेटा';

  @override
  String get navHome => 'होम';

  @override
  String get navLive => 'लाइव';

  @override
  String get navPnr => 'PNR';

  @override
  String get navFavourites => 'सहेजे';

  @override
  String get navSettings => 'सेटिंग्स';

  @override
  String get apiServerBody =>
      'RailPulse प्रॉक्सी का पता। डिफ़ॉल्ट उपयोग करने के लिए खाली छोड़ें।';

  @override
  String get apiServerHint => 'http://192.168.1.10:8787';

  @override
  String get save => 'सहेजें';

  @override
  String get reset => 'डिफ़ॉल्ट पर लौटें';

  @override
  String get serverSaved => 'सर्वर पता सहेजा गया';
}
