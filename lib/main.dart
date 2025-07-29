import 'package:flutter/material.dart';
import 'package:mbi2/addbutton.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
setUrlStrategy(PathUrlStrategy());
  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );



   runApp(MyApp());
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


class Mbi extends StatefulWidget {
   final bool? sendwarning;
  const Mbi({super.key, required this.sendwarning});

  @override
  State<Mbi> createState() => _MbiState();
}

class _MbiState extends State<Mbi> {
  bool hovering = false;
  bool ialwaysfalse = false;
  bool selected1 = true;
  

  bool selected2 = false;

  bool selected3 = false;
  double fontSizeBasedOnLength(String text) {
  if (text.length > 30){
    return 10;
  }
   else if (text.length > 20){
    return 15;
  } else if (text.length > 15){
    return 22;
  } else {
    return 20;
  }
}
  // String? defaults;
String usernames = '';
int minutesElapsed = 0;
List machines = [];
@override
initState(){
if (widget.sendwarning == true){
   WidgetsBinding.instance.addPostFrameCallback((_) {
      Warning();
   });
    
}
  super.initState();
  morning.shuffle();
  afternoon.shuffle();
  evening.shuffle();
  night.shuffle();
  WidgetsBinding.instance.addPostFrameCallback((_) {
  fetchUsername();
});
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
                  Text('You have reached your monthly \ntransaction limit.',  textAlign: TextAlign.center,style: TextStyle(fontFamily: 'WorkSans', fontSize: 18),),
                  SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                                        Navigator.pop(context);
                                        setState(() {
                                          
                                        });
                            },
                            child: Container(
                              width:   150,
                              height: 40,
                              decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(7)
                                        ),
                              child: Center(child: Text('Close', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize:18),),),
                            ),
                          ),
                        ),
                      ],
                    )

        ],
      ),
  )
  
  )));
}
Future machineFetch() async {
  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response0 = await Supabase.instance.client.from('user').select().eq('email', email ?? 'hi').maybeSingle();
  username = response0?['username'];
  final response1 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', email ?? '').maybeSingle();
  final response3 = await Supabase.instance.client.from('process_users').select().eq('userpu', email ?? '').or('disabled.is.null,disabled.not.eq.true');
  return [response3, response1, username];
}

String username = '';
String? allowedProcess;
String? fetchedUsername;
String? fetchedUsernamer;
Map<int, bool> isHovered = {};
Map<int, bool> isHovered2 = {};
ValueNotifier loadingUser  = ValueNotifier(true);

String? alone = 'true';
Future fetchUsername() async {
  setState(() {
    loadingUser.value = true;
  });

  final user = Supabase.instance.client.auth.currentUser;

  print('user $user');
  


  final email = user?.email;
print('emil $email');
  final response = await Supabase.instance.client
      .from('user')
      .select()
      .eq('email', email ?? 'hi')
      .maybeSingle();

  fetchedUsernamer = response?['username'] ?? 'hi';
    fetchedUsername = email ?? 'hi';
print(' fetched $fetchedUsername');

  if (fetchedUsername != null) {
    final response3 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', fetchedUsername ?? 'hi').maybeSingle();
    print('response3 $response3');
    if (response3 != null){
      allowedProcess = response3['machine'];

    } 
  } else {
    final response2 = await Supabase.instance.client
        .from('process_users')
        .select()
        .eq('userpu', fetchedUsername ?? 'hi')
        .or('disabled.is.null,disabled.not.eq.true');
 print('response2 $response2');
    if (response2 != null && response2.isNotEmpty) {
      
      allowedProcess = response2[0]['processpu'];
    } else {
      allowedProcess = ''; // or handle the missing data case
    
  

    
    }}
   
   print('allo $allowedProcess');
       final response10 = await Supabase.instance.client.from('process_users').select().eq('processpu', allowedProcess ?? "").or('disabled.is.null,disabled.not.eq.true');

          if (response10.length > 1){
            
            alone = 'false';
            
          } else {
           alone = 'true';
          }


print('alone $alone');
    return {
    'username': fetchedUsername,
    'allowedProcess': allowedProcess,
    'alone': alone
  };
}


