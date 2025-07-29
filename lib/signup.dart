import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:async';
import 'routes.dart';

import 'package:go_router/go_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

 runApp(MaterialApp.router(
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter,
  ));

}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State <LoginPage> createState() =>  LoginPageState();
}

class  LoginPageState extends State<LoginPage> {

int timer1 = 60;

void countDown(){
  Timer.periodic(Duration(seconds: 1), (timer){
setState(() {
  
});
timer1--;
if (timer1 == 0){
  timer.cancel();
  disabled = false;
}
setState(() {
  
});
});
}

final ValueNotifier<String> errorText = ValueNotifier('');
bool disabled = false;
bool resend = false;
bool isHovered1 = true;
bool isHovered2 = true;
bool isHovered3 = true;
bool isHovered4 = true;
  TextEditingController companyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    bool isValidEmail(String email) {
  final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
  return emailRegex.hasMatch(email);
}


void confirmationPopUp(){
  showDialog(context: context, builder:(context) {
    return StatefulBuilder(builder:(context, setLocalState) =>
    AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 400,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
    Container(
      width: 55,
height: 55,
decoration: BoxDecoration(
  shape: BoxShape.circle,
  color: const Color.fromARGB(255, 142, 209, 144)
),
      child: Icon(Icons.check_circle, color: const Color.fromARGB(255, 53, 150, 56), size: 40,)),
    SizedBox(height: 10,),
    Text('Submitted Successfully!', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 21),),
        SizedBox(height: 10,),
        Text('We will review your submission shortly \nand send you an email to reset\n your password.', textAlign: TextAlign.center,
       style: TextStyle(fontFamily: 'WorkSans', fontSize: 16.5), 
        )
          ],
        ),
      ),
    )
    ); 
  },);
}
void signUp() async {
   final response3 = await Supabase.instance.client.from('company').select().eq('companyname', companyController.text);
      if (response3.isEmpty){
  if (companyController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      usernameController.text.isNotEmpty 
      ) {
    print('here7');
      await Supabase.instance.client.from('pendinguser').insert({
        
        'username': usernameController.text,
        'email': emailController.text,
        'company': companyController.text,
      });
      confirmationPopUp();
 }
  else  {
     
   errorText.value = "Please don't leave a field blank";
   print('here');
    setState(() {
      
    });
     }} else if (response3.isNotEmpty) {
     errorText.value = 'Company already registered. Ask an admin to add you as a user';
       print('here2');
     setState(() {
       
     });
      }

  setState(() {});
}
//   Future<void> resendConfirmationEmail(BuildContext context, String email) async {
//   try {
//     await Supabase.instance.client.auth.signUp(
//       email: email,
//       password: 'temporaryDummy123!', // placeholder password
//     );

//     // If no error thrown, this is either a new user or confirmation re-sent
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Confirmation email sent to $email')),
//     );
//   } catch (e) {
//     final errorMsg = e.toString();

