import 'package:flutter/material.dart';
import 'Mapa_usuario.dart';
import 'registro_usuario.dart';
import 'seleccionElectrodomestico.dart';

class MyAppLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String enteredUsername = _correoController.text;
    String enteredPassword = _passwordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/Frame_1.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar( actions: [IconButton(
            icon: Icon(Icons.person_add_alt_rounded,
                size: 40, color: Colors.black87),
            constraints:
            BoxConstraints.tightFor(width: 60, height: 60),
            highlightColor: Colors.cyan,
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            },
          ),],
            toolbarHeight: 80,
            titleTextStyle: const TextStyle(
              fontSize: 28.0, // Tamaño de fuente
              fontWeight: FontWeight.bold, // Peso de fuente
              color: Colors.white, // Color del texto
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: SafeArea(
            child: Center(
                child: SingleChildScrollView(

                child: SizedBox(
                  width: 400, // Ancho del Card
                  height: 300, // Alto del Card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(child:
                        TextField(
                            controller: _correoController,
                            decoration: InputDecoration(
                              hintText: 'Correo',
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
                            cursorColor: Colors.blue),
                  ),

                        TextField(
                            controller: _passwordController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Contraseña ',
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
                            cursorColor: Colors.blue),
                        SizedBox(height: 45),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                          // Navegar a la siguiente pantalla o realizar otras acciones
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyMapScreen()),
                        );
                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                              foregroundColor:
                                  Colors.white, // Color del texto del botón
                              elevation: 10, // Altura de la sombra
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 45.0,
                                  vertical: 10.0), // Relleno interno del botón
                            ),
                            child: Text(
                              'Ingresar',
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
            )),
          ),
        ),
    );
  }
}
