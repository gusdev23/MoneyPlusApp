


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_plus_app/user_views/meta_dashboard_view.dart';

class MetaAddView extends StatelessWidget {
  final String DocId;

  MetaAddView({required this.DocId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MotivoMeta(DocId: DocId,),
      ),
    );
  }
}

class MotivoMeta extends StatelessWidget {
  final String DocId;

  MotivoMeta({required this.DocId});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              '¿Qué deseas lograr?',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xFF041F33)),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: [
                SavingsCard(
                  icon: Icons.shopping_cart,
                  title: 'Comprar algo',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Comprar algo');
                  },
                ),
                SavingsCard(
                  icon: Icons.flight,
                  title: 'Viaje',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Viaje');
                  },
                ),
                SavingsCard(
                  icon: Icons.directions_car,
                  title: 'Auto',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Auto');
                  },
                ),
                SavingsCard(
                  icon: Icons.home,
                  title: 'Hogar',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Hogar');
                  },
                ),
                SavingsCard(
                  icon: Icons.monetization_on,
                  title: 'Deudas',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Deudas');
                  },
                ),
                SavingsCard(
                  icon: Icons.savings,
                  title: 'Solo guardar',
                  onPressed: () {
                    _mostrarDetallesMeta(context, 'Solo guardar');
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          ElevatedButton(
            onPressed: () {
              _mostrarDetallesMeta(context, 'Otro');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF094976),
            ),
            child: Text('Otro'),
          ),
        ],
      ),
    );
  }

  void _mostrarDetallesMeta(BuildContext context, String selectedGoal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MetaAddDetails(selectedGoal,DocId)),
    );
  }
}

class MetaAddDetails extends StatefulWidget {
  final String selectedGoal;
  final String DocId;
  MetaAddDetails(this.selectedGoal, this.DocId);

  @override
  _MetaAddDetailsState createState() => _MetaAddDetailsState();
}

class _MetaAddDetailsState extends State<MetaAddDetails> {
  DateTime? _selectedDate;
  TextEditingController _goalController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController montoGuardarController = TextEditingController();
  bool _showSecondCard = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void fecha() async {
      await initializeDateFormatting('es_ES', null);
    }

