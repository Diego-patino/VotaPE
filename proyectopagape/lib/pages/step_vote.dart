import 'package:flutter/material.dart';


class step_vote extends StatefulWidget {
  const step_vote({super.key});

  @override
  State<step_vote> createState() => _step_voteState();
}

class _step_voteState extends State<step_vote> {
  int _currentStep = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stepper(
     //type: StepperType.horizontal,         
          steps:  [

              Step(
              title: Text('Primer Paso'), 
              content: Text('Ten tu DNI a la mano para la agilización del proceso'),
              ),
        
              Step(
              title: Text('Segundo Paso'), 
              content: Text('Registrate con nosotros, nuestro formulario solicitará información de tu DNI, si ya posees una cuenta, Inicia Sesión'),
              ),
        
              Step(
              title: Text('Tercer Paso'), 
              content: Text('Verifica la lista de las elecciones y corrobora la información de tu candidato elegido'),
              ),
        
              Step(
              title: Text('Cuarto Paso'), 
              content: Text('Presiona el botón de "Realizar tu voto" aparecerá una barra de navegación que peditrá tu confirmación de tu elección'),
              ),
        
              Step(
              title: Text('Quinto Paso'), 
              content: Text('Se te pedirá una verificación de tu huella dactilar y listo'),
              ),
        
          ],
        
          onStepTapped: (int newIndex){
            setState(() {
                _currentStep = newIndex;
            });
          },
        
          currentStep : _currentStep,
          onStepContinue: (){
            if (_currentStep !=4){
              setState(() {
                _currentStep +=1;
              });
            }
          },  
          onStepCancel: (){
            if (_currentStep !=0) {
              setState(() {
                _currentStep -=1;
              });
            }
          },    
            ),
    ),
    );
  }
}