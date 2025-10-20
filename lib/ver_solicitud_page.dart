import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerSolicitudPage extends StatefulWidget {
  final String userId;
  final String username;
  final String rol;
  final String roluser;
  const VerSolicitudPage({
    super.key,
    required this.userId,
    this.username = '',
    this.rol = '',
    this.roluser = '',
  });
  @override
  _VerSolicitudPageState createState() => _VerSolicitudPageState();
}

class _VerSolicitudPageState extends State<VerSolicitudPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> solicitudes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    fetchSolicitudes();
  }

  Future<void> fetchSolicitudes() async {
    final url = Uri.parse(
        'http://192.168.1.99/api/vacaciones/obtener_solicitud_vacaciones.php');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id': widget.userId});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          solicitudes =
              List<Map<String, dynamic>>.from(data['solicitudes'] ?? []);
        });
        //print('Solicitudes obtenidas: $solicitudes');
        isLoading = false;
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error al obtener las solicitudes: $e');
    }
  }

  String _formatFechaSolicitud(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    } catch (e) {
      return fecha;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'Mis Solicitudes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : solicitudes.isEmpty
              ? Center(
                  child: Text(
                    'No hay solicitudes para mostrar.',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estatus / Historial de Solicitud de Vacaciones',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      ...solicitudes
                          .map((solicitud) => SlideTransition(
                                position: _animation,
                                child: _buildSolicitudCard(solicitud),
                              ))
                          .toList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSolicitudCard(Map<String, dynamic> solicitud) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
                Icons.confirmation_number, 'ID', solicitud['id'].toString()),
            _buildInfoRow(
              Icons.calendar_today,
              'Fecha de Solicitud',
              _formatFechaSolicitud(solicitud['fecha_solicitud']),
            ),
            _buildInfoRow(
                Icons.date_range, 'Rango de Fechas', solicitud['rango_fechas']),
            _buildInfoRow(Icons.timelapse, 'Días Seleccionados',
                solicitud['dias_seleccionados'].toString()),
            const SizedBox(height: 8.0),
            _buildAutorizacionRow('Autorización 1', solicitud['estado'],
                solicitud['motivo_rechazo']),
            const SizedBox(height: 8.0),
            _buildAutorizacionRow('Autorización 2', solicitud['estado_2'],
                solicitud['motivo_rechazo_2']),
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

  Widget _buildAutorizacionRow(
      String label, String status, String motivoRechazo) {
    Color statusColor;
    switch (status) {
      case 'Autorizada':
        statusColor = Colors.green;
        break;
      case 'Rechazada':
        statusColor = Colors.red;
        break;
      case 'Pendiente':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_user, color: Colors.teal[800], size: 20.0),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(width: 8.0),
            Icon(Icons.circle, color: statusColor, size: 16.0),
            const SizedBox(width: 4.0),
            Text(
              status,
              style: TextStyle(
                fontSize: 16.0,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (motivoRechazo.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 28.0, top: 4.0),
            child: Text(
              'Motivo: $motivoRechazo',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}
