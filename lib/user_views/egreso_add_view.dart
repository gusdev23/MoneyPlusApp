import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EgresoAddView extends StatefulWidget {
  final String DocId;

  EgresoAddView({required this.DocId});

  @override
  _EgresoAddViewState createState() => _EgresoAddViewState();
}

class _EgresoAddViewState extends State<EgresoAddView> {
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController montoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Registra un egreso',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF041F33),
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
                  ],
                  onChanged: (value) {
                    tipoController.text = value.toString();
                  },
                  decoration: InputDecoration(
                    labelText: 'Selecciona un tipo de egreso',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monto \$0.00',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    agregaregreso(context);
                  },
                  child: Text('Guardar'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF041F33)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> agregaregreso(BuildContext context) async {
    try {
      // Validar que los campos no estén vacíos
      if (tipoController.text.isEmpty ||
          descripcionController.text.isEmpty ||
          montoController.text.isEmpty) {
        _mostrarSnackBar(context, 'Todos los campos son requeridos');
        return;
      }

      // Obtén la referencia al documento del usuario
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(widget.DocId);

      // Accede a la subcolección "egresos" dentro del documento del usuario
      CollectionReference egresosCollectionRef =
          userDocRef.collection('egresos');

      // Agrega un nuevo documento a la colección "egresos"
      await egresosCollectionRef.add({
        'tipo': tipoController.text,
        'descripcion': descripcionController.text,
        'monto': double.parse(montoController.text),
      });

      // Muestra un mensaje de éxito
      _mostrarSnackBar(context, 'egreso registrado con éxito');

      // Limpia los controladores después de agregar el egreso
      tipoController.clear();
      descripcionController.clear();
      montoController.clear();
    } catch (e) {
      // Muestra un mensaje de fracaso en caso de error
      _mostrarSnackBar(context, 'Error al registrar el egreso: $e');
    }
  }

  void _mostrarSnackBar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}

