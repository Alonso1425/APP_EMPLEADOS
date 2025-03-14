import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AvisoPrivacidadPage extends StatelessWidget {
  AvisoPrivacidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Aviso de Privacidad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ).animate().fadeIn(duration: 500.ms),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ScrollablePositionedList.builder(
          itemCount: _content.length,
          itemBuilder: (context, index) {
            return _content[index]
                .animate()
                .slideX(
                    begin: -1.0,
                    end: 0.0,
                    duration: 500.ms,
                    curve: Curves.easeOut)
                .fadeIn(duration: 500.ms);
          },
        ),
      ),
    );
  }

  final List<Widget> _content = [
    Text(
      'Aviso de Privacidad',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 16),
    Text(
      'NEXT IMPULSE S DE RL DE CV con domicilio en Paseo San Isidro, No. Interior 102 y No. Exterior 318, Santiaguito, Metepec Estado de México y C.P. 52140, conforme a lo establecido en la Ley Federal de Protección de Datos en Posesión de Particulares, pone a disposición de nuestros clientes, proveedores, empleados y público en general, nuestro Aviso de Privacidad.',
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16),
    Text(
      'Los datos personales que nos proporciona son utilizados estrictamente en la realización de funciones propias de nuestra empresa y por ningún motivo serán transferidos a terceros.',
      style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16),
    _buildSectionTitle(
        '1. A nuestros empleados solicitamos los siguientes datos personales:'),
    _buildSectionContent(
        ' I.	Nombre, teléfono, correo electrónico, domicilio, fecha y lugar de nacimiento.\n'),
    _buildSectionContent(
        'II.	Antecedentes laborales, puesto, sueldo y motivo de terminación laboral en los últimos cinco empleos.\n'),
    SizedBox(height: 16),
    _buildSectionSubtitle(
        'En caso de realizar modificaciones al presente Aviso de Privacidad, le informaremos mediante correo electrónico, nuestro sitio web oficial, medios impresos y nuestros operadores telefónicos.'),
  ];

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  static Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 15),
    );
  }

  static Widget _buildSectionSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    );
  }
}
