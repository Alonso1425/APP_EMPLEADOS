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

  Future<void> registerUser() async {
    if (usernameController.text.isEmpty ||
        paternalsurnameController.text.isEmpty ||
        maternalsurnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        rolController.text.isEmpty ||
        roluserController.text.isEmpty ||
        phoneController.text.isEmpty ||
        numberemployeeController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, Ingresa Todos los Campos.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
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

    final response = await http.post(
      Uri.parse('http://192.168.1.67/api/register.php'), //API
      body: jsonEncode({
        "username": usernameController.text,
        "paternal_surname": paternalsurnameController.text,
        "maternal_surname": maternalsurnameController.text,
        "email": emailController.text,
        "rol": rolController.text,
        "rol_user": roluserController.text,
        "phone": phoneController.text,
        "number_employee": numberemployeeController.text,
        "password": passwordController.text,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data['message'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
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
      if (data['success']) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de Conexión con el Servidor.')),
      );
    }
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
              padding: const EdgeInsets.all(24.0),
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelText: 'Área de Trabajo',
                      labelStyle: const TextStyle(color: Colors.black),
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
                    items: <String>[
                      'Producción',
                      'Metales',
                      'Inyección',
                      'Impresión',
                      'Almacén',
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelStyle: TextStyle(color: Colors.black),
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
                      labelStyle: const TextStyle(color: Colors.black),
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
                    items: <String>[
                      'Empleado A',
                      'Empleado B',
                      'Administrativo',
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
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.black),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: true,
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
