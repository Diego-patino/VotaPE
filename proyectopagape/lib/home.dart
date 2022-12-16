import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/models/users.dart';
import 'package:pagapetodo/pages/candidatos.dart';
import 'package:pagapetodo/pages/step_vote.dart';
import 'package:pagapetodo/widgets/drawer.dart';
import 'package:pagapetodo/widgets/drawer_nologueado.dart';
import 'package:pagapetodo/widgets/user_info.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  UserModel Usuario_logeado = UserModel();
  
  Trace customTrace = FirebasePerformance.instance.newTrace('elecciones_call');
  @override
  void initState() {
  customTrace.start();
    super.initState();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(user.uid)
          .get()
          .then((value) {
        this.Usuario_logeado = UserModel.fromMap(value.data());
        setState(() {});
      });
    } else {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: FirebaseAuth.instance.currentUser?.uid != null
          ? home_drawer(
              correo: Usuario_logeado.correo ?? "",
              nombre: Usuario_logeado.nombre ?? "",
              foto: Usuario_logeado.foto ?? "",
              apellido: Usuario_logeado.apellido ?? "",
              direccion: Usuario_logeado.direccion ?? "",
            )
          : drawer_nologin(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[

            userinfo(
                foto: Usuario_logeado.foto ?? "",
                nombre: Usuario_logeado.nombre ?? ""),
            Stack(children: <Widget>[
              imagenfondo(context),
              imagen(context),
              subtitulo(context),
              parrafo(context),
              boton(context),
              imagenchild(context),
            ],
            
            ),
            SizedBox(height: 20),
            Container(
              child: Text("Eventos mas Recientes"),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Elecciones")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    customTrace.incrementMetric("vista_de_elecciones_exitosas", 1);
                    customTrace.stop();
                    return Container(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];

                              final docID = documentSnapshot.id;
                              final fecha = documentSnapshot["Fecha"];
                              final nombre = documentSnapshot["nombre"];
                              final foto = documentSnapshot["foto"];
                              

                              //print(type);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 120,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 4,
                                      ),
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => candidatos(
                                                      correoUser: Usuario_logeado.correo ?? "",
                                                      apellidoUser: Usuario_logeado.apellido ?? "",
                                                      nombreUser: Usuario_logeado.nombre ?? "",
                                                      documentId: docID,
                                                      nombre: nombre,
                                                    ))),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 124.0,
                                              margin:
                                                  const EdgeInsets.only(left: 46),
                                              constraints:
                                                  const BoxConstraints.expand(),
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 235, 134, 20),
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10.0,
                                                      offset: Offset(0.0, 10.0),
                                                    )
                                                  ]),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    76.0, 16.0, 16.0, 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      "$nombre",
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                    ),
                                                    Text(
                                                      "$fecha",
                                                      style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w400),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              alignment:
                                                  FractionalOffset.centerLeft,
                                              child: Container(
                                                height: 92,
                                                width: 92,
                                                child: CircleAvatar(
                                                    radius: 90,
                                                    backgroundImage: NetworkImage(
                                                      "$foto",
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }));
                  } else {
                    return const Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//widgets apartes para el stack

Widget imagenfondo(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 3.0,
    width: MediaQuery.of(context).size.width / 1,
  );
}

Widget imagen(BuildContext context) {
  return Positioned(
    top: MediaQuery.of(context).size.height / 300.8,
    child: Image.asset(
      "assets/fondo.jpeg",
      width: 400,
    ),
  );
}

Widget subtitulo(BuildContext context) {
  return Positioned(
      top: MediaQuery.of(context).size.height / 50.8,
      left: MediaQuery.of(context).size.height / 85.5,
      child: Container(
          width: 140,
          child: Column(
            children: [
              Text(
                "Realiza tu voto sin salir de casa",
                textAlign: TextAlign.center,
                style: GoogleFonts.bungee(
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 136, 0),
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
                // style: TextStyle(
                //   color: Color.fromARGB(255, 255, 145, 0),
                //   fontWeight: FontWeight.w900,
                //   fontSize: 25,
                // ),
              ),
            ],
          )));
}

Widget parrafo(BuildContext context) {
  return Positioned(
    top: MediaQuery.of(context).size.height / 5.7,
    left: MediaQuery.of(context).size.height / 150.0,
    child: Container(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Text(
          "Si aun tienes dudas porfavor mira nuestra guia que tenemos preparado para ti",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}

Widget boton(BuildContext context) {
  return Positioned(
      top: MediaQuery.of(context).size.height / 4.2,
      left: MediaQuery.of(context).size.height / 150.0,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.grey,
        color: Color.fromARGB(255, 255, 145, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: const <Widget>[
              Text(
                "¿Como votar?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              Text("Aprende en 5 sencillos pasos",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ],
          ),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => step_vote()),
          );
        },
      ));
}

Widget imagenchild(BuildContext context) {
  return Positioned(
      top: MediaQuery.of(context).size.height / 4.9,
      left: MediaQuery.of(context).size.height / 2.7,
      child: Container(
        width: 100,
        height: 90,
        child: Image.asset('assets/niño.png'),
      ));
}






/*   return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                          
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Expanded(
                              child: Text(documentSnapshot["StudentName"])),
                          Expanded(
                              child: Text(documentSnapshot["StudentID"])),
                          Expanded(
                              child:
                                  Text(documentSnapshot["StudentNotas"])),
                          Expanded(
                              child: Text(
                                  documentSnapshot["StudentProgramID"])),
                        ],
                      );
                    },
                    itemCount: snapshot.data!.docs.length); */
