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
  const Mbi({super.key});

  @override
  State<Mbi> createState() => _MbiState();
}

class _MbiState extends State<Mbi> {
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
    return 25;
  }
}
  // String? defaults;
String usernames = '';
int minutesElapsed = 0;
List machines = [];
@override
initState(){

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

Future machineFetch() async {
  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response0 = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  username = response0?['username'];
  final response1 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
  final response3 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
  return [response3, response1, username];
}

String username = '';
String allowedProcess = '';
String? fetchedUsername;
Map<int, bool> isHovered = {};
Map<int, bool> isHovered2 = {};
ValueNotifier loadingUser  = ValueNotifier(true);

String? alone = 'true';
Future fetchUsername() async {
  setState(() {
    loadingUser.value = true;
  });

  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    setState(() {
      loadingUser.value = false;
    });
   
  }


  final email = user?.email;

  final response = await Supabase.instance.client
      .from('user')
      .select()
      .eq('email', email!)
      .maybeSingle();

  fetchedUsername = response?['username'];

  if (fetchedUsername != null) {
    final response3 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', fetchedUsername!).maybeSingle();
    if (response3 != null){
      allowedProcess = response3['machine'];

    } else {
    final response2 = await Supabase.instance.client
        .from('process_users')
        .select()
        .eq('userpu', fetchedUsername!).or('disabled.is.null,disabled.not.eq.true');
       
        allowedProcess = response2[0]['processpu'];
    
    }}
       final response10 = await Supabase.instance.client.from('process_users').select().eq('processpu', allowedProcess).or('disabled.is.null,disabled.not.eq.true');

          if (response10.length > 1){
            
            alone = 'false';
            
          } else {
           alone = 'true';
          }

  setState(() {
    loadingUser.value = false;
  });
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

  @override
  Widget build(BuildContext context) {
     
   return Scaffold(
    floatingActionButton: AddButton(),
  backgroundColor: Color(0xFFFAFAFA),
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
                SizedBox(height: 170),
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
                SizedBox(height:25,),
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
                                  Text('Inbound',  textAlign: TextAlign.center, style: TextStyle(
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
                SizedBox(height: 25),
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
                                     Icon(Icons.pageview_outlined, size: 29 ,color: const Color.fromARGB(255, 142, 204, 255)),
                                     SizedBox(width: 5),
                                  Text('Outbound',  textAlign: TextAlign.center, style: TextStyle(
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
                             SizedBox(height: 300),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: (){
                                   Supabase.instance.client.auth.signOut();
                                  context.go('/login');
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: 40),
                                      Text('Logout',  textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, 
                                      color:  const Color.fromARGB(255, 177, 220, 255),),),
                                       SizedBox(width: 10),
                                                               Icon(Icons.logout, color:  const Color.fromARGB(255, 177, 220, 255),)
                                    ],
                                  ),
                                ),
                              ),
              ],
            ),
          ],
        ),
      ),
     loadingUser.value ? Center(
      
      child: Row(
        children: [
          SizedBox(width: 750,),
          CircularProgressIndicator(color: Colors.blue,),
        ],
      )) : 
    Column(
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
                  
                                          FutureBuilder(
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
                final response0 = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
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
             Material(
              elevation: 11,
              borderRadius: BorderRadius.circular(16),
               child: Container(
                width: 1350,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white,  const Color.fromARGB(255, 177, 220, 255)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        return ShaderMask(
  shaderCallback: (bounds) => LinearGradient(
    colors: [const Color.fromARGB(255, 0, 80, 200), const Color.fromARGB(255, 255, 226, 81)],
  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
  blendMode: BlendMode.srcIn,
  child: Text(
    '${greeting()}, $usernames!', 
    style: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
      color: Colors.white, // Needed for ShaderMask to work
    ),
  ),
);
                      }
                    ),
                 SizedBox(height: 20),
                FutureBuilder(
           future: Future.wait([
            Supabase.instance.client.from('masterdata').select(),
            fetchUsername(),
            Supabase.instance.client.from('detail').select(),
            ]),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
              loadingUser.value = true;
          
             } else {
            
             } if (snapshot.hasError){
              return Text('Error: ${snapshot.error}');
             }
        
        print('loadus $loadingUser');
        final data3 = snapshot.data?[0] ?? [];
   final userData = snapshot.data?[1];
   final data = snapshot.data?[2] ?? [];
if (userData == null || userData is! Map<String, dynamic> ) {
  loadingUser.value = true;
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
        .where((entry) => entry['current_user'] == fetchedUsername )
        .where((entry) {
        final start = DateTime.parse(entry['starttime']);
        final finish = entry['finishedtime'];
        if (finish == null) return false;
        final finish1 = DateTime.parse(entry['finishedtime']);
         return start.difference(finish1).inDays.abs() <= 1;
         
        
        }).toList()
        : 
        data
        .where((entry) => entry['user_unique'] == fetchedUsername)
        .where((entry) {
        final start = DateTime.parse(entry['starttime']);
        final finish = entry['finishedtime'];
        if (finish == null) return false;
        final finish1 = DateTime.parse(entry['finishedtime']);
         return start.difference(finish1).inDays.abs() <= 1;
         
        
        }).toList();
        
        
        final filteredData1 = data3
        .where((entry) => entry['usernamem'] == usernamer);
        
      
          final filteredData3 = 
      
        data
        .where((entry) => (entry['current_user'] == fetchedUsername|| entry['user_unique'] == fetchedUsername ) && entry['usernamem'] != fetchedUsername);
        
          
        final filteredData2 = data
         .where((entry) => (entry['current_user'] == fetchedUsername|| entry['user_unique'] == fetchedUsername ) && entry['usernamed'] != fetchedUsername)
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
      
        
final filteredData9 = data.where((entry) => (entry['current_user'] == fetchedUsername || entry['user_unique'] == fetchedUsername)  && entry['endtime'] != null && DateTime.now().difference(DateTime.parse(entry['endtime'])).abs().inDays <= 1);
       final filteredData10 = data.where((entry) => (entry['usernamed'] == fetchedUsername  && entry['endtime'] != null && DateTime.now().difference(DateTime.parse(entry['starttime'])).inDays <= 1));
    

             return 
                 Row(
                
                   children: [
                     Material(
                     elevation: 8,
                     borderRadius: BorderRadius.circular(16),
                     child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                       child: GestureDetector(
 onTap: (){
                                 context.go('/inbound');
                                  },
                         child: Container(
                          width: 350,
                          height: 150,
                         decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 240, 250),
                          borderRadius: BorderRadius.circular(16),
                         ),
                         child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                            Column(
                              children: [
                                    SizedBox(height: 10),
                                Row(
                                  children: [
                                Container(
                                  width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                 color: const Color.fromARGB(255, 177, 220, 255),
                                 borderRadius: BorderRadius.circular(10),
                                                          ), child: Icon(Icons.call_received_outlined, color:  const Color.fromARGB(255, 0, 55, 100), size: 30)),
                                                                 
                                                                SizedBox(width: 30),
                                                                Text('Inbound (${filteredData3.length})' , style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, 
                                                                fontSize: 22, fontFamily: 'WorkSans')),
                                                              
                              ]),
                                       SizedBox(height: 10),                          
                                  Row(
                                                      children: [
                                                               
                                                                
                                                                SizedBox(height: 3),
                                                                Text('Finished Today:', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, fontFamily: 'Inter', 
                                                                fontSize: 16)),
                                                            
                                                                  SizedBox(width: 10),
                                Text('${filteredData9.length}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                SizedBox(width: 20),
                                                                 
                                                      ],
                                                    ),
                                                      SizedBox(height: 10),
                                                       Row(
                                                                 children: [
                                                                  SizedBox(width: 20,),
                                                                  Text('Avg. Duration (min)', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, fontFamily: 'Inter',
                                                       fontSize: 16)),
                                                           SizedBox(width: 10),
                                                                   Text(avg1 != -1 ?'$avg1' : 'N/A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                                               
                                                       
                                                       SizedBox(height: 3),
                                                       
                                                                 ],
                                                       ),
                              ],
                            ),
                         
                          ],),
                         ),
                         ),
                       ),
                     ),
                     ),
                     SizedBox(width: 20),
                      Material(
                     elevation: 8,
                     borderRadius: BorderRadius.circular(16),
                     child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                       child: GestureDetector(
 onTap: (){
                                 context.go('/outbound');
                                  },
                         child: Container(
                          width: 350,
                          height: 150,
                         decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 240, 250),
                          borderRadius: BorderRadius.circular(16),
                         ),
                         child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                            Column(
                              children: [
                                    SizedBox(height: 10),
                                Row(
                                  children: [
                                Container(
                                  width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                 color: const Color.fromARGB(255, 177, 220, 255),
                                 borderRadius: BorderRadius.circular(10),
                                                          ), child: Icon(Icons.call_made_outlined, color:  const Color.fromARGB(255, 0, 55, 100), size: 30)),
                                                                 
                                                                SizedBox(width: 30),
                                                                Text('Outbound (${filteredData1.length})' , style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, 
                                                                fontSize: 22, fontFamily: 'WorkSans')),
                                                              
                              ]),
                                       SizedBox(height: 10),                          
                                  Row(
                                                      children: [
                                                               
                                                                
                                                                SizedBox(height: 3),
                                                                Text('Finished Today:', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, fontFamily: 'Inter', 
                                                                fontSize: 16)),
                                                            
                                                                  SizedBox(width: 10),
                                Text('${filteredData10.length}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                SizedBox(width: 20),
                                                                 
                                                      ],
                                                    ),
                                                      SizedBox(height: 10),
                                                       Row(
                                                                 children: [
                                                                  SizedBox(width: 20,),
                                                                  Text('Avg. Duration (min)', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, fontFamily: 'Inter',
                                                       fontSize: 16)),
                                                           SizedBox(width: 10),
                                                                   Text(avg2 != -1 ?'$avg2' : 'N/A', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                                                               
                                                       
                                                       SizedBox(height: 3),
                                                       
                                                                 ],
                                                       ),
                              ],
                            ),
                         
                          ],),
                         ),
                         ),
                       ),
                     ),
                     ),
