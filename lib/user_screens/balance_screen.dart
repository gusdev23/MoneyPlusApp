import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/balance_view.dart';

class BalanceScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalanceView(jsonIngresos: jsonData1, jsonEgresos: jsonData2)
    );
  }
}


final List<Map<String, dynamic>> jsonData1 = [
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

final List<Map<String, dynamic>> jsonData2 = [
    {
      "tipo": "Hogar",
      "monto": "2000",
      "descripcion": "Renta casa",
    },
    {
      "tipo": "Alimentación",
      "monto": "1000",
      "descripcion": "Comida mensual",
    },
    {
      "tipo": "Transporte",
      "monto": "2500",
      "descripcion": "Transporte",
    },
    {
      "tipo": "Hogar",
      "monto": "500",
      "descripcion": "Compra de gas",
    },
    {
      "tipo": "Ocio",
      "monto": "3000",
      "descripcion": "Actividade de ocio",
    },
    // Agrega más elementos JSON según sea necesario
  ];