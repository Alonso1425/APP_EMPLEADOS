import 'package:empleados_app/ver_solicitud_admi_page.dart';
import 'package:flutter/material.dart';
import 'comunicados_page.dart';
import 'ver_solicitud_admi_page.dart'; // Nueva pantalla para ver y gestionar solicitudes
import 'confidencial_page.dart';
import 'login.dart';

class HomeAdmiPage extends StatefulWidget {
  final String username;
  final String email;
  final String rol;
  final String roluser;

  const HomeAdmiPage({
    super.key,
    required this.username,
    required this.email,
    required this.rol,
    required this.roluser,
  });

  @override
  _HomeAdmiPageState createState() => _HomeAdmiPageState();
}

class _HomeAdmiPageState extends State<HomeAdmiPage> {
  int _selectedIndex = 0;

  // Lista de páginas
  final List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    // Inicializar las páginas según el rol
    _widgetOptions.addAll([
      ComunicadosPage(), // Índice 0
      VerSolicitudesVacacionesPage(), // Índice 1 (Nueva pantalla para gestionar solicitudes)
      ConfidencialPage(), // Índice 2
    ]);
  }

  // Cambiar la página seleccionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Cerrar sesión
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
              leading:
                  Icon(Icons.announcement_outlined, color: Colors.blueGrey),
              title: Text(
                'Comunicados Importantes',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(0); // Índice 0
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_outlined, color: Colors.blueGrey),
              title: Text(
                'Ver Solicitudes de Vacaciones',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(1); // Índice 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: Colors.blueGrey),
              title: Text(
                'Confidencialidad',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(2); // Índice 2
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Comunicados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Solicitudes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_gmailerrorred),
            label: 'Confidencial',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        backgroundColor: Colors.lightBlue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
