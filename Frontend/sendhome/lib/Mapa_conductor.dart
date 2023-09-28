import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MyMapConductorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapConductorScreen(),
    );
  }
}

class MapConductorScreen extends StatefulWidget {
  @override
  _MapConductorScreenState createState() => _MapConductorScreenState();
}

class _MapConductorScreenState extends State<MapConductorScreen> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};

  // Datos del solicitante
  String nombreSolicitante = "Nombre del Solicitante";
  String direccionSolicitante = "Dirección del Solicitante";
  double valorCarrera = 25.0; // Valor de la carrera

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Google'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
              // Agregar un marcador en el mapa
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId('1'),
                    position: LatLng(37.422, -122.084),
                    infoWindow: InfoWindow(
                      title: 'Ubicación del Solicitante',
                      snippet:
                      '$nombreSolicitante\n$valorCarrera USD\n$direccionSolicitante',
                    ),
                  ),
                );
              });
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(37.422, -122.084),
              zoom: 15.0,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Card(
              elevation: 8.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Solicitante',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text('Nombre: $nombreSolicitante'),
                    Text('Dirección: $direccionSolicitante'),
                    Text('Valor de la Carrera: \$${valorCarrera.toStringAsFixed(2)} USD'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}