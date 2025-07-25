import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:go_router/go_router.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
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


class CustomToast {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _ToastContent(message: message),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _ToastContent extends StatelessWidget {
  final String message;

  const _ToastContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 500, // 👈 This will now work!
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 31, 31),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 10, ),
            Text(
              message,
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomToast2 {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _ToastContent2(message: message),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _ToastContent2 extends StatelessWidget {
  final String message;

  const _ToastContent2({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 250, // 👈 This will now work!
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 63, 128, 26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.task_alt, color: Colors.white),
            SizedBox(width: 10, ),
            Text(
              message,
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class AdminDash extends StatefulWidget {
 final bool? sendwarning;
  const AdminDash({super.key, required this.sendwarning});

  @override
  State<AdminDash> createState() => _LoginState();
}

class _LoginState extends State<AdminDash> {

bool selected1 = true;
bool selected2 = false;
bool selected3 = false;
bool selected4 = false;
bool selected6 = false;
String username = 'user';
bool selected5 = false;
bool hovering = false;

bool isHovered1 = false;
bool isHovered2 = false;
bool isHovered3 = false;
bool isHovered4 = false;


  double fontSizeBasedOnLength(String text) {
    print('textler ${text.length}');
                  if (text.length > 1 && text.length <= 15){
                    return 13.5;
                  }
                   else if (text.length > 15){
                    return 10.00;
                  } else {
                    return 17;
                  }
                }
                

void _launchURL() async {
  final url = Uri.parse('https://flowleansolutions.com/billing');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}



List<String> morning = ['Rise and shine', 'Good morning!', "Let's make today awesome!", "Morning, what's on the schedule today?",
"Let's get this day started.", "Ready to knock out some tasks?"];
List<String> afternoon = ['Hey there!', 'Good afternoon!', "Hope you're having a good day.", 'Stretch break?', 
'You got this!', 'Have a good day!', "How's the day so far?"];
List<String> evening = ['Good evening!', 'How did your day go?', "Hope you're having a good evening.", "The day's almost done. Or just starting?"];
List<String> night = ["Up late? Let's get productive", "Hope you have a good night.", 'Hey there, hope you are having a good night.'];

String greeting(){
   
  if (DateTime.now().hour >= 5 && DateTime.now().hour < 12){
    
    return morning[0];
  } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17){
return afternoon[0];
  } else if (DateTime.now().hour >= 17 && DateTime.now().hour <= 21){
    return evening[0];
  } else {
    return night[0];
  }
}




 String? _role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    if (widget.sendwarning == true){
   WidgetsBinding.instance.addPostFrameCallback((_) {
      Warning();
   });
    }
  morning.shuffle();
  afternoon.shuffle();
  evening.shuffle();
  night.shuffle();
  Timer.periodic(Duration(minutes: 1), (timer){
  setState(() {
    
  });
});

  }

void Warning() {
showDialog(context: context, builder: (_) => StatefulBuilder(
  builder:(context, setLocalState) => AlertDialog(
backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.all(0),
  
    content: Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 193, 188),
                    ),
                    child: Icon(
                    Icons.warning, color: Colors.red, size: 50,
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text('Warning!', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 25),),
                  SizedBox(height: 13,),
                  Text('You have reached your monthly \ntransaction limit.',  textAlign: TextAlign.center,style: TextStyle(fontFamily: 'WorkSans'),),
                  SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                                    width:   150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(7)
                                    ), child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                          setState(() {
                                            
                                          });
                                        },
                                        child: Center(child: Text('Close', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize:18),),)),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                     Container(
                                    width:   150,
                                    height:  40,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(width: 0.5, color: Colors.black),
                                      borderRadius: BorderRadius.circular(7)
                                    ), child: Center(child: 
                                    Text('Upgrade', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 0, 0, 0), fontSize:18,)),),
                                  ),
                      ],
                    )

        ],
      ),
  )
  
  )));
}
  Future<void> _loadUserRole() async {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email;

    final response = await Supabase.instance.client.from('user').select().eq('email', email ?? 'Hi').single();
    final role = response['role'];

    setState(() {
      _role = role;
      _loading = false;
    });
  }

  bool didntpayed = false;

