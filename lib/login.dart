import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:go_router/go_router.dart';
import 'routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'dart:ui';


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
 bool seepassword = false;
bool  selected2 = true;
bool selected3 = false;
bool noUsername = true;
bool noPassword = true;
bool sendwarning = false;

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();



 
    Future loginWithEdgeFunction() async {
  final uri = Uri.parse('https://rmotaezqlbiiiwwiaomh.supabase.co/functions/v1/create-admin-user'); 

  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
    }),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);


final accessToken = json['session']?['access_token'];
final refreshToken = json['session']?['refresh_token'];

print('Login successful!');
print('Access Token: $accessToken');
print('Refresh Token: $refreshToken');
     final sessionJsonString = jsonEncode(json['session']);

print('session json string: $sessionJsonString');
await Supabase.instance.client.auth.setSession(
 refreshToken
);



    // You can now save the token or use it
  } else {
    print('Login failed: ${response.statusCode}');
    errorText = '${response.body}';
    print(response.body);
    setState(() {
      
    });
  }
}



bool hovering= false;

  
  Future signIn() async{
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
       image: DecorationImage(
                             image: AssetImage(hovering  ? 'images/newforklift.png' : 'images/lightsoff2.png'),
                             fit: BoxFit.cover,
                           ),
    ),
    child: Center(
      child: ClipRRect(
                  borderRadius:  BorderRadius.circular(15),
                  child: BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
       
      child: MouseRegion(
          onEnter: (event){
                        setState(() {
                          hovering = true;
                        });
                      },
                       onExit: (event){
                        setState(() {
                          hovering = false;
                        });
                      },
        child: Container(
          height: MediaQuery.of(context).size.height < 400 ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.width
      < 500 ? MediaQuery.of(context).size.height * 0.8
           : MediaQuery.of(context).size.height > 1000 ? MediaQuery.of(context).size.height * 0.5 :MediaQuery.of(context).size.height * 0.7,
          width:MediaQuery.of(context).size.width < 1300 ? 380 :450,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255).withAlpha(hovering ? 100 : 60),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 0.7, color: Colors.white)
            
          ),
          child: 
          Column(children: [
            SizedBox(height: 75,),
            Text('Login',  style: TextStyle(fontWeight: FontWeight.bold, 
            fontFamily: 'Inter',
            color: hovering == false ? const Color.fromARGB(255, 133, 203, 249) :const Color.fromARGB(255, 0, 94, 171), fontSize:50),),
            SizedBox(height: 15),
             Text('Please sign in.',  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 18, fontFamily: 'Inter'),),
             SizedBox(height: 15),
              Text(errorText,  style: TextStyle(color: const Color.fromARGB(255, 255, 65, 65), fontSize: 16, fontFamily: 'Inter'),),
             SizedBox(height: 10),
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
            noPassword = true;
                  });
                },
                 child: Column(
                   children: [
                     Align(
                      alignment: Alignment.center,
                       child: AnimatedPadding(
                        duration: Duration(milliseconds: 200),
                         padding: const EdgeInsets.all(8.0),
                         child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: noUsername ? 350 : 360,
                          height: noUsername ? 45 : 50,
                          decoration: BoxDecoration(
                           color: noUsername == false ?  const Color.fromARGB(255, 255, 255, 255).withAlpha(100) : Colors.transparent,
                            
                            border: Border.all(width: 1, color: hovering ? const Color.fromARGB(255, 1, 67, 160) : Color.fromARGB(255, 84, 178, 255)),
                            borderRadius: BorderRadius.circular(8),
                           
                          ),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: SizedBox(
                              width: 350,
                              height: 45,
                               child: Theme(
                                  data: Theme.of(context).copyWith(
                             textSelectionTheme: TextSelectionThemeData(
                                                        selectionColor: const Color.fromARGB(255, 30, 184, 255).withAlpha(100), // <- selection highlight
                                                        selectionHandleColor: const Color.fromARGB(255, 230, 247, 255)           // <- draggable handle
                             ),
                                                        ),
                                 child: TextField(
                                  onTap:() {
                                                       noUsername = false;
                                                 noPassword = true;
                                                 setState(() {
                                                   
                                                 },);
                                                 setState(() {
                                                   
                                                 });
                                                   },
                                   style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                  cursorColor: Colors.black,
                                             controller: emailController,
                                 decoration: InputDecoration(
                                 
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                 suffixIcon: Icon(Icons.mail, color: Colors.grey),
                                 hintText: 'Email',
                                  hintStyle: TextStyle(
                                 color: Colors.black, 
                                 fontWeight: FontWeight.bold
                                                            ),
                                 contentPadding: EdgeInsets.symmetric(vertical:noUsername ? MediaQuery.of(context).size.height < 700 ? 5 :
                                 
                                 10 : 12, horizontal: 10),
                                 )
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             SizedBox(height: 15),
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
                  noUsername = true;
                  });
                },
                 child: Theme(
                    data: Theme.of(context).copyWith(
                             textSelectionTheme: TextSelectionThemeData(
                         selectionColor: const Color.fromARGB(255, 30, 184, 255).withAlpha(100), // <- selection highlight
                         selectionHandleColor: const Color.fromARGB(255, 230, 247, 255)           // <- draggable handle
                             ),
                         ),
                   child: Align(
                        alignment: Alignment.center,
                         child: AnimatedPadding(
                          duration: Duration(milliseconds: 200),
                           padding: const EdgeInsets.all(8.0),
                           child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: noPassword ? 350 : 360,
                            height: noPassword ? 45 : 50,
                            decoration: BoxDecoration(
                              color: noPassword  == false ?  const Color.fromARGB(255, 255, 255, 255).withAlpha(100) : Colors.transparent,
                              
                              border: Border.all(width: 1, color: hovering ? const Color.fromARGB(255, 1, 67, 160) : Color.fromARGB(255, 84, 178, 255)),
                              borderRadius: BorderRadius.circular(8),
                              //  boxShadow: noPassword ? null : [BoxShadow(
                              //   color: Colors.blue.withAlpha(70),
                              //   blurRadius: 20,
                              // )] 
                            ),
                     child: SizedBox(
                      width: 350,
                      height: 45,
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextField(
                           onTap:() {
                                                       noUsername = true;
                                                 noPassword = false;
                                                 setState(() {
                                                   
                                                 },);
                                                 setState(() {
                                                   
                                                 });
                                                   },
                          onSubmitted: (value) async {
                                          if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
                                          final navContext = context;
                                        
                                          // Call your edge function login
                                          // final loginSuccess = await loginWithEdgeFunction();
                                        
                                          
                                        
                                          // After loginWithEdgeFunction, you must set the session manually!
                                          // Example:
                                          // await Supabase.instance.client.auth.setSession(sessionData);
                                        
                                        await loginWithEdgeFunction();
                                          final session = Supabase.instance.client.auth.currentSession;
                                          final user = Supabase.instance.client.auth.currentUser;
                                          final isLoggedIn = session != null;
                                        
                                        
                                          if (!isLoggedIn) {
                     setState(() {
                       errorText = "Login failed or session not set";
                     });
                     return;
                                          }
                                        
                                          final email = user?.email;
                                          if (email == null) {
                     setState(() {
                       errorText = "User email missing";
                     });
                     return;
                                          }
                                        
                                          final response = await Supabase.instance.client
                       .from('user')
                       .select()
                       .eq('email', email)
                       .maybeSingle();
                                        
                                          final role = response?['role'];
                                          final company = response?['company'];
                                        
                                          // final response3 = await Supabase.instance.client
                                          //     .from('company')
                                          //     .select()
                                          //     .eq('companyname', company)
                                          //     .maybeSingle();
                                        
                                          // if (response3 != null) {
                                          //   final billingStart = DateTime.parse(response3?['startdate']);
                                          //   final nextBilling = billingStart.add(Duration(days: 30));
                                        
                                          //   bool isThisBillingPeriod(DateTime day) {
                                          //     return day.isAfter(billingStart) && day.isBefore(nextBilling);
                                          //   }
                                        
                                          //   final responsee = await Supabase.instance.client
                                          //       .from('detail')
                                          //       .select()
                                          //       .eq('company', company);
                                        
                                          //   List inthisbilling = [];
                                          //   if (response3?['subscription'] != null) {
                                          //     for (final entry in responsee) {
                                          //       if (isThisBillingPeriod(DateTime.parse(entry['starttime']))) {
                                          //         inthisbilling.add(entry);
                                          //       }
                                          //     }
                                          //     if (response3?['subscription'] == 'Basic') {
                                          //       if (inthisbilling.length == 500) {
                                          //         sendwarning = true;
                                          //       }
                                          //     } else if (response3?['subscription'] == 'Pro') {
                                          //       if (inthisbilling.length == 1000) {
                                          //         sendwarning = true;
                                          //       }
                                          //     }
                                          //   }
                                          // }
                                        
                                          if (role == 'admin') {
                     navContext.go('/admindashboard', extra: {'sendwarning': sendwarning});
                                          } else {
                     navContext.go('/dashboard');
                                          }
                                        } else {
                                          setState(() {
                     errorText = "Please don't leave a field blank";
                                          });
                                        }              },
                          cursorColor: Colors.black,
                          obscureText: seepassword? false : true,
                          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
                                     controller: passwordController,
                         decoration: InputDecoration(
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                         suffixIcon:
                            //  IconButton(
                            //   onPressed: (){
                            //     setState(() {
                                  
                            //       seepassword = !seepassword;
                            //     });
                            //   },
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: (){
                                    seepassword = !seepassword;
                                    setState(() {
                                      
                                    });
                                  },
                                  child: Icon( seepassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey)),
                              )
                             
                             ,
                          
                          hintText: 'Password',
                                 hintStyle: TextStyle(
                         color: Colors.black, 
                         fontWeight: FontWeight.bold
                       ),
                             contentPadding: EdgeInsets.symmetric(vertical:noPassword ? MediaQuery.of(context).size.height < 700 ? 5 :
                                 
                                 10 : 12, horizontal: 5),
                         )
                         ),
                       ),
                     ),
                   ),
                                ),
                              ),
                 ),)),
             SizedBox(height: 20),
             MouseRegion(
              cursor: SystemMouseCursors.click,
               child: GestureDetector(
                onTap: (){
                context.go('/forgotpassword');
                },
                
                child: Text('Forgot Password?', style: TextStyle(fontFamily: 'Inter', 
                fontWeight: FontWeight.bold,
                
                fontSize: 17, color: hovering ? const Color.fromARGB(255, 0, 44, 80) : const Color.fromARGB(255, 136, 201, 255)),)),
             ),
              SizedBox(height: 40),
             MouseRegion(
              cursor: SystemMouseCursors.click,
               child: GestureDetector(
                onTap: () async {
                if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                                 final navContext = context; 
                                 if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
                   await loginWithEdgeFunction();
                       final session = Supabase.instance.client.auth.currentSession;
                       print('session $session');
                       final user = Supabase.instance.client.auth.currentUser;
                       final isLoggedIn = session != null;
                   
                       if (!isLoggedIn) {
                         
                       }
                   
                       if (isLoggedIn ) {
                         final email = user?.email;
                         if (email == null) return null;
                   
                         final response = await Supabase.instance.client
                             .from('user')
                             .select()
                             .eq('email', email)
                             .maybeSingle();
                              
                             
                         final role = response?['role'];
                            final company = response?['company'];
                         print('company $company');
                          final response3 = await Supabase.instance.client
                             .from('company')
                             .select()
                             .eq('companyname', company)
                             .maybeSingle();
                             print('r3 $response3');
                          if (response3 != null){
                      final billingStart =  DateTime.parse(response3?['startdate']);
                   final nextBilling = billingStart.add(Duration(days: 30)); 
                   bool isThisBillingPeriod(DateTime day) {
                     return day.isAfter(billingStart) && day.isBefore(nextBilling);
                   }
                   
                       final responsee = await Supabase.instance.client.from('detail').select().eq('company', company);
                   List inthisbilling = [];
                             if (response3?['subscription'] != null){
                               for (final entry in responsee){
                   if (isThisBillingPeriod(DateTime.parse(entry['starttime']))){
                   inthisbilling.add(entry);
                   }
                               }
                             if (response3?['subscription'] == 'Basic'){
                              
                               if (inthisbilling.length == 500){
                                 sendwarning = true;
                               }
                             } else if (response3?['subscription'] == 'Pro'){
                               
                               if (inthisbilling.length == 1000){
                                 sendwarning = true;
                               }
                             }
                             }
                          }
                   print('stop lying $role');
                         if (role == 'admin') {
                            navContext.go('/admindashboard', extra: {'sendwarning': sendwarning});
                         } else {
                          navContext.go('/dashboard');
                         }
                       }}
                                 else {
                    errorText = "Please don't leave a field blank";
                    setState(() {
                      
                    });
                                                     
            }
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
                    width: MediaQuery.of(context).size.width < 530 ? 300 : 350,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      gradient: LinearGradient(
                        colors: [Colors.white, hovering  == false ? const Color.fromARGB(255, 115, 192, 255) : const Color.fromARGB(255, 64, 154, 228), Colors.white]
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                     child: 
                      Center(child: Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 15),)),
                   
                   ),
                 ),
               ),
             )
          ],)
        ),
      ),
    ),
      )
    ))
);
}
}