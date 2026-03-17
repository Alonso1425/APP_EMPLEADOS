import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

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

class _VerSolicitudPageState extends State<VerSolicitudPage> {
  List<Map<String, dynamic>> solicitudes = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  // Paleta de colores profesional
  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _secondaryColor = const Color(0xFF3498DB);
  final Color _accentColor = const Color(0xFFE74C3C);
  final Color _successColor = const Color(0xFF27AE60);
  final Color _warningColor = const Color(0xFFF39C12);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _hintColor = const Color(0xFF7F8C8D);

  @override
  void initState() {
    super.initState();
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
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage =
              'Error al cargar las solicitudes: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Error de conexión: $e';
      });
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

  Future<void> _refreshSolicitudes() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    await fetchSolicitudes();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header personalizado sin AppBar
            _buildCustomHeader(isSmallScreen),
            Expanded(
              child: isLoading
                  ? _buildLoadingState()
                  : hasError
                      ? _buildErrorState()
                      : solicitudes.isEmpty
                          ? _buildEmptyState()
                          : _buildSolicitudesList(isSmallScreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Se eliminó el IconButton de retroceso
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mis Solicitudes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Historial y estado de tus solicitudes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${solicitudes.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_secondaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando solicitudes...',
            style: TextStyle(
              color: _hintColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: _accentColor,
          ),
          SizedBox(height: 16),
          Text(
            'Error al cargar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _hintColor,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _refreshSolicitudes,
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: _hintColor,
          ),
          SizedBox(height: 16),
          Text(
            'No hay solicitudes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aún no has realizado ninguna solicitud de vacaciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _hintColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesList(bool isSmallScreen) {
    return RefreshIndicator(
      onRefresh: _refreshSolicitudes,
      backgroundColor: _backgroundColor,
      color: _secondaryColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            // Resumen rápido
            _buildQuickSummary(),
            SizedBox(height: 20),
            // Lista de solicitudes
            ...solicitudes.asMap().entries.map((entry) {
              final index = entry.key;
              final solicitud = entry.value;
              return _buildSolicitudCard(solicitud, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSummary() {
    final autorizadas = solicitudes
        .where(
            (s) => s['estado'] == 'Autorizada' || s['estado_2'] == 'Autorizada')
        .length;
    final pendientes = solicitudes
        .where(
            (s) => s['estado'] == 'Pendiente' || s['estado_2'] == 'Pendiente')
        .length;
    final rechazadas = solicitudes
        .where(
            (s) => s['estado'] == 'Rechazada' || s['estado_2'] == 'Rechazada')
        .length;

    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Resumen de Solicitudes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Autorizadas', autorizadas, _successColor),
                _buildSummaryItem('Pendientes', pendientes, _warningColor),
                _buildSummaryItem('Rechazadas', rechazadas, _accentColor),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSolicitudCard(Map<String, dynamic> solicitud, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: _cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Fecha de Solicitud',
                value: _formatFechaSolicitud(solicitud['fecha_solicitud']),
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.date_range,
                label: 'Rango de Fechas',
                value: solicitud['rango_fechas'],
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.timelapse,
                label: 'Días Solicitados',
                value: solicitud['dias_seleccionados'].toString(),
              ),

              SizedBox(height: 16),

              // Estados de autorización
              _buildAutorizacionSection(solicitud),
            ],
          ),
        ),
      ),
    )
        .animate()
        .slideY(
          begin: 0.5,
          end: 0.0,
          duration: 500.ms + (index * 100).ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 600.ms + (index * 100).ms);
  }

  Widget _buildSolicitudHeader(Map<String, dynamic> solicitud) {
    final estadoGeneral = _getEstadoGeneral(solicitud);
    final Color estadoColor = _getColorForEstado(estadoGeneral);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solicitud #${solicitud['id']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _formatFechaSolicitud(solicitud['fecha_solicitud']),
                style: TextStyle(
                  fontSize: 14,
                  color: _hintColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: estadoColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: estadoColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getIconForEstado(estadoGeneral),
                size: 14,
                color: estadoColor,
              ),
              SizedBox(width: 6),
              Text(
                estadoGeneral,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: estadoColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _secondaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: _secondaryColor),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: _hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutorizacionSection(Map<String, dynamic> solicitud) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estados de Autorización',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        SizedBox(height: 12),
        _buildAutorizacionItem(
          label: 'Primera Autorización',
          status: solicitud['estado'],
          motivo: solicitud['motivo_rechazo'],
        ),
        SizedBox(height: 8),
        _buildAutorizacionItem(
          label: 'Segunda Autorización',
          status: solicitud['estado_2'],
          motivo: solicitud['motivo_rechazo_2'],
        ),
      ],
    );
  }

  Widget _buildAutorizacionItem({
    required String label,
    required String status,
    required String motivo,
  }) {
    final Color statusColor = _getColorForEstado(status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForEstado(status),
                size: 16,
                color: statusColor,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (motivo != null && motivo.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 8),
              child: Text(
                'Motivo: $motivo',
                style: TextStyle(
                  fontSize: 12,
                  color: _accentColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getEstadoGeneral(Map<String, dynamic> solicitud) {
    if (solicitud['estado'] == 'Rechazada' ||
        solicitud['estado_2'] == 'Rechazada') {
      return 'Rechazada';
    } else if (solicitud['estado'] == 'Autorizada' &&
        solicitud['estado_2'] == 'Autorizada') {
      return 'Autorizada';
    } else {
      return 'Pendiente';
    }
  }

  Color _getColorForEstado(String estado) {
    switch (estado) {
      case 'Autorizada':
        return _successColor;
      case 'Rechazada':
        return _accentColor;
      case 'Pendiente':
        return _warningColor;
      default:
        return _hintColor;
    }
  }

  IconData _getIconForEstado(String estado) {
    switch (estado) {
      case 'Autorizada':
        return Icons.check_circle;
      case 'Rechazada':
        return Icons.cancel;
      case 'Pendiente':
        return Icons.pending;
      default:
        return Icons.help;
    }
  }
}
