String? validatecontra(String? contraform){
  if(contraform == null || contraform.isEmpty)
  return 'Porfavor ingrese una contraseña';

  String pattern = 
    r'^(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,30}$';  //Tiene que tener =>(Minuscula)(Numero).{6 digitos}
    // Para simbolos es => ... (?=.*?[!@#\$&*~]) ...
    // Para Mayusculas es => ... (?=.*?[A-Z]) ...
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(contraform))
    return '''La contraseña tiene que tener 6 digitos incluyendo números''';
    
  return null;
}