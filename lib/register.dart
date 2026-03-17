import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final confirmPasswordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController paternalsurnameController =
      TextEditingController();
  final TextEditingController maternalsurnameController =
      TextEditingController();
  final TextEditingController rolController = TextEditingController();
  final TextEditingController roluserController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController numberemployeeController =
      TextEditingController();

  //CONTACTO DE EMERGENCIA
  final TextEditingController contactonombreController =
      TextEditingController();
  final TextEditingController domicilioController = TextEditingController();
  final TextEditingController emergenciaphoneController =
      TextEditingController();
  final TextEditingController relacioncontactoController =
      TextEditingController();

  // Paleta de colores profesional
  final Color _primaryColor = const Color(0xFF2C3E50);
  final Color _secondaryColor = const Color(0xFF3498DB);
  final Color _accentColor = const Color(0xFFE74C3C);
  final Color _successColor = const Color(0xFF27AE60);
  final Color _backgroundColor = const Color(0xFFF8F9FA);
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF2C3E50);
  final Color _hintColor = const Color(0xFF7F8C8D);

  Future<void> registerUser() async {
    if (usernameController.text.isEmpty ||
        paternalsurnameController.text.isEmpty ||
        maternalsurnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        rolController.text.isEmpty ||
        roluserController.text.isEmpty ||
        phoneController.text.isEmpty ||
        numberemployeeController.text.isEmpty ||
        contactonombreController.text.isEmpty ||
        domicilioController.text.isEmpty ||
        emergenciaphoneController.text.isEmpty ||
        relacioncontactoController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Por favor, completa todos los campos obligatorios.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!validatePasswords()) {
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.email, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Por favor, ingresa un correo electrónico válido.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.99/api/register.php'),
        body: jsonEncode({
          "username": usernameController.text,
          "paternal_surname": paternalsurnameController.text,
          "maternal_surname": maternalsurnameController.text,
          "email": emailController.text,
          "rol": rolController.text,
          "rol_user": roluserController.text,
          "phone": phoneController.text,
          "number_employee": numberemployeeController.text,
          "contacto_nombre": contactonombreController.text,
          "domicilio": domicilioController.text,
          "emergencia_phone": emergenciaphoneController.text,
          "relacion_contacto": relacioncontactoController.text,
          "password": passwordController.text,
          "confirm_password": confirmPasswordController.text,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  data['success']
                      ? Icons.check_circle_outline
                      : Icons.error_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data['message'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: data['success'] ? _successColor : _accentColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            duration: Duration(seconds: 4),
          ),
        );
        if (data['success']) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        }
      } else {
        _showErrorSnackBar('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error de conexión: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        duration: Duration(seconds: 4),
      ),
    );
  }

  bool validatePasswords() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Las contraseñas no coinciden.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.security, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'La contraseña debe tener al menos 6 caracteres.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: _accentColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('Registro de Usuario',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isSmallScreen ? 18.0 : 20.0,
            )).animate().fadeIn(duration: 500.ms),
        backgroundColor: _primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Card(
                color: _cardColor,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 20.0 : 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header con icono
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_add_alt_1,
                              size: 50,
                              color: _secondaryColor,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Crear Nueva Cuenta',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 22.0 : 26.0,
                                fontWeight: FontWeight.w700,
                                color: _textColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Complete todos los campos para registrarse',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14.0 : 16.0,
                                color: _hintColor,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 500.ms),

                      const SizedBox(height: 20),

                      // Formulario en columnas responsivas
                      _buildResponsiveForm(isSmallScreen),

                      const SizedBox(height: 30),

                      // Información de campos obligatorios
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: _secondaryColor, size: 16),
                            SizedBox(width: 8),
                            Text(
                              '* Campos obligatorios',
                              style: TextStyle(
                                color: _hintColor,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón de registro
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _secondaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: isSmallScreen ? 14.0 : 16.0,
                            ),
                            textStyle: TextStyle(
                              fontSize: isSmallScreen ? 16.0 : 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add,
                                  size: 20, color: Colors.white),
                              SizedBox(width: 10),
                              Text('CREAR CUENTA'),
                            ],
                          ),
                        ),
                      ).animate().scale(delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveForm(bool isSmallScreen) {
    if (isSmallScreen) {
      return _buildFormColumn();
    } else {
      return _buildFormGrid();
    }
  }

  Widget _buildFormColumn() {
    return Column(
      children: [
        _buildPersonalInfoSection(),
        const SizedBox(height: 20),
        _buildWorkInfoSection(),
        const SizedBox(height: 20),
        _buildEmergencyContactSection(),
        const SizedBox(height: 20),
        _buildSecuritySection(),
      ],
    );
  }

  Widget _buildFormGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildPersonalInfoSection()),
            SizedBox(width: 20),
            Expanded(child: _buildWorkInfoSection()),
          ],
        ),
        SizedBox(height: 20),
        _buildEmergencyContactSection(),
        SizedBox(height: 20),
        _buildSecuritySection(),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildFormSection(
      icon: Icons.person_outline,
      title: 'Información Personal',
      children: [
        _buildTextField(
          controller: usernameController,
          label: 'Nombre(s)',
          icon: Icons.person,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: paternalsurnameController,
          label: 'Apellido Paterno',
          icon: Icons.person_outline,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: maternalsurnameController,
          label: 'Apellido Materno',
          icon: Icons.person_outline,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: emailController,
          label: 'Correo Electrónico',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: phoneController,
          label: 'Teléfono',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildWorkInfoSection() {
    return _buildFormSection(
      icon: Icons.work_outline,
      title: 'Información Laboral',
      children: [
        _buildTextField(
          controller: numberemployeeController,
          label: 'Número de Empleado',
          icon: Icons.badge,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildDropdown(
          controller: rolController,
          label: 'Departamento/Área',
          icon: Icons.business_center,
          items: [
            'Administración',
            'Responsable de Planta',
            'Metales',
            'Inyección',
            'Impresión de Exhibidores',
            'Impresión y Corte de Publicidad',
            'Almacén',
            'Calidad',
            'Finanzas',
            'Recursos Humanos',
            'Diseño',
            'Sistemas Informáticos',
            'Comunicación y Redes Sociales',
            'Encargado de Área'
          ],
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildDropdown(
          controller: roluserController,
          label: 'Rol de Usuario',
          icon: Icons.manage_accounts,
          items: [
            'Personal de Producción',
            'Directivo',
            'Jefe de Área',
            'Gerente de Área',
            'Supervisor'
          ],
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildFormSection(
      icon: Icons.contact_emergency,
      title: 'Contacto de Emergencia',
      accentColor: _accentColor,
      children: [
        _buildTextField(
          controller: contactonombreController,
          label: 'Nombre Completo',
          icon: Icons.person,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: domicilioController,
          label: 'Domicilio',
          icon: Icons.home,
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: emergenciaphoneController,
          label: 'Teléfono de Emergencia',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: relacioncontactoController,
          label: 'Relación con el Contacto',
          icon: Icons.people_alt,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildFormSection(
      icon: Icons.security,
      title: 'Seguridad',
      children: [
        _buildPasswordField(
          controller: passwordController,
          label: 'Contraseña',
          isPasswordVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          isRequired: true,
        ),
        SizedBox(height: 16),
        _buildPasswordField(
          controller: confirmPasswordController,
          label: 'Confirmar Contraseña',
          isPasswordVisible: _isConfirmPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
          isRequired: true,
        ),
        SizedBox(height: 8),
        Text(
          'La contraseña debe tener al menos 6 caracteres',
          style: TextStyle(
            color: _hintColor,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
    Color? accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor ?? _secondaryColor, size: 22),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    )
        .animate()
        .slideX(
          begin: -0.5,
          end: 0.0,
          duration: 500.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 500.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isRequired = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(color: _secondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: _secondaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isPasswordVisible,
    required VoidCallback onToggleVisibility,
    bool isRequired = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(color: _secondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: _secondaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        prefixIcon: Icon(Icons.lock, color: _textColor.withOpacity(0.6)),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: _textColor.withOpacity(0.6),
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cursorColor: _secondaryColor,
      style: TextStyle(color: _textColor),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
    bool isRequired = false,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      onChanged: (String? newValue) {
        setState(() {
          controller.text = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: '$label${isRequired ? ' *' : ''}',
        labelStyle: TextStyle(color: _textColor.withOpacity(0.7)),
        floatingLabelStyle: TextStyle(color: _secondaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: _secondaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        prefixIcon: Icon(icon, color: _textColor.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 16), //ADD
      ),
      style: TextStyle(color: _textColor, fontSize: 16.0),
      dropdownColor: _cardColor,
      icon: Icon(Icons.arrow_drop_down, color: _textColor.withOpacity(0.6)),
      isExpanded: true, //ADD
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
}
