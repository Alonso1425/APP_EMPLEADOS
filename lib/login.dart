import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home.dart'; // Importa la pantalla de inicio normal
import 'home_admi.dart'; // Importa la pantalla de administración
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por Favor, Ingresa Todos los Campos.',
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
      Uri.parse('http://192.168.1.67/api/login.php'), //API
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    final data = jsonDecode(response.body);
    //print(data);

    if (data['success']) {
      String username = data['username'] ?? 'Usuario';
      String email = data['email'] ?? 'Email';
      String rol = data['rol'] ?? 'Rol';
      String roluser = data['rol_user'] ?? 'Rol Usuario';

      // Validar el rol del usuario
      if (roluser == "Encargados de Área" ||
          roluser == "Administrativo" ||
          rol == "Encargado de Área") {
        // Redirigir a la pantalla de administración
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeAdmiPage(
              username: username,
              email: email,
              rol: rol,
              roluser: roluser,
            ),
          ),
        );
      } else {
        // Redirigir a la pantalla de inicio normal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              username: username,
              email: email,
              rol: rol,
              roluser: roluser,
            ),
          ),
        );
      }
    } else {
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
          duration: Duration(seconds: 2), // Duración del mensaje
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            color: Colors.white,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15.0), // Ajusta el radio del borde aquí
                    child: Image.asset(
                      'assets/img/Logo.jpg',
                      height: 85, // Ajusta el tamaño según sea necesario
                      width: 310, // Si deseas un ancho específico
                      fit: BoxFit
                          .cover, // Para asegurar que la imagen se ajuste correctamente
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo',
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
                  ),
                  SizedBox(height: 20.0),
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: _obscureText,
                    cursorColor: Colors.black,
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 45.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 17.0),
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'Registrarme',
                      style: TextStyle(fontSize: 17.0, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
