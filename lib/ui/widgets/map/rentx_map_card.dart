import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'package:rentx/models/location.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

class RentXMapCard extends StatefulWidget {
  final RentXLocation location;
  final double? width;
  final double? height;
  final bool? disableNavigation;
  final RentXMapController? controller;
  final Function(RentXLatLong)? onPositionTap;
  final List<RentXMapMarker>? markers;

  const RentXMapCard(
      {Key? key,
      required this.location,
      this.width,
      this.height,
      this.disableNavigation,
      this.controller,
      this.onPositionTap,
      this.markers})
      : assert(onPositionTap == null || markers == null),
        super(key: key);

  @override
  _RentXMapCardState createState() => _RentXMapCardState();
}

class _RentXMapCardState extends State<RentXMapCard> {
  final MapController _mapController = MapController();
  LatLng? _locationMarkerPosition;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      widget.controller!.move = _move;
      widget.controller!.zoomIn = _zoomIn;
      widget.controller!.zoomOut = _zoomOut;
    }
    _locationMarkerPosition =
        LatLng(widget.location.latitude, widget.location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (context) => Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            width: widget.width,
            height: widget.height,
            child: AbsorbPointer(
              absorbing:
                  widget.disableNavigation != null && widget.disableNavigation!,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  onTap: _onMapTap,
                  slideOnBoundaries: true,
                  enableScrollWheel: false,
                  allowPanningOnScrollingParent: false,
                  allowPanning: false,
                  center: LatLng(
                      widget.location.latitude, widget.location.longitude),
                  zoom: 16.0,
                ),
                layers: [
                  TileLayerOptions(
                    backgroundColor: context.theme.theme.backgroundColor,
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [_locationMarker(), ..._predefinedMarkers() ?? []],
                  ),
                ],
              ),
            )));
  }

  Marker _locationMarker() {
    return Marker(
      width: width(32),
      height: height(32),
      point: _locationMarkerPosition ??
          LatLng(widget.location.latitude, widget.location.longitude),
      builder: (ctx) {
        return SvgPicture.asset(
          "assets/img/marker.svg",
        );
      },
    );
  }

  List<Marker>? _predefinedMarkers() {
    return widget.markers
        ?.map((marker) => Marker(
            point: LatLng(marker.point.latitude, marker.point.longitude),
            width: marker.width,
            height: marker.height,
            builder: marker.builder))
        .toList();
  }

  void _move(RentXLocation location) {
    setState(() {
      _locationMarkerPosition = LatLng(location.latitude, location.longitude);
    });
    _mapController.move(LatLng(location.latitude, location.longitude), 16);
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (widget.onPositionTap != null) {
      widget.onPositionTap?.call(RentXLatLong(point.latitude, point.longitude));
      setState(() {
        _locationMarkerPosition = point;
      });
    }
  }

  void _zoomIn() {
    _mapController.move(_mapController.center, _mapController.zoom + 1);
  }

  void _zoomOut() {
    _mapController.move(_mapController.center, _mapController.zoom - 1);
  }
}

class RentXMapController {
  Function(RentXLocation)? move;

  Function()? zoomIn;

  Function()? zoomOut;

  RentXMapController();
}

class RentXMapMarker {
  late RentXLatLong point;
  late double width;
  late double height;
  late WidgetBuilder builder;

  RentXMapMarker(
      {required this.point,
      required this.width,
      required this.height,
      required this.builder});
}
