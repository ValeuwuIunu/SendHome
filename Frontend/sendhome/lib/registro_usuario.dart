import 'package:flutter/material.dart';
import 'registro_conductor.dart';

class User {
  String numUser;
  String nombreUser;
  String correo;
  String passwordUser;
  String passworCdUser;

  User(this.numUser, this.nombreUser, this.correo, this.passwordUser,
      this.passworCdUser);
}

class MyAppregistrousuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _numUserController = TextEditingController();
  final _nombreUserController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordUserController = TextEditingController();
  final _passwordCUserController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              // Navegar a la siguiente pantalla o realizar otras acciones
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAppregistroconductor()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
              foregroundColor: Colors.white,
              elevation: 5,
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            ),
            child: Text(
              'Registrarse como conductor',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
        toolbarHeight: 80,
        titleTextStyle: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
                  width: 400, // Ancho del Card
                  height: 550, // Alto del Card

                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _numUserController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
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
                              return 'Por favor, ingresa una cédula válida.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nombreUserController,
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
                                borderSide: BorderSide(color: Colors.black54)),
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
                          controller: _correoController,
                          decoration: InputDecoration(
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
                                borderSide: BorderSide(color: Colors.black54)),
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
                          controller: _passwordUserController,
                          obscureText: true,
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
                                borderSide: BorderSide(color: Colors.black54)),
                          ),
                          cursorColor: Colors.blue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa una contraseña.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordCUserController,
                          obscureText: true,
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
                                borderSide: BorderSide(color: Colors.black54)),
                          ),
                          cursorColor: Colors.blue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, confirma la contraseña.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 70.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navegar a la siguiente pantalla o realizar otras acciones
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyAppregistrousuario()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                              foregroundColor:
                                  Colors.white, // Color del texto del botón
                              elevation: 10, // Altura de la sombra
                              padding: EdgeInsets.symmetric(
                                  horizontal: 45.0,
                                  vertical: 10.0), // Relleno interno del botón
                            ),
                            child: Text(
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
          ),
        ),
      ),
    );
  }
}

class ConfirmationUserPage extends StatelessWidget {
  final User user;

  ConfirmationUserPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmación de Registro como usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Numero telefónico: ${user.numUser}'),
            Text('Nombre completo: ${user.nombreUser}'),
            Text('Correo electrónico: ${user.correo}'),
            Text('Contraseña: ${user.passwordUser}'),
            Text('Confirmar contraseña: ${user.passworCdUser}')
          ],
        ),
      ),
    );
  }
}
