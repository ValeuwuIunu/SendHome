import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sendhome/global/global.dart';
import 'LoginScreen.dart';
import 'registro_conductor.dart';



class RegistrationPage extends StatefulWidget {

  const RegistrationPage({Key? key}) : super(key: key);
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

  bool _passwordVisible =false;

  void _sumit()async{
    if(_formKey.currentState!.validate()){
      await firebaseAuth.createUserWithEmailAndPassword(
          email: _correoController.text.trim(),
          password: _passwordUserController.text.trim(),
      ).then((value) async{
        currentUser=value.user;
        if(currentUser !=null){
         Map userMap = {
           "id":currentUser!.uid,
           "name":_nombreUserController.text.trim(),
           "email":_correoController.text.trim(),
           "phone":_numUserController.text.trim(),
         };
         DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
         userRef.child(currentUser!.uid).set(userMap);
        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
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
                        IntlPhoneField(
                          showCountryFlag: false,
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.deepPurpleAccent,
                          ),
                          decoration: InputDecoration(
                            hintText: "Número",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          initialCountryCode: 'CC',
                          onChanged: (value) {
                            setState(() {
                              _numUserController.text = value.completeNumber;
                            });
                          },
                        ),
                        SizedBox(height: 1),
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
                            prefixIcon: Icon(Icons.person,color: Colors.deepPurpleAccent),

                          ),
                          cursorColor: Colors.blue,
                          autovalidateMode:AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if(value==null || value.isEmpty){
                              return "El nombre no puede estar vacio";
                            }
                            if(value.length <2){
                              return "Porfavor ingrese un nombre valido";
                            }
                            if(value.length >49){
                              return "El nombre no puede tener mas de 50 caracteres ";
                            }
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
                        SizedBox(height: 20),
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
                            _passwordUserController.text=value;
                          }),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          obscureText:!_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Confirmar Contraseña',
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
                            if(value !=_passwordUserController.text){
                              return "El Pasword no coincide";
                            }

                            if(value.length <2){
                              return "Porfavor ingrese una clave valida";
                            }
                            if(value.length >99){
                              return "La Clave no puede tener mas de 100 caracteres ";
                            }
                          },
                          onChanged: (value)=>setState(() {
                            _passwordCUserController.text=value;
                          }),
                        ),
                        SizedBox(height: 70.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navegar a la siguiente pantalla o realizar otras acciones
                              _sumit();
                              print(_formKey.currentState);
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrationPage()),
                              );*/
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
            ),
          ),
        ),
      ),
    );
  }
}


