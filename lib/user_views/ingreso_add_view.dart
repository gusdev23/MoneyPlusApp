import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IngresoAddView extends StatefulWidget {
  final String DocId;

  IngresoAddView({required this.DocId});

  @override
  _IngresoAddViewState createState() => _IngresoAddViewState();
}

class _IngresoAddViewState extends State<IngresoAddView> {
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
                    'Registra un ingreso',
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
                      value: 'Nomina',
                      child: Text('Nomina'),
                    ),
                    DropdownMenuItem(
                      value: 'Renta de Propiedad',
                      child: Text('Renta de Propiedad'),
                    ),
                    DropdownMenuItem(
                      value: 'Donación',
                      child: Text('Donación'),
                    ),
                    DropdownMenuItem(
                      value: 'Utilidad negocio/empresa',
                      child: Text('Utilidad negocio/empresa'),
                    ),
                    DropdownMenuItem(
                      value: 'Pensión/Seguridad Social',
                      child: Text('Pensión/Seguridad Social'),
                    ),
                     DropdownMenuItem(
                      value: 'Ingresos por Inversiones',
                      child: Text('Ingresos por Inversiones'),
                    ),
                    DropdownMenuItem(
                      value: 'Adicionales',
                      child: Text('Adicionales'),
                    ),
                  ],
                  onChanged: (value) {
                    tipoController.text = value.toString();
                  },
                  decoration: InputDecoration(
                    labelText: 'Selecciona un tipo de ingreso',
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
                    agregarIngreso(context);
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

  Future<void> agregarIngreso(BuildContext context) async {
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

      // Accede a la subcolección "ingresos" dentro del documento del usuario
      CollectionReference ingresosCollectionRef =
          userDocRef.collection('ingresos');

      // Agrega un nuevo documento a la colección "ingresos"
      await ingresosCollectionRef.add({
        'tipo': tipoController.text,
        'descripcion': descripcionController.text,
        'monto': double.parse(montoController.text),
      });

      // Muestra un mensaje de éxito
      _mostrarSnackBar(context, 'Ingreso registrado con éxito');

      // Limpia los controladores después de agregar el ingreso
      tipoController.clear();
      descripcionController.clear();
      montoController.clear();
    } catch (e) {
      // Muestra un mensaje de fracaso en caso de error
      _mostrarSnackBar(context, 'Error al registrar el ingreso: $e');
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


