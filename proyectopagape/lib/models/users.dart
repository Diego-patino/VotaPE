class UserModel {
  String? uid;
  String? nombre;
  String? apellido;
  String? correo;
  String? foto;
  String? dni;
  String? direccion;
   
  

  UserModel({this.uid, 
  this.nombre, 
  this.apellido,
  this.correo, 
  this.foto,
  this.dni,
  this.direccion });


  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      nombre: map['nombre'],
      apellido: map['apellido'],
      correo: map['correo'],
      foto: map['foto'],
      dni: map['dni'],
      direccion: map['direccion']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'foto': foto,
      'dni': dni,
      'apellido': apellido,
      'direccion': direccion,
    };
  }
}