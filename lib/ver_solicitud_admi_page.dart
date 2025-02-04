import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminVacacionesPage extends StatefulWidget {
  const AdminVacacionesPage({super.key});

  @override
  _AdminVacacionesPageState createState() => _AdminVacacionesPageState();
}

class _AdminVacacionesPageState extends State<AdminVacacionesPage> {
  final List<Map<String, dynamic>> _solicitudes = [
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'Tecnología',
      'fechaSolicitud': '2023-10-01',
      'rangoFechas': '01/10/2023 - 05/10/2023',
      'diasTotales': 5,
      'estado': 'Pendiente',
      'motivoRechazo': '',
    },
    {
      'nombre': 'María Gómez',
      'cargo': 'Diseñadora',
      'area': 'Marketing',
      'fechaSolicitud': '2023-10-02',
      'rangoFechas': '10/10/2023 - 15/10/2023',
      'diasTotales': 6,
      'estado': 'Pendiente',
      'motivoRechazo': '',
    },
  ];

  void _aceptarSolicitud(int index) {
    setState(() {
      _solicitudes[index]['estado'] = 'Aprobada';
    });
    _mostrarMensaje('Solicitud aprobada');
  }

  void _rechazarSolicitud(int index) {
    TextEditingController motivoController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Rechazar Solicitud',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingrese el motivo de rechazo:'),
              TextField(
                controller: motivoController,
                decoration: const InputDecoration(hintText: 'Motivo'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      color: Colors.yellow[800], fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _solicitudes[index]['estado'] = 'Rechazada';
                  _solicitudes[index]['motivoRechazo'] = motivoController.text;
                });
                Navigator.pop(context);
                _mostrarMensaje('Solicitud rechazada');
              },
              child:
                  const Text('Rechazar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Solicitudes de Vacaciones',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 500.ms),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _solicitudes.length,
        itemBuilder: (context, index) {
          final solicitud = _solicitudes[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre: ${solicitud['nombre']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 8),
                  _buildBoldText('Cargo:', solicitud['cargo']),
                  _buildBoldText('Área:', solicitud['area']),
                  _buildBoldText(
                    'Fecha de Solicitud:',
                    DateFormat('dd/MM/yyyy')
                        .format(DateTime.parse(solicitud['fechaSolicitud'])),
                  ),
                  _buildBoldText('Rango de Fechas:', solicitud['rangoFechas']),
                  _buildBoldText(
                      'Días Totales:', solicitud['diasTotales'].toString()),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (solicitud['estado'] == 'Pendiente') ...[
                        _buildButton('Aceptar', Colors.green,
                            () => _aceptarSolicitud(index)),
                        const SizedBox(width: 8),
                        _buildButton('Rechazar', Colors.red,
                            () => _rechazarSolicitud(index)),
                      ],
                      if (solicitud['estado'] == 'Aprobada')
                        const Text(
                          'Aprobada',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ).animate().fadeIn(duration: 500.ms),
                      if (solicitud['estado'] == 'Rechazada')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rechazada',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ).animate().fadeIn(duration: 500.ms),
                            if (solicitud['motivoRechazo'].isNotEmpty)
                              Text('Motivo: ${solicitud['motivoRechazo']}')
                                  .animate()
                                  .fadeIn(duration: 500.ms),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().slideX(
              begin: -1.0, end: 0.0, duration: 500.ms, curve: Curves.easeOut);
        },
      ),
    );
  }

  Widget _buildBoldText(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ).animate().scale(delay: 500.ms);
  }
}