    fecha();
    DateFormat formatoFecha = DateFormat('d MMM yyyy', 'es_ES');
    _goalController = TextEditingController(text: widget.selectedGoal);
    final TextEditingController frecuenciaController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nombre de la meta',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  if (!_showSecondCard)
                    TextFormField(
                      controller: _goalController,
                      style: TextStyle(fontSize: 16.0),
                      enabled: !_showSecondCard,
                    ),
                  if (_showSecondCard)
                    Text(
                      _goalController.text,
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'Monto objetivo',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  if (!_showSecondCard)
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: montoController,
                      enabled: !_showSecondCard,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese el monto',
                      ),
                    ),
                  if (_showSecondCard)
                    Text(
                      montoController.text,
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  SizedBox(height: 16.0),
                  Text(
                    'Fecha objetivo',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    _selectedDate != null ? formatoFecha.format(_selectedDate!) : '',
                    style: TextStyle(fontSize: 16.0, color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  if (!_showSecondCard)
                    TextButton.icon(
                      onPressed: !_showSecondCard ? () => _selectDate(context) : null,
                      icon: Icon(Icons.edit_calendar_rounded),
                      label: Text('Seleccionar fecha'),
                      style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  SizedBox(height: 16.0),
                  if (!_showSecondCard)
                    ElevatedButton(
                      onPressed: () {
                        if (_goalController.text.isNotEmpty &&
                            _selectedDate != null &&
                            montoController.text.isNotEmpty) {
                          setState(() {
                            _showSecondCard = true;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('¡Campos faltantes!'),
                                content: Text('Por favor, llenar todos los campos faltantes'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text('Continuar'),
                    ),
                ],
              ),
            ),
          ),
          if (_showSecondCard)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Frecuencia:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: DropdownButtonFormField(
                            items: [
                              DropdownMenuItem(
                                value: 'diario',
                                child: Text('Diario'),
                              ),
                              DropdownMenuItem(
                                value: 'semanal',
                                child: Text('Semanal'),
                              ),
                              DropdownMenuItem(
                                value: 'quincenal',
                                child: Text('Quincenal'),
                              ),
                              DropdownMenuItem(
                                value: 'mensual',
                                child: Text('Mensual'),
                              ),
                            ],
                            onChanged: (value) {
                              frecuenciaController.text = value.toString();
                              double? montoMeta = double.tryParse(montoController.text);
                              if (montoMeta != null) {
                                montoGuardarController.text =
                                    calcularMontoAGuardar(_selectedDate!, value!, montoMeta).toStringAsFixed(2);
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Seleccionar frecuencia',
                            ),
                          ), 
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text(
                          'Monto a guardar:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextFormField(
                            controller: montoGuardarController,
                            enabled: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        CollectionReference metasCollection = FirebaseFirestore.instance.collection('users').doc(widget.DocId).collection('metas');

                        DocumentReference nuevaMetaRef = metasCollection.doc();
                        print(frecuenciaController.text);
                        Map<String, dynamic> nuevaMeta = {
                          'nombre': _goalController.text,
                          'montoMeta': montoController.text,
                          'fechaInicio': DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
                          'fechaObjetivo': DateFormat('dd/MM/yyyy').format(_selectedDate!).toString() ,
                          'plazo': frecuenciaController.text,
                          'totalPlazos': calcularTotalPlazos(_selectedDate!, frecuenciaController.text),
                          'actualPlazo': 0,
                          'metaCumplida': false,
                          'montoActual': '0',
                          'montoPlazo': calcularMontoAGuardar(_selectedDate!, frecuenciaController.text, double.parse(montoController.text)).toString(),
                        };
                        print(nuevaMeta);
                        await nuevaMetaRef.set(nuevaMeta);
                        await Future.delayed(Duration(milliseconds: 500));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MetasView(DocId: widget.DocId),
                          ),
                        );
                        // Acción cuando se presiona el botón "Guardar meta"
                        print('Guardar meta');
                      },
                      child: Text('Guardar meta'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

double calcularMontoAGuardar(DateTime fechaObjetivo, String frecuencia, double montoMeta) {
  DateTime fechaActual = DateTime.now();
  int mesesRestantes = fechaObjetivo.month - fechaActual.month + 12 * (fechaObjetivo.year - fechaActual.year);

  double montoAGuardar = montoMeta / mesesRestantes;

  switch (frecuencia) {
    case 'Diario':
      montoAGuardar /= 30; // asumiendo un mes de 30 días
      break;
    case 'Semanal':
      montoAGuardar /= 4; // asumiendo un mes de 4 semanas
      break;
    case 'Quincenal':
      montoAGuardar /= 2;
      break;
    // Para 'Mensual', no se hace ninguna modificación
  }

  return montoAGuardar;
}

int calcularTotalPlazos(DateTime fechaObjetivo, String frecuencia) {
  DateTime fechaActual = DateTime.now();
  int mesesRestantes = fechaObjetivo.month - fechaActual.month + 12 * (fechaObjetivo.year - fechaActual.year);

  int totalPlazos = mesesRestantes;

  switch (frecuencia) {
    case 'Diario':
      totalPlazos *= 30; // asumiendo un mes de 30 días
      break;
    case 'Semanal':
      totalPlazos *= 4; // asumiendo un mes de 4 semanas
      break;
    case 'Quincenal':
      totalPlazos *= 2;
      break;
    // Para 'Mensual', no se hace ninguna modificación
  }

  return totalPlazos;
}

class SavingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const SavingsCard({required this.icon, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Color(0xFF094976)),
            SizedBox(height: 8.0),
            Text(title, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}