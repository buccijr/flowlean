import 'package:flutter/material.dart';
import 'package:mbi2/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_router/go_router.dart';

import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );



}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
class DetailsR extends StatefulWidget {
   final String? accessToken;
  final String? type;
  const DetailsR({super.key,  this.accessToken,  this.type});


  @override
  State<DetailsR> createState() => _DetailsRState();
}

class _DetailsRState extends State<DetailsR> {

// @override
// void initState(){
  
//   super.initState();
// final session = Supabase.instance.client.auth.currentSession;
// final isRecovery = widget.type == 'recovery';

// if (session == null || !isRecovery) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     context.go('/login');
//   });
// }

// }

TextEditingController emailControl = TextEditingController();
String errorText = '';
  @override
  Widget build (BuildContext context){
  return Scaffold(
  backgroundColor: Color(0xFFFAFAFA),
  body: Center(
    child: Container(
      width: 400,
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: const Color.fromARGB(255, 114, 183, 239)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
     
        children: [
          SizedBox(height: 80,),
          Container(
            width: 70,
            height: 70,
decoration: BoxDecoration(
  color: const Color.fromARGB(255, 194, 227, 255),
  shape: BoxShape.circle
),
child: Center(child: Icon(Icons.lock, size: 40, color: const Color.fromARGB(255, 76, 171, 249)),),
          ),
          SizedBox(height: 20,),
          Text(
            'Password Reset', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'WorkSans', fontSize: 24),
          ),
          SizedBox(height: 10,),
            Text(
                "Enter your new password.", style: 
                TextStyle(color: Colors.grey, fontFamily: 'WorkSans', fontSize: 15),
                         ),
                          SizedBox(height: 30,),
          //  Row(
          //    children: [
          //       SizedBox(width: 50),
          //      Text(
          //       'Email', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 17),
          //                ),
                       
          //    ],
          //  ),
            SizedBox(height: 8,),
          Container(width: 300, height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey)),
          child: TextField(
               controller: emailControl,
            onSubmitted: (value) async {
                
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: emailControl.text),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 173, 218, 255),
          content: Row(children: [
            const SizedBox(width: 10),
            const Icon(Icons.task_alt, color: Colors.white),
            const SizedBox(width: 30),
            const Text(
              'Password updated',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ]),
        ),
      );
    } catch (e) {
      errorText = 'Error: $e';
    }
setState(() {
  
});
    
            },
         
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 16),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
          ),
          SizedBox(height: 20,),
MouseRegion(
  cursor: SystemMouseCursors.click,
  child: GestureDetector(
    onTap: () async {
     
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: emailControl.text),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromARGB(255, 173, 218, 255),
          content: Row(children: [
            const SizedBox(width: 10),
            const Icon(Icons.task_alt, color: Colors.white),
            const SizedBox(width: 30),
            const Text(
              'Password updated',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ]),
        ),
      );
    } catch (e) {
      errorText = 'Error: $e';
    }
setState(() {
  
});
    },
    child: Container(
      width: 300,
      height: 45,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 156, 210, 255), borderRadius: BorderRadius.circular(5)),
      child: Center(child: Text('Reset password', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 17),),),
    ),
  ),
) ,
SizedBox(height: 20,),
Text(errorText, style: TextStyle(fontFamily: 'Inter', color: Colors.red),)
             ],
      ),
    ),
  )
  );
  }
}