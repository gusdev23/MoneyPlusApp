import 'package:flutter/material.dart';

class IngresoDashboardView extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16.0), // Espacio alrededor del título
              alignment: Alignment.topCenter,
              child: Text(
                'Mis ingresos',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF041F33), // Color del texto
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06, // Ajusta la posición vertical del título
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72, // Ajusta la altura según el tamaño de la pantalla
                child: DynamicCardList(jsonData: jsonData),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DynamicCardList extends StatelessWidget {
  final List<Map<String, dynamic>> jsonData;

  DynamicCardList({required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de columnas (2 en este caso)
        crossAxisSpacing: 10.0, // Espacio horizontal entre columnas
        mainAxisSpacing: 10.0, // Espacio vertical entre filas
      ),
      itemCount: jsonData.length,
      itemBuilder: (context, index) {
        final cardData = jsonData[index];

                return Card(
          elevation: 3.0,
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Ajusta el encabezado al ancho del card
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF094976), // Color de fondo del encabezado
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    cardData["tipo"], // Tipo
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color del texto
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0), // Ajusta el espaciado del pie de página
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${cardData["monto"]}", // Monto
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black, // Color del monto
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        cardData["descripcion"], // Descripción
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black, // Color de la descripción
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(), // Espaciador para empujar el Container hacia la parte inferior
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Color de fondo del pie de página
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
                    child: Text(
                      "Marzo - Abril", // Período
                      style: TextStyle(
                        color: Colors.black, // Color del período
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final List<Map<String, dynamic>> jsonData = [
    {
      "tipo": "Nomina",
      "descripcion": "Pago recibido de nomina mensual",
      "monto": "5000",
    },
       {
      "tipo": "Donación familiar",
      "descripcion": "Ingreso proporcionado por familiar",
      "monto": "2000",
    },
       {
      "tipo": "Utilidad negocio/empresa",
      "descripcion": "Ganancias negocio dulces",
      "monto": "1000",
    },
       {
      "tipo": "Donación familiar",
      "descripcion": "Dinero de mi papá",
      "monto": "2355",
    },
       {
      "tipo": "Utilidad negocio/empresa",
      "descripcion": "Ganancias de ventas",
      "monto": "9000",
    },
       {
      "tipo": "Donación familiar",
      "descripcion": "Dinero de mi mamá",
      "monto": "1300",
    },
  ];

  