import 'package:flutter/material.dart';

class VerSolicitudesVacacionesPage extends StatelessWidget {
  final List<Map<String, dynamic>> solicitudes = [
    {
      'id': 1,
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-01',
      'rangoFechas': '01/10/2023 - 05/10/2023',
      'diasSeleccionados': 5,
      'estado': 'Pendiente',
      'motivoRechazo': '',
    },
    // Más solicitudes...
  ];

  VerSolicitudesVacacionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Solicitudes de Vacaciones'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: solicitudes.length,
        itemBuilder: (context, index) {
          final solicitud = solicitudes[index];
          return _buildSolicitudCard(solicitud, context);
        },
      ),
    );
  }

  Widget _buildSolicitudCard(
      Map<String, dynamic> solicitud, BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${solicitud['nombre']}'),
            Text('Cargo: ${solicitud['cargo']}'),
            Text('Área: ${solicitud['area']}'),
            Text('Fecha de Solicitud: ${solicitud['fechaSolicitud']}'),
            Text('Rango de Fechas: ${solicitud['rangoFechas']}'),
            Text('Días Seleccionados: ${solicitud['diasSeleccionados']}'),
            Text('Estado: ${solicitud['estado']}'),
            if (solicitud['estado'] == 'Rechazada')
              Text('Motivo de Rechazo: ${solicitud['motivoRechazo']}'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _aprobarSolicitud(context, solicitud['id']),
                  child: Text('Aprobar'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () => _rechazarSolicitud(context, solicitud['id']),
                  child: Text('Rechazar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _aprobarSolicitud(BuildContext context, int id) {
    // Lógica para aprobar la solicitud
    print('Solicitud $id aprobada');
  }

  void _rechazarSolicitud(BuildContext context, int id) {
    // Lógica para rechazar la solicitud
    showDialog(
      context: context,
      builder: (context) {
        String motivo = '';
        return AlertDialog(
          title: Text('Motivo de Rechazo'),
          content: TextField(
            onChanged: (value) => motivo = value,
            decoration: InputDecoration(hintText: 'Ingrese el motivo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                print('Solicitud $id rechazada. Motivo: $motivo');
                Navigator.pop(context);
              },
              child: Text('Enviar'),
            ),
          ],
        );
      },
    );
  }
}
