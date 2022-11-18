import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/api/local_auth_api.dart';
import 'package:pagapetodo/models/eleccion.dart';

import '../home.dart';
import '../widgets/toast.dart';



class CandidatoDetail extends StatefulWidget{

  final String documentId;
  final String foto;
  final String informacion;
  final String nombre;
  final String partido;
  final String promesa;
  final String idEleccion;
  
    CandidatoDetail({
      required this.idEleccion,
      required this.documentId,
      required this.foto,
      required this.informacion,
      required this.nombre,
      required this.partido,
      required this.promesa,
    });


  @override
  State<CandidatoDetail> createState() => _CandidatoDetailState();
}

class _CandidatoDetailState extends State<CandidatoDetail> {

  //* Aqui establezco que la página empieza de 0 
  int currentPage = 0;
  EleccionModel eleccion = EleccionModel();
  final User? user = FirebaseAuth.instance.currentUser;
  Set<String> votosRealizados = {};

  @override
  void initState() {
    
    FirebaseFirestore.instance
            .collection("Elecciones")
            .doc(widget.idEleccion)
            .get()
            .then((value) {
          this.eleccion = EleccionModel.fromMap(value.data());
          setState(() {
            
          });});
    super.initState();
  }

  Future crearVotoRealizado() async {

    if (votosRealizados.contains(widget.idEleccion)) {
      votoError();
    } else{
      DocumentReference documentReference =
        FirebaseFirestore.instance
        .collection("Usuarios")
        .doc(user!.uid)
        .collection("Votos Realizados")
        .doc(widget.idEleccion);

      documentReference
        .set({
          "Eleccion": eleccion.nombre,
          "VotoCandidato": widget.nombre,
          "VotoPartido": widget.partido,
          "Hora": DateTime.now(),
        })
        
        .then((value) => votoRealizado())
        .catchError((error) => print("Voto fallo : $error"));

        Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => home(),
            ),
            (route) => false,//if you want to disable back feature set to false

        );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.nombre, style: GoogleFonts.balooPaaji2(textStyle:TextStyle(color: Colors.black, fontSize: 25))),
        leading: IconButton(
        onPressed: (){
             Navigator.of(context).pop();
          },
        icon: Icon(Icons.arrow_back_sharp, color: Colors.orange.shade900, size: 30,)),
      ), 
      body: Column(
        
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: 
        
        [         
          Container(
            padding: EdgeInsets.all(5),
            height: 180,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 170,
                  decoration: BoxDecoration(
                    image:DecorationImage(
                      image: NetworkImage('${widget.foto}'),
                      fit: BoxFit.cover,
                    ),
                    shape: BoxShape.circle,                   
                     ),
                ),                
              ],
              ),
          ),

          Container(
                
                child: Column(
                  children: [
                    Text('INFORMACIÓN DEL CANDIDATO',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                   ),
                ),
              ],
            )
          ),

          Container(
            padding: EdgeInsets.all(10),
            child: Column(              
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 216, 223),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10)
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Text(widget.informacion)))                 ,
                  width: 280,
                  height: 150,                  
                )
              ],
            ),
          ),

          Container(                
                child: Column(
                  children: [
                    Text('Propuesta',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                   ),
                ),
              ],
            )
          ),

          Container(
            padding: EdgeInsets.all(10),
            child: Column(              
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 210, 216, 223),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10)
                    ),
                  ),
                   child: Container(
                   padding: EdgeInsets.all(25),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Text(widget.promesa))),                   
                  width: 280,
                  height: 100,                  
                )
              ],
            ),
          ),
        
         user != null? Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(32),            
            child: ElevatedButton(             
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
        
                ),
                primary: Color.fromARGB(255, 255, 153, 0),
              ),
              child: Text('Realizar voto'),              
              onPressed: (){
                if (user != null) {
                  _onButtonPressed();
                } else{
                  logearseerror();
                }

              },
            ),
          ),
        ):Container(),
         user != null? 
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Usuarios")
                .doc(user!.uid)
                .collection("Votos Realizados")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                      final docID = documentSnapshot.id;
                      votosRealizados.add(docID);
                      print(votosRealizados);

                        //print(type);
                      return Container();
                    }
                  ) 
                );
              } else {
                return const Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(),
                );
              }
            },
          ): Container(),

        ],

        ),
            
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              //primer recuadro de la "seleccion" (start)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 20, bottom: 10,),
                    child: Text('Confirmar seleccion'),
                  ),
                  IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.cancel, color: Colors.orange,))
                ],
              ),

             const Divider(color: Colors.black26, thickness: 1, indent: 10, endIndent: 10),

              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Elecciones: '),
                  )
                ],
              ),

              //aqui es un contenedor q conllevaa la imagen y letra de las elecciones (start)
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                            eleccion.foto??"",
                          ) 
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Text("${eleccion.nombre}"),
                        Text("${eleccion.fecha}",
                            style: TextStyle(color: Colors.grey))
                      ],
                    )
                  ],
                ),
              ),

              const Divider(color: Colors.black26, thickness: 1, indent: 10, endIndent: 10),

              //aqui es un contenedor q conllevaa la imagen y letra de las elecciones (start)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text('Candidato: '),
                  )
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 224, 224, 224),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 80,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                            widget.foto
                          ) 
                      )
                    ),
                    SizedBox(width: 10),
                    Column(
                      children:[
                        Text(
                          widget.nombre,
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          '     Partido ${widget.partido}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 126, 126, 126)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey))),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                padding: EdgeInsets.symmetric(vertical: 6),
                height: 50,
                child: Column(
                  children: const <Widget>[
                    Text( 
                        textAlign: TextAlign.center,
                        'Luego de presionar el boton “Confirmar eleccion con 1 toque” se necesitara verificar su identidad con su huella digital, despues de ello la informacion ingresada ya no podra cambiarse ni borrarse',
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),

              ///aqui se encontraria el botom (start)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        disabledColor: Colors.grey,
                        color: Colors.orange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          child: const Text(
                            "Confirmar eleccion con 1 toque",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () async{

                          try {
                            final isAuthenticated = await LocalAuthApi.authenticate();

                            if (isAuthenticated) {
                              crearVotoRealizado();
                            }
                          } catch (e) {
                            authError();
                          }
                        },
                      )
                  ],
                ),
              )

              ///aqui se encontraria el botom (start)
            ],
          );
        });
        
  }



}