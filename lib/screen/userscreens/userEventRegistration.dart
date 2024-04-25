import 'package:espy/screen/userscreens/user_homeScreen.dart';
import 'package:flutter/material.dart';

class userEventRegistration extends StatelessWidget {
  const userEventRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         Container(
           child: SizedBox
           (
            height: 230,
            child: Image.asset("assets/images/Hackathon_Team.png")),
          ),
         Card(
          // elevation: 50,
          shadowColor: Colors.black,
          color: Colors.greenAccent[100],
          child: SizedBox(
            width: 250,
            height: 480,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                   //CircleAvatar
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  Text(
                    'Hackathon 3.0',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: Container(child: Image.asset("assets/images/location_img.png"))),
                      )
                      ,Text(
                        "RIT Kottayam , Kerala"
                        ),
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: Container(child: Image.asset("assets/images/calender_icon.png"))),
                      )
                      ,Text(
                        "29th September,2024"
                        ),
                    ],
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 15,
                          width: 15,
                          child: Container(child: Image.asset("assets/images/category.png"))),
                      )
                      ,Text(
                        "HACKATHON"
                        ),
                    ],
                  )
                  ,
                  SizedBox(
                    height:10 ,
                  ), //SizedBox
                  const Text(
                    'Unlock your creativity with Adobe Photoshop! Join us for an exciting workshop where you will learn the fundamentals of Photoshop, including tools and techniques for editing and enhancing images. Whether you are a beginner or an experienced user, this event is perfect for you',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 124, 66, 66),
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Text(
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold) ,
                        "Speaker :"
                        ),
                        Text(
                        " Prof Nisha"
                        ),
                  ],),
                  SizedBox(height: 10,),
                  Row(children: [
                    Text(
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold) ,

                        "Fee :"
                        ),
                        Text(
                        " 100/-"
                        ),
                        
                  ],),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("For more info: "),
                      Text(style: TextStyle(color: Colors.red)," www.espy.com")
                    ],
                  )
                  , //SizedBox
                  // SizedBox(
 
                  //   child: ElevatedButton(
                  //     onPressed: () => 'Null',
                  //     style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStateProperty.all(Colors.green)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(4),
                  //       child: Row(
                  //         children: const [
                  //           Icon(Icons.touch_app),
                  //           Text('Visit')
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  //   // RaisedButton is deprecated and should not be used
                  //   // Use ElevatedButton instead
 
                  //   // child: RaisedButton(
                  //   //   onPressed: () => null,
                  //   //   color: Colors.green,
                  //   //   child: Padding(
                  //   //     padding: const EdgeInsets.all(4.0),
                  //   //     child: Row(
                  //   //       children: const [
                  //   //         Icon(Icons.touch_app),
                  //   //         Text('Visit'),
                  //   //       ],
                  //   //     ), //Row
                  //   //   ), //Padding
                  //   // ), //RaisedButton
                  // ) //SizedBox
                ],
              ), //Column
            ), //Padding
          ), //SizedBox
        ),//Size
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
         SizedBox(
 
                    child: ElevatedButton(
                      onPressed: () => 'Null',
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: const [
                            Icon(Icons.touch_app),
                            Text( style: 
                                TextStyle(color: Color.fromARGB(130, 0, 0, 0), fontWeight: FontWeight.bold,fontSize: 17) ,

                            'Register')
                          ],
                        ),
                      ),
                    ),
                    // RaisedButton is deprecated and should not be used
                    // Use ElevatedButton instead
 
                    // child: RaisedButton(
                    //   onPressed: () => null,
                    //   color: Colors.green,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(4.0),
                    //     child: Row(
                    //       children: const [
                    //         Icon(Icons.touch_app),
                    //         Text('Visit'),
                    //       ],
                    //     ), //Row
                    //   ), //Padding
                    // ), //RaisedButton
                  ) 
          ],
        )
      ],
    );
    
  }
}