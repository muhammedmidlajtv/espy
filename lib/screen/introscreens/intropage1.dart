import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
             children: [Image.asset("assets/images/organizer.png",fit: BoxFit.cover,width: double.infinity,),
                        const SizedBox(height: 64),Text("ORGANIZER",style: TextStyle(color: Colors.teal.shade700,fontSize: 32,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 24,),Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 30),child: Text("Streamline your event planning experience with our intuitive ESPY where efficiency meets ease!" ,textAlign: TextAlign.justify,style:  TextStyle( color: Colors.brown.shade600, ),),)],
      )
      
    );
  }
}
