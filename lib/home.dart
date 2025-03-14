import 'package:empleados_app/aviso_privacidad_page.dart';
import 'package:empleados_app/codigo_etica_page.dart';
import 'package:empleados_app/solicitud_emergencia_page.dart';
import 'package:flutter/material.dart';
import 'comunicados_page.dart';
import 'solicitud_vacaciones_page.dart';
import 'ver_solicitud_page.dart';
import 'confidencial_page.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String email;
  final String rol;
  final String roluser;

  const HomePage({
    super.key,
    required this.username,
    required this.email,
    required this.rol,
    required this.roluser,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista de páginas
  final List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    // Inicializar las páginas
    _widgetOptions.addAll([
      ComunicadosPage(), // Índice 0
      SolicitudVacacionesPage(
        username: widget.username,
        rol: widget.rol,
        roluser: widget.roluser,
      ), // Índice 1
      SolicitudEmergenciaPage(
        username: widget.username,
        rol: widget.rol,
        roluser: widget.roluser,
      ), // Índice 2
      VerSolicitudPage(), // Índice 3
      ConfidencialPage(), // Índice 4
      AvisoPrivacidadPage(), // Índice 5
      CodigoEticaPage(), // Índice 6
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
                color: Colors.blueGrey[800],
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
                'Comunicados Importantes',
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
                'Solicitud de Vacaciones',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(1); // Índice 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.emergency, color: Colors.red),
              title: Text(
                'Solicitud de Vacaciones de Emergencia',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(2); // Índice 2
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt_outlined, color: Colors.blueAccent),
              title: Text(
                'Estatus / Historial de Solicitud de Vacaciones',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _onItemTapped(3); // Índice 3
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
                _onItemTapped(4); // Índice 4
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
                _onItemTapped(5); // Índice 5
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
                _onItemTapped(6); // Índice 6
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
              _buildNavItem(Icons.beach_access, 'Vacaciones', 1),
              _buildNavItem(Icons.emergency, 'Emergencia', 2),
              _buildNavItem(Icons.list_alt, 'Ver Solicitud', 3),
              _buildNavItem(Icons.record_voice_over, 'Acércate', 4),
              _buildNavItem(Icons.security, 'Aviso de Privacidad', 5),
              _buildNavItem(Icons.handshake, 'Código de Ética', 6),
            ],
          ),
        ),
      ),
    );
  }
}
