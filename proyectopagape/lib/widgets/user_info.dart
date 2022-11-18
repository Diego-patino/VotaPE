import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/models/dni.dart';
import 'package:pagapetodo/models/users.dart';
import 'package:pagapetodo/widgets/drawer.dart';

class userinfo extends StatefulWidget {

  final String foto;
  final String nombre;
  
  userinfo({
    required this.foto,
    required this.nombre,
  });
  @override
  State<userinfo> createState() => _userinfoState();
}

class _userinfoState extends State<userinfo> {

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser?.uid != null ?

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
 
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.5,
                                         
                      child: Text("Bienvenido",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSans(                                            
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20, 
                              ) ,)
                        ),
                    ),

                    Container(
                    padding: EdgeInsets.all(15),
                     height: MediaQuery.of(context).size.height*0.15,
                      width: MediaQuery.of(context).size.width*0.55,
                       
                        child: Text(widget.nombre,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(                                            
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30, 
                              ) ,)
                        ),           
                     
                    )
                  ],
                ),
              ),
            
              Column(
                children: [
                  Container(
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
                ],
              ),

              SizedBox(height: 20,),

            ],
            ): Container();
  }
}