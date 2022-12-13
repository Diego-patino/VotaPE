class DniModel {
  String? dni;
  String? fecha_E;
  String? fecha_V;
  bool? usuario;
  String? nombre;
  String? apellido;
  String? direccion;
   
  

  DniModel({this.dni, 
  this.fecha_E, 
  this.fecha_V, 
  this.usuario,
  this.nombre,
  this.apellido,
  this.direccion,
  });


  // receiving data from server
  factory DniModel.fromMap(map) {
    return DniModel(
      dni: map['DNI'],
      fecha_E: map['Fecha_E'],
      fecha_V: map['Fecha_V'],
      usuario: map['Usuario'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      direccion: map['direccion']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'DNI': dni,
      'Fecha_E': fecha_E,
      'Fecha_V': fecha_V,
      'Usuario': usuario,
      'nombre': nombre,
      'apellido': apellido,
      'direccion': direccion,
    };
  }
}