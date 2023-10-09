import 'package:flutter/material.dart';

class BalanceView extends StatelessWidget {
  final List<Map<String, dynamic>> jsonIngresos;
  final List<Map<String, dynamic>> jsonEgresos;

  BalanceView({required this.jsonIngresos, required this.jsonEgresos});

 double calculateTotal(List<Map<String, dynamic>> data) {
    double total = 0.0;
    for (final item in data) {
      total += double.parse(item["monto"]);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalIncome = calculateTotal(jsonIngresos);
    final totalExpense = calculateTotal(jsonEgresos);
    final balance = totalIncome - totalExpense;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Alinea los elementos a la derecha
                  children: [
                    Text(
                      'Mi balance',
                      style: TextStyle(
                        color: Color(0xFF041F33),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ), 
              Text(
                'Ingresos',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0d6efd),
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text('Tipo'),),
                  DataColumn(label: Text('Descripción')),
                  DataColumn(label: Text('Monto')),
                ],
                rows: jsonIngresos.map((income) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${income["tipo"]}')),
                      DataCell(Text('${income["descripcion"]}')),
                      DataCell(Text('\$${income["monto"]}')),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              Text(
                'Egresos',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFbe1025)
                ),
              ),
              DataTable(
                columns: [
                  DataColumn(label: Text('Tipo')),
                  DataColumn(label: Text('Descripción')),
                  DataColumn(label: Text('Monto')),
                ],
                rows: jsonEgresos.map((expense) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${expense["tipo"]}')),
                      DataCell(Text('${expense["descripcion"]}')),
                      DataCell(Text('\$${expense["monto"]}')),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Alinea los elementos a la derecha
                  children: [
                    Text(
                      'Total ingresos: \$${totalIncome.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total egresos: \$${totalExpense.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Balance: \$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                color: Color(0xFF094976), // Color de fondo #66CDAA
                padding: EdgeInsets.all(16.0), // Espacio interno para los textos
                child: Column(
                  children: [
                    Text(
                      '¡FELICITACIONES!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color del texto en blanco
                      ),
                    ),
                    Text(
                      'Cuentas con un balance financiero sano, sigue así y tus bolsillos te lo agradecerán.',
                      style: TextStyle(fontSize: 16.0, color: Colors.white), // Color del texto en blanco
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
