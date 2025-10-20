import 'package:empleados_app/aviso_privacidad_page.dart';
import 'package:empleados_app/codigo_etica_page.dart';
import 'package:empleados_app/comunicados_admi_page.dart';
import 'package:empleados_app/confidencial_admi_page.dart';
import 'package:empleados_app/ver_solicitud_admi_page.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class HomeAdmiPage extends StatefulWidget {
  final String username;
  final String email;
  final String rol;
  final String roluser;
  final String userId;

  const HomeAdmiPage(
      {super.key,
      required this.username,
      required this.email,
      required this.rol,
      required this.roluser,
      required this.userId});

  @override
  _HomeAdmiState createState() => _HomeAdmiState();
}

class _HomeAdmiState extends State<HomeAdmiPage> {
  int _selectedIndex = 0;

  //LISTA DE PÁGINAS DEL HOMEADMI
  final List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();

    //INICIALIZAMOS LAS PÁGINAS
    _widgetOptions.addAll([
      ComunicadosAdmiPage(username: widget.username, userId: widget.userId),
      AdminVacacionesPage(),
      ConfidencialAdminPage(),
      AvisoPrivacidadPage(),
      CodigoEticaPage(),
    ]);
  }

  //CAMBIAR LA PÁGINA SELECCIONADA
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //DIALOG DE CERRAR SESIÓN
  void _logout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 25),
                Text(
                  "Cerrando Sesión...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Cerrar el diálogo
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    });
  }

  // Método para construir los ítems de la barra de navegación
  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        _onItemTapped(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index ? Colors.blue[800] : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 19,
              color: _selectedIndex == index ? Colors.white : Colors.black,
            ),
            SizedBox(height: 2.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: _selectedIndex == index ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido(a): ${widget.username}',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Acción para notificaciones
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              accountName: Text(
                widget.username,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              accountEmail: Text(widget.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  widget.username[0].toUpperCase(),
                  style: TextStyle(fontSize: 34, color: Colors.blueGrey),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.announcement_outlined, color: Colors.orange),
              title: Text(
                'Comunicados',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(0); // Índice 0
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.beach_access_outlined, color: Colors.lightGreen),
              title: Text(
                'Solicitudes de Vacaciones',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(1); // Índice 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.record_voice_over, color: Colors.blueGrey[900]),
              title: Text(
                'Acércate',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(2); // Índice 2
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: Colors.deepOrange),
              title: Text(
                'Aviso de Privacidad',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(3); // Índice 3
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.handshake, color: Colors.indigo[900]),
              title: Text(
                'Código de Ética',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(4); // Índice 4
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.grey.shade300,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 18),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 65,
        color: Colors.lightBlue,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.announcement, 'Comunicados', 0),
              _buildNavItem(Icons.beach_access, 'Solicitudes de Vacaciones', 1),
              _buildNavItem(Icons.record_voice_over, 'Acércate', 2),
              _buildNavItem(Icons.security, 'Aviso de Privacidad', 3),
              _buildNavItem(Icons.handshake, 'Código de Ética', 4),
            ],
          ),
        ),
      ),
    );
  }
}