List<String> morning = ['Rise and shine!', 'Good morning!', "Let's make today awesome!", "Morning, what's on the schedule today?",
"Let's get this day started.", "Ready to knock out some tasks?"];
List<String> afternoon = ['Hey there!', 'Good afternoon!', "Hope you're having a good day.", 'Stretch break?', 
'You got this!', 'Have a good day!', "How's the day so far?"];
List<String> evening = ['Good evening!', 'How did your day go?', "Hope you're having a good evening.", "The day's almost done. Or just starting?"];
List<String> night = ["Up late? Let's get productive", "Hope you have a good night.", 'Hey there, hope you are having a good night.'];

String greeting(){
  
  if (DateTime.now().hour >= 5 && DateTime.now().hour <= 11){
    return 'Good Morning';
  } else if (DateTime.now().hour >= 12 && DateTime.now().hour <= 17){
return 'Good Afternoon';
  } else if (DateTime.now().hour >= 17 && DateTime.now().hour <= 20){
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

Icon greetingIcon(){
if (DateTime.now().hour >= 5 && DateTime.now().hour < 11){
    return Icon(Icons.wb_twighlight);
  } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 17){
   return Icon(Icons.wb_sunny);
  } else if (DateTime.now().hour >= 17 && DateTime.now().hour <= 20){
    return Icon(Icons.bedtime);
  } else {
    return Icon(Icons.nights_stay);
}}

int? id;

String selectedMaterial = 'Please select a material';
String selectedTime1 = 'Please select a time';
String selectedStep1 = 'Please select a step';
String selectedTime2 = 'Please select a time';

String selectedStep2 = 'Please select a step';
String selectedProcess = 'Please select a process';

bool materialSelected = true;
bool processSelected = false;
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
    

    if (Supabase.instance.client.auth.currentSession == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
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
          // Container(
          //   width:  MediaQuery.of(context).size.width * 0.229358,
          //   height:MediaQuery.of(context).size.height * 0.059242,
          //   decoration: BoxDecoration(
          //     color: Colors.red,
          //     borderRadius: BorderRadius.circular(10)
          //   ), child: Center(child: Text('Renew', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: MediaQuery.of(context).size.height * 0.026066),),),
          // )
                ],
              )
            ),
          ),
        ),
      );
}
     
   return Scaffold(
    floatingActionButton: AddButton(),
 backgroundColor: Color.fromARGB(255, 236, 244, 254),
  body: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
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
      
        child: Row(
          children: [
            Column(
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
                            });
                            },
                            child: Container(
                              width: 165,
                              height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selected1 ?  const Color.fromARGB(255, 0, 55, 100) : null,
                              ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                    SizedBox(width: 7),
                                     Icon(Icons.home, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                     SizedBox(width: 5),
                                  Text('Dashboard',  textAlign: TextAlign.center, style: TextStyle(
                                    color: selected1 ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 20, fontWeight: FontWeight.w500, 
                                    ),),
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
                            
                           context.go('/inbound');
                            setState(() {
                              selected1 = false;
                              selected2 = true;
                              selected3 = false;
                            });
                            },
                            child:Container(
                          width: 175,
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
                              Text('Inbound',  textAlign: TextAlign.center, style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20, fontWeight: FontWeight.w500),),
                                 SizedBox(width: 5),
                                  StreamBuilder(stream: Supabase.instance.client.from('detail').stream(primaryKey: ['id']), builder:(context, snapshot) {
                                    
                                     final data = snapshot.data ?? [];

                                     final filteredData = data.where((entry) => entry['endtime'] == null && entry['process'] == allowedProcess && ((entry['current_user'] == null && entry['user_unique'] == null) || ((entry['current_user'] == fetchedUsernamer|| entry['user_unique'] ==
                                      fetchedUsernamer) )));
                                     return                               Flexible(
                                       child: Text('(${filteredData.length})',  textAlign: TextAlign.center, style: TextStyle(
                                                                       color:filteredData.isEmpty ?  const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 253, 242, 143),
                                                                         fontSize: filteredData.length > 9 ? 13.5 : 16, fontWeight: FontWeight.w500),),
                                     );
                                   },),
                                  
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
                            
                              context.go('/outbound');
                            setState(() {
                              selected1 = false;
                              selected2 = false;
                              selected3 = true;
                            });
                            },
                            child:  Container(
                          width: 175,
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
                                 Icon(Icons.pageview_outlined, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                 SizedBox(width: 3),
                              Text('Outbound',  textAlign: TextAlign.center, style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20, fontWeight: FontWeight.w500),),
                                 SizedBox(width: 5),
                                   StreamBuilder(stream: Supabase.instance.client.from('masterdata').stream(primaryKey: ['id']), builder:(context, snapshot) {
                                     final data = snapshot.data ?? [];
                                     final filteredData = data.where((entry) => entry['usernamem'] == fetchedUsername && entry['finishedtime'] == null);
                                     return                               Flexible(
                                       child: Text('(${filteredData.length})',  textAlign: TextAlign.center, style: TextStyle(
                                                                       color: filteredData.isEmpty ?  const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 253, 242, 143),
                                                                         fontSize: filteredData.length > 9 ? 13.5 : 16, fontWeight: FontWeight.w500),),
                                     );
                                   },)
                            ],
                          ),
                        )),
                                     ),
                     ),
                   ],
                 ),
               ),
                             Spacer(),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: (){
                                   Supabase.instance.client.auth.signOut();
                                  context.go('/login');
                                  },
                                  child:  Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 40),
                                            Column(
                                              children: [
                                                Text('Logout',  textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, 
                                                color:  const Color.fromARGB(255, 177, 220, 255),),),
                                              ],
                                            ),
                                             SizedBox(width: 10),
                                                                     Icon(Icons.logout, color:  const Color.fromARGB(255, 177, 220, 255),)
                                          ],
                                        ),
                                         SizedBox(height: 20,),
                                      ],
                                    ),
                                ),
                              ),
                               SizedBox(height: 20,)
              ],
            ),
           
          ],
        ),
      ),
    //  loadingUser.value ? Center(
      
    //   child: Row(
    //     children: [
    //       SizedBox(width: 750,),
    //       CircularProgressIndicator(color: Colors.blue,),
    //     ],
    //   )) : 
    Column(
       mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
           [
           
            Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Row(

                  children: [
                    SizedBox(width: 40),
                  
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: FutureBuilder(
                                              future: machineFetch(),
                                              builder: (context, snapshot) {
                                               if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                                                loadingUser.value = true;
                                               }
                                             
                                               final datas = snapshot.data ?? [];
                                            
                                                                                     
                                            
                                               
                                               
                                                              if (datas is! List || datas.length < 2 || snapshot.data == null) {
                                                                loadingUser.value = true;
                                                                 return Text('Dashboard - ', style: TextStyle(
                                                                      fontFamily: 'WorkSans',
                                                                      color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30));
                                                                      
                                                              }
                                                          
                                                final data = snapshot.data[0] ?? {};
                                               
                                               final data2 = snapshot.data[1] ?? {};
                                                          final machine = (data2 is Map<String, dynamic>) ? data2['machine'] : null;
                                                                                     
                                                  
                                             data.sort((a, b) {
                                                            if (a['processpu'] == machine) return -1;
                                                            if (b['processpu'] == machine) return 1;
                                                            return 0;
                                                          });
                                                          final processList = data.map((e) => e['processpu']).toList();
                                                         String? defaults = processList.contains(machine)
                                                ? machine
                                                : (processList.isNotEmpty ? processList.first : null);
                                                                                     
                                                if (data.length == 1){
                                                return Text('Dashboard - $defaults', style: TextStyle(
                                                                      fontFamily: 'WorkSans',
                                                                      color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30));
                                              } else {
                                                return Row(children: [
                                                 Text('Dashboard - ', style: TextStyle(
                                                                      fontFamily: 'WorkSans',
                                                                      color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
                                                                      SizedBox(width: 5,),
                                                                      DropdownButtonHideUnderline(
                                                                        child: DropdownButton<String>(
                                                                          value: defaults,
                                                                         items: processList.toSet().map<DropdownMenuItem<String>>((process) {
                                                            return DropdownMenuItem<String>(
                                                              value: process,
                                                              child: Text(
                                                                process,
                                                                style: TextStyle(
                                                                  fontFamily: 'WorkSans',
                                                                  color: const Color.fromARGB(255, 23, 85, 161),
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 30,
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                                          onChanged: (value) async {
                                                                            
                                                                           final user = Supabase.instance.client.auth.currentUser;
                                                            final email = user?.email;
                                                            final response0 = await Supabase.instance.client.from('user').select().eq('email', email ?? 'hi').maybeSingle();
                                                            final company = response0?['company'];
                                                            final responses = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
                                                     defaults = value!;
                                                                          
                                                                          responses == null ?
                                                                          await Supabase.instance.client.from('user_machine').insert({
                                                                            'machine': defaults,
                                                                            'company': company,
                                                                            'user_mac': username,
                                                                          }) : await Supabase.instance.client.from('user_machine').update({
                                                                           'machine': defaults,
                                                                          }).eq('user_mac', username);
                                                                        setState(() {
                                                                            defaults = value;
                                                                          });
                                                                          },
                                                                        ),
                                                                      ),
                                                ],);
                                              }
                                              }
                                            ),
                                          ),
                                        
                  ],
                )),
                  SizedBox(height: 20),
        
        Align(
        alignment: Alignment.centerLeft,
         child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
                        borderRadius: BorderRadius.circular(16),
                        color: const Color.fromARGB(255, 255, 255, 255),
                          image: DecorationImage(
                                   image: AssetImage(hovering ? 'images/newforklift.png' : 'images/lightsoff2.png'),
                                   fit: BoxFit.cover,
                                 ),
                        
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          FutureBuilder(
                            future: Supabase.instance.client.from('user').select(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting){
                                loadingUser.value = true;
                              }
                              final user = Supabase.instance.client.auth.currentUser;
                              final email = user?.email;
                              final data = snapshot.data ?? [];
                               final filteredData = data.where((entry) => entry['email'] == email,).toList();
                        for(final entry in filteredData){
                         usernames = entry['username'];
                        }
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: hovering ? Text(
                                    '${greeting()}, $usernames!', 
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.07,
                                    shadows: [    Shadow(offset: Offset(-1, -1), color: Colors.black),
          Shadow(offset: Offset(1, -1), color: Colors.black),
          Shadow(offset: Offset(-1, 1), color: Colors.black),
          Shadow(offset: Offset(1, 1), color: Colors.black),],
                                      fontFamily: 'Inter',
                                      color: Colors.white, // Needed for ShaderMask to work
                                    ),
                                  ) : ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [const Color.fromARGB(255, 164, 200, 255), const Color.fromARGB(255, 255, 226, 81)],
                                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    '${greeting()}, $usernames!', 
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.07,
                                    
                                      fontFamily: 'Inter',
                                      color: Colors.white, // Needed for ShaderMask to work
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                       SizedBox(height: 20),

                          ]
                        ),
                      
                      ),
                      ),
                   ),
                 );
               }
             )])),]),
             SizedBox(width: 40,),
