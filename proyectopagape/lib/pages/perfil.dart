import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Perfil extends StatefulWidget {

  final String correo;
  final String nombre;
  final String apellido;
  
  Perfil({
    required this.correo,
    required this.nombre,
    required this.apellido,
  });

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        leading: IconButton(
        onPressed: (){
             Navigator.of(context).pop();
          },
        icon: Icon(Icons.arrow_back_sharp, color: Colors.white, size: 30,)),
      ), 
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 150,
              padding: const EdgeInsets.only(bottom: 15),
              child: Container(
                color: Colors.orange,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: const Text(
                        'MI PERFIL',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Text(
                      widget.nombre,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.apellido,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child:  Text(
                    'DATOS DE CONTACTO',
                    style: GoogleFonts.montserrat(                                            
                      textStyle: TextStyle(
                          fontSize: 15, 
                          color: Color.fromARGB(255, 66, 58, 58)
                          ) ,)
                    
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Numero de telefono',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 23),
                  // ignore: sort_child_properties_last
                  child: const Text(
                    '922 445 251',
                    style: TextStyle(fontSize: 18),
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Correo electronico',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 23),
                  // ignore: sort_child_properties_last
                  child:  Text(
                    widget.correo,
                    style: TextStyle(fontSize: 18),
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Direccion',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 23),
                  // ignore: sort_child_properties_last
                  child: const Text(
                    'Av lujan patito sanchez 85',
                    style: TextStyle(fontSize: 18),
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