//     if (errorMsg.contains('User already registered')) {
//       // Supabase will still resend confirmation email in this case
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Confirmation email resent to $email')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $errorMsg')),
//       );
//     }
//   }
// }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:  Color.fromARGB(255, 243, 243, 243),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
        width: MediaQuery.of(context).size.width < 600 ? 400 : MediaQuery.of(context).size.width < 1040 ? 580 : 1020,
        height:  MediaQuery.of(context).size.height < 710 ? 580 : 750,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            SizedBox(width: 10),
            MediaQuery.of(context).size.width < 1040 ? SizedBox.shrink() : Container(
        width:   MediaQuery.of(context).size.height < 710 ? 300 : 350,
        height: 875,
        decoration: BoxDecoration(
        
          gradient: LinearGradient(
            colors: [ const Color.fromARGB(255, 21, 150, 255), const Color.fromARGB(255, 211, 235, 255)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
            ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Text('Optimize manufacturing \nefficiency for your business', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white,
            fontSize: 30, fontWeight: FontWeight.w900),),
            Spacer(),
            Center(child: Text('FlowLeanSolutions', style: TextStyle(fontFamily: 'WorkSans', color: Colors.white, )))
          ],
        ),
        )
            ),
            Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width < 1040 ? 10 : 70),
            Column(
              
              mainAxisAlignment: MediaQuery.of(context).size.width < 600 ? MainAxisAlignment.start : MainAxisAlignment.center,
          crossAxisAlignment: MediaQuery.of(context).size.width < 600 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
              SizedBox(height:  MediaQuery.of(context).size.height < 710 ? 10: 90,),
              Center(child: Text('Sign Up', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 40, color: Color.fromARGB(255, 17, 145, 251),),)),
              SizedBox(height: 10,),
              
              Column(
                children: [
                  Text(  MediaQuery.of(context).size.width < 600 ? 'Fill out the form and we will \nreview your submission.' : 'Fill out the form and we will review your submission.', style: TextStyle(color: resend ? const Color.fromARGB(255, 106, 191, 84) : const Color.fromARGB(255, 73, 73, 73), fontFamily: 'Inter',
                  fontSize: 15, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                 resend ?  TextButton(
                    style: TextButton.styleFrom(
        backgroundColor: Colors.white,
                  ),
                  onPressed: disabled ? null : () async {    
         
         setState(() {
           
         });
                 }, child: Text(disabled ? 'Resend ($timer1)' : 'Resend', style: TextStyle(fontFamily: 'WorkSans', color: Colors.black, fontSize: 16),)) : SizedBox.shrink()
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Text('Username', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16),),
                SizedBox(width: 420),
                ],
              ),
                SizedBox(height: 15,),
              Row(
                children: [
                 
                  StatefulBuilder(
                  builder: (context, setLocalState) =>
                  MouseRegion(
                      onEnter: (event) {
                        setLocalState(() {
                          isHovered1  = true;
                          isHovered3 = false;
                          isHovered2 = true;
                          isHovered4 = true;
                        });
                       
                      },
                      onExit: (event) => {
                        setLocalState(() {
                          isHovered1  = true;
                          isHovered3 = true;
                      isHovered2 = true;
                                              isHovered4 = true;
                        })
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width < 600 ? 300 : 500,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 238, 238),
                          boxShadow: isHovered3 ? null : [BoxShadow(
                            color: const Color.fromARGB(255, 48, 157, 246),
                            blurRadius: 15
                          )],
                         
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: usernameController,
                          cursorColor: Colors.black,
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                          
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter your username...',
                      hintStyle: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 125, 125, 125), fontWeight: FontWeight.normal),
                      suffixIcon: Icon(Icons.person, color: const Color.fromARGB(255, 128, 128, 128),),
                      contentPadding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
               Row(
                children: [
                  Text('Company', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16),),
                SizedBox(width: 420),
                ],
              ),
                SizedBox(height: 15,),
              Row(
                children: [
                 
                  StatefulBuilder(
                  builder: (context, setLocalState) =>
                  MouseRegion(
                      onEnter: (event) {
                        setLocalState(() {
                                                  isHovered3 = true;
                          isHovered1  = true;
                          isHovered4 = false;
                          isHovered2 = true;
                        });
                       
                      },
                      onExit: (event) => {
                        setLocalState(() {
                          isHovered1  = true;
                          isHovered4 = true;
                      isHovered2 = true;
                                              isHovered3 = true;
                        })
                      },
                      child: Container(
                       width: MediaQuery.of(context).size.width < 600 ? 300 : 500,
                        height: 45,
                        decoration: BoxDecoration(
                             color: const Color.fromARGB(255, 238, 238, 238),
                          boxShadow: isHovered4 ? null : [BoxShadow(
                            color:  const Color.fromARGB(255, 48, 157, 246),
                            blurRadius: 15
                          )],
                          
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                          controller: companyController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter your company...',
                       hintStyle: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 125, 125, 125), fontWeight: FontWeight.normal),
                      suffixIcon: Icon(Icons.add_business, color: const Color.fromARGB(255, 128, 128, 128)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Align(
                    
                    child: Text('Email', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16),)),
                SizedBox(width: 450),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                 
                  StatefulBuilder(
                  builder: (context, setLocalState) =>
                  MouseRegion(
                      onEnter: (event) {
                        setLocalState(() {
                          isHovered1  = false;
                          isHovered2 = true;
                          isHovered3 = true;
                                                  isHovered4 = true;
                        });
                       
                      },
                      onExit: (event) => {
                        setLocalState(() {
                          isHovered1  = true;
                      isHovered2 = true;
                      isHovered3 = true;
                                              isHovered4 = true;
                        })
                      },
                      child: Container(
                       width: MediaQuery.of(context).size.width < 600 ? 300 : 500,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 238, 238),
                          boxShadow: isHovered1 ? null : [BoxShadow(
                            color: const Color.fromARGB(255, 48, 157, 246),
                            blurRadius: 15
                          )],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                          controller: emailController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Enter your email...',
                       hintStyle: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 125, 125, 125), fontWeight: FontWeight.normal),
                      suffixIcon: Icon(Icons.mail, color:const Color.fromARGB(255, 128, 128, 128),),
                      contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
        //             Row(
        //               children: [
        //                 Text('Password', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16),),
        //             SizedBox(width: 426)
        //               ],
        //             ),
        //             SizedBox(height: 15,),
        //             Row(
        //               children: [
        //                 StatefulBuilder(
        //  builder: (context, setLocalState) => 
        //                   MouseRegion(
        //                                       onEnter: (event) {
        //                       setLocalState(() {
        //                         isHovered1  = true;
        //                         isHovered2 = false;
        //                         isHovered3 = true;
        //                                                 isHovered4 = true;
        //                               });
        //                         setLocalState(() {
                            
        //                         });
                                  
                       
        //                     },
        //                     onExit: (event) => {
        //                       setLocalState(() {
        //                         isHovered1  = true;
        //                    isHovered2 = true;
        //                    isHovered3 = true;
        //                                            isHovered4 = true;
        //                         setLocalState(() {
                            
        //                         });
        //                       })
        //                     },
        //                     child: Container(
        //                       width: 500,
        //                       height: 45,
        //                       decoration: BoxDecoration(
        //                         color: Colors.white,
        //                         boxShadow: isHovered2 ? null : [ BoxShadow(
        //                           color:const Color.fromARGB(255, 13, 115, 199),
        //                           blurRadius: 10,
        //                         )],
        //                         border: Border.all(width: 0.5),
        //                         borderRadius: BorderRadius.circular(6),
        //                       ),
        //                       child: TextField(
        //                         obscureText: true,
        //                         onSubmitted: (_)async {
        // signUp();
        //                         },
        //                         controller: passwordController,
        //                         cursorColor: Colors.black,
        //                         decoration: InputDecoration(
        //                           enabledBorder: InputBorder.none,
        //                           disabledBorder: InputBorder.none,
        //                     focusedBorder: InputBorder.none,
        //                     hintText: 'Enter your password...',
        //                     suffixIcon: Icon(Icons.lock, color: Colors.grey,),
        //                     contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
                 SizedBox(height: MediaQuery.of(context).size.height < 710 ? 13 : 30,),
                   StatefulBuilder(
                     builder: (context, setLocalState) {
                       return MouseRegion(
                         onEnter: (event) {
                            setLocalState(() {
                              isHovered1  = true;
                              isHovered2 = true;
                              isHovered3 = true;
                                                      isHovered4 = false;
                                    });
                              setLocalState(() {
                                
                              });
                                      
                           
                          },
                          onExit: (event) => {
                            setLocalState(() {
                              isHovered1  = true;
                         isHovered2 = true;
                         isHovered3 = true;
                                                 isHovered4 = true;
                              setLocalState(() {
                                
                              });
                            })
                          },
                        cursor: SystemMouseCursors.click,
                        
                         child: GestureDetector(
                          onTap: () async {
                           
                            signUp();
                            
                          },
                           child: Row(
                             children: [
                               SizedBox(
                                width: MediaQuery.of(context).size.width < 600 ? 300 : 550,
                                height: 80,
                                 child: Align(
                                  alignment: Alignment.center,
                                   child: AnimatedPadding(
                                    duration: Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(10),
                                                             child:   AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: MediaQuery.of(context).size.width < 600 ? 300 : isHovered4 == false ?  503 : 500,
                                    height: isHovered4 == false ? 55 : 50,
                                    decoration: BoxDecoration(
                                                               color: isHovered4 == false ? const Color.fromARGB(255, 101, 186, 255) : Color.fromARGB(255, 26, 152, 255),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                     child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                     
                                      Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 16),),
                                      SizedBox(width: 10,),
                                                                          isHovered4  == false ?   Icon(Icons.arrow_forward, size: 25,) : SizedBox.shrink(),
                                     ],)
                                   ),
                                                            ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       );
                     }
                   ),
                   SizedBox(height: MediaQuery.of(context).size.height < 710 ? 7: 25,),
                   Row(
                     children: [
                       Text('Already have an account?', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 132, 132, 132), 
                       fontSize: 16)),
                       SizedBox(width: 0,),
                       TextButton(
        onPressed: (){
         context.go('/login');
        },
                       child: Text('Sign in', style: TextStyle(fontFamily: 'Inter', color: Colors.blue, fontSize: 16))),
                     ]
                   ),
                   SizedBox(height:  MediaQuery.of(context).size.height < 710 ? 5 : 20,),
                   ValueListenableBuilder(
                     valueListenable: errorText,
                     builder: (context, value, child) {
                       return Text(errorText.value, style: TextStyle(fontFamily: 'Inter', color: Colors.red),);
                     }
                   )
            ],),
          ],
        ),
            )
          ],),
        ),
          ),
        ),
      )
    );
  }
}