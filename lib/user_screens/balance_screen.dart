import 'package:flutter/material.dart';
import 'package:money_plus_app/user_views/balance_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceScreen extends StatefulWidget {
  final String docId;

  BalanceScreen({required this.docId});

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  List<Map<String, dynamic>> jsonDataIngresos = [];
  List<Map<String, dynamic>> jsonDataEgresos = [];

  @override
  void initState() {
    super.initState();
    obtenerColeccionIngresos();
    obtenerColeccionEgresos();
  }

  Future<void> obtenerColeccionIngresos() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.docId);

      CollectionReference ingresosCollectionRef =
          userDocRef.collection('ingresos');

      QuerySnapshot ingresosQuerySnapshot =
          await ingresosCollectionRef.get();

      jsonDataIngresos = ingresosQuerySnapshot.docs.map((ingresoDoc) {
        Map<String, dynamic> datosIngreso = ingresoDoc.data()
          as Map<String, dynamic>;
        datosIngreso['id'] = ingresoDoc.id; // Agrega el ID al mapa
        return datosIngreso;
      }).toList();
      print(jsonDataIngresos);
      setState(() {});
    } catch (e) {
      print('Error al obtener la colección de ingresos: $e');
    }
  }

  Future<void> obtenerColeccionEgresos() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.docId);

      CollectionReference egresosCollectionRef =
          userDocRef.collection('egresos');

      QuerySnapshot egresosQuerySnapshot =
          await egresosCollectionRef.get();

      jsonDataEgresos = egresosQuerySnapshot.docs.map((egresoDoc) {
        Map<String, dynamic> datosEgreso = egresoDoc.data()
          as Map<String, dynamic>;
        datosEgreso['id'] = egresoDoc.id; // Agrega el ID al mapa
        return datosEgreso;
      }).toList();
      print(jsonDataEgresos);
      setState(() {});
    } catch (e) {
      print('Error al obtener la colección de egresos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalanceView(
        jsonIngresos: jsonDataIngresos,
        jsonEgresos: jsonDataEgresos,
      ),
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