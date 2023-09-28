import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sendhome/seleccionElectrodomestico.dart';

class MyMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyMapScreen(),
    );
  }
}

class MyMapScreen extends StatefulWidget {
  @override
  _MyMapScreenState createState() => _MyMapScreenState();
}

class _MyMapScreenState extends State<MyMapScreen> {
  GoogleMapController? _controller;
  TextEditingController _startAddressController = TextEditingController();
  TextEditingController _endAddressController = TextEditingController();
  TextEditingController _personNameController = TextEditingController();
  TextEditingController _personIDController = TextEditingController();
  Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        toolbarHeight: 20,
        titleTextStyle: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  _controller = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(4.6097, -74.0817), // Coordenadas de Bogotá
                zoom: 15.0,
              ),
              markers: _markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _startAddressController,
              decoration: InputDecoration(
                labelText: 'Dirección de partida',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _endAddressController,
              decoration: InputDecoration(
                labelText: 'Dirección de llegada',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _personNameController,
              decoration: InputDecoration(
                labelText: 'Nombre de la persona',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _personIDController,
              decoration: InputDecoration(
                labelText: 'Identificación de la persona',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                // Navegar a la siguiente pantalla o realizar otras acciones
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppSelectElect()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(47, 8, 73, 0.90),
                foregroundColor: Colors.white,
                elevation: 10,
                padding: const EdgeInsets.symmetric(
                    horizontal: 45.0, vertical: 10.0),
              ),
              child: Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}