//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Wed, Jun 20, 2012  05:22:36 PM
// Author: hernichen


/** Singleton Yahoo PlaceFinder */
YPlaceFinder yPlaceFinder = new YPlaceFinder._internal();

/**
 * Bridge Dart to Yahoo PlaceFinder API; see http://developer.yahoo.com/geo/placefinder/ for details.
 */
class YPlaceFinder {
  const String _BASE_URI = "http://where.yahooapis.com/geocode";

  factory YPlaceFinder() => yPlaceFinder;

  YPlaceFinder._internal(){}

  /** Load geo information per the specified [location] parameters in a Map via
   * returned Future.then() function; see
   * <http://developer.yahoo.com/geo/placefinder/guide/responses.html> for details.
   *
   * + [locations] location parameter; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [controls] optional control parametr; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [flags] optional control flag; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details.
   * + [gflags] optional special control flag; see <http://developer.yahoo.com/geo/placefinder/guide/requests.html> for details
   */
  Future<Map> loadGeoInfo(Map locations, {Map controls, String flags, String gflags}) {
    StringBuffer params = new StringBuffer();
    if (locations != null)
      locations.forEach((k,v) => params.isEmpty() ? params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    if (controls != null) { //skip flags key
      controls.forEach((k,v) =>
          k.toLowerCase() == 'flags' ? params.add("") : params.isEmpty() ?
              params.add(k).add('=').add(v) : params.add('&').add(k).add('=').add(v));
    }
    if (flags != null) {
      if (!flags.isEmpty()) {
        //filter out "J" & "P" flag, always use XML
        flags = StringUtil.filterOut(flags, "JP");
        if (params.isEmpty())
          params.add("flags=").add(flags);
        else
          params.add("&flags=").add(flags);
      }
    }

    if (gflags != null) {
      if (!gflags.isEmpty()) {
        if (params.isEmpty())
          params.add("gflags=").add(gflags);
        else
          params.add("&gflags=").add(gflags);
      }
    }

    StringBuffer url = new StringBuffer(_BASE_URI);
    if (!params.isEmpty())
      url.add("?").add(params);
    Completer cmpl = new Completer();
    HttpRequest req = new HttpRequest();
    req.on.readyStateChange.add((event){
      if (req.readyState == HttpRequest.DONE && req.status == 200) {
        final Document doc = req.responseXML;
        if (doc != null) {
          var resultSet = JSUtil.xmlNodeToDartMap(doc.documentElement, new Map());
          if (resultSet is Map)
            cmpl.complete(resultSet);
          else
            cmpl.completeException(new RuntimeError("No element: '$resultSet'"));
        } else {
          cmpl.completeException(new RuntimeError("Empty document"));
        }
      }
    });
    req.open("GET", url.toString(), true);
    req.send(null);
    return cmpl.future;
  }
}