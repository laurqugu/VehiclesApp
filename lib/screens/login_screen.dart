import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

import 'package:vehicles_app/helpers/constans.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _showLogo(),
            SizedBox(height: 9,),
            _showEmail(),
            _showPassword(),
            _showRememberMe(),
            _showButtons(),
          ],
        )
      ),
    );
  }

 Widget _showLogo() {
   return Image(
     image: AssetImage('assets/vehicles_logo.png'),
     width: 250,
   );
 }

 Widget _showEmail() {
   return Container(
     padding: EdgeInsets.all(20),
     child: TextField(
       autofocus: true,
       keyboardType: TextInputType.emailAddress,
       decoration: InputDecoration(
         hintText: 'Ingresa tu correo electrónico',
         labelText: 'Correo electrónico',
         errorText: _emailShowError ? _emailError : null,
         prefixIcon: Icon(Icons.alternate_email),
         suffixIcon: Icon(Icons.email),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10)
         ),
       ),
       onChanged: (value) {
         _email = value;
       },
     ),
   );
 }

 Widget _showPassword() {
    return Container(
     padding: EdgeInsets.all(20),
     child: TextField(
       obscureText: !_passwordShow,
       decoration: InputDecoration(
         hintText: 'Ingresa tu contraseña',
         labelText: 'Contraseña',
         errorText: _passwordShowError ? _passwordError : null,
         prefixIcon: Icon(Icons.lock),
         suffixIcon: IconButton(
           icon: _passwordShow ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
           onPressed: () {
             setState(() {
               _passwordShow = !_passwordShow;               
             });
           }, 
         ),
         border: OutlineInputBorder(
           borderRadius: BorderRadius.circular(10)
         ),
       ),
       onChanged: (value) {
         _password = value;
       },
     ),
   );
 }

 Widget _showRememberMe() {
   return CheckboxListTile(
     title: Text('Recordarme'),
     value: _rememberme, 
     onChanged: (value) {
       setState(() {
         _rememberme = value!;
       });
     },     
   );
 }

 Widget _showButtons() {
   return Container(
     margin: EdgeInsets.only(left: 10, right: 10),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: <Widget>[
         Expanded(
           child: ElevatedButton(
             child: Text('Ingresar'),
             style: ButtonStyle(
               backgroundColor: MaterialStateProperty.resolveWith<Color>(
                 (Set<MaterialState> states) {
                   return Color(0xFF0f2d84);
                 }
               ),
             ),
             onPressed: () => _Login(),
           ),
         ),
         SizedBox(width: 20,),
         Expanded(
           child: ElevatedButton(
             child: Text('Registrarse'),
             style: ButtonStyle(
               backgroundColor: MaterialStateProperty.resolveWith<Color>(
                 (Set<MaterialState> states) {
                   return Color(0xFF6679b1);
                 }
               ),
             ),
             onPressed: () {},
           ),
         )
       ],
     ),
   );
 }

 void _Login() async {
   setState(() {
     _passwordShow = true;
   });

   if (!_validateFields()) {
     return;     
   }

   Map<String, dynamic> request = {
     'userName': _email,
     'password': _password,
   };

   var url = Uri.parse('${Constans.apiUrl}/api/account/CreateToken');
   var response = await http.post(
     url,
     headers: {
       'content-type': 'application/json',
       'accept': 'application/json',
     },
     body: jsonEncode(request)
   );

   print(response.body);

 }

  bool _validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu correo electrónico';
    }else if(!EmailValidator.validate(_email)){
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu correo electrónico válido.';
    }
    else{
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu contraseña.';
    }else if(_password.length < 6){
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debe ingresar una contraseña de al menos 6 caracteres.';
    }
    else{
      _passwordShowError = false;
    }

    setState(() { });

    return isValid;
  }
}