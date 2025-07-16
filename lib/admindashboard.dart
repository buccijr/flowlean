import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';
import 'package:fl_chart/fl_chart.dart';


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


class AdminDash extends StatefulWidget {
 
  const AdminDash({super.key});

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


bool isHovered1 = false;
bool isHovered2 = false;
bool isHovered3 = false;
bool isHovered4 = false;







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
    
  morning.shuffle();
  afternoon.shuffle();
  evening.shuffle();
  night.shuffle();
  Timer.periodic(Duration(minutes: 1), (timer){
  setState(() {
    
  });
});

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

@override
Widget build(BuildContext content){
    

    if (_role == 'user') {
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
              Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color:  const Color.fromARGB(255, 23, 85, 161), fontSize: 30 ) )
             ],),
            SizedBox(height: 10),
            Align(
             alignment: Alignment.topLeft,
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             
             Row(
               children: [
                SizedBox(width: 40),
                 Material(
                     
                  elevation: 11,
                  borderRadius: BorderRadius.circular(16),
                   child: Container(
                    width: MediaQuery.of(context).size.width * 0.78,
                    height: MediaQuery.of(context).size.height * 0.3 ,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // gradient: LinearGradient(
                      //   colors: [Colors.white, Colors.white,  const Color.fromARGB(255, 177, 220, 255)],
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight
                      //   )
                      color: const Color.fromARGB(255, 0, 69, 126)
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
                            return  ShaderMask(
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
                     Text(greeting(), style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20, fontFamily: 'Inter'),)
                        ]
                      ),
                    
                    ),
                    ),
                 ),
               ],
             ),
             SizedBox(height: 25),
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
              return DateTime.now().difference(finish1).inDays.abs() <= 1;
            
           
           }).toList();
           
           final filteredData1 = data.where((entry) {
             
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
      if (text.length > 4 && text.length <= 10){
        return MediaQuery.of(context).size.width * 0.02;
      }
       else if (text.length > 15){
        return MediaQuery.of(context).size.width * 0.015;
      } else if (text.length > 20) {
        return MediaQuery.of(context).size.width * 0.011;
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
                  height: isHovered1 ? MediaQuery.of(context).size.width * 0.075 : MediaQuery.of(context).size.width * 0.07,
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
                                                                  
                                                                     Text('$responsenumber', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                     
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
                  height: isHovered2 ? MediaQuery.of(context).size.width * 0.075 : MediaQuery.of(context).size.width * 0.07,
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
                                 
                                    Text('$finishedToday', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0)),),
                                   
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
                  height: isHovered3 ? MediaQuery.of(context).size.width * 0.075 : MediaQuery.of(context).size.width * 0.07,
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
                                    
                                    Text('${filteredData1.length}', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0))),
                                   
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
                  height: isHovered4 ? MediaQuery.of(context).size.width * 0.075 : MediaQuery.of(context).size.width * 0.07,
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
                                    
                                    Text(avg == -1 ? 'N/A' : '$avg', style: TextStyle(fontFamily: 'Inter', fontSize: MediaQuery.of(context).size.width * 0.02, color: const Color.fromARGB(255, 0, 0, 0))),
                                  
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
                Container(
                  width: MediaQuery.of(context).size.width * .79,
                  height: MediaQuery.of(context).size.height * 0.37,
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    color:  Color(0xFFFAFAFA),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(width: 30,),
                                Text('Weekly Requests', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 23),),
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
      final now = DateTime.now();
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
                                           data.length >= 5 ?
                                           (data.length == 0 ? 10 : data.length % 5 == 0 ? data.length : roundMaxY(data.length.toDouble()))/5 : 1,
                                            getTitlesWidget: (value, meta) {
                                             
                                              return Text('${value.toInt()}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133)),);
                                         
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
                                       
                                       const labels = ['Monday', 'Tuesday', 'Wednesday', 'Thursday ', 'Friday', 'Saturday', 'Sunday' ];
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
              ],
            ),
               
           ],),
         ),
         
      ],)
    );
 
}
}