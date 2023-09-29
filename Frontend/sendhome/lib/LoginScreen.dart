import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Mapa_usuario.dart';
import 'global/global.dart';
import 'registro_usuario.dart';
import 'seleccionElectrodomestico.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible =false;

  void _sumit()async{
    if(_formKey.currentState!.validate()){
      await firebaseAuth.createUserWithEmailAndPassword(
        email: _correoController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) async{
        currentUser=value.user;
        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.push(context, MaterialPageRoute(builder: (c)=>MyMapApp()));
      }).catchError((errorMesage){
        Fluttertoast.showToast(msg: "Error ocurred: \n $errorMesage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all field are valid");
    }
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
                            prefixIcon: Icon(Icons.mail,color: Colors.deepPurpleAccent),
                          ),
                          cursorColor: Colors.blue,
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value==null || value.isEmpty){
                              return "El Correo no puede estar vacio";
                            }
                            if(EmailValidator.validate(value)==true){
                              return null;
                            }
                            if(value.length <2){
                              return "Porfavor ingrese un Correo valido";
                            }
                            if(value.length >99){
                              return "El Correo no puede tener mas de 100 caracteres ";
                            }
                          },
                        ),
                  ),
                        TextFormField(
                          obscureText:!_passwordVisible,
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
                            prefixIcon: Icon(Icons.password,color: Colors.deepPurpleAccent),
                            suffixIcon: IconButton(
                              icon :Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.deepPurpleAccent,
                              ),
                              onPressed: (){
                                setState(() {
                                  _passwordVisible=!_passwordVisible;
                                });
                              },
                            ),
                          ),
                          cursorColor: Colors.blue,
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value==null || value.isEmpty){
                              return "El Clave no puede estar vacio";
                            }
                            if(value.length <2){
                              return "Porfavor ingrese una clave valida";
                            }
                            if(value.length >99){
                              return "La Clave no puede tener mas de 100 caracteres ";
                            }
                          },
                          onChanged: (value)=>setState(() {
                            _passwordController.text=value;
                          }),
                        ),
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
                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: (){},
                          child:Center(
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Tienes una cuenta?",
                              style: TextStyle(
                                color:Colors.black45,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){},
                              child: Text(
                                'sing In',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                          ],
                        )

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
