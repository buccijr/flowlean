import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_router/go_router.dart';
import 'routes.dart';

import 'package:flutter_web_plugins/url_strategy.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp.router(
      routerConfig: appRouter,
  debugShowCheckedModeBanner: false,
  ));

}


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


String errorText = '';
 bool selected1 = false;
bool  selected2 = true;
bool selected3 = false;
bool noUsername = true;
bool noPassword = true;


TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

void signIn() async{
  try {
   await Supabase.instance.client.auth.signInWithPassword(
                password: passwordController.text,
                email: emailController.text
             );

final user = Supabase.instance.client.auth.currentUser;
final role = user?.userMetadata!['role'];
//  context.go(role == 'admin' ? '/admindashboard' : '/dashboard');
               
                  emailController.clear();
                  passwordController.clear();
                  errorText = '';
  } catch(e)    {      
    if (e.toString().toLowerCase().contains('invalid_credentials')){
      errorText = 'Incorrect email or password';
    } else {
  errorText = 'Error!';
    }
  setState(() {
    
  });
  }
}


  
@override
Widget build(BuildContext content){
return Scaffold(
  backgroundColor: Colors.transparent,
  body: Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [const Color.fromARGB(255, 24, 151, 255), const Color.fromARGB(255, 197, 223, 244)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
    child: Center(
      child: Container(
        height: 470,
        width: 450,
        decoration: BoxDecoration(
          color:  Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          
        ),
        child: 
        Column(children: [
          SizedBox(height: 60,),
          Text('Welcome back!',  style: TextStyle(fontWeight: FontWeight.bold, 
          fontFamily: 'Montserrat',
          color: const Color.fromARGB(255, 0, 0, 0), fontSize: 25),),
          SizedBox(height: 15),
           Text('Please sign in.',  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 16, fontFamily: 'Inter'),),
           SizedBox(height: 15),
            Text(errorText,  style: TextStyle(color: const Color.fromARGB(255, 255, 65, 65), fontSize: 16, fontFamily: 'Inter'),),
           SizedBox(height: 25),
           StatefulBuilder(
            builder: (context, setLocalState) =>
             MouseRegion(
              onEnter: (event){
                setLocalState((){
                    noUsername = false;
              noPassword = true;
                });
                },
               onExit: (event){ 
                setLocalState((){
    noUsername = true;
                });
              },
               child: Column(
                 children: [
                   Container(
                    width: 350,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: const Color.fromARGB(255, 84, 178, 255)),
                      borderRadius: BorderRadius.circular(15),
                       boxShadow: noUsername ? null : [BoxShadow(
                        color: Colors.blue,
                        blurRadius: 10,
                      )] 
                    ),
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: SizedBox(
                        width: 350,
                        height: 45,
                         child: TextField(
                          cursorColor: Colors.black,
                                     controller: emailController,
                         decoration: InputDecoration(
                         
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                         suffixIcon: Icon(Icons.mail, color: Colors.grey),
                         hintText: 'Email',
                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                         )
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
           SizedBox(height: 25),
           StatefulBuilder(
            builder: (context, setLocalState) => 
             MouseRegion(
              onEnter: (event) {
                setLocalState((){
noPassword = false;
              noUsername = true;
                });
              
              },
              onExit: (event) {
                setLocalState((){
                noPassword = true;
                });
              },
               child: Container(
                width: 350,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: const Color.fromARGB(255, 84, 178, 255)),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: noPassword ? null : [BoxShadow(
                    color: Colors.blue,
                    blurRadius: 10,
                  )] 
                ),
                 child: SizedBox(
                  width: 350,
                  height: 45,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: TextField(
                      onSubmitted: (value) {
 if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                signIn();
              } 
              else {
                errorText = "Please don't leave a field blank";
                setState(() {
                  
                });
              }                      },
                      cursorColor: Colors.black,
                      obscureText: true,
                                 controller: passwordController,
                     decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.black),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                     suffixIcon: Icon(Icons.lock, color: Colors.grey),
                      hintText: 'Password',
                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                     )
                     ),
                   ),
                 ),
               ),
             ),
           ),
           SizedBox(height: 50),
           MouseRegion(
            cursor: SystemMouseCursors.click,
             child: GestureDetector(
              onTap: () async {
              if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                signIn();
              } 
              else {
                errorText = "Please don't leave a field blank";
                setState(() {
                  
                });
              }
              },
               child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                 child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      colors: [Colors.white, const Color.fromARGB(255, 172, 217, 255), Colors.white]
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                   child: Row(children: [
                    SizedBox(width: 150),
                    Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 15),),
                   ],)
                 ),
               ),
             ),
           )
        ],)
      ),
    ),
  )
);
}
}