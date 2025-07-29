import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'addbutton.dart';
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
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter,
  ));
}




class Outbound extends StatefulWidget {
  const Outbound({super.key});

  @override
  State<Outbound> createState() => _OutboundState();
}

class _OutboundState extends State<Outbound> {

List<Map<String, dynamic>> entries = [];
List<StreamSubscription> pageStreams = [];



int pageSize = 30;
int currentPage = 0;
bool isLoading = false;
bool hasMore = true;
String menuselected = '';
String menudate = '';
final ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();

  fetchNextPage();

  _scrollController.addListener(() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !isLoading && hasMore) {
      fetchNextPage();
    }
  });

  // Optional: Any periodic UI refresh
  Timer.periodic(Duration(minutes: 1), (timer) {
    setState(() {
      // updateTotalTimeOnce();
    });
  });
}

String? allowedProcess;



Future<void> fetchNextPage() async {
  if (isLoading || !hasMore) return;

  setState(() => isLoading = true);

  final from = currentPage * pageSize;
  final to = from + pageSize - 1;

  final response = await Supabase.instance.client
      .from('masterdata')
      .select()
      .order('id', ascending: false)
      .limit(200);

  if (response.isEmpty) {
    setState(() {
      hasMore = false;
      isLoading = false;
    });
    return;
  }

  // Filter out duplicates (just in case)
  final newEntries = response.where((item) {
    final id = item['id'];
    return !entries.any((e) => e['id'] == id);
  }).toList();

  // Add new entries
  setState(() {
    entries.addAll(newEntries);
    currentPage++;
    isLoading = false;
  });

  // Subscribe to realtime updates
  final pageIds = newEntries.map((e) => e['id'] as int).toList();
  subscribeToPageStream(pageIds);
}
void subscribeToPageStream(List<int> ids) {
  final sub = Supabase.instance.client
      .from('masterdata')
      .stream(primaryKey: ['id'])
      .listen((updates) {
    for (final update in updates) {
      final index = entries.indexWhere((e) => e['id'] == update['id']);
      setState(() {
        if (index != -1) {
          // Existing entry updated
          entries[index] = update;
        } else {
          // New entry inserted
          entries.insert(0, update); // add to top, or .add(update) for bottom
        }
      });
    }
  });

  pageStreams.add(sub);
}

@override
void disposee() {
  _scrollController.dispose();

  for (final sub in pageStreams) {
    sub.cancel();
      super.dispose();
  }}
Future<void> finish() async {
  final response = await Supabase.instance.client.from('masterdata').select().maybeSingle();
  final id = response?['id'];
  await Supabase.instance.client.from('masterdata').update({
    'closed': 1,
    'finishedtime': DateTime.now().toIso8601String()
  }).eq('id', id);
}
int filteredData = 1;
int filteredTime = 1;
MenuController menuController  = MenuController();
MenuController menuController2 = MenuController();
int? hoverIndex;

 bool selected1 = false;
bool  selected2 = false;
bool selected3 = true;

String? fetchedUsername;
String? fetchedUsernamer;
String? username;
Future fetchUsername() async {


  final user = Supabase.instance.client.auth.currentUser;

  print('user $user');
  


  final email = user?.email;
print('emil $email');
  final response = await Supabase.instance.client
      .from('user')
      .select()
      .eq('email', email ?? 'hi')
      .maybeSingle();

  fetchedUsername = email ?? 'hi';
  fetchedUsernamer = response?['username'] ?? 'hi';
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
 
    return {
    'username': fetchedUsername,
    'allowedProcess': allowedProcess,
    
  };
}

