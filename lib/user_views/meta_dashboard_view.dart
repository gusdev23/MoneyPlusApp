import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_plus_app/user_views/meta_add_view.dart';
import 'package:money_plus_app/user_views/meta_info_view.dart';

class MetasView extends StatefulWidget {
  final String DocId;

  MetasView({required this.DocId});

  @override
  _MetasViewState createState() => _MetasViewState();
}

class _MetasViewState extends State<MetasView> {
  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    super.initState();
    obtenerMetas();
  }

  Future<void> obtenerMetas() async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(widget.DocId);
      CollectionReference metasCollectionRef = userDocRef.collection('metas');

      QuerySnapshot metasQuerySnapshot = await metasCollectionRef.get();

      jsonData = metasQuerySnapshot.docs.map((metaDoc) {
        Map<String, dynamic> datosMeta = metaDoc.data() as Map<String, dynamic>;
        datosMeta['id'] = metaDoc.id; // Agrega el ID del documento al mapa
        return datosMeta;
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error al obtener la colección de metas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: jsonData.length,
        itemBuilder: (context, index) {
          sortByCompletionPercentage(jsonData);
          final metaData = jsonData[index];
          final montoActual = double.parse(metaData['montoActual']);
          final montoMeta = double.parse(metaData['montoMeta']);
          final montoPlazo = double.parse(metaData['montoPlazo']);
          final cumplido = metaData['metaCumplida'];
          final plazo = metaData['plazo'];

          final progress = (montoActual / montoMeta).clamp(0.0, 1.0);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetaInfoView(metaData: metaData, DocId: widget.DocId, metaDocId: metaData['id']),
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
                      title: Text(
                        metaData['nombre'],
                        style: TextStyle(
                          color: Color(0xFF041F33),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      trailing: cumplido == true
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MetaAddView(DocId: widget.DocId,),
            ),
          );
        },
        child: Icon(Icons.add_to_photos_rounded),
      ),
    );
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
      final completionA = double.parse(a['montoActual'] ) / double.parse(a['montoMeta']);
      //final completionA = (a['montoActual'] as int) / (a['montoMeta'] as int);
      final completionB = double.parse(b['montoActual'] ) / double.parse(b['montoMeta']);
      
      //final completionB = (b['montoActual'] as int) / (b['montoMeta'] as int);
      return completionA.compareTo(completionB);
    });
  }
}




