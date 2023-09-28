import 'package:flutter/material.dart';
import 'registro_conductor.dart';
import 'registro_vehiculo.dart';

enum ProductTypeEnum {C1, C2, C3}

class MyAppregistroLicencia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: RegistrationLicenciaPage(),
    );
  }
}

class RegistrationLicenciaPage extends StatefulWidget {
  @override
  _RegistrationLicenciaPageState createState() => _RegistrationLicenciaPageState();
}

class _RegistrationLicenciaPageState extends State<RegistrationLicenciaPage> {

ProductTypeEnum? _productTypeEnum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(204, 200, 236, 1.0),
      appBar: AppBar(
        leading:
          IconButton(  icon: Icon(Icons.arrow_back_outlined,
              size: 40, color: Colors.black87),
            constraints:
            BoxConstraints.tightFor(width: 60, height: 60),
            highlightColor: Colors.cyan,
            splashColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAppregistroconductor()),
              );
            },
          ),

        toolbarHeight: 80,
        titleTextStyle: const TextStyle(
          fontSize: 28.0, // Tamaño de fuente
          fontWeight: FontWeight.bold, // Peso de fuente
          color: Colors.white, // Color del texto
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),body: Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const Text( 'Adjunte una foto con su licencia de conducción ',
                  style: TextStyle(
                      fontSize:
                      20.0, // Tamaño de fuente// Peso de fuente (puede ser FontWeight.normal)
                    color: Colors.black87, // Color del texto
                    fontStyle: FontStyle
                        .italic, // Estilo de fuente (puede ser FontStyle.normal)// Espacio entre caracteres// Decoración (puede ser TextDecoration.none)// Color de la decoración (si es necesario)
                    decorationStyle: TextDecorationStyle
                        .dashed, // Estilo de la decoración, // Fuente personalizada (si está disponible)

                  ),),

                  SizedBox(
                    height: 100.0,
                    width: 200.0,
                    child: Image.asset('assets/upload.png'),
                  ),
                  SizedBox(height: 30.0),

                  RadioListTile<ProductTypeEnum>(
                      contentPadding: EdgeInsets.all(0.0),
                      value: ProductTypeEnum.C1,
                      groupValue: _productTypeEnum,
                      title:Text(ProductTypeEnum.C1.name),
                      onChanged:(val){
                        setState(() {
                          _productTypeEnum=val;
                        });
                      }),
                  RadioListTile<ProductTypeEnum>(
                      contentPadding: EdgeInsets.all(0.0),
                      value: ProductTypeEnum.C2,
                      groupValue: _productTypeEnum,
                      title:Text(ProductTypeEnum.C2.name),
                      onChanged:(val){
                        setState(() {
                          _productTypeEnum=val;
                        });
                      }),
                  RadioListTile<ProductTypeEnum>(
                      contentPadding: EdgeInsets.all(0.0),
                      value: ProductTypeEnum.C3,
                      groupValue: _productTypeEnum,
                      title:Text(ProductTypeEnum.C3.name),
                      onChanged:(val){
                        setState(() {
                          _productTypeEnum=val;
                        });
                      }),


                 SizedBox(height: 70.0),

              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navegar a la siguiente pantalla o realizar otras acciones
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyAppregistroVehiculo()),
                    );
                  },
                  icon: const Icon(Icons.add),
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
                    'Vehículo',
                    style: TextStyle(
                        fontSize:
                        18.0), maxLines: 1,// Tamaño de fuente del texto del botón
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


