import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:money_plus_app/user_views/meta_dashboard_view.dart';

class MetaInfoView extends StatelessWidget {
  final Map<String, dynamic> metaData;

  MetaInfoView({required this.metaData});

  @override
  Widget build(BuildContext context) {
    final String nombre = metaData['nombre'];
    final int montoMeta = metaData['montoMeta'];
    final int montoActual = metaData['montoActual'];
    final int montoPlazo = metaData['montoPlazo'];
    final int totalPlazos = metaData['totalPlazos'];
    final int actualPlazo = metaData['actualPlazo'];
    final String plazo = metaData['plazo'];
    final DateTime f_inicio=DateFormat("dd/MM/yyyy").parse(metaData['fechaInicio'])   ;
    final DateTime f_objetivo= DateFormat("dd/MM/yyyy").parse(metaData['fechaObjetivo']);

    Map<String, String> Plazos = {
      "diario": "Día",
      "semanal": "Semana",
      "quincenal": "Quincena",
      "mensual": "Mes",
    };


    //Manejo de monedas
    NumberFormat formatMX = NumberFormat.simpleCurrency(locale: 'es_MX');
    formatMX.maximumFractionDigits = 0;

    //Formato de fecha
    void fecha()async{
      await initializeDateFormatting('es_ES', null);
    }
    fecha();
    DateFormat formatoFecha = DateFormat('d MMM yyyy', 'es_ES');

    //Calcular fecha correspondiente al plazo
    DateTime fechaPlazo(){

      DateTime fechaPlazo;

      if (plazo == "diario") {
        fechaPlazo = f_inicio.add(Duration(days: actualPlazo));
      } else if (plazo == "semanal") {
        fechaPlazo = f_inicio.add(Duration(days: actualPlazo * 7));
      } else if (plazo == "quincenal") {
        fechaPlazo = f_inicio.add(Duration(days: actualPlazo * 15));
      } else{
        fechaPlazo = f_inicio.add(Duration(days: actualPlazo * 30)); // Aproximadamente 30 días por mes
      }

      return  fechaPlazo;
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Esto centra los elementos verticalmente
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MetasView(),
                          ),
                        );
                        },
                        child: Icon(Icons.arrow_back_outlined, color: Color(0xFF041F33)),
                      ),
                      SizedBox(width: 20), // Añade un margen entre los elementos
                      Text(
                        nombre,
                        style: TextStyle(
                          color: Color(0xFF041F33),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      Spacer(),
                      SizedBox(width: 10), // Añade un margen entre los elementos
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(labelText: 'Nuevo nombre'),
                                      
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Implementa la lógica para guardar el nuevo nombre de la meta aquí
                                        Navigator.of(context).pop(); // Cierra el modal
                                      },
                                      child: Text('Guardar'),            
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(Icons.edit, color: Color(0xFF041F33)),
                      ),
                      SizedBox(width: 20), // Añade un margen entre los elementos
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Eliminar Meta'),
                                content: Text('¿Seguro que deseas eliminar esta meta?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Cierra el diálogo
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Eliminar',
                                      style: TextStyle(
                                        color: Colors.red, // Color rojo
                                      ),
                                    ),
                                    onPressed: () {
                                      // Implementa la lógica para eliminar la meta aquí
                                      Navigator.of(context).pop(); // Cierra el diálogo
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Icon(Icons.delete, color: Color(0xFF041F33)),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xFF094976), // Color de fondo #66CDAA
                  padding: EdgeInsets.all(16.0), // Espacio interno para los textos
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatoFecha.format(f_inicio), style: TextStyle(color: Colors.white)), // Texto en la parte superior izquierda
                          Text(formatoFecha.format(f_objetivo), style: TextStyle(color: Colors.white)), // Texto en la parte superior derecha
                        ],
                      ),
                      SizedBox(height: 20), // Espacio entre los textos superiores y el montoMeta
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Fondo gris claro
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            formatMX.format(montoMeta).toString(),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatMX.format(montoActual).toString(), style: TextStyle(color: Colors.white)),
                              Text('${((montoActual / montoMeta) * 100).round()}%', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Stack(
                            children: [
                              LinearProgressIndicator(
                                value: montoActual / montoMeta,
                                backgroundColor: Colors.grey[400]!,
                                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 96, 177, 100)!),
                                minHeight: 10.0,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 10.0, // Asegura que el texto no cubra la barra de progreso
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ],
                    
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF094976), // Color de fondo azul
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: Text(
                              '${Plazos.containsKey(plazo) ? Plazos[plazo] : plazo} ' +actualPlazo.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('¿Está seguro que lo deseas marcar como ahorrado?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Sí'),
                                        onPressed: () {
                                          // Realiza la acción de confirmación aquí
                                          Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.check_box_outline_blank_outlined, color: Colors.grey),
                                SizedBox(width: 10),
                                Text('\$${montoPlazo}', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          formatoFecha.format(fechaPlazo()),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      
                    ],
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos columnas
                childAspectRatio: 2.0, // Proporción alto/ancho de cada elemento
              ),
              itemCount: totalPlazos,
              itemBuilder: (BuildContext context, int index) {
                var cumplido = false;
                if(index+1<actualPlazo){
                  cumplido=true;
                }
                return ListTile(
                  leading: Icon(cumplido ? Icons.check_box : Icons.check_box_outline_blank_rounded, color: cumplido ? Colors.green : Colors.grey,),
                  title: Text('\$${montoPlazo}',style: TextStyle(
                    decoration: cumplido ? TextDecoration.lineThrough : TextDecoration.none,
                  ),),
                  subtitle: Text('${Plazos.containsKey(plazo) ? Plazos[plazo] : plazo} ${index + 1} de $totalPlazos'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}