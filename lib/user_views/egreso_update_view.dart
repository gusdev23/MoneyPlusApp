import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EgresoUpdateView extends StatefulWidget {
  final String DocId;

  EgresoUpdateView({required this.DocId});

  @override
  _EgresoUpdateViewState createState() => _EgresoUpdateViewState();
}

class _EgresoUpdateViewState extends State<EgresoUpdateView> {
  List<Map<String, dynamic>> jsonData = [];
  double cardScale = 1.0;

  // Controladores para los campos del formulario
  TextEditingController tipoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController montoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerColeccionegresos();
  }

  Future<void> obtenerColeccionegresos() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference egresosCollectionRef =
          userDocRef.collection('egresos');

      QuerySnapshot egresosQuerySnapshot =
          await egresosCollectionRef.get();

      jsonData = egresosQuerySnapshot.docs.map((egresoDoc) {
        Map<String, dynamic> datosegreso = egresoDoc.data() as Map<String, dynamic>;
        datosegreso['id'] = egresoDoc.id; // Agrega el ID al mapa
        return datosegreso;
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error al obtener la colección de egresos: $e');
    }
  }

  Future<void> guardarModificaciones(Map<String, dynamic> egresoData) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference egresosCollectionRef =
          userDocRef.collection('egresos');

      // Actualiza el documento de egreso en Firestore
      await egresosCollectionRef.doc(egresoData['id']).update({
        'tipo': tipoController.text,
        'descripcion': descripcionController.text,
        'monto': double.parse(montoController.text),
      });

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Modificaciones guardadas con éxito'),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EgresoUpdateView(DocId:widget.DocId),
          ),
        );
      });
    } catch (e) {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar modificaciones: $e'),
        ),
      );
      print(e);
    }
  }

  Future<void> eliminaregreso(String egresoId) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference egresosCollectionRef =
          userDocRef.collection('egresos');

      // Elimina el documento de egreso en Firestore
      await egresosCollectionRef.doc(egresoId).delete();

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Egreso eliminado con éxito'),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EgresoUpdateView(DocId:widget.DocId),
          ),
        );
      });
    } catch (e) {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el egreso: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Modificar egresos',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF041F33),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                final egresoData = jsonData[index];

                return GestureDetector(
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      // Asigna los valores actuales a los controladores
                      tipoController.text = egresoData['tipo'];
                      descripcionController.text = egresoData['descripcion'];
                      montoController.text = egresoData['monto'].toString();

                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Modificar',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: tipoController.text,
                                  items: <String>[
                                    'Hogar',
                                    'Alimentación',
                                    'Transporte',
                                    'Ocio',
                                    'Salud',
                                    'Deudas',
                                    'Ahorros/Inversiones',
                                    'Educación',
                                  ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      tipoController.text = newValue ?? '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Tipo de egreso',
                                  ),
                                ),
                                TextFormField(
                                  controller: descripcionController,
                                  decoration: InputDecoration(
                                    labelText: 'Descripción',
                                  ),
                                ),
                                TextFormField(
                                  controller: montoController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Monto',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Guarda las modificaciones
                                        guardarModificaciones(egresoData);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Guardar'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color(0xFF041F33)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirmación'),
                                              content: Text(
                                                  '¿Estás seguro de que deseas eliminar este egreso?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Elimina el egreso
                                                    eliminaregreso(egresoData['id']);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Sí'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      cardScale = 1.0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    transform: Matrix4.identity()..scale(cardScale),
                    child: Card(
                      margin: EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(egresoData['tipo']),
                        subtitle: Text(egresoData['descripcion']),
                        trailing: Text('\$${egresoData['monto']}'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



 