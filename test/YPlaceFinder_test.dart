import 'package:rikulo_yapi/yplacefinder.dart';

void main() {
  yPlaceFinder.loadGeoInfo({'location' : 'San+Francisco,+CA'})
    .then((Map result) => print(result));
}
