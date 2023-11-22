import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EgresoDashboardView extends StatelessWidget {
  final String DocId;

  EgresoDashboardView({required this.DocId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.topCenter,
              child: Text(
                'Mis egresos',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF041F33),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72,
                child: DynamicCardList(DocId: DocId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicCardList extends StatelessWidget {
  final String DocId;

  DynamicCardList({required this.DocId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: obtenerColeccionegresos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> jsonData = snapshot.data!;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color(0xFF094976),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          cardData["tipo"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\$${cardData["monto"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              cardData["descripcion"],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            capitalizeFirstLetter(DateFormat('MMMM', 'es_ES').format(DateTime.now())),
                            style: TextStyle(
                              color: Colors.black,
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
      },
    );
  }
  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }
  Future<List<Map<String, dynamic>>> obtenerColeccionegresos() async {
    List<Map<String, dynamic>> jsonData = [];

    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(DocId);
      CollectionReference egresosCollectionRef = userDocRef.collection('egresos');
      QuerySnapshot egresosQuerySnapshot = await egresosCollectionRef.get();

      egresosQuerySnapshot.docs.forEach((ingresoDoc) {
        Map<String, dynamic> datosIngreso = ingresoDoc.data() as Map<String, dynamic>;
        jsonData.add(datosIngreso);
      });

      print(jsonData);
      print(jsonData.length);
      return jsonData;
    } catch (e) {
      print('Error al obtener la colección de egresos: $e');
      throw e;
    }
  }
}



final List<Map<String, dynamic>> jsonData = [
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