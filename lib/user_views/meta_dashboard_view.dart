import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/meta_add_view.dart';
import 'package:money_plus_app/user_views/meta_info_view.dart';

class MetasView extends StatelessWidget {
  final List<Map<String, dynamic>> jsonData = [
  {
    "nombre": "Meta de Vacaciones",
    "montoMeta": 2000,
    "montoActual": 1500,
    "montoPlazo": 500,
    "plazo": "mensual",
    "totalPlazos": 12,
    "actualPlazo": 10,
    "fechaInicio": "01/01/2023",
    "fechaObjetivo": "01/12/2023",
  },
  {
    "nombre": "Compra de Automóvil",
    "montoMeta": 15000,
    "montoActual": 3000,
    "montoPlazo": 1000,
    "plazo": "mensual",
    "totalPlazos": 12,
    "actualPlazo": 10,
    "fechaInicio": "01/01/2023",
    "fechaObjetivo": "01/12/2023",
  },
  {
    "nombre": "Fondo de Emergencia",
    "montoMeta": 5000,
    "montoActual": 3000,
    "montoPlazo": 300,
    "plazo": "mensual",
    "totalPlazos": 12,
    "actualPlazo": 10,
    "fechaInicio": "01/01/2023",
    "fechaObjetivo": "01/12/2023",
  },
  {
    "nombre": "Educación Universitaria",
    "montoMeta": 10000,
    "montoActual": 2000,
    "montoPlazo": 1000,
    "plazo": "mensual",
    "totalPlazos": 12,
    "actualPlazo": 2,
    "fechaInicio": "01/11/2023",
    "fechaObjetivo": "01/10/2024",
  },
  {
    "nombre": "Renovación de Casa",
    "montoMeta": 25000,
    "montoActual": 25000,
    "montoPlazo": 1500,
    "plazo": "mensual",
    "totalPlazos": 12,
    "actualPlazo": 12,
    "fechaInicio": "01/01/2023",
    "fechaObjetivo": "01/12/2023",
  },
  // Agrega más registros de metas según sea necesario
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          sortByCompletionPercentage(jsonData);
          final metaData = jsonData[index];
          final montoMeta = metaData['montoMeta'];
          final montoActual = metaData['montoActual'];
          final montoPlazo = metaData['montoPlazo'];
          final plazo = metaData['plazo'];

          final progress = (montoActual / montoMeta).clamp(0.0, 1.0);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetaInfoView(metaData: metaData),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ListTile(
                      title: Text(metaData['nombre'],style: TextStyle(color: Color(0xFF041F33),fontWeight: FontWeight.bold,fontSize: 20.0,),),
                      trailing: montoActual == montoMeta
                      ? Text(
                          '¡Meta lograda!',
                          style: TextStyle(
                            color: Colors.green[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        )
                      : Text(
                          '\$${montoMeta.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 175, 169, 84),
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),

                      subtitle: Text(
                        '\$${montoPlazo.toStringAsFixed(2)} $plazo',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    
                  ),
                  
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getProgressColor(progress), // Llama a la función getProgressColor
                    ),
                  )
                ],
              ),
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetaAddView(),
                ),
              );
        },
        child: Icon(Icons.add_to_photos_rounded),
      ),
    );
  }
}

Color getProgressColor(double progress) {
  if (progress <= 0.3) {
    return Color.fromARGB(255, 17, 132, 221); // Rojo para 0-30%
  } else if (progress <= 0.74) {
    return Color.fromARGB(255, 11, 80, 133); // Amarillo para 31-74%
  } else {
    return Color(0xFF041F33); // Verde para 75-100%
  }
}
void sortByCompletionPercentage(List<Map<String, dynamic>> data) {
  data.sort((a, b) {
    final completionA = (a['montoActual'] as int) / (a['montoMeta'] as int);
    final completionB = (b['montoActual'] as int) / (b['montoMeta'] as int);
    return completionA.compareTo(completionB);
  });
}





