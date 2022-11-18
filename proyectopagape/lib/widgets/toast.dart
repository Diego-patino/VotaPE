import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void logearseerror() => Fluttertoast.showToast(
  msg: "Primero inicia sesion porfavor!",
  
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  fontSize: 15
  
);

void loginerror() => Fluttertoast.showToast(
  msg: "Correo o contraseña incorrectos",
  
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  fontSize: 15,
  
  
);

void authError() => Fluttertoast.showToast(
  msg: "Porfavor configura los parametros de autenticacion de tu celular",
  
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  fontSize: 15,
  
  
);

void votoError() => Fluttertoast.showToast(
  msg: "Ya realizaste tu voto!",
  
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  fontSize: 15,
  
  
);

void votoRealizado() => Fluttertoast.showToast(
  msg: "Voto Ingresado Correctamente!",
  
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 2,
  backgroundColor: Colors.orange,
  textColor: Colors.white,
  fontSize: 15,
  
  
);