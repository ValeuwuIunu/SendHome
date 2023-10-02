import 'package:flutter/material.dart';
import 'recibo.dart';

class Comprainfo {
  String metodopago = '';
  String total = '';
  String descripcion = '';

  bool nevera = false;
  bool lavadora = false;
  bool televisor = false;
  bool secadora = false;
  bool horno = false;
  bool otro = false;
}

class MyAppSelectElect extends StatelessWidget {
  const MyAppSelectElect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SelectElectPage(title: ''),
    );
  }
}

class SelectElectPage extends StatefulWidget {
  const SelectElectPage({super.key, required this.title});

  final String title;

  @override
  State<SelectElectPage> createState() => _SelectElectState();
}

class _SelectElectState extends State<SelectElectPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController descripcionController = TextEditingController();

  Comprainfo compraInfo = Comprainfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        toolbarHeight: 20,
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
          margin: EdgeInsets.all(16.5),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 1500.0, // Establece la altura máxima deseada
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 1000, // Ancho del Card
                  height: 900, // Alto del Card

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Seleccione un electrodoméstico',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                              decorationStyle: TextDecorationStyle.dashed,
                            ),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: const Text('Nevera'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.nevera,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.nevera = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      CheckboxListTile(
                        title: const Text('Lavadora'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.lavadora,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.lavadora = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      CheckboxListTile(
                        title: const Text('Televisior'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.televisor,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.televisor = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      CheckboxListTile(
                        title: const Text('Secadora'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.secadora,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.secadora = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      CheckboxListTile(
                        title: const Text('Horno'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.horno,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.horno = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      CheckboxListTile(
                        title: const Text('Otro'),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: compraInfo.otro,
                        onChanged: (bool? newValue) {
                          setState(() {
                            compraInfo.otro = newValue ?? false;
                          });
                        },
                        activeColor: Colors.indigoAccent,
                      ),
                      SizedBox(height: 1),
                      TextField(
                          controller: descripcionController,
                          decoration: const InputDecoration(
                            hintText: 'Describa el electrodoméstico',
                            labelStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black), // Cambia el color del borde enfocado si es necesario
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .black54), // Cambia el color del borde cuando no está enfocado si es necesario
                            ),
                          ),
                          cursorColor: Colors.black),
                      SizedBox(height: 10),
                      const Row(
                        children: <Widget>[
                          Icon(
                            Icons.shopping_bag,
                            size: 26.0, // Tamaño del ícono
                            color: Colors.deepPurple, // Color del ícono
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Total: ',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                              decorationStyle: TextDecorationStyle.dashed,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 11.5),
                      const Text(
                        'Medio de pago: ',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          decorationStyle: TextDecorationStyle.dashed,
                        ),
                      ),
                      SizedBox(height: 8),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navegar a la siguiente pantalla o realizar otras acciones
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyRecibo()),
                            );
                          },
                          icon: const Icon(Icons.credit_card),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                            foregroundColor:
                                Colors.white, // Color del texto del botón
                            elevation: 10, // Altura de la sombra
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45.0,
                                vertical: 10.0), // Relleno interno del botón
                          ),
                          label: const Text(
                            'Tarjeta Debito/Crédito',
                            style: TextStyle(
                                fontSize:
                                    13.0), // Tamaño de fuente del texto del botón
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(47, 8, 73, 0.5),
                            foregroundColor:
                                Colors.white, // Color del texto del botón
                            elevation: 10, // Altura de la sombra
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 10.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/PSE.png', // Ruta de la imagen en el directorio 'assets'
                                width: 35, // Ancho de la imagen
                                height: 35,
                                alignment:
                                    Alignment.topLeft, // Alto de la imagen
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "PSE",
                                style: TextStyle(fontSize: 13),
                              )
                            ],
                          ))

                      // Color del ícono
                    ],
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
