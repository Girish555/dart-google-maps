import 'dart:html' hide MouseEvent;
import 'package:js/js.dart' as js;
import 'package:google_maps/google_maps.dart';

ElevationService elevator;
GMap map;
final InfoWindow infowindow = js.retain(new InfoWindow());
final LatLng denali = js.retain(new LatLng(63.3333333, -150.5));

void main() {
  final mapOptions = new MapOptions()
    ..zoom = 8
    ..center = denali
    ..mapTypeId = MapTypeId.TERRAIN
    ;
  map = js.retain(new GMap(query("#map_canvas"), mapOptions));

  // Create an ElevationService
  elevator = js.retain(new ElevationService());

  // Add a listener for the click event and call getElevation on that location
  map.onClick.listen(getElevation);
}


void getElevation(MouseEvent e) {
  final locations = new List<LatLng>();

  // Retrieve the clicked location and push it on the array
  final LatLng clickedLocation = js.retain(e.latLng);
  locations.add(clickedLocation);

  // Create a LocationElevationRequest object using the array's one value
  var positionalRequest = new LocationElevationRequest()
    ..locations = locations
    ;

  // Initiate the location request
  elevator.getElevationForLocations(positionalRequest, (List<ElevationResult> results, ElevationStatus status) {
    if (status == ElevationStatus.OK) {

      // Retrieve the first result
      if (!results.isEmpty) {

        // Open an info window indicating the elevation at the clicked position
        infowindow.content = 'The elevation at this point <br>is ${results[0].elevation} meters.';
        infowindow.position = clickedLocation;
        js.release(clickedLocation);
        infowindow.open(map);
      } else {
        window.alert('No results found');
      }
    } else {
      window.alert('Elevation service failed due to: ${status}');
    }
  });
}