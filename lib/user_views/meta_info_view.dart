import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MetaInfoView extends StatelessWidget {
  final Map<String, dynamic> metaData;

  MetaInfoView({required this.metaData});

  @override
  Widget build(BuildContext context) {
    final String nombre = metaData['nombre'];
    final int montoMeta = metaData['montoMeta'];
    final int montoActual = metaData['montoActual'];
    final int montoPlazo = metaData['montoPlazo'];
    final int totalPlazos = metaData['totalPlazos'];
    final int actualPlazo = metaData['actualPlazo'];
    final String plazo = metaData['plazo'];
    final String f_inicio=metaData['fechaInicio'];
    final String f_objetivo=metaData['fechaObjetivo'];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Esto centra los elementos verticalmente
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    nombre,
                    style: TextStyle(
                      color: Color(0xFF041F33),
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Fecha objetivo:' + f_objetivo.toString(),
                    style: TextStyle(
                      color: Color(0xFF041F33),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Color(0xFF041F33)),
                    SizedBox(width: 10),
                    Text('Meta: \$${montoMeta.toStringAsFixed(2)}'),
                    SizedBox(width: 20), // Añade un espacio entre los elementos
                    Icon(Icons.show_chart, color: Color(0xFF041F33)),
                    SizedBox(width: 10),
                    Text('Ahorrado: \$${montoActual.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timeline, color: Color(0xFF041F33)),
                    SizedBox(width: 10),
                    Text('Monto: \$${montoPlazo.toStringAsFixed(2)}'),
                    SizedBox(width: 20), // Añade un espacio entre los elementos
                    Icon(Icons.access_time, color: Color(0xFF041F33)),
                    SizedBox(width: 10),
                    Text(
                      'Siguiente: \$${montoPlazo.toStringAsFixed(2)} $plazo',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Plazos',style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF041F33),
            ),),
          ),
          Expanded(
            child: ListView(
              children: List.generate(totalPlazos, (index) {
                final cumplido = index < actualPlazo;
                return ListTile(
                  leading: Icon(cumplido ? Icons.check_box : Icons.check_box_outline_blank_rounded),
                  title: Text('Ahorro ${index + 1} de $totalPlazos'),
                  subtitle: Text('\$${montoPlazo.toStringAsFixed(2)}'),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}