//                         Row(
//                    children: [
//                      Material(
//                      elevation: 11,
//                      borderRadius: BorderRadius.circular(16),
//                      child: MouseRegion(
//                       cursor: SystemMouseCursors.click,
//                        child: GestureDetector(
//  onTap: (){
//                                    Navigator.push(context, PageRouteBuilder(
//                                          pageBuilder: (context, animation, secondaryAnimation) => Outbound(
                                          
//                                          ),
//                                          transitionDuration: Duration.zero,
//                                          reverseTransitionDuration: Duration.zero,
                                       
                                     
                                   
//                                    ));
//                                   },
//                                child:   Container(
//                       width: 220,
//                       height: 100,
//                      decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 228, 240, 250),
//                       borderRadius: BorderRadius.circular(16),
//                      ),
//                      child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10),
//                         Center(child: Container(
//                            width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 177, 220, 255),
//                             borderRadius: BorderRadius.circular(10),
//                           ),child: Icon(Icons.call_made, color:  const Color.fromARGB(255, 0, 55, 100), size: 30))),
//                         SizedBox(width: 20),
//                         Column(
//                           children: [
//                            SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 Text('${filteredData1.length}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                                 SizedBox(width: 60),
//                               ],
//                             ),
//                             SizedBox(height: 3),
//                             Text('Outbound', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, 
//                             fontSize: 16))
//                           ],
//                         ),
                     
