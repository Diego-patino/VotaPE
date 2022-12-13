import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/home.dart';
import 'package:pagapetodo/pages/candidatos.dart';
import 'package:pagapetodo/models/users.dart';
import 'package:pagapetodo/widgets/validator.dart';

import '../models/dni.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {

  @override
  void dispose() {
    animationcontroller;
    animationcontroller2;
    animationcontroller3;
    super.dispose();
  }

  DateTime? fechaEmision;
  Future _fechaEmisionconfirm(BuildContext context) async{
      final initialDate = DateTime.now().toLocal();
      final newdate = await showDatePicker(
         builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, 
              ),
            ),
          ),
          child: child!,
        );
      },
        context: context, 
        initialDate: fechaEmision?? initialDate, 
        firstDate: DateTime(DateTime.now().year-20), 
        lastDate: DateTime(DateTime.now().year+20));
      if (newdate == null) return ;
      setState(() {
        fechaEmision = newdate;
      });
    }

     String getFechaEmisionText() {
    if (fechaEmision==null) {
      return 'Seleccionar la fecha';
    } else {
      return '${fechaEmision!.day}/${fechaEmision!.month}/${fechaEmision!.year}';
    }
  }

  DateTime? fechaVencimiento;
  Future _fechaVencimientoConfirm(BuildContext context) async{
      final initialDate = DateTime.now().toLocal();
      final newdate = await showDatePicker(
         builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, 
              onPrimary: Colors.white, 
              onSurface: Colors.black, 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, 
              ),
            ),
          ),
          child: child!,
        );
      },
        context: context, 
        initialDate: fechaVencimiento?? initialDate, 
        firstDate: DateTime(DateTime.now().year-20), 
        lastDate: DateTime(DateTime.now().year+20));
      if (newdate == null) return ;
      setState(() {
        fechaVencimiento = newdate;
      });
    }

     String getFechaVencimientoText() {
    if (fechaVencimiento==null) {
      return 'Seleccionar la fecha';
    } else {
      return '${fechaVencimiento!.day}/${fechaVencimiento!.month}/${fechaVencimiento!.year}';
    }
  }
  
  Future confirmarDNI() async{
    if (dniPersonas.contains(_dnicontroller.text.trim())) {
        
      print(_dnicontroller.text.trim());
        FirebaseFirestore.instance
            .collection("Ciudadanos")
            .doc(_dnicontroller.text.trim())
            .get()
            .then((value) { print("${dniModel.dni} adasda");
          this.dniModel = DniModel.fromMap(value.data());
          setState(() {});
          if (dniModel.fecha_V == getFechaVencimientoText() && dniModel.fecha_E == getFechaEmisionText()) {

            if (dniModel.usuario== false) {
              signUp(_emailcontroller.text, _passwordcontroller.text,);
            } else {
              final text = 'El DNI ingresado ya esta en uso';
              final snackBar = SnackBar(content: Text(text));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          } else {
              final text = 'Datos ingresados incorrectos';
              final snackBar = SnackBar(content: Text(text));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(dniModel.fecha_E);
              print("object");
              print(dniModel.fecha_V);
            
          }
        });
    } else {
      final text = 'DNI no encontrado';
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
    }

  }

  Future signUp(String email, String password) async{
    setState(()=> cargando = true);
    if (_formKey.currentState!.validate()) {
      if (passwordConfirmed()) {
        
        try {
          
          //crea el usuario
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailcontroller.text.trim(),
            password: _passwordcontroller.text.trim(),

            );
            //agrega el usuario

              postDetailsToFirestore();

              MensajError1 ='';

            /* addUserDetails(
              nombre:_nombrecontroller.text.trim(),
              apellido: _apellidocontroller.text.trim(),
              correo: _emailcontroller.text.trim()); */
          } on FirebaseAuthException catch (error) {
            MensajError1 = error.message!;
            
            print(error);

              if (MensajError1 == 'Given String is empty or null') {
              final text = 'Porfavor ingrese los datos faltantes en los recuadros';
              final snackBar = SnackBar(content: Text(text));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } if (MensajError1 == 'The email address is already in use by another account.') {
              final text = 'El correo ingresado ya esta en uso';
              final snackBar = SnackBar(content: Text(text));
              
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
              final snackBar = SnackBar(content: Text(error.message!));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
          
          }
    } else {
        final text = 'Las contraseñas no coinciden';
        final snackBar = SnackBar(content: Text(text));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    
    setState(()=> cargando = false);
    }
       
  }

  Future postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.correo = user!.email;
    userModel.uid = user.uid;
    userModel.nombre = dniModel.nombre;
    userModel.apellido = dniModel.apellido;
    userModel.dni = _dnicontroller.text;
    userModel.foto = 'https://cdn-icons-png.flaticon.com/512/4647/4647291.png';
    userModel.direccion = dniModel.direccion;

    await firebaseFirestore
        .collection("Usuarios")
        .doc(user.uid)
        .set(userModel.toMap());

    dniModel.usuario = true;
    await firebaseFirestore
        .collection("Ciudadanos")
        .doc(dniModel.dni)
        .set(dniModel.toMap());

   /* Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false); */
       Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => home(),
        ),
        (route) => false,//if you want to disable back feature set to false

    );
        
  }

 /* Future<String?> addUserDetails({ required String nombre, required String apellido, required String correo}) async{
    await FirebaseFirestore.instance.collection('UsuariosApp').add({
      'nombre' : nombre,
      'apellido': apellido,
      'correo': correo,
    });
  } */

  bool passwordConfirmed(){
    if (_passwordcontroller.text.trim() == _confirmpasswordcontroller.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

    final _formKey = GlobalKey<FormState>();
    String dropdownvalue = "";
    Set<String> dniPersonas = {};
    DniModel dniModel = DniModel();
    bool _isVisible = false;
    bool _isPasswordEightCharacters = false;
    bool _hasPasswordOneNumber = false;
    bool cargando = false;
    final TextEditingController _emailcontroller = TextEditingController();
    final TextEditingController _passwordcontroller = TextEditingController();
    final TextEditingController _confirmpasswordcontroller = TextEditingController();
    final TextEditingController _dnicontroller = TextEditingController();
    final TextEditingController _dniFV = TextEditingController();
    final TextEditingController _dniFE = TextEditingController();
    String MensajError1 = '';

    
    onPasswordChanged(String password) {
        final numericRegex = RegExp(r'[0-9]');
        setState(() {
          _isPasswordEightCharacters = false;
          if(password.length >= 6)
              _isPasswordEightCharacters = true;

              _hasPasswordOneNumber = false;
              if(numericRegex.hasMatch(password))
              _hasPasswordOneNumber = true;
        });
    }
    final labelstyle1 = TextStyle(color: Colors.black45, fontSize: 18);
    final outlineInputBorder_enabled = OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12, width: 2.5),
                          borderRadius: BorderRadius.circular(10));
    final OutlineInputBorder_focused = OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange, width: 2.5),
                          borderRadius: BorderRadius.circular(10),);
    late AnimationController animationcontroller;
    late AnimationController animationcontroller2;
    late AnimationController animationcontroller3;
    bool get isForwardAnimation => 
      animationcontroller.status == AnimationStatus.forward ||
      animationcontroller.status == AnimationStatus.completed;
    bool get isForwardAnimation2 => 
      animationcontroller2.status == AnimationStatus.forward ||
      animationcontroller2.status == AnimationStatus.completed;
    bool get isForwardAnimation3 => 
      animationcontroller3.status == AnimationStatus.forward ||
      animationcontroller3.status == AnimationStatus.completed;

   @override
    void initState() {
        super.initState();
        animationcontroller = AnimationController(
          value: 0,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 200),
          vsync: this,)..addStatusListener((status) {
            setState(() { });});
            
        animationcontroller2 = AnimationController(
          value: 0,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 200),
          vsync: this,)..addStatusListener((status) {
            setState(() { });});
            
        animationcontroller3 = AnimationController(
          value: 0,
          duration: Duration(milliseconds: 1000),
          reverseDuration: Duration(milliseconds: 200),
          vsync: this,)..addStatusListener((status) {
            setState(() { });});

      }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Registrate', style: GoogleFonts.balooPaaji2(textStyle:TextStyle(color: Colors.black, fontSize: 25))),
        leading: IconButton(
        onPressed: (){
             Navigator.of(context).pop();
          },
        icon: Icon(Icons.arrow_back_sharp, color: Colors.orange.shade900, size: 30,)),
      ), 
    
    body:
        SafeArea(
          child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                
                    SizedBox(height: 20,),

              Container(
                width: MediaQuery.of(context).size.width*0.9,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailcontroller,              
                      // Teclado tipo Correo
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(  
                       // filled: true,
                       // fillColor: Colors.grey,             
                        prefixIcon: Icon(Icons.email, color: Colors.amber[600],) ,  
                        focusedBorder: OutlineInputBorder_focused, 
                        enabledBorder: outlineInputBorder_enabled,                                                          
                        border: OutlineInputBorder(),
                        hintText: "Correo",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
                     
                    SizedBox(height: 30,),
                    TextFormField(
                      controller: _passwordcontroller,   
                      validator: validatecontra,           
                      onChanged: (password) => onPasswordChanged(password),
                      obscureText: !_isVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Colors.amber[600],),               
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible? Icon(Icons.visibility, color: Colors.orange,) : Icon(Icons.visibility_off , color: Colors.grey,),
                        ),
                        focusedBorder: OutlineInputBorder_focused, 
                          enabledBorder: outlineInputBorder_enabled,
                        border: OutlineInputBorder(),
                        hintText: "Contraseña",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
        
                    SizedBox(height: 30,),

                    TextFormField(
                      controller: _confirmpasswordcontroller,              
                      onChanged: (password) => onPasswordChanged(password),
                      obscureText: !_isVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Colors.amber[600],),               
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: _isVisible? Icon(Icons.visibility, color: Colors.orange,) : Icon(Icons.visibility_off , color: Colors.grey,),
                        ),
                        focusedBorder: OutlineInputBorder_focused, 
                        enabledBorder: outlineInputBorder_enabled,  
                        border: OutlineInputBorder(),
                        hintText: "Confirmar contraseña",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
                    SizedBox(height:30,),
        
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Ciudadanos")
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
                                  dniPersonas.add(docID);

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
                      ),

                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _isPasswordEightCharacters? Colors.green : Colors.transparent,
                            border: _isPasswordEightCharacters? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Icon(Icons.check, color: Colors.white, size: 15,),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("Debe contener al menos 6 carácteres")
                      ],
                    ),
        
                    SizedBox(height: 10,),
        
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: _hasPasswordOneNumber? Colors.green : Colors.transparent,
                            border: _isPasswordEightCharacters? Border.all(color: Colors.transparent) : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Icon(Icons.check, color: Colors.white, size: 15,),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text("Debe contener al menos 1 número")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

                    isForwardAnimation?Container():

                    Container(
                       
                      child: ElevatedButton(
                            onPressed:() {
                                animationcontroller.forward();                              
                              },
                            style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 65),
                            elevation: 2,
                            ),
                            child: const Text(
                              "Validar DNI",
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),
                    ),

                  const SizedBox(height: 45.0,),

                   AnimatedBuilder(
                    animation: animationcontroller,
                    builder: (context, child) => FadeScaleTransition(
                      animation: animationcontroller,
                      child: child,
                    ),
                     child: Visibility(
                      visible: animationcontroller.status != AnimationStatus.dismissed,
                       child: Column(
                         children: [
                           Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child:  Text('Escribe tu DNI',
                              textAlign: TextAlign.center,
                              
                              style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 20), ) ),
                            ),
                                      
                            const SizedBox(height: 10.0,),   
                    
                            Container(
                              
                              width: MediaQuery.of(context).size.width*0.9,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                  controller: _dnicontroller,
                                  decoration: InputDecoration(
                                    
                                   /* errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent, width: 3)),
                                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent, width: 3)),*/
                                    prefixIcon: Icon(Icons.numbers_outlined, color: Colors.black54,),
                                    enabledBorder: outlineInputBorder_enabled,
                                    focusedBorder: OutlineInputBorder_focused,
                                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                                    labelText: '',
                                    labelStyle: labelstyle1,
                            
                                  ),
                                  onChanged: (value){
                            
                                  },
                                ),
                            ),

                      SizedBox(height: 10,),

                       Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child:  Text('Coloca tu fecha de Emision',
                          textAlign: TextAlign.center,
                          
                          style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 20),) ),
                        ),
                
                      SizedBox(height: 10,),
                
                     ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange
                      ),
                      onPressed: (){
                        _fechaEmisionconfirm(context);
                      }, 
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Center(
                          child: Text(
                            getFechaEmisionText(),
                            style: TextStyle(fontSize: 15),)),
                      )),

                     SizedBox(height: 10,),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child:  Text('Coloca tu fecha de Vencimiento',
                          textAlign: TextAlign.center,
                          
                          style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 20),) ),
                        ),
                    
                            SizedBox(height: 10,),

                         ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange
                          ),
                          onPressed: (){
                            _fechaVencimientoConfirm(context);
                          }, 
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.8,
                            child: Center(
                              child: Text(
                                getFechaVencimientoText(),
                                style: TextStyle(fontSize: 15),)),
                          )), 


                          const SizedBox(height: 25.0,),

                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: cargando? null: () {
                                if (_formKey.currentState!.validate()) {
                                  confirmarDNI();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade500,
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              ),
                              child: cargando? Container(child:CircularProgressIndicator(color: Colors.lightGreen,) , height: 20, width: 20,) 
                              :const Text(
                                "Registrame!",
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),


                        ],
                      ),
                    ),
                  ),
  
              SizedBox(height: 20.0),
                    /* Padding(
                    padding:EdgeInsets.only(top: 20),
                    child: IconButton(
                      onPressed:() {
                        ChangeUserFoto();
                      },
                      icon: Icon(Icons.person_add, size: 20,),
                      iconSize: 30,
                    ), ),*/
                  
                            ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

