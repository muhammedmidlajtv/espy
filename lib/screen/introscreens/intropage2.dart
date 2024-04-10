import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
             children: [Image.asset("assets/images/image.png",fit: BoxFit.cover,width: double.infinity,),
                        const SizedBox(height: 64),Text("APPLICATION",style: TextStyle(color: Colors.teal.shade700,fontSize: 32,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 24,),Container(padding: const EdgeInsets.symmetric(),child: Text("Description",style:  TextStyle(color: Colors.brown.shade600, ),),)],
      )
      
    );
  }
}
