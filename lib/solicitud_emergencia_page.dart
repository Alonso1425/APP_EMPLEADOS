import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SolicitudEmergenciaPage extends StatefulWidget {
  final String username;
  final String rol;
  final String roluser;

  const SolicitudEmergenciaPage(
      {super.key, this.username = '', this.rol = '', this.roluser = ''});

  @override
  _SolicitudEmergenciaPageState createState() =>
      _SolicitudEmergenciaPageState();
}

class _SolicitudEmergenciaPageState extends State<SolicitudEmergenciaPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController rolController = TextEditingController();
  final TextEditingController roluserController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController rangoFechaController = TextEditingController();
  final TextEditingController motivoController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  int _diasSeleccionados = 0;
  final List<DateTime> _diasSolicitados = [];
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  String? dropdownValue;
  String? parentescoValue;
  bool showOtherField = false;
  bool showOtherField2 = false;

  // Paleta de colores profesional
  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _secondaryColor = const Color(0xFF3498DB);
  final Color _accentColor = const Color(0xFFE74C3C);
  final Color _warningColor = const Color(0xFFF39C12);
  final Color _successColor = const Color(0xFF27AE60);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _hintColor = const Color(0xFF7F8C8D);

  @override
  void initState() {
    super.initState();
    _setDate();
    _loadUserData();
    _focusedDay = DateTime.now();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showInformativeDialog());
  }

  void _loadUserData() {
    setState(() {
      usernameController.text = widget.username;
      rolController.text = widget.rol;
      roluserController.text = widget.roluser;
    });
  }

  void _setDate() {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    dateController.text = currentDate;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_diasSolicitados.contains(selectedDay)) {
        _diasSolicitados.remove(selectedDay);
      } else {
        _diasSolicitados.add(selectedDay);
      }
      _diasSeleccionados = _diasSolicitados.length;
      if (_diasSolicitados.isNotEmpty) {
        _diasSolicitados.sort((a, b) => a.compareTo(b));
        rangoFechaController.text = _diasSolicitados
            .map((e) => DateFormat('dd/MM/yyyy').format(e))
            .join(' - ');
      } else {
        rangoFechaController.clear();
      }
    });
  }

  void _enviarSolicitudEmergencia() {
    if (_diasSeleccionados == 0) {
      _mostrarMensajeError(
          'Por favor selecciona al menos un día de emergencia.');
      return;
    }

    if (dropdownValue == null) {
      _mostrarMensajeError('Por favor selecciona el tipo de emergencia.');
      return;
    }

    if (dropdownValue == "Otro" && motivoController.text.isEmpty) {
      _mostrarMensajeError('Por favor especifica el motivo de la emergencia.');
      return;
    }

    if (dropdownValue == "Enfermedad" && parentescoValue == null) {
      _mostrarMensajeError(
          'Por favor selecciona el parentesco con el familiar.');
      return;
    }

    _resetfields();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: _successColor),
              SizedBox(width: 10),
              Text(
                "Solicitud Enviada",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ],
          ),
          content: Text(
            "Tu solicitud de vacaciones de emergencia fue enviada exitosamente para revisión y autorización.",
            style: TextStyle(
              color: _textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "ENTENDIDO",
                style: TextStyle(
                  color: _secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _accentColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  void _resetfields() {
    setState(() {
      _diasSolicitados.clear();
      _diasSeleccionados = 0;
      rangoFechaController.clear();
      dropdownValue = null;
      parentescoValue = null;
      motivoController.clear();
      showOtherField = false;
      showOtherField2 = false;
    });
  }

  void _showInformativeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: _warningColor),
              SizedBox(width: 10),
              Text(
                'Importante',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Las vacaciones por emergencia solamente serán autorizadas cuando se trate de situaciones no previstas o de emergencia, tales como: Accidente, Enfermedad o Fallecimiento de un Familiar en primer o segundo grado.',
            style: TextStyle(
              color: _textColor.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ACEPTAR',
                style: TextStyle(
                  color: _secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      // appBar: AppBar(
      //   title: Text(
      //     'Solicitud de Emergencia',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.w600,
      //       fontSize: isSmallScreen ? 18 : 20,
      //     ),
      //   ).animate().fadeIn(duration: 500.ms),
      //   backgroundColor: _primaryColor,
      //   centerTitle: true,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header informativo
              _buildHeaderSection(isSmallScreen),
              SizedBox(height: 20),

              // Información del empleado
              _buildEmployeeInfoSection(isSmallScreen),
              SizedBox(height: 20),

              // Calendario
              _buildCalendarSection(isSmallScreen),
              SizedBox(height: 20),

              // Resumen de selección
              _buildSelectionSummarySection(isSmallScreen),
              SizedBox(height: 20),

              // Tipo de emergencia
              _buildEmergencyTypeSection(isSmallScreen),
              SizedBox(height: 20),

              // Botón de enviar
              _buildActionButtonSection(isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emergency,
            size: 40,
            color: _accentColor,
          ),
          SizedBox(height: 10),
          Text(
            'Solicitud de Emergencia',
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Para situaciones no previstas que requieren atención inmediata',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: _hintColor,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildEmployeeInfoSection(bool isSmallScreen) {
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
                Icon(Icons.person_outline, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Información del Solicitante',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              label: 'Fecha de Solicitud',
              value: dateController.text,
              icon: Icons.today,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Nombre del Empleado',
              value: usernameController.text,
              icon: Icons.person,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Cargo',
              value: rolController.text,
              icon: Icons.business_center,
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              label: 'Área/Departamento',
              value: roluserController.text,
              icon: Icons.apartment,
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideX(
          begin: -0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: _hintColor),
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
              SizedBox(height: 4),
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

  Widget _buildCalendarSection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Selecciona los días de emergencia',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => _diasSolicitados.contains(day),
                onDaySelected: _onDaySelected,
                calendarFormat: _calendarFormat,
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon:
                      Icon(Icons.chevron_left, color: _secondaryColor),
                  rightChevronIcon:
                      Icon(Icons.chevron_right, color: _secondaryColor),
                  headerPadding: EdgeInsets.symmetric(vertical: 12),
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textColor,
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _accentColor,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: _accentColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: _accentColor),
                  ),
                  todayTextStyle: TextStyle(
                    color: _accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  defaultTextStyle: TextStyle(
                    color: _textColor,
                  ),
                  weekendTextStyle: TextStyle(
                    color: _accentColor,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                availableGestures: AvailableGestures.all,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '💡 Toca los días que necesitas por emergencia',
              style: TextStyle(
                fontSize: 12,
                color: _hintColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slideX(
          begin: 0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildSelectionSummarySection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: _secondaryColor),
                SizedBox(width: 10),
                Text(
                  'Resumen de Selección',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSummaryItem(
              icon: Icons.calendar_today,
              label: 'Días de Emergencia',
              value: '$_diasSeleccionados',
              color: _accentColor,
            ),
            SizedBox(height: 12),
            _buildSummaryItem(
              icon: Icons.date_range,
              label: 'Fechas Seleccionadas',
              value: rangoFechaController.text.isNotEmpty
                  ? rangoFechaController.text
                  : 'No hay fechas seleccionadas',
              color: _diasSeleccionados > 0 ? _successColor : _hintColor,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
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
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTypeSection(bool isSmallScreen) {
    return Card(
      color: _cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: _accentColor),
                SizedBox(width: 10),
                Text(
                  'Tipo de Emergencia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              value: dropdownValue,
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue;
                  showOtherField = dropdownValue == "Otro";
                  showOtherField2 = dropdownValue == "Enfermedad";
                  if (!showOtherField) motivoController.clear();
                  if (!showOtherField2) parentescoValue = null;
                });
              },
              label: 'Selecciona el tipo de emergencia',
              icon: Icons.emergency,
              items: ['Enfermedad', 'Accidente', 'Fallecimiento', 'Otro'],
              isRequired: true,
            ),
            SizedBox(height: 16),
            if (showOtherField)
              _buildTextField(
                controller: motivoController,
                label: 'Especifica el motivo de la emergencia',
                icon: Icons.description,
                maxLines: 3,
              ).animate().fadeIn(duration: 300.ms),
            if (showOtherField2)
              Column(
                children: [
                  SizedBox(height: 16),
                  _buildDropdownField(
                    value: parentescoValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        parentescoValue = newValue;
                      });
                    },
                    label: 'Parentesco con el familiar',
                    icon: Icons.family_restroom,
                    items: [
                      'Esposo(a) / Pareja',
                      'Padre / Madre',
                      'Hijo(a)',
                      'Hermano(a)',
                      'Abuelo(a)',
                      'Padre / Madre del esposo(a) / Pareja',
                      'Hijo(a) del esposo(a) / Pareja',
                      'Hermano(a) del esposo(a) / Pareja',
                      'Abuelo(a) del esposo(a) / Pareja',
                    ],
                    isRequired: true,
                  ).animate().fadeIn(duration: 300.ms),
                ],
              ),
          ],
        ),
      ),
    )
        .animate()
        .slideX(
          begin: -0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 600.ms);
  }

  Widget _buildDropdownField({
    required String? value,
    required Function(String?) onChanged,
    required String label,
    required IconData icon,
    required List<String> items,
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(color: _secondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _secondaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        prefixIcon: Icon(icon, color: _textColor.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: TextStyle(color: _textColor, fontSize: 16),
      dropdownColor: _cardColor,
      icon: Icon(Icons.arrow_drop_down, color: _textColor.withOpacity(0.6)),
      isExpanded: true,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: _textColor),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(color: _secondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _secondaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        prefixIcon: Icon(icon, color: _textColor.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cursorColor: _secondaryColor,
      style: TextStyle(color: _textColor),
    );
  }

  Widget _buildActionButtonSection(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _enviarSolicitudEmergencia,
        style: ElevatedButton.styleFrom(
          backgroundColor: _diasSeleccionados > 0 && dropdownValue != null
              ? _accentColor
              : Colors.grey[400],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: isSmallScreen ? 16 : 18,
          ),
          textStyle: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text('ENVIAR SOLICITUD DE EMERGENCIA'),
          ],
        ),
      ),
    ).animate().scale(delay: 800.ms);
  }
}