//                       ],),
//                      ),
//                      ),
//                      ))),
//                            SizedBox(width: 30),
                   
//                                    Material(
//                      elevation: 11,
//                      borderRadius: BorderRadius.circular(16),
//                      child: Container(
//                       width: 220,
//                       height: 100,
//                      decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 228, 240, 250),
//                       borderRadius: BorderRadius.circular(16),
//                      ),
//                      child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10),
//                         Center(child: Container(
//                            width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 177, 220, 255),
//                             borderRadius: BorderRadius.circular(10),
//                           ),child: Icon(Icons.task_alt, color:  const Color.fromARGB(255, 0, 55, 100), size: 30))),
//                         SizedBox(width: 20),
//                         Column(
//                           children: [
//                            SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 Text('$finishedToday', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                                 SizedBox(width: 70),
//                               ],
//                             ),
//                             SizedBox(height: 3),
//                             Text('Finished Today', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, 
//                             fontSize: 15.5))
//                           ],
//                         ),
                     
//                       ],),
//                      ),
//                      ),
//                      ),
//                      SizedBox(width: 30),
                   
//                                    Material(
//                      elevation: 11,
//                      borderRadius: BorderRadius.circular(16),
//                      child: Container(
//                       width: 220,
//                       height: 100,
//                      decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 228, 240, 250),
//                       borderRadius: BorderRadius.circular(16),
//                      ),
//                      child: Padding(
//                       padding: const EdgeInsets.all(10),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 10),
//                         Center(child: Container(
//                            width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 177, 220, 255),
//                             borderRadius: BorderRadius.circular(10),
//                           ),child: Icon(Icons.schedule, color:  const Color.fromARGB(255, 0, 55, 100), size: 30))),
//                         SizedBox(width: 20),
//                         Column(
//                           children: [
//                            SizedBox(height: 2),
//                             Row(
//                               children: [
//                                 Text('$average', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
//                                 SizedBox(width: 70),
//                               ],
//                             ),
//                             SizedBox(height: 3),
//                             Text('Average Completion\n time (min)', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontWeight: FontWeight.bold, 
//                             fontSize: 14))
//                           ],
//                         ),
                     
