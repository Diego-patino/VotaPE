import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/pages/login.dart';

class drawer_nologin extends StatefulWidget {
  const drawer_nologin({Key? key}) : super(key: key);

  @override
  State<drawer_nologin> createState() => _drawer_nologinState();
}

class _drawer_nologinState extends State<drawer_nologin> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Parece que aun no estas logeado, puedes hacerlo presionando aqui", 
            textAlign: TextAlign.center,
            style: GoogleFonts.balooPaaji2(
              textStyle:TextStyle(
                color: Colors.black, fontSize: 25))),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                builder: (context) =>
                Login()));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange
              ),
              child: Text("Logeate"))
          ],
        ),
      ),
    );
  }
}