import 'package:flutter/material.dart';
class EgresoAddView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: null, // Oculta el AppBar
        body: Container(
          constraints: BoxConstraints(maxHeight: 350),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1, // 20% de arriba
            left: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.height * 0.05,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1, // 10% de los laterales
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFF041F33), // Borde color gris
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Registra un egreso',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF041F33), // Texto azul
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: 'tipo1',
                    child: Text('Tipo de egreso 1'),
                  ),
                  DropdownMenuItem(
                    value: 'tipo2',
                    child: Text('Tipo de egreso 2'),
                  ),
                ], // Agrega los elementos del desplegable según tus necesidades
                onChanged: (value) {
                  // Maneja la selección del desplegable
                },
                decoration: InputDecoration(
                  labelText: 'Selecciona un tipo de egreso',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monto \$0.00',
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Maneja el evento del botón "Guardar"
                },
                child: Text('Guardar'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF041F33)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}