import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admindashboard.dart';
import 'dart:async';
import 'login.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: LoginPage()));

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
String errorText = '';

void signUp() async {
   final response3 = await Supabase.instance.client.from('company').select().eq('companyname', companyController.text);
      if (response3.isEmpty){
  if (passwordController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      usernameController.text.isNotEmpty &&
      isValidEmail(emailController.text.trim())) {
    try {
    final result = await Supabase.instance.client.auth.signUp(
        password: passwordController.text.trim(),
        email: emailController.text.trim(),
        data: {
          'role': 'admin',
        },
      );
      final userId = result.user!.id; 


      // final user = Supabase.instance.client.auth.currentUser;
      // await Supabase.instance.client.auth.refreshSession();

      // if (user?.emailConfirmedAt != null){

     
      await Supabase.instance.client.from('user').insert({
         'id': userId,
        'username': usernameController.text,
        'email': emailController.text,
        'company': companyController.text,
      });
         await Supabase.instance.client.from('company').insert({
          'usernamec': usernameController.text,
          'companyname': companyController.text,
      });

      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AdminDash(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      // } else {
      //   resend = true;
      //   errorText = 'Please check your inbox for\n a confirmation email.';
      // }

    } catch (e) {
      if (e.toString().contains('User already registered')) {
        errorText = 'An account with this email already exists.';
      } else if (e.toString().toLowerCase().contains('duplicate key')){
        errorText = 'Username already in use.';
    }
       else {
        errorText = 'Signup failed: $e';
       }
      }
    }
  } else if (passwordController.text.isEmpty ||
      emailController.text.isEmpty ||
      usernameController.text.isEmpty) {
     
    errorText = "Please don't leave a field blank";
     } else if (response3.isNotEmpty) {
     errorText = 'Company already registered. Ask an admin to add you as a user';
      }
   else if (!isValidEmail(emailController.text.trim())) {
    errorText = 'Please enter a valid email';
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
        child: Container(
width: 1020,
height: 750,
decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
),
child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(children: [
    SizedBox(width: 10),
    Container(
      width: 350,
      height: 875,
      decoration: BoxDecoration(
      
        gradient: LinearGradient(
          colors: [ const Color.fromARGB(255, 21, 150, 255), const Color.fromARGB(255, 128, 196, 251)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
          ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Text('Optimize manufacturing \nefficiency for your business', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white,
          fontSize: 30, fontWeight: FontWeight.w900),),
          Spacer(),
          Center(child: Text('MBI - Sign Up', style: TextStyle(fontFamily: 'WorkSans', color: Colors.white, )))
        ],
      ),
      )
    ),
    Center(
      child: Row(
        
        children: [
          SizedBox(width: 70),
          Column(children: [
            SizedBox(height: 60,),
            Row(
              children: [
                Text('Sign Up', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 30),),
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Text(errorText, style: TextStyle(color: resend ? const Color.fromARGB(255, 106, 191, 84) : Colors.red, fontFamily: 'WorkSans',
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
            SizedBox(height: 10,),
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
                      width: 500,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: isHovered3 ? null : [BoxShadow(
                          color: const Color.fromARGB(255, 13, 115, 199),
                          blurRadius: 10
                        )],
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: usernameController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter your username...',
                    suffixIcon: Icon(Icons.person, color: Colors.grey,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
                      width: 500,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: isHovered4 ? null : [BoxShadow(
                          color: const Color.fromARGB(255, 13, 115, 199),
                          blurRadius: 10
                        )],
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: companyController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter your company...',
                    suffixIcon: Icon(Icons.add_business, color: Colors.grey,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
                      width: 500,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: isHovered1 ? null : [BoxShadow(
                          color: const Color.fromARGB(255, 13, 115, 199),
                          blurRadius: 10
                        )],
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: emailController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter your email...',
                    suffixIcon: Icon(Icons.mail, color: Colors.grey,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
                SizedBox(height: 15,),
            Row(
              children: [
                Text('Password', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16),),
            SizedBox(width: 426)
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
                        isHovered2 = false;
                        isHovered3 = true;
                                                isHovered4 = true;
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
                    child: Container(
                      width: 500,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: isHovered2 ? null : [ BoxShadow(
                          color:const Color.fromARGB(255, 13, 115, 199),
                          blurRadius: 10,
                        )],
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        obscureText: true,
                        onSubmitted: (_)async {
signUp();
                        },
                        controller: passwordController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Enter your password...',
                    suffixIcon: Icon(Icons.lock, color: Colors.grey,),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
               SizedBox(height: 55),
                 MouseRegion(
                  cursor: SystemMouseCursors.click,
                   child: GestureDetector(
                    onTap: () async {
                      signUp();
                    },
                     child: Row(
                       children: [
                         Container(
                          width: 500,
                          height: 50,
                          decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 26, 152, 255),
                            borderRadius: BorderRadius.circular(15),
                          ),
                           child: Row(children: [
                            SizedBox(width: 200),
                            Row(
                              children: [
                                Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 15),),
                                SizedBox(width: 20,),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                           ],)
                         ),
                       ],
                     ),
                   ),
                 ),
                 SizedBox(height: 25,),
                 Row(
                   children: [
                     Text('Already have an account?', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 132, 132, 132), 
                     fontSize: 16)),
                     SizedBox(width: 0,),
                     TextButton(
onPressed: (){
   Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Login()
        ),
      );
},
                     child: Text('Sign in', style: TextStyle(fontFamily: 'Inter', color: Colors.blue, fontSize: 16))),
                   ]
                 )
          ],),
        ],
      ),
    )
  ],),
),
        )
      )
    );
  }
}