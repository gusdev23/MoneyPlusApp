import 'package:flutter/material.dart';

class EgresoUpdateView extends StatefulWidget {
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

  @override
  _EgresoUpdateViewState createState() => _EgresoUpdateViewState();
}

class _EgresoUpdateViewState extends State<EgresoUpdateView> {
  double cardScale = 1.0;

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
                  color: Color(0xFF041F33), // Color del texto
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.jsonData.length,
              itemBuilder: (context, index) {
                final ingresoData = widget.jsonData[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      // Cambia la escala al tocar el Card
                      cardScale = 0.95;
                    });

                    // Retrasa la navegación al modal para que la animación sea visible
                    Future.delayed(Duration(milliseconds: 300), () {
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
                                  value: ingresoData['tipo'], // Valor inicial
                                  items: <String>[
                                    'Hogar',
                                    'Alimentación',
                                    'Transporte',
                                    'Ocio',
                                    // Agrega más tipos según tus necesidades
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      ingresoData['tipo'] = newValue; // Actualiza el valor seleccionado
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Tipo de egreso',
                                  ),
                                ),
                                TextFormField(
                                  initialValue: ingresoData['descripcion'],
                                  decoration: InputDecoration(
                                    labelText: 'Descripción',
                                  ),
                                ),
                                TextFormField(
                                  initialValue: ingresoData['monto'],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Monto',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Acción cuando se guarda la modificación
                                        Navigator.pop(context); // Cierra el modal
                                      },
                                      child: Text('Guardar'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(Color(0xFF041F33)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Mostrar un diálogo de confirmación
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Confirmación'),
                                              content: Text('¿Estás seguro de que deseas eliminar este egreso?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Cierra el diálogo
                                                  },
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Acción cuando se confirma la eliminación del ingreso
                                                    // Coloca aquí la lógica para eliminar el ingreso
                                                    Navigator.of(context).pop(); // Cierra el diálogo
                                                    // Puedes mostrar un mensaje de éxito o realizar otras acciones después de eliminar
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
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
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
                      // Restaura la escala del Card al valor original
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