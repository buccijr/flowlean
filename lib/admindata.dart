

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'dart:convert';
import 'routes.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

void main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp.router(
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter));

}

class AdminData extends StatefulWidget {
  final password;
  final email;
  const AdminData({super.key,  this.password, this.email});

  @override
  State<AdminData> createState() => _AdminDataState();
}

class _AdminDataState extends State<AdminData> {
String menuselected = '';
bool hovered = false;
String menudate = '';
int? hoverIndex;
 bool selected1 = false;
bool  selected2 = false;
bool selected3 = false;
bool selected4 = true;
bool selected5 = false;
bool selected6 = false;
int filteredData = 1;

int filteredTime = 1;

List<Map<String, dynamic>> entries = [];

List<StreamSubscription> pageStreams = [];
void downloaderCsv(String csvData, String filename) {
  final bytes = utf8.encode(csvData);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url); // Cleanup
}
final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;
Future<void> downloadCsv() async {
  final url = Uri.parse('https://rmotaezqlbiiiwwiaomh.supabase.co/functions/v1/validate-csv');

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: '{}', // If your function expects JSON body, otherwise send needed data here
  );

  if (response.statusCode == 200) {
    // response.body contains CSV data as plain text
    final csvData = response.body;

  downloaderCsv(csvData, 'entries_export.csv');
    // Now handle this csvData in Flutter, e.g. save to file or share
    print('CSV data received:\n$csvData');

    // You could write csvData to a file, or open a share dialog, etc.
  } else {
    print('Failed to get CSV: ${response.statusCode} - ${response.body}');
  }
}




int pageSize = 30;
int currentPage = 0;
bool isLoading = false;
bool hasMore = true;

final ScrollController _scrollController = ScrollController();
int maxId = 0;
@override

void initState() {
  super.initState();
   _loadUserRole();
  fetchNextPage();
checkUserStatus();
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
  });}


  
 String? _role;
  bool _loading = true;