Future<void> didntPay () async{
final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email;

    final response = await Supabase.instance.client.from('user').select().eq('email', email ?? 'Hi').single();
    final company = response['company'];
    final response1 = await Supabase.instance.client.from('company').select().eq('companyname', company).single();
    final enddate = response1['enddate'];
    if (enddate != null){
      if ((DateTime.parse(enddate)).difference(DateTime.now()).inDays <= 1){
        didntpayed = true;
      }
    }
}
@override
Widget build(BuildContext content){
    

    if (_role == 'user' || Supabase.instance.client.auth.currentSession == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Image.asset(
              'images/restrict.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

if (didntpayed == true){
  return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
            
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *0.13188,
                    height: MediaQuery.of(context).size.height * 0.27251,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    color: const Color.fromARGB(255, 255, 193, 188),
                    ),
                    child: Icon(
                    Icons.warning, color: Colors.red, size: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text('Membership Expired', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.height * 0.059242),),
          SizedBox(height: 40,),
          Container(
            width:  MediaQuery.of(context).size.width * 0.229358,
            height:MediaQuery.of(context).size.height * 0.059242,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10)
            ), child: Center(child: Text('Renew', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.026066),),),
          )
                ],
              )
            ),
          ),
        ),
      );
}



return
   Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 244, 254),
      body: Row(children: [
        Container(
          height: double.infinity,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
           bottomLeft: Radius.circular(0,),
           bottomRight: Radius.circular(6),
          topRight: Radius.circular(6),
          topLeft: Radius.circular(0)
            ),
           color: const Color.fromARGB(255, 0, 74, 123),
          ),
        
          child: Column(
            children: [
              
              SizedBox(height:MediaQuery.of(context).size.height * 0.15,),
             Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                            selected1 = true;
                            selected2 = false;
                            selected3 = false;
                            selected4 = false;
                            selected5 = false;
                               selected6 = false;
                          });
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected1 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Row(
                            children: [
                                SizedBox(width: 7),
                                 Icon(Icons.home, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                 SizedBox(width: 5),
                              Text('Dashboard',  textAlign: TextAlign.center, style: TextStyle(
                                color: selected1 ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20, fontWeight: FontWeight.w500),),
                            ],
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
              SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
            Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                          context.go('/materials');
                            selected1 = false;
                            selected2 = true;
                            selected3 = false;
                            selected4 = false;
                            selected5 = false;
                               selected6 = false;
                          });
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected2 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.pageview_outlined, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Materials',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
                SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
                 Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                        context.go('/process');
                            selected1 = false;
                            selected2 = false;
                            selected3 = false;
                            selected4 = false;
                            selected5 = false;
                            selected6 = true;
                          });
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected6 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.forklift, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Process',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
            SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
            Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                           context.go('/data');
                            selected1 = false;
                            selected2 = false;
                            selected3 = false;
                            selected4 = true;
                            selected5 = false;
                               selected6 = false;
                          });
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected4 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.table_view, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Data',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
        
            SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
               Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                           context.go('/users');
          
                            selected1 = false;
                            selected2 = false;
                            selected3 = true;
                            selected4 = false;
                            selected5 = false;
                               selected6 = false;
                          });
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected3 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.group, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Users',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
                 SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
            Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                            
                                   context.go('/route');
                            selected1 = false;
                            selected2 = false;
                            selected3 = false;
                            selected4 = false;
                            selected5 = true;
                               selected6 = false;
    
        
                         
                         
                          });
                        
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected5 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.turn_slight_right, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Route',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
             SizedBox(height:MediaQuery.of(context).size.height * 0.018,),
              Align(
              alignment: Alignment.centerLeft,
               child: Row(
                 children: [
                  SizedBox(width: 10), 
                   MouseRegion(
                    cursor: SystemMouseCursors.click,
                     child: GestureDetector(
                         onTap: (){
                          setState(() {
                                    context.go('/reports');
                         
                          });
                        
                          },
                          child: Container(
                            width: 165,
                            height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                           
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                  SizedBox(width: 7),
                                   Icon(Icons.bar_chart, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                   SizedBox(width: 5),
                                Text('Reports',  textAlign: TextAlign.center, style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20, fontWeight: FontWeight.w500),),
                              ],
                            ),
                          )),
                                   ),
                   ),
                 ],
               ),
             ),
                          Spacer(),
                             Row(
                              children: [
                                SizedBox(width: 40),
                                TextButton(
                                  onPressed: () async {
                                  context.go('/login');
                                    await Supabase.instance.client.auth.signOut();
                                   
                                        setState(() {
                                          
                                        });
                                  },
                                  child: Text('Logout',  textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, 
                                color:  const Color.fromARGB(255, 177, 220, 255),),)),
                                 SizedBox(width: 10),
                           Icon(Icons.logout, color:  const Color.fromARGB(255, 177, 220, 255),)
                           
                              ],
                            ), SizedBox(height: 20,),            
            ],
          ),
         
        ),
         Expanded(
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
           
            children: [
             SizedBox(height: 20),
             Row(children: [
              SizedBox(width: 40,),
              Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color:  const Color.fromARGB(255, 23, 85, 161), fontSize: 30 ) ),
              Spacer(),
             Container(
              width: 140,
              height: 45,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 107, 188, 255),
                borderRadius: BorderRadius.circular(10)
              ),
               child: Center(
                 child: FutureBuilder(
                   future: Supabase.instance.client.from('company').select(), // returns Future<Map<String, dynamic>?>
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return CircularProgressIndicator();
                     } else if (snapshot.hasError) {
                       return Text('Error: ${snapshot.error}');
                     } else if (!snapshot.hasData || snapshot.data == null) {
                       return Text('No data');
                     }
                 
                     final data1 = snapshot.data ?? [];
                   
                     return DropdownButtonHideUnderline(child: 
                     DropdownButton(
                      onChanged: (value){
if (value == 'Upgrade'){
_launchURL();
} else if (value == 'Cancel'){
   showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
),
        content: SizedBox(
            width: 330,
            height: 230,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 18),
                 Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 193, 188),
                      ),
                      child: Icon(Icons.error, color: Colors.red, size: 28,)),
                  SizedBox(height: 10,),
                  Text('Unsubscribe?', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 10,),
                  Text('Are you sure you would like to\n cancel your subscription?', textAlign: TextAlign.center, style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 15),),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                                      width: 140,
                                      height: 35,
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      border: Border.all(width: 0.5, color: Colors.black),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector
                                          ( onTap: (){
                                          Navigator.pop(context);
                                          },
                                            child: Center(child: Text('Cancel', style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 0, 0, 0))))),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6,),
                                    Container(
                                  width: 140,
                                  height: 35,
                                  decoration: BoxDecoration(
                                  color: Colors.red,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector
                                      ( onTap: () async {
                                          // CustomToast2.show(context, 'Cancellation successful.');
                                          
                                        final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;
                                         final url = Uri.parse('https://rmotaezqlbiiiwwiaomh.supabase.co/functions/v1/cancel-subscription');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: '{}', 
  );

  if (response.statusCode == 200) {
    print('success ${response.body}');
      CustomToast2.show(context, 'Cancellation successful.');
    
  } else {
    print('error ${response.body}');
     CustomToast.show(context, 'Cancellation failed. If error persits, contact our team.');
  }
                                      },
                                        child: Center(child: Text('Unsubscribe', style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 255, 255, 255))))),
                                    ),
                                  ),
                                )
                    ],
                  )
              
                       ] ),
            ),
          )
      ),
      );
 
  setState(() {
    
  });
}

                      },
                      value: 'Main',
                      items: [
                      
                      DropdownMenuItem(
                        value: 'Main',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Plan: ${data1[0]['subscription']}', style: TextStyle(fontFamily: 'Inter', fontSize: 18),),
                        )),
                        DropdownMenuItem(
                        value: 'Upgrade',
                        child: Text('Upgrade', style: TextStyle(fontFamily: 'Inter', fontSize: 18),)),
                        DropdownMenuItem(
                        value: 'Cancel',
                        child: Text('Unsubscribe', style: TextStyle(fontFamily: 'Inter', fontSize: 18),)),
                      ],
                      
                      )
                       );
                   },
                 ),
               ),
             ),
             SizedBox(width: MediaQuery.of(context).size.width < 1500 ? 50 : 150,)
             ],
),
            SizedBox(height: 10),
            Align(
             alignment: Alignment.topLeft,
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             
             Row(
               children: [
                SizedBox(width: 40),
                 StatefulBuilder(
                   builder: (context, setLocalState) {
                     return MouseRegion(
                      onEnter: (event){
                        setLocalState(() {
                          hovering = true;
                        });
                      },
                       onExit: (event){
                        setLocalState(() {
                          hovering = false;
                        });
                      },
                       child: Material(
                           
                        elevation: 11,
                        borderRadius: BorderRadius.circular(16),
                         child: Container(
                          width: MediaQuery.of(context).size.width * 0.78,
                          height: MediaQuery.of(context).size.height * 0.3 ,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                             image: AssetImage(hovering ? 'images/newforklift.png' : 'images/lightsoff2.png'),
                             fit: BoxFit.cover,
                           ),
                       
                            borderRadius: BorderRadius.circular(16),
                            // gradient: LinearGradient(
                            //   colors: [Colors.white, Colors.white,  const Color.fromARGB(255, 177, 220, 255)],
                            //   begin: Alignment.centerLeft,
                            //   end: Alignment.centerRight
                            //   )
                            color: const Color.fromARGB(255, 255, 255, 255)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                              FutureBuilder(
                                future:  Supabase.instance.client.from('user').select(),
                                builder: (context, snapshot) {
                                  final user = Supabase.instance.client.auth.currentUser;
                                  final email = user?.email;
                                  final data = snapshot.data ?? [];
                                  final filteredData = data.where((entry) => entry['email'] == email,).toList();
                                  for(final entry in filteredData){
                                   username = entry['username'];
                                  }
                                  return   hovering ? Text(
                                    'Welcome, $username!', 
                                    style: TextStyle(
                                      fontSize: 40,
                                      
                             fontWeight: FontWeight.bold,
                                    shadows: [    Shadow(offset: Offset(-1, -1), color: Colors.black),
          Shadow(offset: Offset(1, -1), color: Colors.black),
          Shadow(offset: Offset(-1, 1), color: Colors.black),
          Shadow(offset: Offset(1, 1), color: Colors.black),],
                                      fontFamily: 'WorkSans',
                                      color: Colors.white, // Needed for ShaderMask to work
                                    ),
                                  ) : ShaderMask(
                         shaderCallback: (bounds) => LinearGradient(
                           colors: [const Color.fromARGB(255, 167, 202, 255), const Color.fromARGB(255, 255, 226, 81)],
                         ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                         blendMode: BlendMode.srcIn,
                         child: Text(
                           'Welcome, $username!', 
                           style: TextStyle(
                             fontSize: 40,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'WorkSans',
                             color: Colors.white, // Needed for ShaderMask to work
                           ),
                         ),
                       );
                          }   ),
                           SizedBox(height: 20),
                           MediaQuery.of(context).size.width < 530 ? SizedBox.shrink() :  Text(greeting(), style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontFamily: 'Inter'),)
                              ]
                            ),
                          
                          ),
                          ),
                       ),
                     );
                   }
                 ),
               ],
             ),
             SizedBox(height: 25),
              MediaQuery.of(context).size.width < 530 ? SizedBox.shrink() :
              
              FutureBuilder(
           future: Future.wait([Supabase.instance.client.from('masterdata').select(), Supabase.instance.client.from('detail').select()]),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
             } else if (snapshot.hasError){
              return Text('Error: ${snapshot.error}');
             }
           
           final data = snapshot.data?[0] ?? [];
           final data1 = snapshot.data?[1] ?? [];
           final filteredData = data.where((entry) {
             final start = DateTime.parse(entry['starttime']);
             final finish = entry['finishedtime'];
             if (finish == null) return false;
             final finish1 = DateTime.parse(entry['finishedtime']);
              return DateTime.now().toUtc().difference(finish1).inHours.abs() <= 24;
            
           
           }).toList();
           
           final filteredData1 = data1.where((entry) {
             
             final start = DateTime.parse(entry['starttime']);
            
              return start.difference(DateTime.now()).inDays.abs() <= 30; 
             
            
           
           }).toList();
    
           final datara = data1.where((entry) => entry['endtime'] == null);
           
           final filteredData2 = data1
               .where((entry) => entry['endtime'] != null)
             
               .toList();
    int total = 0;
               for (final entry in filteredData2){
                final startTime = DateTime.parse(entry['starttime']);
                final endTime = DateTime.parse(entry['endtime']);
                total += endTime.difference(startTime).inSeconds;
               }
           
           final avg = filteredData2.isNotEmpty ? (total / filteredData2.length  /60).toStringAsFixed(2): -1;
           final average = filteredData2.isNotEmpty   ? total/filteredData2.length : 'N/A';
           final finishedToday = filteredData.isNotEmpty ? filteredData.length : '0';
           
           final responsenumber = datara.length;
                   double fontSizeBasedOnLength(String text) {
                    
      if (text.length > 1 && text.length < 8){
        return MediaQuery.of(context).size.width * 0.02;
      }
       else if (text.length > 8 && text.length <= 13){
        return MediaQuery.of(context).size.width * 0.013;
      } else if (text.length >= 13 && text.length <= 18) {

        return MediaQuery.of(context).size.width * 0.01;
       } 
        else if (text.length >= 20) {

        return MediaQuery.of(context).size.width * 0.008;
       }  else  {
       return MediaQuery.of(context).size.width * 0.02;
        
      }
    }
           
    
             return Row(
              
               children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.023),
                 Row(
                
                   children: [
                     StatefulBuilder(
                       builder: (context, setLocalState) {
                         return MouseRegion(
                          onEnter: (event){
                          setLocalState(() {
                              isHovered1 = true;
                            });
                          },
                          onExit: (event) {
                               setLocalState(() {
                              isHovered1 = false;
                            });
                          },
                    child:   Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered1 
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 2),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
 width: isHovered1 ?  MediaQuery.of(context).size.width * .185 : MediaQuery.of(context).size.width * .18,
                  height: isHovered1 ? MediaQuery.of(context).size.width * 0.073 : MediaQuery.of(context).size.width * 0.07,
                           decoration: BoxDecoration(
                            color:  const Color.fromARGB(255, 254, 254, 254),
                            borderRadius: BorderRadius.circular(16),
                             boxShadow: isHovered1 ?  [ BoxShadow(color: const Color.fromARGB(255, 206, 186, 85), blurRadius: 10)] :   
                             [ BoxShadow(color: const Color.fromARGB(255, 174, 174, 174), blurRadius: 5)]
                           ),
                           child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                               
                              // Center(child: 
                                //  Container(
                                //    width: 40,
                                // height: 40,
                                // decoration: BoxDecoration(
                                //   color: const Color.fromARGB(255, 177, 220, 255),
                                //   borderRadius: BorderRadius.circular(10),
                                 
                                // ), child: Icon(Icons.pending_outlined, color:  const Color.fromARGB(255, 0, 55, 100), size: 30)),
                                // ),
                         
                              Row(
                            
                                children: [
                                  SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        SizedBox(width: 20,),
                                        //  Center(child: 
                                 Container(
                                   width: MediaQuery.of(context).size.width * .06,
                  height: MediaQuery.of(context).size.height * 0.11 ,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 208, 104, 0),
                                  borderRadius: BorderRadius.circular(10),
                                 
                                ), child: Icon(Icons.forklift, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                // ),
                               
                                        
                                      ],
                                    ),
                                    SizedBox(width:MediaQuery.of(context).size.width * 0.006 ,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Column(
                                                               children: [
                                                                   SizedBox(height: 15),
                                                                 Text('Active Requests', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                              fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                
                                                                 SizedBox(height: 5),
                                                                 Row(
                                                                 
                                                                   children: [
                                                                  //  MediaQuery.of(context).size.width * 0.02
                                                                    Text('$responsenumber', overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Inter', 
                                                                    fontSize: fontSizeBasedOnLength('$responsenumber'), color: const Color.fromARGB(255, 0, 0, 0)),),
                                     
                                                                   ],
                                                                 ),
                                                              
                                                               ],
                                                             ),
                                                            
                                   ],
                                 ),
                                
                                ],
                              ),
                           
                            ],),
                           ),
                           ),
                                    ))
                         );
                       }
                     ),
                     SizedBox(width: MediaQuery.of(context).size.width * 0.018),
                                          StatefulBuilder(
                       builder: (context, setLocalState) {
                         return MouseRegion(
                          onEnter: (event){
                          setLocalState(() {
                              isHovered2 = true;
                          
                            });
                          },
                          onExit: (event) {
                               setLocalState(() {
                              isHovered2 = false;
                            });
                          },
                    child:   Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered2
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 2),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                                      width: isHovered2 ?  MediaQuery.of(context).size.width * .185 : MediaQuery.of(context).size.width * .18,
                  height: isHovered2 ? MediaQuery.of(context).size.width * 0.073 : MediaQuery.of(context).size.width * 0.07,
                           decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(16),
                             boxShadow: isHovered2 ?  [ BoxShadow(color: const Color.fromARGB(255, 206, 186, 85), blurRadius: 10)] : 
                             [ BoxShadow(color: const Color.fromARGB(255, 174, 174, 174), blurRadius: 5)]
                           ),
                     child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                       
                       SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(width: 20,),
                                        //  Center(child: 
                                 Container(
                               width: MediaQuery.of(context).size.width * .06,
                  height: MediaQuery.of(context).size.height * 0.11 ,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 40, 73),
                                  borderRadius: BorderRadius.circular(10),
                                 
                                ), child: Icon(Icons.task_alt, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                // ),
                                
                                        
                                      ],
                                    ),
                                  
                        SizedBox(width:MediaQuery.of(context).size.width * 0.006 ,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                  SizedBox(height: 15),
                                Text('Finished Today', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                              fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                 
                                   Text('$finishedToday', style: TextStyle(fontFamily: 'Inter', fontSize: fontSizeBasedOnLength('$finishedToday'), color: const Color.fromARGB(255, 0, 0, 0)),),
                                   
                                  ],
                                ),
                             
                              ],
                            ),
                          ],
                        ),
                     
                      ],),
                     ),
                     )
                                    )));})
                      
                   ],
                 ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.018),
                        Row(
                   children: [
                    StatefulBuilder(
                       builder: (context, setLocalState) {
                         return MouseRegion(
                          onEnter: (event){
                          setLocalState(() {
                              isHovered3 = true;
                            });
                          },
                          onExit: (event) {
                               setLocalState(() {
                              isHovered3 = false;
                            });
                          },
                    child:   Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered3
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 2),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                                      width: isHovered3 ?  MediaQuery.of(context).size.width * .185 : MediaQuery.of(context).size.width * .18,
                  height: isHovered3 ? MediaQuery.of(context).size.width * 0.073 : MediaQuery.of(context).size.width * 0.07,
                           decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(16),
                             boxShadow: isHovered3 ?  [ BoxShadow(color: const Color.fromARGB(255, 206, 186, 85), blurRadius: 10)] : 
                             [ BoxShadow(color: const Color.fromARGB(255, 174, 174, 174), blurRadius: 5)]
                           ),
                      
                     child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                          SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                                      width: MediaQuery.of(context).size.width * .06,
                  height: MediaQuery.of(context).size.height * 0.11 ,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 189, 225, 255),
                                      borderRadius: BorderRadius.circular(10),
                                     
                                    ), child: Icon(Icons.calendar_month, color:  const Color.fromARGB(255, 255, 255, 255), size:  MediaQuery.of(context).size.width * .017)),
                                   
                                    
                          ],
                        ),
                         SizedBox(width:MediaQuery.of(context).size.width * 0.006 ,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                   SizedBox(height: 15),
                                Text('Total (30 days)', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                              fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                               SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text('${filteredData1.length}', style: TextStyle(fontFamily: 'Inter', fontSize: fontSizeBasedOnLength('${filteredData1.length}'), color: const Color.fromARGB(255, 0, 0, 0))),
                                   
                                  ],
                                ),
                                
                              ],
                            ),
                          ],
                          
                        ),
                     
                      ],),
                     ),
                     ))
                         ));
                       }),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.018),
                     
                     
                   StatefulBuilder(
                       builder: (context, setLocalState) {
                         return MouseRegion(
                          onEnter: (event){
                          setLocalState(() {
                              isHovered4 = true;
                            });
                          },
                          onExit: (event) {
                               setLocalState(() {
                              isHovered4 = false;
                            });
                          },
                    child:   Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered4
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 2),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                                      width: isHovered4 ?  MediaQuery.of(context).size.width * .185 : MediaQuery.of(context).size.width * .18,
                  height: isHovered4 ? MediaQuery.of(context).size.width * 0.073 : MediaQuery.of(context).size.width * 0.07,
                           decoration: BoxDecoration(
                            color:  const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(16),
                             boxShadow: isHovered4 ?  [ BoxShadow(color: const Color.fromARGB(255, 206, 186, 85), blurRadius: 10)] : 
                             [ BoxShadow(color: const Color.fromARGB(255, 174, 174, 174), blurRadius: 5)]
                           ),
                     child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                        children: [
                            SizedBox(height: 10),
                       Row(
                          children: [
                            SizedBox(width: 20),
                            Container(
                                       width: MediaQuery.of(context).size.width * .06,
                  height: MediaQuery.of(context).size.height * 0.11 ,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(10),
                                     
                                    ), child: Icon(Icons.schedule, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                   
                          ],
                        ),
                        SizedBox(width:MediaQuery.of(context).size.width * 0.006 ,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                   SizedBox(height: 15),
                                Text('Avg. Time', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                              fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                               SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text(avg == -1 ? 'N/A' : '$avg', style: TextStyle(fontFamily: 'Inter', fontSize: fontSizeBasedOnLength((avg == -1 ? 'N/A' : '$avg')), color: const Color.fromARGB(255, 0, 0, 0))),
                                  
                                  ],
                                ),
                                
                              ],
                            ),
                          ],
                        ),
                          
                     
                      ],),
                     ),
                     ))));
                       }),
                   ],
                 ),
             
               ],
             );
           }
              )
           ],
              ),
            ),
            SizedBox(height: 30,),
            // Row(
            //   children: [
            //     SizedBox(width: 50,),
            //     Text('Weekly Recap', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 20),),
            //   ],
            // ),
            SizedBox(height: 0,),
            Row(
              children: [
                SizedBox(width: 30,),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width * .79,
                      height: MediaQuery.of(context).size.height * 0.37,
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        color:  Color(0xFFFAFAFA),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Text('Weekly Requests', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'WorkSans', fontSize: 23),),
                                  ],
                                )),
                              SizedBox(height: 10,),
                    
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .79,
                      height: MediaQuery.of(context).size.height * 0.290,
                               child: FutureBuilder(
                                 future: Supabase.instance.client.from('masterdata').select(),
                                 builder: (context, snapshot) {
                                  print('width: ${MediaQuery.of(context).size.width}, height: ${MediaQuery.of(context).size.height} ');
                                  double roundMaxY(double maxY) {
                          if (maxY <= 5) return 5;
                        
                          // Find the nearest multiple of 5 or 10 above maxY
                          int base = 10;
                          if (maxY < 20) base = 5;
                          return (maxY / base).ceil() * base.toDouble();
                        }
                                  final data = snapshot.data ?? [];
                        
                                  bool isThisWeek(DateTime day) {
                          final now = DateTime.now().toUtc();
                          final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1)); // Monday at 00:00
                          final endOfWeek = startOfWeek.add(const Duration(days: 7)); // Next Monday at 00:00 (exclusive)
                        
                          return day.isAtSameMomentAs(startOfWeek) || 
                                 (day.isAfter(startOfWeek) && day.isBefore(endOfWeek));
                        }
                                  final mondayData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.monday && isThisWeek(dayOfWeek);
                                  });
                                   final tuesdayData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.tuesday && isThisWeek(dayOfWeek);
                                  });
                                   final wednesdayData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.wednesday && isThisWeek(dayOfWeek);
                                  });
                                   final thursdayData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.thursday && isThisWeek(dayOfWeek);
                                  });
                                   final fridayData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.friday && isThisWeek(dayOfWeek);
                                  });
                                   final satData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.saturday&& isThisWeek(dayOfWeek);
                                  });
                                   final sunData = data.where((entry){
                                    final dayOfWeek = DateTime.parse(entry['starttime']).toLocal();
                                    return dayOfWeek.weekday == DateTime.sunday&& isThisWeek(dayOfWeek);
                                  });
                        
                        final datar = data.where((entry) => isThisWeek(DateTime.parse(entry['starttime'])));
                                  
                                   return Padding(
                                     padding: const EdgeInsets.all(25),
                                     child: BarChart(
                                      
                                     
                                      BarChartData(
                                        
                                    barTouchData: BarTouchData(
                                      
                                      enabled: true,
                                      touchTooltipData: BarTouchTooltipData(
                                        tooltipBorderRadius: BorderRadius.circular(13),
                                        maxContentWidth: 40,
                                      
                                        getTooltipColor: (groups){
                                          return Colors.transparent;
                                        } ,
                                        getTooltipItem:(group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                  '${rod.toY.toInt()}',
                                  TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter', fontSize: 20, height: 0)
                                 
                                  );
                                  
                                        },
                                      ),
                                    ),
                                               maxY: roundMaxY (datar.length.toDouble()),
                                             borderData: FlBorderData(show: false),
                                             gridData: FlGridData(show: false),
                            //                     gridData: FlGridData(
                            //   show: true,
                            //   drawHorizontalLine: true,
                            //   drawVerticalLine: false, // 🔥 disables vertical lines
                            //   getDrawingHorizontalLine: (value) => FlLine(
                            //     color: Colors.grey.withOpacity(0.2),
                            //     strokeWidth: 1,
                            //   ),
                            // ),
                                     barGroups: [
                                     BarChartGroupData(x: 0 ,barRods: [BarChartRodData(toY: mondayData.length.toDouble(),  width:  MediaQuery.of(context).size.width * .026,
                     gradient:LinearGradient(colors: [const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 1 ,barRods: [BarChartRodData(toY: tuesdayData.length.toDouble(),  width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors:[const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 2 ,barRods: [BarChartRodData(toY: wednesdayData.length.toDouble(), width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors:[const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 3 ,barRods: [BarChartRodData(toY: thursdayData.length.toDouble(),width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors:[const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 4 ,barRods: [BarChartRodData(toY: fridayData.length.toDouble(),width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors: [const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 5 ,barRods: [BarChartRodData(toY: satData.length.toDouble(),  width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors: [const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                      BarChartGroupData(x: 6 ,barRods: [BarChartRodData(toY: sunData.length.toDouble(),  width:  MediaQuery.of(context).size.width * .026, gradient:LinearGradient(colors: [const Color.fromARGB(255, 183, 223, 255), const Color.fromARGB(197, 19, 101, 169)],
                                      ),
                                       borderRadius: BorderRadius.circular(10))]),
                                     
                                     ],
                                               titlesData: FlTitlesData(
                                             leftTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                               showTitles: true,
                                              
                                               interval:
                                              roundMaxY (datar.length.toDouble()) >= 5 ?
                                               (  roundMaxY (datar.length.toDouble()) == 0 ? 10 :   roundMaxY (datar.length.toDouble()) % 5 == 0 ?   roundMaxY (datar.length.toDouble()) : roundMaxY(data.length.toDouble()))/5 : 1,
                                                getTitlesWidget: (value, meta) {
                                                 
                                                  return Text('${value.toInt()}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 0, 86, 179)),);
                                             
                                                },
                                              )
                                             ),
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: false),
                                          ),
                                     bottomTitles: AxisTitles(
                                       sideTitles: SideTitles(
                                         showTitles: true,
                                         reservedSize:40,
                                         getTitlesWidget: (value, meta) {
                                           
                                           List labels =   MediaQuery.of(context).size.width < 750 ? 
                                             ['M', 'T', 'W', 'T', 'F', 'S', 'S' ]
                                            : 
                                           ['Monday', 'Tuesday', 'Wednesday', 'Thursday ', 'Friday', 'Saturday', 'Sunday' ];
                                           if (value.toInt()< 0 || value.toInt() >= labels.length) return Container();
                                           return Padding(
                                             padding: EdgeInsetsGeometry.only(top: 3),
                                             child: Column(
                                               children: [
                                                SizedBox(height: 17),
                                                 Text(labels[value.toInt()],
                                                 style: TextStyle(
                                                   fontFamily: 'WorkSans',
                                                   color: const Color.fromARGB(255, 83, 83, 83),
                            
                                                 ),
                                                 
                                                 ),
                                               ],
                                             )
                                             );
                                         },
                                       )
                                     ),
                                           rightTitles: AxisTitles(
                                            
                                             sideTitles: SideTitles(showTitles: false,
                                           
                                     
                                             ),
                                             
                                           
                                           ),),  
                                     
                                     ),
                                     
                                              //         barGroups: [
                                              //   BarChartGroupData(
                                              //     x: 0,
                                              //     barRods: [BarChartRodData(toY: 10, width: 16, color: Colors.blue)],
                                              //   ),
                                              //   BarChartGroupData(
                                              //     x: 1,
                                              //     barRods: [BarChartRodData(toY: 12, width: 16, color: Colors.orange)],
                                              //   ),
                                              // ],
                                      ),
                                   );
                                 }
                               ),
                             ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
               
           ],),
         ),
         
      ],)
    );
 
}
}