import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart'; // Importar el paquete de animaciones

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

  Future<void> registerUser() async {
    if (usernameController.text.isEmpty ||
        paternalsurnameController.text.isEmpty ||
        maternalsurnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        rolController.text.isEmpty ||
        roluserController.text.isEmpty ||
        phoneController.text.isEmpty ||
        numberemployeeController.text.isEmpty ||
        //CONTACTO DE EMERGENCIA
        contactonombreController.text.isEmpty ||
        domicilioController.text.isEmpty ||
        emergenciaphoneController.text.isEmpty ||
        relacioncontactoController.text.isEmpty ||
        //ACCION DE REGISTRAR AL FINAL
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      // Validar confirmar contraseña
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Por favor, Ingresa Todos los Campos.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!validatePasswords()) {
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.99/api/register.php'), //API
      body: jsonEncode({
        "username": usernameController.text,
        "paternal_surname": paternalsurnameController.text,
        "maternal_surname": maternalsurnameController.text,
        "email": emailController.text,
        "rol": rolController.text,
        "rol_user": roluserController.text,
        "phone": phoneController.text,
        "number_employee": numberemployeeController.text,
        //CAMPOS DE CONTACTO DE EMERGENCIA
        "contacto_nombre": contactonombreController.text,
        "domicilio": domicilioController.text,
        "emergencia_phone": emergenciaphoneController.text,
        "relacion_contacto": relacioncontactoController.text,
        //CAMPOS DE CONTRASEÑA
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: data['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 3),
        ),
      );
      if (data['success']) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Error de Conexión con el Servidor.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool validatePasswords() {
    if (passwordController.text != confirmPasswordController.text) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.white,
              ),
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
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    // Las contraseñas coinciden
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        title: Text('Formulario de Registro',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            .animate()
            .fadeIn(duration: 500.ms), // Animación de fadeIn en el título
        backgroundColor: const Color.fromARGB(255, 0, 140, 255),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 12.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Asegúrate de tener un archivo de imagen en assets
                  SizedBox(height: 5.0),
                  Text(
                    'Registro',
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ).animate().fadeIn(
                      duration: 500.ms), // Animación de fadeIn en el título
                  SizedBox(height: 20.0),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),
                  TextField(
                    controller: paternalsurnameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido Paterno',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),
                  TextField(
                    controller: maternalsurnameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido Materno',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),

                  TextField(
                    controller: numberemployeeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Número de Empleado',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon:
                          Icon(Icons.person_search, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),

                  DropdownButtonFormField<String>(
                    value: null,
                    onChanged: (String? newValue) {
                      setState(() {
                        rolController.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Departamento / Área de Trabajo',
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: const Icon(Icons.people, color: Colors.black),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    dropdownColor: Colors.white,
                    items: <String>[
                      'Administración',
                      'Responsable de Planta',
                      'Metales',
                      'Inyección',
                      'Impresión de Exhibidores',
                      'Impresión y Corte de Publicicidad',
                      'Almacén',
                      'Calidad',
                      'Finanzas',
                      'Recursos Humanos',
                      'Diseño',
                      'Sistemas Informáticos',
                      'Comunicación y Redes Sociales',
                      'Encargado de Área'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  const SizedBox(height: 16.0),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.email, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Número de Teléfono',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 16.0),

                  DropdownButtonFormField<String>(
                    value: null,
                    onChanged: (String? newValue) {
                      setState(() {
                        roluserController.text = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Rol de Usuario',
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: const Icon(Icons.people, color: Colors.black),
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    dropdownColor: Colors.white,
                    items: <String>[
                      'Personal de Producción',
                      'Directivo', //PERMISOS:
                      'Jefe de Área',
                      'Gerente de Área',
                      'Supervisor'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  const SizedBox(height: 16.0),

                  Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.contact_emergency,
                                      color: Colors.red),
                                  SizedBox(width: 8.0),
                                  Text('Contacto de Emergencia',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0)),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              TextField(
                                controller: contactonombreController,
                                decoration: InputDecoration(
                                  labelText: 'Nombre Completo',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.people, color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Colors.black,
                              )
                                  .animate()
                                  .slideX(
                                      begin: -1.0,
                                      end: 0.0,
                                      duration: 500.ms,
                                      curve: Curves.easeOut)
                                  .fadeIn(duration: 500.ms),
                              SizedBox(height: 16.0),
                              TextField(
                                controller: domicilioController,
                                decoration: InputDecoration(
                                  labelText: 'Domicilio',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.map, color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Colors.black,
                              )
                                  .animate()
                                  .slideX(
                                      begin: -1.0,
                                      end: 0.0,
                                      duration: 500.ms,
                                      curve: Curves.easeOut)
                                  .fadeIn(duration: 500.ms),
                              SizedBox(height: 16.0),
                              TextField(
                                controller: emergenciaphoneController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Número de Teléfono',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!),
                                  ),
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Colors.black,
                              )
                                  .animate()
                                  .slideX(
                                      begin: -1.0,
                                      end: 0.0,
                                      duration: 500.ms,
                                      curve: Curves.easeOut)
                                  .fadeIn(
                                      duration: 500
                                          .ms), // Animación de deslizamiento y fadeIn
                              SizedBox(height: 16.0),
                              TextField(
                                controller: relacioncontactoController,
                                decoration: InputDecoration(
                                  labelText: 'Relación con el Contacto',
                                  labelStyle: TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]!),
                                  ),
                                  prefixIcon: Icon(Icons.people_alt,
                                      color: Colors.black),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Colors.black,
                              )
                                  .animate()
                                  .slideX(
                                      begin: -1.0,
                                      end: 0.0,
                                      duration: 500.ms,
                                      curve: Curves.easeOut)
                                  .fadeIn(duration: 500.ms),
                              SizedBox(height: 16.0),
                            ],
                          ))
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(duration: 500.ms),
                  SizedBox(height: 16.0),

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: !_isPasswordVisible,
                    cursorColor: Colors.black,
                  )
                      .animate()
                      .slideX(
                          begin: -1.0,
                          end: 0.0,
                          duration: 500.ms,
                          curve: Curves.easeOut)
                      .fadeIn(
                          duration:
                              500.ms), // Animación de deslizamiento y fadeIn
                  SizedBox(height: 15.0),
                  TextField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      labelStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: !_isConfirmPasswordVisible,
                    cursorColor: Colors.black,
                  ),
                  SizedBox(height: 30.0),

                  ElevatedButton(
                    onPressed: registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 13.0),
                      textStyle: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    child: Text('Registrarme',
                        style: TextStyle(color: Colors.white)),
                  )
                      .animate()
                      .scale(delay: 500.ms), // Animación de escala en el botón
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
