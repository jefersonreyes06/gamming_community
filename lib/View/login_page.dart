import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:game_community/Widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget
{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      /*appBar: AppBar(
        title: Text("Login"),
      ),*/
      body:Container(
        alignment: Alignment(Alignment.center.x, Alignment.center.y),
        decoration: BoxDecoration(color: Colors.white),

        child: Container(
          decoration: BoxDecoration(color: Colors.lightBlue[200], borderRadius: BorderRadius.all(Radius.circular(20))),
          width: 320,
          height: 500,
          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,

            children:
            [
              SizedBox(height: 10,),
              Text("Login", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

              SizedBox(height: 5,),
              //IconButton(onPressed: () {context.go('/home');}, icon: Icon(Icons.home)),
              CustomTextField(label: "Email", borderRadius: 30, height: 38,),
              CustomTextField(label: "Password", borderRadius: 30, height: 38,),
              Column(
                children:
                [
                  Text("You don`t have an account? Register now",),
                  TextButton(onPressed: () => context.go('/register'), child: Text("Click here.", textAlign: TextAlign.start,)),
                ]
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: () {context.go('/home');}, icon: Icon(Icons.panorama_photosphere_select_sharp)),
                  IconButton(onPressed: () {context.go('/home');}, icon: Icon(Icons.panorama_photosphere_select_sharp)),
                  IconButton(onPressed: () {context.go('/home');}, icon: Icon(Icons.panorama_photosphere_select_sharp)),
                ],
              ),

            ]
          )
        )



      ),

    );
  }
}