void updateTotalTimeOnce() async {
  
    final List<dynamic> records = await Supabase.instance.client
        .from('masterdata')
        .select('id, starttime, finishedtime, closed');

    for (var entry in records) {
      if (entry['created_at'] == null) continue;

      final createdAt = DateTime.parse(entry['starttime']);
      int minutesElapsed;

      if (entry['finishedtime'] != null && entry['closed'] == 1) {
        minutesElapsed = DateTime.parse(entry['finishedtime']).difference(createdAt).inMinutes;
      } else {
        minutesElapsed = DateTime.now().toUtc().difference(createdAt).inMinutes;
      }
setState(() {
  
});

    }
  
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
       final    finalFiltern =   entries.where((entry){
                
           
               if (filteredData == 2) {
            if (filteredTime == 3){
            return entry['closed'] == 1 && DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
            
            } else if (filteredTime == 4){
return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['closed']  == 1;
            } else if (filteredTime == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['closed']  == 1;  
            } else { 
              return entry['closed'] == 1;
            }
          } else if (filteredData == 3) {
            if (filteredTime == 3){
            return entry['closed'] == 0 && DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
            
            } else if (filteredTime == 4){
return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['closed']  == 0;
            } else if (filteredTime == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['closed']  == 0;  
            } else { 
              return entry['closed'] == 0;
            }
          }
          
          if (filteredTime == 2 ){
          if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['closed'] == 1;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['closed'] == 0;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1;
          }
          } 
                     if (filteredTime == 3){
           if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7 && entry['closed'] == 1;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7 && entry['closed'] == 0;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
          }
          } 
           if (filteredTime == 4){
           
           if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['closed'] == 30;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30  && entry['closed'] == 30;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30;
          }
          } else {
            return true; 
          }}).toList();
              
              finalFiltern.sort((a, b) {
  final closedA = a['closed'] ?? 1;
  final closedB = b['closed'] ?? 1;
  if (closedA != closedB) {
    return closedA.compareTo(closedB); // closed = 0 first
  } else {
    return (b['id'] ?? 0).compareTo(a['id'] ?? 0); // higher id first
  }
});
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
                        context.go('/dashboard');
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
                         context.go('/inbound');
                          selected1 = false;
                          selected2 = true;
                          selected3 = false;
                        });
                        },
                        child: Container(
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

                                     final filteredData = data.where((entry) => entry['endtime'] == null && entry['process'] == allowedProcess && ((entry['current_user'] == null && entry['user_unique'] == null) || 
                                     ((entry['current_user'] == fetchedUsernamer|| entry['user_unique'] ==fetchedUsernamer) )));
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
                        setState(() {
                          selected1 = false;
                          selected2 = false;
                          selected3 = true;
                        });
                        },
                        child: Container(
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
                                 SizedBox(width:5),
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
                                    child: Column(
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
                                SizedBox(height: 20,),
          ],
        ),
      ),
      Row(
        children: [
          SizedBox(width: 15),
          SizedBox(
             width: MediaQuery.of(context).size.width * 0.87,
                height: MediaQuery.of(context).size.height * 0.93,
            child: Column(children: [
             SizedBox(height: 20),
                      Row(
            children: [
              SizedBox(width: 30),
              Text('Outbound Data', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30
              , fontFamily: 'Inter')),
            ],
                      ),
                       SizedBox(height: 30),
             Row(children: [
                SizedBox(width: 17),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: MenuAnchor(
                    controller: menuController,
                    style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all( const Color.fromARGB(255, 255, 255, 255),),
                    ),
                    builder: (BuildContext context, MenuController controller, Widget? child) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                      onTap: (){
                        if (menuController.isOpen){
                          menuController.close();
                        } else {
                          menuController.open();
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 45,
                        decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(width: 1, color:  const Color.fromARGB(255, 23, 85, 161))
                        ),
                        child: Row(children: [
                          SizedBox(width: 6),
                          Text(menuselected == 'All' ? 'All' : menuselected == 'Finished' ? 'Finished' : menuselected == 'Unfinished' ? 'Unfinished' : 'Status', style:
                           TextStyle(fontFamily: 'WorkSans', fontSize: 15)),
                          Spacer(),
                          Icon(Icons.tune),
                          SizedBox(width: 5,)
                        ],),
                      ),
                      ),
                    );
                    },
                    menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        filteredData = 1;
                        menuselected = 'All';
                        setState(() {
                          
                        });
                      },
                      child: Text('All')
                    ),
                     MenuItemButton(
                      onPressed: () {
                        filteredData =2;
                         menuselected = 'Finished';
                        setState(() {
                          
                        });
                      },
                      child: Text('Finished')
                    ),
                     MenuItemButton(
                      onPressed: () {
                        filteredData = 3;
                         menuselected = 'Unfinished';
                        setState(() {
                          
                        });
                      },
                      child: Text('Unfinished')
                    )
                    ]),
                ),
                SizedBox(width: 20),
                 Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: MenuAnchor(
                    controller: menuController2,
                    style: MenuStyle(
                      backgroundColor: WidgetStateProperty.all( const Color.fromARGB(255, 255, 255, 255),),
                    ),
                    builder: (BuildContext context, MenuController controller, Widget? child) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                      onTap: (){
                        if (menuController.isOpen){
                          menuController2.close();
                        } else {
                          menuController2.open();
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 45,
                        decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(width: 1, color:  const Color.fromARGB(255, 23, 85, 161))
                        ),
                        child: Row(children: [
                          SizedBox(width: 6),
                          Text(menudate == 'All' ? 'All' : menudate == 'Day' ? 'Day' : menudate == '7 days' 
                          ? '7 days' : menudate == '30 days' ? '30 days' :
                           'Date', style: TextStyle(fontFamily: 'WorkSans', fontSize: 15)),
                          Spacer(),
                          Icon(Icons.calendar_month),
                          SizedBox(width: 5,),
                        ],),
                      ),
                      ),
                    );
                    },
                    menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        filteredTime = 1;
                        menudate = 'All';
                        setState(() {
                          
                        });
                      },
                      child: Text('All')
                    ),
                     MenuItemButton(
                      onPressed: () {
                        filteredTime  =2;
                        menudate = 'Day';
                        setState(() {
                          
                        });
                      },
                      child: Text('Past day')
                    ),
                     MenuItemButton(
                      onPressed: () {
                        filteredTime = 3;
                        menudate = '7 days';
                        setState(() {
                          
                        });
                      },
                      child: Text('Past 7 days')
                    ),
                     MenuItemButton(
                      onPressed: () {
                        filteredTime = 4;
                        menudate = '30 days';
                        setState(() {
                          
                        });
                      },
                      child: Text('Past 30 days')
                    )
                    ]),
                ),
              
                 ],),
                      SizedBox(height: 25),
            Container(
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                        colors: [ const Color.fromARGB(255, 186, 224, 254), const Color.fromARGB(255, 234, 245, 255) ],
                      begin: Alignment.centerLeft, end: Alignment.centerRight),
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                ),
                height: 60,
                width: double.infinity,
                child: Row(children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width:  MediaQuery.of(context).size.width * 0.04, child: Text('ID', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                    fontWeight: FontWeight.bold)),),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width:  MediaQuery.of(context).size.width * 0.207, child: Text('Requested', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                    fontWeight: FontWeight.bold))),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.088,  child: Text('Needed', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                    fontWeight: FontWeight.bold))),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.088,  child: Text('Request Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                    fontWeight: FontWeight.bold))),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                       SizedBox(width: MediaQuery.of(context).size.width * 0.088,  child: Text('Finished Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                       fontWeight: FontWeight.bold))),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width:  MediaQuery.of(context).size.width * 0.15, child: Text('Current Process', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                    fontWeight: FontWeight.bold))),
                     SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.088,  child: Text('Total Time (min)', style: TextStyle(fontSize: 15, fontFamily: 'Inter', 
                    fontWeight: FontWeight.bold))),
                    
                ],)
            ),
                      Expanded(
            child: FutureBuilder(
              future: fetchUsername(),
              builder: (context, snapshot) {
                 if (!snapshot.hasData){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,height: 30,
                          child: CircularProgressIndicator(color: Colors.blue,)),
                      ],
                    ),
                  );
                 }
                final usernamer = snapshot.data;
                print('$usernamer usr');
              final finalFilter = finalFiltern.where((entry) => entry['usernamem'] == (usernamer['username'] ?? '')).toList();
        return    isLoading && finalFilter.isEmpty ? Center(
              child: SizedBox(
                width: 40, height: 50,
                child: CircularProgressIndicator(color: Colors.blue)),
            ) :
            finalFilter.isEmpty && !isLoading ? 
             Center(child: Column(
                children: [
                  SizedBox(height: 70),
                  Stack(
                    children: [
                     Image( image: AssetImage('images/search.png'
                    ),
                     width: 400,
                      height: 400,
                      fit: BoxFit.contain,),
                    Positioned
                    (
                      left: 100,
                      top: 300, child: Text('Nothing here yet...', style: TextStyle(color:  const Color.fromARGB(255, 0, 55, 100), fontSize: 25, 
                      fontWeight: FontWeight.bold )))
                    ])
                ],
              ))
            :
            
         ListView.builder(
              itemCount: finalFilter.length ,
              itemBuilder: (context, index) {
                    if (index == finalFilter.length) {
        return SizedBox.shrink();
      }
                final entry =  finalFilter[index];
                          
                    final startTime = DateFormat("MM-dd h:mm a").format(DateTime.parse(entry['starttime']).toLocal());
                    final endTime = (entry['finishedtime'] != null)
                        ? DateFormat("MM-dd h:mm a")
                            .format(DateTime.parse(entry['finishedtime']))
                        : 'N/A';
                          
                    int minutesElapsed;
                  final createdAt = DateTime.parse(entry['starttime']).toUtc();
                    if (entry['finishedtime'] != null && entry['closed'] == 1) {
                      minutesElapsed = DateTime.parse(entry['finishedtime']).toUtc()
                          .difference(createdAt)
                          .inMinutes;
                    } else {
                      minutesElapsed = DateTime.now().toUtc().difference(createdAt).inMinutes;
                    }
                      
                
                
                          
                    return StatefulBuilder(
                      builder: (context, setLocalState) => 
                     Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 118, 118, 118))),
                  color: 
                      (entry['closed'] == 1)
                          ? Color.fromARGB(255, 172, 250, 175)
                          : hoverIndex == entry['id'] ? const Color.fromARGB(255, 247, 247, 247) :
                          Colors.white),
                          
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                           onHover: (event){
                            setLocalState(() {
                             
                               hoverIndex = entry['id'];
                            });
                          },
                          onExit: (event) {
                            setLocalState(() {
                              hoverIndex = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                      context.go('/details/${entry['id']}', extra: {'route': '/outbound'});
                            },
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.04, child: Text('${entry['id']}', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.207, child: Text(entry['requestitem'] ?? '', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.088, child: Text(entry['needtime'] ?? '', style: TextStyle(fontSize: 16,fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.088, child: Text(startTime, style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.088, child: Text(endTime, style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width:  MediaQuery.of(context).size.width * 0.15, child: Text(entry['currentprocess'] ?? '', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text('$minutesElapsed', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
                      )
                      
            ]),
          ),
        ],
      )
    ],),
  ),
);
}
}