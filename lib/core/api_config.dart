/// Main Link for API calls
const String endpoint = 'https://api.openweathermap.org/data/2.5/';

String iconURL(String icon) => 'https://openweathermap.org/img/wn/$icon@2x.png';

/// API Key
String get appid => '097c61bfc1e557c6898369de5d830c45';

/// API call for current weather
String get weatherPoint => '${endpoint}weather';

/// Language for API call
String get lang => 'ua';