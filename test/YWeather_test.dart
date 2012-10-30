import 'package:rikulo_yapi/yplacefinder.dart';
import 'package:rikulo_yapi/yweather.dart';

void main() {
  yPlaceFinder.loadGeoInfo({'location' : 'San+Francisco,+CA'})
    .then((Map result) {
      String woeid = result['ResultSet']['Result']['woeid'];
      new YWeather(woeid).loadWeatherInfo()
        .then((Map result) => print(result));
    });
}