bool showbutton = false;
Future<void> checkUserStatus() async {
final user = Supabase.instance.client.auth.currentUser;
final email = user?.email;
final responser = await Supabase.instance.client.from('user').select().eq('email', email ?? '').maybeSingle();
final company = responser?['company'];
final response2 = await Supabase.instance.client.from('company').select().eq('companyname', company).maybeSingle();
print('response 2 $response2');
if (response2?['subscription'] != 'Basic'){
  
  showbutton = true;
}
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
 
Future<void> fetchNextPage() async {
  

  final response = await Supabase.instance.client
      .from('masterdata')
      .select('*') // ✅ IMPORTANT: without this, .range() is ignored!
     
      .order('id', ascending: false)
     .limit(500);

  setState(() {
    entries.addAll(response);
  });

  // Subscribe to new pages (if needed)
  final pageIds = response.map((e) => e['id'] as int).toList();
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
void dispose() {
  _scrollController.dispose();

  for (final sub in pageStreams) {
    sub.cancel();
  }
  
  super.dispose();  // <-- add this to properly clean up!
}
// @override
// void initState(){
//   super.initState();
   

// Timer.periodic(Duration(minutes: 1), (timer){
//   setState(() {
//     updateTotalTimeOnce();
//   });
// });
// }



MenuController menuController  = MenuController();
MenuController menuController2 = MenuController();



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
  Widget build(BuildContext context){
    
          final finalFilter = 
          entries.where((entry){
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
                                 finalFilter.sort((a, b) {
  final closedA = a['closed'] ?? 1;
  final closedB = b['closed'] ?? 1;
  if (closedA != closedB) {
    return closedA.compareTo(closedB); // closed = 0 first
  } else {
    return (b['id'] ?? 0).compareTo(a['id'] ?? 0); // higher id first
  }
});
   

   
   
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
                         context.go('/admindashboard');
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
                          
                          selected1 = false;
                          selected2 = false;
                          selected3 = false;
                          selected4 = true;
                             selected6 = false;
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
                          
           selected6 = false;
                                     selected5 = false;
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
            Row(
        children: [
          SizedBox(width: 10,),
          SizedBox(
            width: 1515,
            height: 825,
            child: Column(
              children: [
                SizedBox(height: 20),
                      Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                SizedBox(width: 30),
                Text('Data', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', color:  const Color.fromARGB(255, 23, 85, 161), fontSize: 30 )),
              ],
            ),
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
                Spacer(),
                showbutton ?
                StatefulBuilder(
                  builder: (context, setLocalState) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (event){
                        setLocalState(() {
                          hovered = true;
                        });
                      },
                       onExit: (event){
                        setLocalState(() {
                          hovered = false;
                        });
                      },
                      child: GestureDetector(
                        onTap: ()  async {
                      
                    
                          downloadCsv();
                        
                      
                    
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedPadding(
                            duration: Duration(milliseconds: 200),
                            
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: hovered ? 125 : 120,
                              height: hovered ? 47 : 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: hovered ? const Color.fromARGB(255, 237, 247, 255) : Colors.white,
                                boxShadow: [BoxShadow(color: const Color.fromARGB(255, 181, 181, 181), blurRadius: 10, offset:  Offset(0, 5))],
                                border: Border.all(width: 1.5, color: const Color.fromARGB(255, 176, 208, 255))
                              ),
                              child: Center(child:       ShaderMask(
                                                       shaderCallback: (bounds) => LinearGradient(
                                                         colors: [const Color.fromARGB(255, 154, 195, 244),const Color.fromARGB(255, 0, 0, 0)],
                                                       ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                                       blendMode: BlendMode.srcIn,
                                                       child: Text(
                                                        'Save as CSV',
                                                         style: TextStyle(
                                                           fontSize: 16,
                                                           fontFamily: 'Inter',
                                                           color: Colors.white, // Needed for ShaderMask to work
                                                         ),
                                                       ),
                                                     )),
                              
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ) : SizedBox.shrink(),
                SizedBox(width: 25,),
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
                    SizedBox(width:  MediaQuery.of(context).size.width * 0.03, child: Text('ID', style: TextStyle(fontSize: 15, fontFamily: 'Inter',)),),
                  SizedBox(width: 20),

                   
                    SizedBox(width: 150, child: Text('From', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                    SizedBox(width: 20),
                    SizedBox(width: 250, child: Text('Requested Item', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Needed', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Request Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                       SizedBox(width: 150, child: Text('Finished Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 250, child: Text('Current Process', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Total Time (min)', style: TextStyle(fontSize: 15, fontFamily: 'Inter',  fontWeight: FontWeight.bold))),
                    
                ],)
            ),
                      
                    SizedBox(
                      width: 1520,
                      height:  MediaQuery.of(context).size.height * 0.68,
            child: 
            
            
              // final filteredData2 = data.where((entry){
              //             if (filteredData == 2){ 
              //             return entry['closed'] == 1;
            
              //             } else if (filteredData == 3){
              //               return entry['closed'] == 0;
              //             } else {
              //               return true;
              //             }
              //           },).toList();
            
            
              // final filteredData2 = filteredData == 2 ? data.where((entry) => entry['closed'] == 1).toList() : filteredData == 3 ? 
              // data.where((entry) => entry['closed'] == 0).toList() : data;
            
            isLoading && finalFilter.isEmpty ? Center(
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
              itemCount: finalFilter.length,
              itemBuilder: (context, index) {
                    if (index == finalFilter.length) {
        return SizedBox.shrink();
            }
                final entry =  finalFilter[index];
                      
                final startTime = DateFormat("MM-dd h:mm a")
                    .format(DateTime.parse(entry['starttime']));
                final endTime = (entry['finishedtime'] != null)
                    ? DateFormat("MM-dd h:mm a")
                        .format(DateTime.parse(entry['finishedtime']))
                    : 'N/A';
                      
                int minutesElapsed;
                final createdAt = DateTime.parse(entry['starttime']);
                if (entry['finishedtime'] != null && entry['closed'] == 1) {
                  minutesElapsed = DateTime.parse(entry['finishedtime'])
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
                    color:   (entry['closed'] == 1)
                        ? Color.fromARGB(255, 172, 250, 175) :
                    hoverIndex == entry['id'] ? const Color.fromARGB(255, 247, 247, 247) :
                 
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
                        context.go('/details/${entry['id']}', extra: {'route': '/data'});
                         },
                        child: SizedBox(
                          height: 61,
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    SizedBox(width:  MediaQuery.of(context).size.width * 0.03, child: Text('${entry['id']}', style: TextStyle(fontSize: 15, fontFamily: 'Inter',)),),
                                  SizedBox(width: 20),
                                
                                        SizedBox(width: 150, child: Text('${entry['usernamem']}', style: TextStyle(fontFamily: 'Inter', fontSize: 16))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 250, child: Text(entry['requestitem'] ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 16))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text(entry['needtime'] ?? '', style: TextStyle(fontFamily: 'Inter', fontSize: 16))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text(startTime, style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text(endTime, style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 250, child: Text(entry['currentprocess'] ?? '', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text('$minutesElapsed', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: 1, child: Column(children: [
                                    SizedBox(height: 45,),
                                  ],)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                 
                      )
                      
            ]),
          ),
        ],
            )]),
      ));
    
    
  }
  }
