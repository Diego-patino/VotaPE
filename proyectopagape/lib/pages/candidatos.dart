import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/pages/Register.dart';
import 'package:pagapetodo/pages/candidato_details.dart';
import 'package:pagapetodo/pages/perfil.dart';

class candidatos extends StatefulWidget {
  final String documentId;
  final String nombre;
  final String nombreUser;
  final String correoUser;
  final String apellidoUser;

  candidatos({
    required this.documentId,
    required this.nombre,
    required this.nombreUser,
    required this.correoUser,
    required this.apellidoUser,
  });

  @override
  State<candidatos> createState() => _candidatosState();
}

class _candidatosState extends State<candidatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_sharp,
              color: Colors.orange.shade900,
              size: 30,
            )),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.nombre,
              textAlign: TextAlign.center,
              style: GoogleFonts.hammersmithOne(
                  textStyle: TextStyle(
                fontSize: 40,
              )),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Elecciones")
                  .doc(widget.documentId)
                  .collection("Candidatos")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshot.data!.docs[index];

                            final docID = documentSnapshot.id;
                            final nombre = documentSnapshot["nombre"];
                            final partido = documentSnapshot["partido"];
                            final foto = documentSnapshot["foto"];
                            final informacion = documentSnapshot["informacion"];
                            final promesa = documentSnapshot["promesa"];

                            //print(type);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    height: 90,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 20,
                                    ),
                                    child: InkWell(
                                      child: Stack(
                                        children: [
                                          Container(
                                            constraints:
                                                const BoxConstraints.expand(),
                                            decoration: BoxDecoration(
                                                color:
                                                    Color.fromARGB(55, 0, 0, 0),
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                    ),
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  76.0, 16.0, 16.0, 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "$nombre",
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 17.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Text(
                                                    partido,
                                                    style: GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400)),
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
                                              height: 62,
                                              width: 72,
                                              child: CircleAvatar(
                                                  radius: 90,
                                                  backgroundImage: NetworkImage(
                                                    "$foto",
                                                  )),
                                            ),
                                          ),
                                          Positioned(
                                            top: 18,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                60.0,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CandidatoDetail(
                                                              nombreVotacion: widget.nombre,
                                                          idEleccion: widget.documentId,
                                                          documentId: docID,
                                                          foto: foto,
                                                          informacion:
                                                              informacion,
                                                          nombre: nombre,
                                                          partido: partido,
                                                          promesa: promesa,
                                                          correoUser: widget.correoUser,
                                                          nombreUser: widget.nombreUser,
                                                          apellidoUser: widget.apellidoUser,
                                                        ),
                                                      ));
                                                },
                                                style: TextButton.styleFrom(
                                                    primary: Color.fromARGB(
                                                        232, 255, 248, 243),
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 240, 119, 7)),
                                                child: Text("Ver")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }));

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
    );
  }
}
