import 'package:flutter/material.dart';
class BalanceView extends StatelessWidget {
  final List<Map<String, dynamic>> jsonIngresos;
  final List<Map<String, dynamic>> jsonEgresos;

  BalanceView({required this.jsonIngresos, required this.jsonEgresos});

  @override
  Widget build(BuildContext context) {
    double totalIncome = jsonIngresos
        .map((income) => double.parse(income['monto'].toString()))
        .fold(0, (prev, amount) => prev + amount);

    double totalExpense = jsonEgresos
        .map((expense) => double.parse(expense['monto'].toString()))
        .fold(0, (prev, amount) => prev + amount);

    double balance = totalIncome - totalExpense;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Mi balance',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF041F33),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildSummaryCard('Ingresos', totalIncome, Colors.green),
                buildSummaryCard('Egresos', totalExpense, Color.fromARGB(255, 173, 42, 32)),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Detalles',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF041F33),
              ),
            ),
            SizedBox(height: 10.0),
            buildAccordionList(),
            SizedBox(height: 20.0),
            Text(
              'Balance Total',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF041F33),
              ),
            ),
            SizedBox(height: 10.0),
            buildSummaryCard('Balance', balance, const Color.fromARGB(255, 20, 102, 168)),
            SizedBox(height: 20.0),
            Container(
              color: obtenerColorSegunBalance(balance), // Color de fondo #66CDAA
              padding: EdgeInsets.all(16.0), // Espacio interno para los textos
              child: Column(
                children: [
                  Text(
                    obtenerTituloBalance(balance),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color del texto en blanco
                    ),
                  ),
                  Text(
                    obtenerMensajeBalance(balance),
                    style: TextStyle(fontSize: 16.0, color: Colors.white), // Color del texto en blanco
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Color obtenerColorSegunBalance(double balance) {
    if (balance < 0) {
      return Color.fromARGB(255, 173, 42, 32); // Puedes ajustar el color según tu preferencia
    } else if (balance == 0) {
      return Color.fromARGB(255, 146, 134, 29); // Puedes ajustar el color según tu preferencia
    } else {
      return Color(0xFF094976); // El color original para balance positivo
    }
  }
  String obtenerMensajeBalance(double balance) {
    if (balance < 0) {
      return 'No cuenta con un balance sano, procura distribuir tus gastos conforme a tus ingresos.';
    } else if (balance == 0) {
      return 'Su balance se encuentra en el limite, procura evitar mas gastos, recuerda siempre mantener un balance a favor.';
    } else {
      return 'Cuentas con un balance financiero sano, sigue así y tus bolsillos te lo agradecerán.';
    }
  }
  String obtenerTituloBalance(double balance) {
    if (balance < 0) {
      return '¡ALERTA!';
    } else if (balance == 0) {
      return '¡CUIDADO!';
    } else {
      return '¡FELICIDADES!';
    }
  }
  Widget buildSummaryCard(String title, double amount, Color color) {
    return Card(
      elevation: 3.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccordionList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        buildAccordion('Ingresos', jsonIngresos),
        SizedBox(height: 10.0),
        buildAccordion('Egresos', jsonEgresos),
      ],
    );
  }

  Widget buildAccordion(String title, List<Map<String, dynamic>> data) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text('${item["tipo"]}'),
              subtitle: Text('${item["descripcion"]} - \$${item["monto"]}'),
            );
          },
        ),
      ],
    );
  }
}
