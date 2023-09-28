import 'package:flutter/material.dart';
import 'LoginScreen.dart';

class MyRecibo extends StatefulWidget {
  const MyRecibo({Key? key}) : super(key: key);

  @override
  State<MyRecibo> createState() => _MyReciboState();
}

class _MyReciboState extends State<MyRecibo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        toolbarHeight: 30,
        titleTextStyle: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Card(
          color: const Color.fromRGBO(185, 175, 224, 1.0),
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.all(28.5),
          child: SizedBox(
            width: 500,
            height: 650,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Recibo de pago',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column( crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Nombre de quien recibe',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),

                      SizedBox(height: 40),
                      Text(
                        'Cédula de quien recibe',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Precio total a pagar',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Método de pago',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Lugar de envío',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Lugar de destino',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 45),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegar a la siguiente pantalla o realizar otras acciones
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                            foregroundColor: Colors.white,
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 45.0,
                              vertical: 10.0,
                            ),
                          ),
                          child: Text(
                            'Confirmar y empezar trayecto',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
