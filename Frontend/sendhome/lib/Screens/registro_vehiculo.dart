import 'package:flutter/material.dart';

import 'registro_licencia.dart';

class User {
  String placa;
  String modelo;
  String color;
  String cedulaProp;
  String capacidad;

  User(this.placa, this.modelo, this.color, this.cedulaProp, this.capacidad);
}

class MyAppregistroVehiculo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: RegistrationVehiculoPage(),
    );
  }
}

class RegistrationVehiculoPage extends StatefulWidget {
  @override
  _RegistrationVehiculoPageState createState() =>
      _RegistrationVehiculoPageState();
}

class _RegistrationVehiculoPageState extends State<RegistrationVehiculoPage> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _colorController = TextEditingController();
  final _cedulaPropController = TextEditingController();
  final _capacidadController = TextEditingController();

  bool selectedTypeAceptar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_outlined, size: 30, color: Colors.black87),
          constraints: BoxConstraints.tightFor(width: 60, height: 60),
          highlightColor: Colors.cyan,
          splashColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAppregistroLicencia()),
            );
          },
        ),
        toolbarHeight: 35,
        titleTextStyle: const TextStyle(
          fontSize: 28.0, // Tamaño de fuente
          fontWeight: FontWeight.bold, // Peso de fuente
          color: Colors.white, // Color del texto
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(9.5),
        child: Card(
          color: Color.fromRGBO(185, 175, 224, 1.0), // Cambia el color de fondo
          elevation: 6.0, // Cambia la elevación y la sombra
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Cambia el radio de los bordes
          ),
          margin: EdgeInsets.all(28.5),
          child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 1500.0, // Establece la altura máxima deseada
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 500, // Ancho del Card
                    height: 950, // Alto del Card

                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _placaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Placa del vehiculo',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Cambia el color del borde enfocado si es necesario
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .black54), // Cambia el color del borde cuando no está enfocado si es necesario
                                ),
                              ),
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa una placa válida.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _modeloController,
                              decoration: InputDecoration(
                                hintText: 'Modelo',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Cambia el color del borde enfocado si es necesario
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                              ),
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa un modelo válido.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _colorController,
                              decoration: InputDecoration(
                                hintText: 'Color',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Cambia el color del borde enfocado si es necesario
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                              ),
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa un color válido.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              controller: _cedulaPropController,
                              decoration: InputDecoration(
                                hintText: 'Cédula propietario',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Cambia el color del borde enfocado si es necesario
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                              ),
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa una cédula válida.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: _capacidadController,
                              decoration: InputDecoration(
                                hintText: 'Capacidad de almacenamiento',
                                labelStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Cambia el color del borde enfocado si es necesario
                                ),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black54)),
                              ),
                              cursorColor: Colors.blue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa una capacidad válida.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15.0),
                            const Text(
                              'Adjunte una foto con su licencia de conducción ',
                              style: TextStyle(
                                fontSize:
                                    16.0, // Tamaño de fuente// Peso de fuente (puede ser FontWeight.normal)
                                color: Colors.black87, // Color del texto
                                fontStyle: FontStyle
                                    .italic, // Estilo de fuente (puede ser FontStyle.normal)// Espacio entre caracteres// Decoración (puede ser TextDecoration.none)// Color de la decoración (si es necesario)
                                decorationStyle: TextDecorationStyle
                                    .dashed, // Estilo de la decoración, // Fuente personalizada (si está disponible)
                              ),
                            ),
                            SizedBox(height: 5.0),
                            SizedBox(
                              height: 90.0,
                              width: 180.0,
                              child: Image.asset('assets/upload.png'),
                            ),
                            CheckboxListTile(
                              value: selectedTypeAceptar,
                              onChanged: (val) {
                                setState(() {
                                  selectedTypeAceptar = val!;
                                });
                              },
                              activeColor: Colors.indigoAccent,
                              title:
                                  const Text("Acepto términos y condiciones"),
                            ),
                            SizedBox(height: 15.0),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(47, 8, 73, 0.5),
                                  foregroundColor:
                                      Colors.white, // Color del texto del botón
                                  elevation: 10, // Altura de la sombra
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 45.0, vertical: 10.0),
                                ),
                                onPressed: () {
                                  // Navegar a la siguiente pantalla o realizar otras acciones
                                 /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyMapConductorApp()),
                                  );*/
                                },
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                      fontSize:
                                          18.0), // Tamaño de fuente del texto del botón
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ),

    );
  }
}

class ConfirmationPage extends StatelessWidget {
  final User user;

  ConfirmationPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmación de Registro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Placa del vehículo: ${user.placa}'),
            Text('Modelo: ${user.modelo}'),
            Text('Color: ${user.color}'),
            Text('Cedula propietario: ${user.cedulaProp}'),
            Text('Capacidad de almacenamiento: ${user.capacidad}'),
          ],
        ),
      ),
    );
  }
}
