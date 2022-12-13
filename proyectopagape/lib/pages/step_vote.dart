import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';


void main() {
  runApp(step_vote());
}

class step_vote extends StatefulWidget {
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<step_vote> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 5.

  int upperBound = 4; // upperBound MUST BE total number of icons minus 1.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Pasitos para votar", style: GoogleFonts.balooPaaji2(textStyle:TextStyle(color: Colors.black, fontSize: 25))),
        leading: IconButton(
        onPressed: (){
             Navigator.of(context).pop();
          },
        icon: Icon(Icons.arrow_back_sharp, color: Colors.orange.shade900, size: 30,)),
      ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              IconStepper(
                stepColor: Colors.white,
                activeStepColor: Colors.orange,
                stepReachedAnimationEffect: Curves.easeOut,
                steppingEnabled: true,
                icons: [
                  Icon(Icons.account_circle_rounded),
                  Icon(Icons.event_available),
                  Icon(Icons.person_search),
                  Icon(Icons.check_circle_outline),
                ],

                // activeStep property set to activeStep variable defined above.
                activeStep: activeStep,

                // This ensures step-tapping updates the activeStep. 
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              SizedBox(height: 100),
              Expanded(
                child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child:  Text(stepperText(),
                    textAlign: TextAlign.center,
                    
                    style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 20), ) ),
                  ),
                    Image.network("${stepperfoto()}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  String stepperText() {
    switch (activeStep) {
      case 1:
        return 'Selecciona las elecciones a la que desees realizar tu voto';
      case 2:
        return 'Busca un candidato que mas te agrade, ¡Puedes revisar su informacion como promesas de campaña!';
      case 3:
        return 'Confirmas tu voto ingresando tu huella dactilar y Listo';
      default:
        return 'Primero registrate abriendo el menú que se encuentra en la parte superior izquierda de la pantalla';
    }
  }

  String stepperfoto() {
    switch (activeStep) {
      case 1:
        return "https://static.vecteezy.com/system/resources/previews/010/161/449/original/3d-render-hand-holding-mobile-phone-illustration-png.png";
      case 2:
        return "https://cdni.iconscout.com/illustration/premium/thumb/politician-doing-discussion-5991971-4972945.png";
      case 3:
        return "https://www.pngkey.com/png/full/987-9877148_garfield-line-messaging-sticker-cartoon-garfield-thumbs-up.png";
      default:
        return "https://img.freepik.com/premium-vector/online-registration-sign-up-login-account-smartphone-app-user-interface-with-secure-password-mobile-application-ui-web-banner-access-cartoon-people-vector-illustration_2175-1060.jpg?w=2000";
    }
  }
}