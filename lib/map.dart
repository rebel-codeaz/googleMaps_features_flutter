import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mappy/src/directions_model.dart';
import 'package:mappy/src/directions_repository.dart';
import 'package:mappy/widgets/CustomTileProvider.dart';


class MainMap extends StatefulWidget {
  const MainMap({ Key? key }) : super(key: key);

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {

  late GoogleMapController mapController;
  TileOverlay? _tileOverlay = null;

  Marker _myLandMark = Marker(
    markerId: const MarkerId('1'),
    infoWindow: const InfoWindow(title: '1'),
    icon: BitmapDescriptor.defaultMarker,
    position: const LatLng(45.521563, -122.677433),
  );

  // TileProvider tileProvider = Uri.tile
  Marker? _source = null;
  Marker? _destination = null;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  bool _isMapTypeListVisible = false;

  MapType _currentMapType = MapType.normal;

  var currentZoomLevel = 7.0;

  late Directions? _directions = null;

  final _initialCameraPosition = CameraPosition(
    target: LatLng(45.521563, -122.677433),
    zoom: 9.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addTileOverlay();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeTileOverlay() {
    setState(() {
      _tileOverlay = null;
    });
  }

 void _clearTileCache() {
    if (_tileOverlay != null && mapController != null) {
      mapController.clearTileCache(_tileOverlay!.tileOverlayId);
    }
  }

  void _addTileOverlay() {
    final TileOverlay tileOverlay = TileOverlay(
      tileOverlayId: TileOverlayId('tile_overlay_1'),
      tileProvider: DebugTileProvider(),
    );
    setState(() {
      _tileOverlay = tileOverlay;
    });
  }

 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTypeButtonPressed(MapType myType) {
    setState(() {
      _currentMapType = myType;
    });
  }

  void _onZoomChanged(CameraPosition position) {
    // print("position: " + position.target.toString());
    // print("zoom: " + position.zoom.toString());
    setState(() {
      currentZoomLevel = position.zoom;
    });
  }

  void _toggleMapTypeVisiblity() {
    setState(() {
      _isMapTypeListVisible = !_isMapTypeListVisible;
    });
  }

  @override
  Widget build(BuildContext context) {

     Set<TileOverlay> overlays = <TileOverlay>{
      if (_tileOverlay != null) _tileOverlay!,
    };

    return Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialCameraPosition,
              mapType: _currentMapType,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              scrollGesturesEnabled: true,
              minMaxZoomPreference: MinMaxZoomPreference(7, 20),
              // markers: {_myLandMark}, to use to put only one marker
              markers: {
                if (_source != null) _source ?? _myLandMark,
                if (_destination != null) _destination ?? _myLandMark
              },
              onLongPress: _addLandMark,
              onCameraMove: _onZoomChanged,
              tileOverlays: overlays,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: {
                if (_directions != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.deepPurple,
                    width: 2,
                    points: _directions!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
            ),
            if (_directions != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_directions!.totalDistance}, ${_directions!.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                      tooltip: "Brings map to my location",
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.center_focus_strong_rounded),
                      onPressed: () => mapController.animateCamera(
                        _directions != null
                            ? CameraUpdate.newLatLngBounds(
                                _directions!.bounds, 100)
                            : CameraUpdate.newCameraPosition(
                                _initialCameraPosition),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: _isMapTypeListVisible,
                        child: Container(
                          height: 200,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    _onMapTypeButtonPressed(MapType.normal),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.yellow[300],
                                      child: Text(
                                        "N",
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _onMapTypeButtonPressed(MapType.terrain),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.brown[300],
                                      child: Text(
                                        "T",
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    _onMapTypeButtonPressed(MapType.satellite),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.blue[300],
                                      child: Text(
                                        "S",
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FloatingActionButton(
                            tooltip: "Changes map type",
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.grey[400],
                            child: Icon(Icons.map_rounded),
                            onPressed: _toggleMapTypeVisiblity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: false,
              child: Container(
                height: 30,
                width: 300,
                alignment: Alignment.bottomCenter,
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Add tile'),
                      onPressed: _addTileOverlay,
                    ),
                    TextButton(
                      child: const Text('Remove tile'),
                      onPressed: _removeTileOverlay,
                    ),
                    TextButton(
                      child: const Text('Clear tile cache'),
                      onPressed: _clearTileCache,
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ;
  }

  void _addLandMark(LatLng pos) async {
    setState(() {
      if (_source != null || (_source != null && _destination != null)) {
        // Origin is not set OR Origin/Destination are both set
        // Set origin
        setState(() {
          _source = Marker(
              markerId: const MarkerId('#1s'),
              infoWindow: const InfoWindow(title: 'source'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan),
              position: pos);

          _destination = null; //reset destination
          _directions = null;
        });
      } else {
        // Origin is already set
        // Set destination
        _destination = null;
      }
    });
    // Get directions
    final directions = await DirectionsRepository(dio: Dio()).getDirections(
        origin: _source != null ? _source!.position : _myLandMark.position,
        destination: pos);
    setState(() => _directions = directions);
  }

  
}
