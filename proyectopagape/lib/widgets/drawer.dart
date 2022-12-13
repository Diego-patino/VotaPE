import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/home.dart';
import '../pages/perfil.dart';

class home_drawer extends StatefulWidget {

  final String correo;
  final String nombre;
  final String foto;
  final String apellido;
  final String direccion;
  
  home_drawer({
    required this.correo,
    required this.nombre,
    required this.foto,
    required this.apellido,
    required this.direccion,
  });

  @override
  State<home_drawer> createState() => _home_drawerState();
}

class _home_drawerState extends State<home_drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              accountName: Text(widget.nombre),
              accountEmail: Text(widget.correo),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 247, 107, 0),
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width*0.4,
                    alignment: Alignment.topRight,
                    
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.foto),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                    
                  ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Mi perfil'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Perfil(
                    apellido: widget.apellido,
                    correo: widget.correo,
                    nombre: widget.nombre,
                    direccion: widget.direccion,
                  ),));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title: Text('Cerrar sesion'),
              onTap: () {

                _Alertdialogconfirm(context);
              },
            )
          ],
        ),
      );
  }

Future _Alertdialogconfirm(BuildContext context) async{
        
      final alertDialog = showDialog(
            context: context,
            builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(),
            title: Text("Confirmar", 
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),),
            content: Text("Deseas cerrar tu sesion?", 
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  fontSize: 15,
                )),),
            actions: <Widget>[
              Wrap(
                spacing: 70,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                    ),
                    onPressed:  (){
                    Navigator.of(context, rootNavigator: true).pop();
                      signOut(context);
                      },
                    child: Text(
                      'Si',
                      style: GoogleFonts.poppins(textStyle: TextStyle(
                        color: Colors.white
                      ),) 
                    )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: ()=>
                    Navigator.of(context, rootNavigator: true).pop(),
                    child: Text(
                      'No', 
                      style: GoogleFonts.poppins(textStyle:TextStyle(
                        color: Colors.white,
                      ), ) 
                    )
                  ),
              ],
            )
          ],
        ));
    }

    Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => home()));
  }
}
