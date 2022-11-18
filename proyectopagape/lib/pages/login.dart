import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagapetodo/home.dart';
import 'package:pagapetodo/pages/Register.dart';
import 'package:pagapetodo/widgets/toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  bool cargando = false;
    
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  
  final outlineInputBorder_enabled = OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12, width: 2.5),
                        borderRadius: BorderRadius.circular(10));
  final OutlineInputBorder_focused = OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2.5),
                        borderRadius: BorderRadius.circular(10),);

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {

    @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  Future<String?> signIn2({ required String correo, required String contrasena}) async {
    setState(()=> cargando = true);
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: correo, password: contrasena)
            .then((uid) => {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => home())),
                });
      } on FirebaseAuthException catch (e){
        print(e);
        loginerror();
                        
                          
      }
      setState(()=> cargando = false);

}  
  

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Logeate', style: GoogleFonts.balooPaaji2(textStyle:TextStyle(color: Colors.black, fontSize: 25))),
        leading: IconButton(
        onPressed: (){
             Navigator.of(context).pop();
          },
        icon: Icon(Icons.arrow_back_sharp, color: Colors.orange.shade900, size: 30,)),
      ), 
      
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                      obscureText: !isVisible,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Colors.amber[600],),               
                        focusedBorder: OutlineInputBorder_focused, 
                          enabledBorder: outlineInputBorder_enabled,
                        border: OutlineInputBorder(),
                        hintText: "Contraseña",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      ),
                    ),
        
                SizedBox(height: 30,),

                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: ElevatedButton(
                    onPressed: (){
                      signIn2(correo: _emailcontroller.text.trim(), contrasena: _passwordcontroller.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange
                    ),
                    child: Text("Logeame!")),
                ),

                SizedBox(height: 30,),

                

                Wrap(
                    children: [
                      const Text("O registrate presionando ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),),
                      SizedBox(width: 2,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: ((context) => Register())));
                        },
                        child: const Text(
                          "aqui",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}