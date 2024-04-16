import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
             children: [Image.asset("assets/images/user.png",fit: BoxFit.cover,width: double.infinity,),
                        const SizedBox(height: 64),Text("USER",style: TextStyle(color: Colors.teal.shade700,fontSize: 32,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 24,),Container(padding: const EdgeInsets.symmetric(),child: Text("Explore and secure your spot at the hottest events effortlessly – just search, register, and get ready to make memories!",style:  TextStyle(color: Colors.brown.shade600 ),),)],
      )
      
    );
  }
}