//                       ],),
//                      ),
//                      ),
//                      ),
//                    ],
//                  )
                 ]);
             
              
           }
         )
                    ]
                  ),
                
                ),
                ),
             )])),]),
             SizedBox(width: 40,),
//          
            
          
        
        ],
        ),
        SizedBox(height: 30),
    Row(
    children: [
      SizedBox(width: 20),
      Container(
        height: 1,
        width: 1300,
        color: const Color.fromARGB(255, 106, 106, 106),
      ),
    ],
    ),
    SizedBox(height: 20),
    Row(
       mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 45,),
        Text('Inbound', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Montserrat'),),
            SizedBox(width: 1280,),
      ],
    ),
    Row(
       mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 48),
        SizedBox(
          width: 1250,
          height: 173,
          child: FutureBuilder(
            future: Supabase.instance.client
  .from('detail')
  .select()
  .not('usernamed', 'eq', fetchedUsername)
  .eq('process', allowedProcess)
  .order('id', ascending: false)
  .limit(4),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
              loadingUser.value = true;
              } else if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
     
              final data = snapshot.data ?? [];
              if (data.isEmpty){
                return Text('Nothing to see here yet.');
              }

              
            String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}
     
     
              return   ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                 
                 int minutesElapsed;
                  final entry = data[index];
               
               
               
                    final createdAt = DateTime.parse(entry['starttime']);
                  if (entry['endtime'] != null){
                    final finishedTime = DateTime.parse(entry['endtime']);
                    minutesElapsed = finishedTime.toUtc().difference(createdAt).inMinutes;
                  } else {
                    final now = DateTime.now().toUtc();
                    minutesElapsed = now.toUtc().difference(createdAt).inMinutes;
                  }
                  return StatefulBuilder(
                    builder: (context, setLocalState) {
                      return MouseRegion(
                         
                                    onEnter: (event){
                                    setLocalState(() {
                          isHovered2[index] = true;
                        });
                                    },
                                    onExit: (event) {
                                     setLocalState(() {
                          isHovered2[index] = false;
                        });
                                    },
                        child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered2[index] ?? false
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 12),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                              width: isHovered2[index]  ?? ialwaysfalse ? 300 : 290,
                                              height: isHovered2[index]  ?? ialwaysfalse ?165 : 158,
                                        decoration: BoxDecoration(
                                          color:  const Color.fromARGB(255, 240, 245, 249),
                                          borderRadius: BorderRadius.circular(20),
                                                                      boxShadow: isHovered2[index] ?? ialwaysfalse ? [BoxShadow(color: const Color.fromARGB(255, 255, 233, 109),  blurRadius: 10)] : 
                                                                       [BoxShadow(color: const Color.fromARGB(255, 198, 198, 198),  blurRadius: 10)]
                                          // boxShadow: [ BoxShadow(
                                          //   color: const Color.fromARGB(255, 241, 241, 241),
                                          //   blurRadius: 3,
                                          //   offset: Offset(-4, 0)
                                          // )]
                                        ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text('${truncateWithEllipsis(25, entry['originalneed'])}', style: TextStyle(
                                    fontFamily: 'Inter', fontSize: fontSizeBasedOnLength('${entry['originalneed']}'), color: const Color.fromARGB(255, 2, 2, 2),)),
                                  SizedBox(height: 10),
                                  Text('Sent by: ${entry['usernamed']}', style: TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'WorkSans', color: const Color.fromARGB(255, 68, 68, 68))),
                                  SizedBox(height: 10),
                                  Text('Needed: ${entry['neededby']}', style: TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'WorkSans', color: const Color.fromARGB(255, 70, 70, 70)),),
                                  SizedBox(height: 10),
                                  Text('Time: $minutesElapsed', style: TextStyle(fontWeight: FontWeight.bold,  fontFamily: 'WorkSans',  color: const Color.fromARGB(255, 70, 70, 70))),
                                ],),
                               
                              )
                            ),
                                    )),
                      
                          ]),
                      );
                    }
                  );
                 ;
             } );
            }
          ),
        ),
        SizedBox(width: 150,),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            SizedBox(width: 48,),
            Text('Outbound', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
              SizedBox(width: 1250,),
          ],
        ),
      ],
    ),
    SizedBox(height: 0),
    Row(
       mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 42),
        SizedBox(
          width: 1250,
          height: 150,
          child: FutureBuilder(
            future:Supabase.instance.client
          .from('masterdata')
          .select()
          .eq('usernamem', fetchedUsername!)
          .order('id', ascending: false)
          .limit(4),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
              loadingUser.value = true;
              } else if (snapshot.hasError){
                return Text('Error: ${snapshot.error}');
              }
             
              final data = snapshot.data ?? [];
              if (data.isEmpty){
                return Text('Nothing to see here yet.');
              }
             
              
            
             
            String truncateWithEllipsis(int cutoff, String myString) {
          return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
        }
        
        
        
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                 
                
                  final entry = data[index];
              
                final currentProcess = entry['currentprocess'];
                    int minutesElapsed;
              
                    
                      final createdAt = DateTime.parse(entry['starttime']);
                     
                      if (entry['finishedtime'] != null){
                        final finishedTime = DateTime.parse(entry['finishedtime']);
                        
                        minutesElapsed = finishedTime.toUtc().difference(createdAt).inMinutes;
                      } else {
                        final now = DateTime.now().toUtc();
                        minutesElapsed = now.toUtc().difference(createdAt).inMinutes;
                      }
              
                      
                      return Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatefulBuilder(
                            builder: (context, setLocalState) {
                              return MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (event){
                                setLocalState(() {
                      isHovered[index] = true;
                    });
                                },
                                onExit: (event) {
                                 setLocalState(() {
                      isHovered[index] = false;
                    });
                                },
                                child: GestureDetector(
                                                  onTap: (){
                                                   context.go('/details/${entry['id']}', extra: {'route': '/dashboard'});
                                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AnimatedPadding(
                                      duration: Duration(milliseconds: 200),
                                      padding:  isHovered[index] ?? false
                                          ? EdgeInsets.symmetric(horizontal: 0)
                                          : EdgeInsets.symmetric(horizontal: 12),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                              width: isHovered[index]  ?? ialwaysfalse ? 300 : 290,
                                              height: isHovered[index]  ?? ialwaysfalse ?130 : 128,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 240, 245, 249),
                                          borderRadius: BorderRadius.circular(20),
                                                                      boxShadow: isHovered[index] ?? ialwaysfalse ? [BoxShadow(color: const Color.fromARGB(255, 230, 217, 113),  blurRadius: 10)] : 
                                                                       [BoxShadow(color: const Color.fromARGB(255, 198, 198, 198),  blurRadius: 10)]
                                          // boxShadow: [ BoxShadow(
                                          //   color: const Color.fromARGB(255, 241, 241, 241),
                                          //   blurRadius: 3,
                                          //   offset: Offset(-4, 0)
                                          // )]
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text(truncateWithEllipsis(25,  entry['requestitem']), style: TextStyle
                                            (fontFamily: 'Inter',
                                              fontSize: fontSizeBasedOnLength(entry['requestitem']), color: const Color.fromARGB(255, 0, 0, 0),)),
                                            SizedBox(height: 10),
                                            Text('Process: ${truncateWithEllipsis(25, currentProcess)}', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'WorkSans',
                                          color: const Color.fromARGB(255, 93, 93, 93))),
                                            SizedBox(height: 10),
                                            Text('Time Elapsed: $minutesElapsed', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'WorkSans',  color: const Color.fromARGB(255, 72, 72, 72)),),
                                           
                                          ],),
                                         
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ]);
                    });
                }
              )
            
          ),
               SizedBox(width: 150)
      ]),
   
      ],
    ),
    ],),
  )
    );
 
  }
}