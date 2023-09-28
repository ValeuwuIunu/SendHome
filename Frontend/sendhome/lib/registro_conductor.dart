import 'package:flutter/material.dart';
import 'registro_licencia.dart';
import 'registro_usuario.dart';
import 'registro_vehiculo.dart';

class User {
  String numDriver;
  String nombreDriver;
  String correoDriver;
  String passwordDriver;
  String passwordCDriver;
  String cedula;

  User(this.numDriver, this.nombreDriver, this.correoDriver,
      this.passwordDriver, this.passwordCDriver, this.cedula);
}

class MyAppregistroconductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: RegistrationDriverPage(),
    );
  }
}

class RegistrationDriverPage extends StatefulWidget {
  @override
  _RegistrationDriverPageState createState() => _RegistrationDriverPageState();
}

class _RegistrationDriverPageState extends State<RegistrationDriverPage> {
  final _formKey = GlobalKey<FormState>();
  final _numDriverController = TextEditingController();
  final _nombreDriverController = TextEditingController();
  final _correoDriverController = TextEditingController();
  final _passwordDriverController = TextEditingController();
  final _passwordCDriverController = TextEditingController();
  final _cedulaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined,
              size: 40, color: Colors.black87),
          highlightColor: Colors.cyan,
          splashColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAppregistrousuario()),
            );
          },
        ),
        toolbarHeight: 60,
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
                  height: 550, // Alto del Card

                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _numDriverController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Número telefónico',
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
                                return 'Por favor, ingresa una número válida.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _nombreDriverController,
                            decoration: InputDecoration(
                              hintText: 'Nombre completo',
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
                                return 'Por favor, ingresa un nombre válido.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _correoDriverController,
                            decoration: const InputDecoration(
                              hintText: 'Correo electrónico',
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
                                return 'Por favor, ingresa un apellido válido.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordDriverController,
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
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
                                return 'Por favor, ingresa una dirección válida.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordCDriverController,
                            decoration: InputDecoration(
                              hintText: 'Confirmar contraseña',
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
                                return 'Por favor, ingresa una ciudad válida.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _cedulaController,
                            decoration: const InputDecoration(
                              hintText: 'Cédula',
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
                                return 'Por favor, ingresa una ciudad válida.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 60.0),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navegar a la siguiente pantalla o realizar otras acciones
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyAppregistroLicencia()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                                foregroundColor:
                                    Colors.white, // Color del texto del botón
                                elevation: 10, // Altura de la sombra
                                padding: EdgeInsets.symmetric(
                                    horizontal: 45.0,
                                    vertical:
                                        10.0), // Relleno interno del botón
                              ),
                              child: Text(
                                'Continuar',
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
            ),
          ),
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
            Text('Numero telefónico: ${user.numDriver}'),
            Text('Nombre completo: ${user.nombreDriver}'),
            Text('Correo electrónico: ${user.correoDriver}'),
            Text('Contraseña: ${user.passwordDriver}'),
            Text('Confirmar contraseña: ${user.passwordCDriver}')
          ],
        ),
      ),
    );
  }
}
