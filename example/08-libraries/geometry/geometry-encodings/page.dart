#import('dart:html');
#import('../../../../lib/gmaps.dart', prefix:'gmaps');
#import('../../../../lib/gmaps-geometry.dart', prefix:'gmaps_geo');

gmaps.Polyline poly;

void main() {
  final mapOptions = new gmaps.MapOptions()
    ..zoom = 14
    ..center = new gmaps.LatLng(34.3664951, -89.5192484)
    ..mapTypeId = gmaps.MapTypeId.ROADMAP
    ;

  final map = new gmaps.GMap(query("#map_canvas"), mapOptions);

  final polyOptions = new gmaps.PolylineOptions()
    ..strokeColor = '#000000'
    ..strokeOpacity = 1.0
    ..strokeWeight = 3
    ..map = map
    ;
  poly = new gmaps.Polyline(polyOptions);

  // Add a listener for the click event
  gmaps.Events.addListener(map, 'click', addLatLng);
}

/**
 * Handles click events on a map, and adds a new point to the Polyline.
 * Updates the encoding text area with the path's encoded values.
 */
void addLatLng(gmaps.NativeEvent e) {
  final me = new gmaps.MouseEvent.wrap(e);
  final path = poly.getPath();
  // Because path is an MVCArray, we can simply append a new coordinate
  // and it will automatically appear
  path.push(me.latLng);

  // Update the text field to display the polyline encodings
  final encodeString = gmaps_geo.Encoding.encodePath(path);
  if (encodeString !== null) {
    (query('#encoded-polyline') as TextAreaElement).value = encodeString;
  }
}