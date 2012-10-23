import 'package:rikulo_yapi/rikulo_yapi.dart';

void main() {
  placefinder.loadGeoInfo({'location' : 'San+Francisco,+CA'})
    .then((Map result) => print(result));
}