//          
            
          
        
        ],
        ),
        SizedBox(height: 30),
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(width: 50),
      Container(
        height: 1,
        width: MediaQuery.of(context).size.width * 0.75,
        color: const Color.fromARGB(255, 106, 106, 106),
      ),
    ],
    ),
    SizedBox(height : MediaQuery.of(context).size.height < 670 ?  5 : 20),
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
               mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 60,),
                FutureBuilder(
                   future: Future.wait([
                    Supabase.instance.client.from('masterdata').select(),
                    fetchUsername(),
                    Supabase.instance.client.from('detail').select(),
                    ]),
                   builder: (context, snapshot) {
                    print('${snapshot.data} datar');
                  if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2,));
              } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
              }
            
               
                final data3 = snapshot.data?[0] ?? [];
               final userData = snapshot.data?[1];
               final data = snapshot.data?[2] ?? [];
            print('data $data');
            if (userData == null || userData is! Map<String, dynamic> ) {
            
              return Text('');
            }
              print('loadus2 $loadingUser');
            final usernamer = userData['username'];
            final allowedProcessa = userData['allowedProcess'];
            final aloner = userData['alone'];
            
            
                final filteredData = 
                
                data
                .where((entry) => entry['usernamem'] == fetchedUsername && entry['closed'] == 1);
                   
                 
                
              
                 
                
                
                  final filteredData7 = 
                aloner == 'false' ?
                data3
                .where((entry) => entry['current_user'] == fetchedUsernamer )
                .where((entry) {
                final start = DateTime.parse(entry['starttime']);
                final finish = entry['finishedtime'];
                if (finish == null) return false;
                final finish1 = DateTime.parse(entry['finishedtime']);
                 return start.difference(finish1).inDays.abs() <= 1;
                 
                
                }).toList()
                : 
                data
                .where((entry) => entry['user_unique'] == fetchedUsernamer)
                .where((entry) {
                final start = DateTime.parse(entry['starttime']);
                final finish = entry['finishedtime'];
                if (finish == null) return false;
                final finish1 = DateTime.parse(entry['finishedtime']);
                 return start.difference(finish1).inDays.abs() <= 1;
                 
                
                }).toList();
                
                
                final filteredData1 = data3
                .where((entry) => entry['usernamem'] == fetchedUsername && entry['finishedtime'] == null);
                
              
                  final filteredData3 = 
              
                data
                .where((entry) => (entry['current_user'] == fetchedUsernamer|| entry['user_unique'] == fetchedUsernamer )  && entry['endtime'] == null && entry['process'] == allowedProcessa);
                
                  
                final filteredData2 = data
                 .where((entry) => (entry['current_user'] == fetchedUsernamer|| entry['user_unique'] == fetchedUsernamer ) && entry['usernamed'] != fetchedUsername && entry['process'] == 
                 allowedProcessa)
                  .where((entry) => entry['endtime'] != null)
               
                  .toList();
                  int total = 0;
            for (final entry in filteredData2){
                    final startTime = DateTime.parse(entry['starttime']);
                    final endTime = DateTime.parse(entry['endtime']);
                    total += endTime.difference(startTime).inSeconds;
                   }
               
               final avg1 = filteredData2.isNotEmpty ? (total / filteredData2.length  /60).toStringAsFixed(2): -1;
              
               final filteredData19 = data
                 .where((entry) => entry['usernamed'] == fetchedUsername)
                  .where((entry) => entry['endtime'] != null)
               
                  .toList();
                  int total2 = 0;
            for (final entry in filteredData19){
                    final startTime = DateTime.parse(entry['starttime']);
                    final endTime = DateTime.parse(entry['endtime']);
                    total2 += endTime.difference(startTime).inSeconds;
                   }
               
               final avg2 = filteredData19.isNotEmpty ? (total2 / filteredData19.length  /60).toStringAsFixed(2): -1;
              print('width: ${MediaQuery.of(context).size.width}, height: ${MediaQuery.of(context).size.height}');
                
            final filteredData9 = data.where((entry) => (entry['current_user'] == fetchedUsernamer || entry['user_unique'] == fetchedUsernamer)  && entry['endtime'] != null && DateTime.now().toUtc().difference(DateTime.parse(entry['endtime'])).abs().inHours <= 24
       && entry['process'] == allowedProcessa    );
       print('dataaa9 $filteredData9');
            final filteredData10 = data3.where((entry) {
              try {
            final startTime = DateTime.parse(entry['starttime']);
            final duration = DateTime.now().toUtc().difference(startTime);
            return entry['usernamem'] == fetchedUsername &&
                   entry['finishedtime'] != null &&
                   duration.inHours <= 24;
              } catch (_) {
            return false;
              }
            }).toList();
            
            
            
                    return Row(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                             onTap: (){
                                         context.go('/inbound');
                                          },
            
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), width: 
                              MediaQuery.of(context).size.width * 0.36
                              , 
                              height: MediaQuery.of(context).size.height < 420? 300 : MediaQuery.of(context).size.height * 0.5, child: Column(children: [
                              Column(
                                                    children: [
                                                     SizedBox(height : MediaQuery.of(context).size.height < 640 ?  6 : 20),
                                                      Center(child: Text('Inbound (Sent to you)', style: TextStyle(fontFamily: 'Inter', fontSize: 20),)),
                                                     
                                                    // Center(child: 
                                                      //  Container(
                                                      //    width: 40,
                                                      // height: 40,
                                                      // decoration: BoxDecoration(
                                                      //   color: const Color.fromARGB(255, 177, 220, 255),
                                                      //   borderRadius: BorderRadius.circular(10),
                                                       
                                                      // ), child: Icon(Icons.pending_outlined, color:  const Color.fromARGB(255, 0, 55, 100), size: 30)),
                                                      // ),
                                              SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                    Row(
                                                  
                                                      children: [
                                                        
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 20,),
                                                              //  Center(child: 
                                                       Container(
                                                         width: MediaQuery.of(context).size.width * .03,
                                        height: MediaQuery.of(context).size.height * 0.06 ,
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 208, 104, 0),
                                                        borderRadius: BorderRadius.circular(10),
                                                       
                                                      ), child: Icon(Icons.forklift, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                      // ),
                                                     
                                                              
                                                            ],
                                                          ),
                                                          SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
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
                                                                                        
                                                                                           Text('${filteredData3.length}', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                           
                                                                                         ],
                                                                                       ),
                                                                                    
                                                                                     ],
                                                                                   ),
                                                                                  
                                                         ],
                                                       ),
                              
                                
                              ],),
                                 SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                    Row(
                                                  
                                                      children: [
                                                        
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 20,),
                                                              //  Center(child: 
                                                       Container(
                                                         width: MediaQuery.of(context).size.width * .03,
                                        height: MediaQuery.of(context).size.height * 0.06 ,
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 0, 46, 93),
                                                        borderRadius: BorderRadius.circular(10),
                                                       
                                                      ), child: Icon(Icons.task_alt, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                      // ),
                                                     
                                                              
                                                            ],
                                                          ),
                                                          SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.start,
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Column(
                                                                                     children: [
                                                                                       Text('Finished Today', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                                                    fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                                      
                                                                                       SizedBox(height: 5),
                                                                                       Row(
                                                                                       
                                                                                         children: [
                                                                                        
                                                                                           Text('${filteredData9.length}', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                           
                                                                                         ],
                                                                                       ),
                                                                                    
                                                                                     ],
                                                                                   ),
                                                                                  
                                                         ],
                                                       ),
                              
                                
                              ],),
                               SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                    Row(
                                                  
                                                      children: [
                                                        
                                                          Row(
                                                            children: [
                                                              SizedBox(width: 20,),
                                                              //  Center(child: 
                                                       Container(
                                                         width: MediaQuery.of(context).size.width * .03,
                                        height: MediaQuery.of(context).size.height * 0.06 ,
                                                      decoration: BoxDecoration(
                                                        color: const Color.fromARGB(255, 0, 0, 0),
                                                        borderRadius: BorderRadius.circular(10),
                                                       
                                                      ), child: Icon(Icons.schedule, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                      // ),
                                                     
                                                              
                                                            ],
                                                          ),
                                                          SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.start,
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Column(
                                                                                     children: [
                                                                                        SizedBox(height : MediaQuery.of(context).size.height < 610 ?  6: 15),
                                                                                   
                                                                                          Text('Avg. Time', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                                                      fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                       
                                                                                                     
                                                                                       SizedBox(height: 5),
                                                                                       Row(
                                                                                       
                                                                                         children: [
                                                                                        
                                                                                           Text(avg1 != -1 ? '$avg1' : 'N/A',style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                           
                                                                                         ],
                                                                                       ),
                                                                                    
                                                                                     ],
                                                                                   ),
                                                                                  
                                                         ],
                                                       ),
                              
                                
                              ],),
                              ]) ,
                                 
                                    ],
                                  ),
                                  
                               
                                  ),
                            ),
                          ),
                        ),
                              SizedBox(width: 30),
                             MouseRegion(
                              cursor: SystemMouseCursors.click,
                               child: GestureDetector(
                                 onTap: (){
                                         context.go('/outbound');
                                          },
                                 child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)), width: 
                                                 MediaQuery.of(context).size.width * 0.36,
                                                    height: MediaQuery.of(context).size.height < 420? 300 : MediaQuery.of(context).size.height * 0.5,  child: Column(children: [
                                                 Column(
                                                  children: [
                                                      SizedBox(height : MediaQuery.of(context).size.height < 640 ?  6 : 20),
                                                    Center(child: Text('Outbound (Requested by you)', style: TextStyle(fontFamily: 'Inter', fontSize: 20),)),
                                                   
                                                  // Center(child: 
                                                    //  Container(
                                                    //    width: 40,
                                                    // height: 40,
                                                    // decoration: BoxDecoration(
                                                    //   color: const Color.fromARGB(255, 177, 220, 255),
                                                    //   borderRadius: BorderRadius.circular(10),
                                                     
                                                    // ), child: Icon(Icons.pending_outlined, color:  const Color.fromARGB(255, 0, 55, 100), size: 30)),
                                                    // ),
                                             SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                  Row(
                                                
                                                    children: [
                                                      
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 20,),
                                                            //  Center(child: 
                                                     Container(
                                                       width: MediaQuery.of(context).size.width * .03,
                                      height: MediaQuery.of(context).size.height * 0.06 ,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 208, 104, 0),
                                                      borderRadius: BorderRadius.circular(10),
                                                     
                                                    ), child: Icon(Icons.forklift, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                    // ),
                                                   
                                                            
                                                          ],
                                                        ),
                                                        SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Column(
                                                                                   children: [
                                                                                       SizedBox(height : MediaQuery.of(context).size.height < 610 ? 5: 15),
                                                                                     Text('Active Requests', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                                                  fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                                    
                                                                                     SizedBox(height: 5),
                                                                                     Row(
                                                                                     
                                                                                       children: [
                                                                                      
                                                                                         Text('${filteredData1.length}', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                         
                                                                                       ],
                                                                                     ),
                                                                                  
                                                                                   ],
                                                                                 ),
                                                                                
                                                       ],
                                                     ),
                                                 
                                                   
                                                 ],),
                                                    SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                  Row(
                                                
                                                    children: [
                                                      
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 20,),
                                                            //  Center(child: 
                                                     Container(
                                                       width: MediaQuery.of(context).size.width * .03,
                                      height: MediaQuery.of(context).size.height * 0.06 ,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 0, 46, 93),
                                                      borderRadius: BorderRadius.circular(10),
                                                     
                                                    ), child: Icon(Icons.task_alt, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                    // ),
                                                   
                                                            
                                                          ],
                                                        ),
                                                        SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
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
                                                                                      
                                                                                         Text('${filteredData10.length}', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                         
                                                                                       ],
                                                                                     ),
                                                                                  
                                                                                   ],
                                                                                 ),
                                                                                
                                                       ],
                                                     ),
                                                 
                                                   
                                                 ],),
                                                 SizedBox(height : MediaQuery.of(context).size.height < 610 ?  3 : 10),
                                                  Row(
                                                
                                                    children: [
                                                      
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 20,),
                                                            //  Center(child: 
                                                     Container(
                                                       width: MediaQuery.of(context).size.width * .03,
                                      height: MediaQuery.of(context).size.height * 0.06 ,
                                                    decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 0, 0, 0),
                                                      borderRadius: BorderRadius.circular(10),
                                                     
                                                    ), child: Icon(Icons.schedule, color:  const Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * .017)),
                                                    // ),
                                                   
                                                            
                                                          ],
                                                        ),
                                                        SizedBox(width:MediaQuery.of(context).size.width * 0.02 ,),
                                                     Row(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Column(
                                                                                   children: [
                                                                                       SizedBox(height: 15),
                                                                                     Text('Avg. Time', style: TextStyle(color:  const Color.fromARGB(255, 0, 0, 0), 
                                                                                                  fontSize: MediaQuery.of(context).size.width * 0.0118, fontFamily: 'WorkSans',)),
                                                                                                    
                                                                                     SizedBox(height: 5),
                                                                                     Row(
                                                                                     
                                                                                       children: [
                                                                                      
                                                                                         Text(avg2 != -1 ? '$avg2' : 'N/A',style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                                         
                                                                                       ],
                                                                                     ),
                                                                                  
                                                                                   ],
                                                                                 ),
                                                                                
                                                       ],
                                                     ),
                                                 
                                                   
                                                 ],),
                                                 ]) ,
                                                    
                                  ],
                                                     ),
                                                     
                                                    
                                                     ),
                               ),
                             ),
                      ],
                    );
                  }
                )],
            ),
          ],
        ),
      ),
    ),
    ],),
  ])
    ));
 
  }
}