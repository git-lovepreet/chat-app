
import 'package:f_chat_app/components/my_button.dart';
import 'package:f_chat_app/components/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController() ;
  final TextEditingController _pwController = TextEditingController() ;
  final void Function()? onTap;

   LoginPage({super.key,required this.onTap});

   void login(BuildContext context) async{
     final authService= AuthService();

     try{
       authService.signInWithEmailPassword(_emailController.text, _pwController.text);
     }
     catch(e){
       showDialog(context: context,
           builder: (context)=>AlertDialog(
             title: Text(e.toString()),
           ));
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message,
                size: 60,
                color: Theme.of(context).colorScheme.primary,),
        
              SizedBox(height: 50,),
        
              Text("Welcome back, you've been missed!",
              style: TextStyle(fontSize: 16,
              color: Theme.of(context).colorScheme.primary),),
        
              SizedBox(height: 25,),
              
              MyTextField(hinttext: "Email",
              obsecureText: false,
              focusNode: null,
              controller: _emailController,),
        
              SizedBox(height: 10,),
        
              MyTextField(hinttext: "Password",
                obsecureText: true,
                focusNode: null,
                controller: _pwController,),
        
              SizedBox(height: 25,),
        
              MyButton(text: "Login",
              onTap: ()=> login(context),
              ),
              
              SizedBox(height: 25,),
              
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary
                    ),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
