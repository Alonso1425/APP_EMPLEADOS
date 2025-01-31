import 'package:flutter/material.dart';

class VerSolicitudPage extends StatelessWidget {
  // Simulación de datos de solicitudes (esto vendría de una API)
  final List<Map<String, dynamic>> solicitudes = [
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-01',
      'rangoFechas': '01/10/2023 - 05/10/2023',
      'estado': 'Aprobada',
      'motivoRechazo': '',
    },
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-10',
      'rangoFechas': '10/10/2023 - 15/10/2023',
      'estado': 'Rechazada',
      'motivoRechazo': 'No hay suficiente personal disponible.',
    },
    {
      'nombre': 'Juan Pérez',
      'cargo': 'Desarrollador',
      'area': 'TI',
      'fechaSolicitud': '2023-10-20',
      'rangoFechas': '20/10/2023 - 25/10/2023',
      'estado': 'Pendiente',
      'motivoRechazo': '',
    },
  ];

  VerSolicitudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mis Solicitudes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: solicitudes.length,
        itemBuilder: (context, index) {
          final solicitud = solicitudes[index];
          return _buildSolicitudCard(solicitud);
        },
      ),
    );
  }

  Widget _buildSolicitudCard(Map<String, dynamic> solicitud) {
    // Color del estado
    Color estadoColor;
    switch (solicitud['estado']) {
      case 'Aprobada':
        estadoColor = Colors.green;
        break;
      case 'Rechazada':
        estadoColor = Colors.red;
        break;
      case 'Pendiente':
        estadoColor = Colors.orange;
        break;
      default:
        estadoColor = Colors.grey;
    }

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white, // Fondo blanco para todas las tarjetas
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre
            _buildInfoRow(Icons.person, 'Nombre', solicitud['nombre']),
            const SizedBox(height: 8.0),
            // Cargo
            _buildInfoRow(Icons.work, 'Cargo', solicitud['cargo']),
            const SizedBox(height: 8.0),
            // Área
            _buildInfoRow(Icons.business, 'Área', solicitud['area']),
            const SizedBox(height: 8.0),
            // Fecha de Solicitud
            _buildInfoRow(Icons.calendar_today, 'Fecha de Solicitud',
                solicitud['fechaSolicitud']),
            const SizedBox(height: 8.0),
            // Rango de Fechas
            _buildInfoRow(
                Icons.date_range, 'Rango de Fechas', solicitud['rangoFechas']),
            const SizedBox(height: 8.0),
            // Estado
            Row(
              children: [
                Icon(Icons.circle, color: estadoColor, size: 16.0),
                const SizedBox(width: 8.0),
                Text(
                  'Estado: ',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                Text(
                  solicitud['estado'],
                  style: TextStyle(
                    fontSize: 16.0,
                    color: estadoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Motivo de Rechazo (si aplica)
            if (solicitud['estado'] == 'Rechazada') ...[
              const SizedBox(height: 8.0),
              _buildInfoRow(Icons.warning, 'Motivo de Rechazo',
                  solicitud['motivoRechazo']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.teal[800], size: 20.0),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
