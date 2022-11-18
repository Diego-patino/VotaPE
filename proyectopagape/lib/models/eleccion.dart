class EleccionModel {
  String? fecha;
  String? nombre;
  String? foto;
   
  

  EleccionModel({
  this.foto,
  this.nombre,
  this.fecha,
  });


  // receiving data from server
  factory EleccionModel.fromMap(map) {
    return EleccionModel(
      fecha: map['Fecha'],
      nombre: map['nombre'],
      foto: map['foto']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'Fecha': fecha,
      'nombre': nombre,
      'foto': foto,
    };
  }
}