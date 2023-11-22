import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_plus_app/user_screens/ingreso_screen.dart';

class IngresoUpdateView extends StatefulWidget {
  final String DocId;

  IngresoUpdateView({required this.DocId});

  @override
  _IngresoUpdateViewState createState() => _IngresoUpdateViewState();
}

class _IngresoUpdateViewState extends State<IngresoUpdateView> {
  List<Map<String, dynamic>> jsonData = [];
  double cardScale = 1.0;

  // Controladores para los campos del formulario
  TextEditingController tipoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController montoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerColeccionIngresos();
  }

  Future<void> obtenerColeccionIngresos() async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference ingresosCollectionRef =
          userDocRef.collection('ingresos');

      QuerySnapshot ingresosQuerySnapshot =
          await ingresosCollectionRef.get();

      jsonData = ingresosQuerySnapshot.docs.map((ingresoDoc) {
        Map<String, dynamic> datosIngreso = ingresoDoc.data() as Map<String, dynamic>;
        datosIngreso['id'] = ingresoDoc.id; // Agrega el ID al mapa
        return datosIngreso;
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error al obtener la colección de ingresos: $e');
    }
  }

  Future<void> guardarModificaciones(Map<String, dynamic> ingresoData) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference ingresosCollectionRef =
          userDocRef.collection('ingresos');

      // Actualiza el documento de ingreso en Firestore
      await ingresosCollectionRef.doc(ingresoData['id']).update({
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
            builder:(context) => IngresoScreen(DocId: widget.DocId)
            //builder: (context) => IngresoUpdateView(DocId:widget.DocId),
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

  Future<void> eliminarIngreso(String ingresoId) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      CollectionReference ingresosCollectionRef =
          userDocRef.collection('ingresos');

      // Elimina el documento de ingreso en Firestore
      await ingresosCollectionRef.doc(ingresoId).delete();

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingreso eliminado con éxito'),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IngresoUpdateView(DocId:widget.DocId),
          ),
        );
      });
    } catch (e) {
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el ingreso: $e'),
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
              'Modificar ingresos',
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
                final ingresoData = jsonData[index];

                return GestureDetector(
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      // Asigna los valores actuales a los controladores
                      tipoController.text = ingresoData['tipo'];
                      descripcionController.text = ingresoData['descripcion'];
                      montoController.text = ingresoData['monto'].toString();

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
                                    'Nomina',
                                    'Donación familiar',
                                    'Utilidad negocio/empresa',
                                    'Renta de Propiedad',
                                    'Pensión/Seguridad Social',
                                    'Ingresos por Inversiones',
                                    'Adicionales',
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
                                    labelText: 'Tipo de ingreso',
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
                                        guardarModificaciones(ingresoData);
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
                                                  '¿Estás seguro de que deseas eliminar este ingreso?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Elimina el ingreso
                                                    eliminarIngreso(ingresoData['id']);
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
                        title: Text(ingresoData['tipo']),
                        subtitle: Text(ingresoData['descripcion']),
                        trailing: Text('\$${ingresoData['monto']}'),
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





final List<Map<String, dynamic>> jsonData = [
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
// Agrega más elementos JSON según sea necesario
];