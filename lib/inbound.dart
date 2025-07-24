
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'addbutton.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';

import 'package:go_router/go_router.dart';

void main() async {
   
  WidgetsFlutterBinding.ensureInitialized();
 setUrlStrategy(PathUrlStrategy());
  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );


  runApp(MaterialApp.router(
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter));

}


class Inbound extends StatefulWidget {
 
  const Inbound({super.key});

  @override
  State<Inbound> createState() => _InboundState();
}




class _InboundState extends State<Inbound> {
  bool focusmode = false;
String menuselected = '';
String menudate = '';
List<Map<String, dynamic>> entries = [];
List<StreamSubscription> pageStreams = [];

int pageSize = 30;
int currentPage = 0;
Set hasID = {};
bool isLoading = false;
bool hasMore = true;

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


  Timer.periodic(Duration(minutes: 1), (timer) {
    setState(() {
  
    });
    
  });}
  
Future<void> fetchNextPage() async {
  if (isLoading || !hasMore) return;

  setState(() => isLoading = true);

  final from = currentPage * pageSize;
  final to = from + pageSize - 1;

  final response = await Supabase.instance.client
      .from('detail')
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
      .from('detail')
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
      super.dispose();
  }}

String? fetchfromt;
String? fetchtot; 
String? fetchfromt2;
String? fetchtot2; 
Future fetchTo(entry) async {
   

    
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();

  final username = response?['username'];
  final response10 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
  final response18 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
    if (response10.length > 1){
    fetchtot =  response18?['machine'] ?? 'N/A'; 
  } else {
fetchtot = response10[0]['processpu'];
}
  
{ return 
fetchtot;
}
}

Future fetchFrom(entry) async {
   
  final responses = await Supabase.instance.client.from('materials').select().eq('description', entry['originalneed']).maybeSingle() as Map<String, dynamic>;
    
  final location = responses['location'];
  
   
  
fetchfromt = location ?? 'N/A';
 
    
{ return 
fetchfromt;
}
}
ValueNotifier<String?> fromt = ValueNotifier(null);
ValueNotifier<String?> tot = ValueNotifier(null);

   fromTo(entry) async {
  showDialog(context: context, 
  builder:(context) {
    return AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.all(0),
    content: StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          width: 500,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            
          ),
          child: Padding(padding: EdgeInsets.all(20),
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                                  Container(
                  width: 50,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromARGB(255, 215, 215, 215)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.forklift
                  ,  color: const Color.fromARGB(255, 142, 204, 251), size: 25),
                ),
                SizedBox(width: 10),
                  Text('Please fill out the forklift information below.', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 0, 0, 0), 
                  fontSize: 17),),
                ],
              ),
            ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 20),
          Container(
                         width: 400,
                            height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color:Color.fromARGB(255, 0, 74, 123)),),
                        child: FutureBuilder(
                          future: fetchFrom(entry),
                          builder: (context, snapshot) {
                            final fetchh = snapshot.data ?? 'N/A';
                           fromt.value = fetchh ?? 'N/A';
                            return FutureBuilder(
                              future: Supabase.instance.client.from('process').select(),
                              builder: (context, snapshot) {
                                final data = snapshot.data ?? [];
                                final filtereddata = data.where((entry) => entry['description'] != fetchh);
                                return StatefulBuilder(
                                  builder:(context, setLocallyState) => 
                                   DropdownButtonHideUnderline(
                                   child: DropdownButton(
                                       icon: Icon(Icons.keyboard_arrow_down),
                                                 value:  fromt.value,
                                                 items: [
                                                 DropdownMenuItem(
                                                   value: fetchh ?? 'N/A',
                                                   child: Row(
                                                     children: [
                                                       SizedBox(width: 10,),
                                                       Text(fetchh ?? 'N/A' ),
                                                     ],
                                                   )),
                                                  ...filtereddata.map((entry) {
                                                  return  DropdownMenuItem(
                                                   value: entry['description'],
                                                  child: Text(entry['description']),
                                                 );}),
                                                 ],
                                                 onChanged: (value){
                                                   setLocalState((){
                                           fromt.value = value!.toString();
                                          
                                                   });
                                                 
                                                 
                                              
                                                 }
                                   ),
                                  ),
                                );
                              }
                            );
                          }
                        ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                         width: 400,
                            height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color:Color.fromARGB(255, 0, 74, 123)),),
                        child: ValueListenableBuilder(
                          valueListenable: tot,
                          builder: (context, tots, child) {
                            return FutureBuilder(
                              future: fetchTo(entry),
                              builder: (context, snapshot) {
                                final fetchhedd = snapshot.data ?? 'N/A';
                            tot.value = fetchhedd ?? 'N/A';
                                return FutureBuilder(
                                  future: Supabase.instance.client.from('process').select(),
                                  builder: (context, snapshot) {
                                    final data = snapshot.data ?? [];
                                    final filtereddata = data.where((entry) => entry['description'] != fetchhedd).toList();
                                    return StatefulBuilder(
                                      builder:(context, setLocallyState) => 
                                       DropdownButtonHideUnderline(
                                       child: DropdownButton(
                                           icon: Icon(Icons.keyboard_arrow_down),
                                                     value:  tot.value,
                                                     items: [
                                                     DropdownMenuItem(
                                                       value: fetchhedd ?? 'N/A',
                                                       child: Row(
                                                         children: [
                                                          SizedBox(width: 10,),
                                                           Text(fetchhedd ?? 'N/A' ),
                                                         ],
                                                       )),
                                                      ...filtereddata.map((entry) {
                                                      return  DropdownMenuItem(
                                                       value: entry['description'],
                                                      child: Text(entry['description']),
                                                     );}),
                                                     ],
                                                     onChanged: (value){
                                                       setLocalState((){
                                               tot.value = value!.toString();
                                                       });
                                                     
                                                     
                                                  
                                                     }
                                       ),
                                      ),
                                    );
                                  }
                                );
                              }
                            );
                          }
                        ),
                        ),
                           SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                           MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ValueListenableBuilder(
                    valueListenable: fromt,
                    builder: (context, fromtt, child) {
                      return ValueListenableBuilder(
                        valueListenable: tot,
                        builder: (context, tott, child) {
                          return GestureDetector(
                          onTap: () async {
                                               
                                               
                          setState(() {
                               fromt.value = fetchfromt ?? 'N/A';
                               tot.value = fetchtot ?? 'N/A';
                                    
                              },);
                                Navigator.pop(context);
                             
                           
                             
                           
                          },
                          child: Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 0.5),
                            ),
                            child: Center(child: Text('Cancel', style: TextStyle(fontFamily: 'Inter'),)),
                            ),
                          );
                        }
                      );
                    }
                  )
                  ),
                  SizedBox(width: 10,),
                   FutureBuilder(
                    future: Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true'),
                    builder: (context, snapshot) {
                  
                  return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                         
                          Navigator.pop(context);
                          },
                          child: Container(
                            width: 100,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 142, 204, 251),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Save',
                                style: TextStyle(fontFamily: 'Inter'),
                              ),
                            ),
                          ),
                        ),
                      );
                   
                    },
                  ),
                        ],)
          ],),
          ),
        );
      }
    ),
    );
  },
  
  );
}
  int? id;
  DateTime? endTime;
   DateTime? startTimer;
  bool forklift = false;
  Map<int, bool> showGreenMap = {};
final Map<String, int?> _statusCache = {};
int? hoverIndex;
int filteredData = 1;
int filteredTime = 1;
MenuController menuController  = MenuController();
MenuController menuController2 = MenuController();


Future<List<Map<String, dynamic>>> preprocessEntries(
  List<Map<String, dynamic>> rawEntries
) async {
  final List<Map<String, dynamic>> processed = [];

  for (final entry in rawEntries) {
    final extra = await Supabase.instance.client
        .from('masterdata')
        .select()
        .eq('id', entry['id'])
        .maybeSingle();

    if (extra != null) {
      processed.add({...entry, 'extraData': extra});
    } else {
      processed.add(entry); // Or skip
    }
  }

  return processed;
}



Map<String, dynamic>? response5;
String? nextprocess;
bool loadingUser = false;
Future<int?> fetchStatusForEntry(Map<String, dynamic> entry) async {
  
  final cacheKey = '${entry['id']}_${entry['currentprocess']}';
  if (_statusCache.containsKey(cacheKey)) return _statusCache[cacheKey];


final List<Map<String, dynamic>> response2 = 
                           
                                await Supabase.instance.client
                    .from('detail')
                    .select()
                    .eq('idreq', entry['id']);
if (response2.length > 1){
  final startTime = DateTime.parse(entry['finishedtime']);
  final startRange = startTime.subtract(const Duration(seconds: 15));
  final endRange = startTime.add(const Duration(seconds: 15));

   response5  = await Supabase.instance.client
      .from('detail')
      .select('status')
      .eq('idreq', entry['id'])
      .eq('process', entry['currentprocess'])
      .gte('starttime', startRange.toUtc().toIso8601String())
      .lte('starttime', endRange.toUtc().toIso8601String())
      .limit(1)
      .maybeSingle();
} else {
  final startTime = DateTime.parse(entry['starttime']);
  final startRange = startTime.subtract(const Duration(seconds: 15));
  final endRange = startTime.add(const Duration(seconds: 15));

   response5  = await Supabase.instance.client
      .from('detail')
      .select('status')
      .eq('idreq', entry['id'])
      .eq('process', entry['currentprocess'])
      .gte('starttime', startRange.toUtc().toIso8601String())
      .lte('starttime', endRange.toUtc().toIso8601String())
      .limit(1)
      .maybeSingle();
}

  final status = response5?['status'] as int?;
  _statusCache[cacheKey] = status;
  return status;
}



   
Future<List<dynamic>> fetchValues(entry) async {
  Map<String, dynamic>? routeResponse;
  
   final originalNeed = entry['requestitem'];
    if (originalNeed == null) {
    } else {
      final response1 = await Supabase.instance.client
          .from('route')
          .select()
          .or('disabled.is.null,disabled.not.eq.true')
          .eq('material', originalNeed);

  if (response1.isNotEmpty) {
    final detailCount = await Supabase.instance.client
        .from('detail')
        .select()
        .eq('originalneed', entry['requestitem']).eq('idreq', entry['id']);

if (detailCount.isNotEmpty){
    final processsList = await Supabase.instance.client
        .from('route')
        .select()
        .or('disabled.is.null,disabled.not.eq.true')
        .eq('material', entry['requestitem'])
        .eq('step', detailCount.isEmpty ? 1 : detailCount.length )
        .maybeSingle();
    if (processsList != null) {
      routeResponse = processsList;
    }
}
  }
    }

  final processList = await Supabase.instance.client.from('process').select(); 
  final forkliftRows = await Supabase.instance.client
      .from('detail')
      .select()
      .eq('idreq', entry['id'])
      .eq('process', 'Forklift')
      .eq('status', 0).maybeSingle();

  return [ 
    processList, 
  forkliftRows ?? {}, 
  routeResponse ?? {},
  ];
}
String? next;
bool showGreen = false;
int status = 0;
bool isChecked = false;
bool isDone = true;
dynamic step;
String? fromm;
String? tott;
String nextProcess = 'Select the next step';
void confirm(entry, fromt, tot) async {
  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setLocalState) => 
       AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 244, 244, 244),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 35,),
          Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20
          ,color: Colors.blue, fontFamily: 'WorkSans')),
          SizedBox(height: 10),
          Text('Please choose the next step', style: TextStyle(color: const Color.fromARGB(255, 128, 128, 128), fontFamily: 'Inter'),),
          SizedBox(height: 35),
          Container(
            height: 40,
            width: 250,
            decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               border: Border.all(width: 0.5, color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  FutureBuilder(
                
                future: fetchValues(entry),
                
                builder: (context, snapshot) {
                  print("Snapshot data: ${snapshot.data.runtimeType}");
                  if (snapshot.connectionState == ConnectionState.waiting){
             return Text('Loading...');
                  }
                                                  if (snapshot.hasError) {
                                                  return Text('Error: ${snapshot.error}');
                                                }
           
                       final processList = snapshot.data?[0] as List<dynamic>? ?? [];
                           final routeData = snapshot.data?[2] as Map<String, dynamic>? ?? {};
                             final forkliftData = snapshot.data?[1] as Map<String, dynamic>? ?? {};
                           

                           if (routeData.isNotEmpty){
                           nextProcess = '${routeData['process']}';
                           }
                           print("Snapshot data: ${snapshot.data.runtimeType}");
                  return routeData.isNotEmpty  ? Text('${routeData['process']}',  style: TextStyle( fontWeight: FontWeight.bold, color:
                     
                      const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter')) : processList.isNotEmpty ? 
           DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: nextProcess,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Select the next step',
                              child: Text('Select the next step', style: TextStyle(
                                color: Colors.grey, fontFamily: 'Inter'
                              ))
                              ),
                                DropdownMenuItem<String>(
                              value: 'Finished',
                              child: Text('Finished', style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),fontFamily: 'Inter', fontWeight: FontWeight.bold
                              ))
                              ),
                              ...processList.map((entry) { 
                                return DropdownMenuItem<String>(
                                value: entry['description'],
                                child: Text(entry['description'], style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),fontFamily: 'Inter', fontWeight: FontWeight.bold
                              )));
                                }),
                          ],
                          onChanged: (value){
                            nextProcess = value!.toString();
                            setLocalState(() {
                              fromTo(entry);
                            });
                          }
                          ),
                     ) : Text('${forkliftData['nextprocess']}', style: TextStyle( fontWeight: FontWeight.bold, color:
                     
                      const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter'),);
                }
              ), 
          ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 75,),
              Checkbox(
                              activeColor: const Color.fromARGB(255, 0, 74, 123),
               value: isChecked,
                onChanged: (value){
                  if (isChecked == true){
                    forklift = true;
                  } else {
                    forklift = false;
                  }
                 setLocalState(() {
                   
                 });
                 isChecked = value!;
                 setLocalState(() {
                   
                 });
                }
                ),
                 SizedBox(width: 5),
                 Text('Needs forklift', style: TextStyle(fontFamily: 'Inter'),),
                 SizedBox(width: 5,),
                 Icon(Icons.forklift),
            ],
          ),
          SizedBox(height: 25,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
               child:  GestureDetector(
                onTap: (){
                Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),),
                      ],
                    ),
                  ),
                )
              )),
              SizedBox(width: 10),
              MouseRegion(
                cursor: SystemMouseCursors.click,
               child:  GestureDetector(
                onTap: () async {
                await finish(entry, fromt, tot);
                setLocalState(() {
                  _statusCache.clear();
                });
                },
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                   color: const Color.fromARGB(255, 140, 203, 255),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(width: 19,),
                        Text('Ok', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter'),),
                      ],
                    ),
                  ),
                )
              )),
            ],
          ),
          ],
        ),
      ),
      ),
    ));
   
}
String? usernamer;
String? nexts;
String? current;
List processList = [];
Future<void> whichPopUp(entry, fromt, tot) async {

 
 setState(() {
    ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:  Color.fromARGB(255, 126, 255, 131),
                                content: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Icon(Icons.check_circle, color: const Color.fromARGB(255, 0, 152, 5)),
                                  SizedBox(width: 10,),
                                  Text('Completed sucessfully!', style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                 
                                ],
                                ))
                             );
 });
 final response56 = await Supabase.instance.client.from('process').select().eq('description', entry['process']).maybeSingle();
 
 next = entry['nextprocess'];
  await Supabase.instance.client.from('detail').update({
    'status': 1,
    'endtime' : DateTime.now().toUtc().toIso8601String(),
  }).eq('id', entry['id']);

if (entry['nextprocess'] == null || entry['nextprocess'] == 'Finished'){
await Supabase.instance.client.from('masterdata').update({
'closed': 1,
'finishedtime': DateTime.now().toUtc().toIso8601String(),
}).eq('id', entry['idreq']);
}

final response2 = await Supabase.instance.client.from('detail').select().eq('id', entry['id']);
print('rEYA2 $response2');
final  originalNeed = entry['originalneed'];
print('or $originalNeed');
final usernamem = entry['usernamed'];
print('ory $usernamem');
final process = entry['process'];
print ('pro $process');
final response30 = await Supabase.instance.client.from('detail').select().eq('idreq', entry['idreq']);
print('r30 $response30');
final response1 = await Supabase.instance.client.from('route').select().eq('material_route', entry['route_name']).or('disabled.is.null,disabled.not.eq.true');

final response33 = await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', entry['route_name']).eq('step', (entry['steps'] + 1));
print('response 33 $response33');

if (response1.isNotEmpty){
  if (response33.isNotEmpty){
    for (final response3 in response33){
          final response10 = await Supabase.instance.client.from('process_users').select().eq('processpu', process).or('disabled.is.null,disabled.not.eq.true');
     print(response10.length);
          if (response10.length > 1){
            
            alone = 'false';
          } else {
           alone = 'true';
         usernamer = response10[0]['userpu'];
          }
           
    final response4 = await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', entry['route_name']).eq('step', (response2.length + 2));
      // await Supabase.instance.client.from('masterdata').update({
      //                                   'currentprocess': response3['process'],
      //                                 }).eq('id', entry['idreq']);
    
                                      final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];


   

   final responsey = await Supabase.instance.client.from('masterdata').select().eq('id', entry['idreq']).maybeSingle();
if ( response3['to_route']  == 'Material Location'){
       final responseso = await Supabase.instance.client.from('materials').select().eq('description', entry['originalneed']).maybeSingle() as Map<String, dynamic>;
    
  final location = responseso['location'];
  
fetchtot2 = location ?? 'N/A';
 
} else if ( response3['to_route']  == 'Current Process'){
fetchtot2 = responsey!['machine'];
} else {
  fetchtot2 = response3['to_route'];
}

 
if ( response3['from_route']  == 'Material Location'){
       final responseso = await Supabase.instance.client.from('materials').select().eq('description', entry['originalneed']).maybeSingle() as Map<String, dynamic>;
    
  final location = responseso['location'];
  
fetchfromt2 = location ?? 'N/A';
 
} else if ( response3['from_route'] == 'Current Process'){
  
fetchfromt2 = responsey!['machine'];
} else {
  fetchfromt2 = response3['from_route'];
}


  final response99 = await Supabase.instance.client.from('detail').select().eq('idreq', entry['idreq']).eq('route_name', entry['route_name'])
  .eq('steps', entry['steps']).eq('status', 0);
  print('r999 $response99');
if (response99.isEmpty){
   await Supabase.instance.client.from('detail').insert({
    'starttime': DateTime.now().toUtc().toIso8601String(),
    'originalneed': response3['material'],
    'idreq': entry['idreq'], 
    'nextprocess': response4.length == 1 ? response4[0]['process'] ?? 'Finished' : 'Finished',
    'usernamed': usernamem,
    'process': response3['process'] ?? 'N/A',
    'company': company,
    'detail_from': fetchfromt2 ?? 'N/A',
    'detail_to': fetchtot2 ?? 'N/A',
    'steps': entry['steps'] + 1,
    'route_name': entry['route_name'],
    'neededby': entry['neededby']
  });
}



if (response99.isEmpty){
  await Supabase.instance.client.from('masterdata').update({
    'currentprocess': response3['process'],
  }).eq('id', entry['idreq']);


}}
  } else {
 
    await Supabase.instance.client.from('masterdata').update({
    'closed': 1,
    'finishedtime': DateTime.now().toUtc().toIso8601String(),
    
  }).eq('id', entry['idreq']);
  }

} else {
  print('${entry['process']} hie');
   if (response56?['matmov']){
     

   nexts = entry['nextprocess'] ?? 'Finished';
   current = entry['process'];

    if ( nexts != null && nexts != 'Finished'){
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final usern = response?['username'];
    await Supabase.instance.client.from('masterdata').update({
                                        'currentprocess': nexts,
                                      }).eq('id', entry['idreq']);
                                        await Supabase.instance.client.from('detail').insert({
   'starttime': DateTime.now().toUtc().toIso8601String(),
   'originalneed': originalNeed,
   'idreq': entry['idreq'], 
   'usernamed': usernamem,
   'process': nexts,
   'company': company,
    'neededby': entry['needtime'],
    if (alone == 'false')
   'current_user': usernamer,
   if (alone == 'true')
   'user_unique': usern
  });}

  
  if (nexts == 'Finished' || nexts == null){
 
 try {
  final updateResult = await Supabase.instance.client.from('masterdata').update({
    'finishedtime': DateTime.now().toUtc().toIso8601String(),
    'closed': 1,
  }).eq('id', entry['idreq']);
  print('Update result: $updateResult');
} catch (e) {
  print('Update failed with exception: $e');
}

}

  }
    else {

    await Supabase.instance.client.from('masterdata').update({
    'closed': 1,
    'finishedtime': DateTime.now().toUtc().toIso8601String(),
    
  }).eq('id', entry['idreq']);
}
}
}

Future<void> finish(entry, fromt, tot) async {
  if (nextProcess != 'Select the next step'){
 

final  originalNeed = entry['originalneed'];
final usernamem = entry['usernamed'];

if (nextProcess != 'Finished'){

   await Supabase.instance.client.from('masterdata').update({
                                        'currentprocess': forklift ? 'Forklift' : nextProcess,
                                      }).eq('id', entry['idreq']);
} else {
   await Supabase.instance.client.from('masterdata').update({
    if (!forklift)
    'closed': 1,
    if (forklift)
    'currentprocess': 'Forklift',
    if (!forklift)
    'finishedtime': DateTime.now().toUtc().toIso8601String(),
  }).eq('id', entry['idreq']);



if (forklift && nextProcess == 'Finished'){
 final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final usern = response?['username'];
  await Supabase.instance.client.from('detail').insert({
   'starttime': DateTime.now().toUtc().toIso8601String(),
   'originalneed': originalNeed,
   'idreq': entry['idreq'], 
   'usernamed': usernamem,
   'process': 'Forklift',
   'nextprocess': 'Finished',
   'company': company,
    'neededby': entry['needtime'],
    if (alone == 'false')
   'current_user': usernamer,
      if (alone == 'true')
   'user_unique': usern
  });
}

  if (nextProcess != 'Finished'){
    final response56 = await Supabase.instance.client.from('process').select().eq('description', entry['process']).maybeSingle();
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  await Supabase.instance.client.from('detail').insert({
   'starttime': DateTime.now().toUtc().toIso8601String(),
   'originalneed': originalNeed,
   'idreq': entry['idreq'], 
   'usernamed': usernamem,
    'neededby': entry['needtime'],
   'process': forklift ? 'Forklift' : nextProcess,
   if (forklift)
   'nextprocess': nextProcess, 
   'company': company,
   if (forklift || response56?['matmov'])
   'from_detail': fromt ?? 'N/A',
 if (forklift ||response56?['matmov'])
   'to_detail': fromt ?? 'N/A',
  });
  }
  }
  //   setState(() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //                             SnackBar(
  //                               backgroundColor: const Color.fromARGB(255, 201, 245, 203),
  //                               content: Row(
  //                               children: [
  //                                 SizedBox(width: 10,),
  //                                 Icon(Icons.check_circle, color: const Color.fromARGB(255, 133, 255, 137)),
  //                                 SizedBox(width: 10,),
  //                                 Text('You just finished a task!', style: TextStyle(color: const Color.fromARGB(255, 44, 154, 29),
  //                                 fontWeight: FontWeight.bold, fontFamily: 'Inter')),
  //                                 Spacer(),
  //                                 MouseRegion(
  //                                   cursor: SystemMouseCursors.click,
  //                                   child: GestureDetector(
  //                                     onTap: () async {
  //                                       _statusCache.clear();
  //                                       final response = await Supabase.instance.client.from('masterdata').select().maybeSingle();
  //                                     final id = response?['id'];
  //                                     await Supabase.instance.client.from('masterdata').update({
  //                                       'closed': 0,
  //                                       'finishedtime': null,
  //                                     }).eq('id', id);
  //                                     setState(() {
                                        
  //                                     });
  //                                     },
  //                                     child: Container(
  //                                       width: 60,
  //                                       height: 30,
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(width: 1, color: const Color.fromARGB(255, 223, 223, 223)),
  //                                       borderRadius: BorderRadius.circular(10),
  //                                       color: Colors.white,),
  //                                       child: Padding(
  //                                         padding: const EdgeInsets.all(2.0),
  //                                         child: Text('Undo', textAlign: TextAlign.center, style: TextStyle(color: Colors.black ,fontFamily: 'Inter')),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 )
  //                               ],
  //                               ))
  //                            );
  // });
  } else {
     showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        content: SizedBox(
            width: 300,
            height: 150,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Icon(Icons.error, color: Colors.red,),
                  SizedBox(height: 10,),
                  Text('Please do not leave a field blank.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  SizedBox(height: 17),
                  Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.red),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 13),
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector
                                          ( onTap: (){
                                          Navigator.pop(context);
                                          },
                                            child: Text('Understood', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
              
                       ] ),
            ),
          )
      ),
      );
      setState(() {
        
      });
  }
}

 bool selected1 = false;
bool  selected2 = true;
bool selected3 = false;

String? alone;
String? allowedProcess;
String? username;
bool forklifter = false;
Future<Map<String, String?>> fetchUsername() async {
          final user = Supabase.instance.client.auth.currentUser;
          final email = user?.email;
          final response = await Supabase.instance.client.from('user').select().eq('email', email ?? '').maybeSingle();
          print('responseee $response');
          username = response?['username'];
          print('userrf $username');
          final response2 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username ?? '').maybeSingle();
           if (response2 != null){
           allowedProcess = response2['machine'];
           print('allow3 $allowedProcess');
           }
           print('response2 $response2');
           final response3 = await Supabase.instance.client.from('process_users').select().eq('userpu', username ?? '').or('disabled.is.null,disabled.not.eq.true');
       if (response2 == null && response3.isNotEmpty){
            
            allowedProcess = response3[0]['processpu'];

       }

         final response57 = await Supabase.instance.client.from('process').select().eq('description', response3[0]['processpu']).maybeSingle();
         
            response57 != null ?  response57['matmov'] == true ? forklifter = true : forklifter = false : forklifter = false;
              print('r57 $response57');
          final response10 = await Supabase.instance.client.from('process_users').select().eq('processpu', allowedProcess ?? '').or('disabled.is.null,disabled.not.eq.true');
print('allow $allowedProcess');
          if (response10.length > 1){
            
            alone = 'false';
            
          } else {
           alone = 'true';
          }
          print('alone $alone');
          if (response2 != null){
            final response56 = await Supabase.instance.client.from('process').select().eq('description', response2['machine']).maybeSingle();
            print('r56 $response56');
            response56 != null ?  response56['matmov'] == true ? forklifter = true : forklifter = false : forklifter = false;
            print('r57 $response57');
           
//           if (response56 != null && response56['matmov'] == true) {
//   forklifter = true;
//   print('forklifter from response56');
// } else if (response57 != null && response57['matmov'] == true) {
//   forklifter = true;
//   print('r5732 $response57');
// }
          }
            
       
         print('allo $allowedProcess');
         print('allous $username');
         print('allone $alone');
         return {
    'username': username,
    'allowedProcess': allowedProcess,
    'alone': alone,
    
  };
          
}

// void updateTotalTimeOnce() async {
//   try {
//     final List<dynamic> records = await Supabase.instance.client
//         .from('masterdata')
//         .select('id, starttime, finishedtime, closed');

//     for (var entry in records) {
//       if (entry['starttime'] == null) continue;

//       final createdAt = DateTime.parse(entry['starttime']);
//       int minutesElapsed;

//       if (entry['finishedtime'] != null && entry['closed'] == 1) {
//         minutesElapsed = DateTime.parse(entry['finishedtime']).difference(createdAt).inMinutes;
//       } else {
//         minutesElapsed = DateTime.now().difference(createdAt).inMinutes;
//       }

     
//     }
//   } catch (e) {
//     print('Error updating totaltime: $e');
//   }
// }


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

                final finalFiltern = 
              entries.where((entry){
                // if (entry['usernamed'] == username){
                //   return false;
                // }
                // if (entry['process'] != allowedProcess )
                // { 
                //   return false;
                // }
              
              if (filteredData == 2) {
            if (filteredTime == 3){
            return entry['status'] == 1 && DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
            
            } else if (filteredTime == 4){
return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['status']  == 1;
            } else if (filteredTime == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['status']  == 1;  
            } else { 
              return entry['status'] == 1;
            }
          } else if (filteredData == 3) {
            if (filteredTime == 3){
            return entry['status'] == 0 && DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
            
            } else if (filteredTime == 4){
return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['status']  == 0;
            } else if (filteredTime == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['status']  == 0;  
            } else { 
              return entry['status'] == 0;
            }
          }
          
          if (filteredTime == 2 ){
          if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['status'] == 1;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1 && entry['status'] == 0;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 1;
          }
          } 
                     if (filteredTime == 3){
           if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7 && entry['status'] == 1;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7 && entry['status'] == 0;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 7;
          }
          } 
           if (filteredTime == 4 ){
           
           if (filteredData == 2){
            return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30 && entry['status'] == 30;
          } else if (filteredData == 3){
              return DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30  && entry['status'] == 30;
          } else {
            return  DateTime.parse(entry['starttime']).difference(DateTime.now()).inDays.abs() <= 30;
          }
          } else {
            return true; 
          }}).toList();
          
                    finalFiltern.sort((a, b) {
  final closedA = a['status'] ?? 1;
  final closedB = b['status'] ?? 1;
  if (closedA != closedB) {
    return closedA.compareTo(closedB); // closed = 0 first
  } else {
    return (b['id'] ?? 0).compareTo(a['id'] ?? 0); // higher id first
  }
});       
return Scaffold(
  
  floatingActionButton:  focusmode ? SizedBox.shrink() : AddButton(),
backgroundColor: Color.fromARGB(255, 236, 244, 254),
  body: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(children: [
     
     focusmode ? SizedBox.shrink() :
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
                                    
                                     final filteredData = data.where((entry) => entry['endtime'] == null && entry['process'] == allowedProcess && ((entry['current_user'] == null && entry['user_unique'] == null) || ((entry['current_user'] == username|| entry['user_unique'] == username) )));
                                     return                               Flexible(
                                       child: Text('(${filteredData.length})',  textAlign: TextAlign.center, style: TextStyle(
                                                                       color:filteredData.isEmpty ?  const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 253, 242, 143),
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
                         context.go('/outbound');
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
                                     final filteredData = data.where((entry) => entry['usernamem'] == username && entry['finishedtime'] == null);
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
                               
          ],
        ),
      ),
      Row(
        children: [
          SizedBox(width: 10),
          SizedBox(
            width: focusmode ?  MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.87 ,
                height: MediaQuery.of(context).size.height * 0.93,
            child: Column(children: [
               focusmode ? SizedBox(height: 5,) :
                       SizedBox(height: 20),
                      
                      Row(
            children: [
              SizedBox(width: 30),
              focusmode == false ?
              Text('Inbound Data', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30
              , fontFamily: 'Inter')) : 
              TextButton(onPressed: (){
                setState(() {
                  focusmode = false;
                });
              }, child: Text('Exit', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 18),)),
            ],
                      ),
                      focusmode ? SizedBox(height: 0,) :
                       SizedBox(height: 30),
                    
                    focusmode ? SizedBox.shrink() :
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
                SizedBox(width: 20,),
                Tooltip(
                  message: 'Focus Mode',
                decoration: BoxDecoration(
    color: Colors.transparent, 
  ),
                  textStyle: TextStyle(fontFamily: 'Inter'),
                  child: IconButton(
                   
                    onPressed: (){
                      setState(() {
                        focusmode = true;
                      });
                    }, icon: Icon(Icons.mobile_friendly, color: focusmode ? Colors.blue : Colors.grey,)),
                )
                 ],),
                focusmode ? SizedBox(height: 5,) :
                       SizedBox(height: 25),
  
            Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
                        colors: [ const Color.fromARGB(255, 186, 224, 254), const Color.fromARGB(255, 234, 245, 255) ],
                      begin: Alignment.centerLeft, end: Alignment.centerRight),
                       borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                ),
              
                height: 60,
                width:  focusmode ? MediaQuery.of(context).size.width : double.infinity,
                child: FutureBuilder(
                  future: fetchUsername(),
                  builder: (context, snapshot) {
                    
                    return Row(children: [
                        SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    
                        SizedBox(width:  focusmode ? MediaQuery.of(context).size.width *  0.3 : MediaQuery.of(context).size.width *  0.15, child: Text('ID', style: TextStyle(fontSize: 15, fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                    
                        SizedBox(width:  focusmode ? MediaQuery.of(context).size.width *  0.3 : MediaQuery.of(context).size.width *  0.15, child: Text('Requested Item', style: TextStyle(fontSize: 15, fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                           SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                        SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.15 : MediaQuery.of(context).size.width * 0.088, child: Text('Needed', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                            focusmode ? SizedBox.shrink() :
                        SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text('Request Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                        
                           SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                            focusmode ? SizedBox.shrink() :
                            SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text('Finished Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                            fontWeight: FontWeight.bold))),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text('Total Time', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                           SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                            if (forklifter)
                            SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.15 : MediaQuery.of(context).size.width * 0.088, child: Text('From', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                            fontWeight: FontWeight.bold))),
                               SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  if (forklifter)
                            SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.09: MediaQuery.of(context).size.width * 0.088, child: Text('To', style: TextStyle(fontSize: 14, fontFamily: 'Inter',
                            fontWeight: FontWeight.bold))),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          
                    ],);
                  }
                )
            ),
            Expanded(
            child: FutureBuilder(
      future: fetchUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && (snapshot.data == null || snapshot.data!.isEmpty)) {
    return Center(child: CircularProgressIndicator(color: Colors.blue));
    }
      
        final username = snapshot.data!['username'];
    final allowedProcess = snapshot.data!['allowedProcess'];
    
    final finalFilter = finalFiltern.where((entry) =>  entry['process'] == allowedProcess).toList();
      
                
                        
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
            : ListView.builder(
              itemCount: finalFilter.length   + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                    if (index == finalFilter.length) {
        return SizedBox.shrink();
      }
                    final entry = finalFilter[index];
                          
                    final startTime = DateFormat("MM-dd h:mm a")
                        .format(DateTime.parse(entry['starttime']).toLocal());
                    final endTime = (entry['endtime'] != null)
                        ? DateFormat("MM-dd h:mm a")
                            .format(DateTime.parse(entry['endtime']).toLocal())
                        : 'N/A';
                          
                    int minutesElapsed;
                    final createdAt = DateTime.parse(entry['starttime']);
                    if (entry['endtime'] != null) {
                      minutesElapsed = DateTime.parse(entry['endtime'])
                          .difference(createdAt)
                          .inMinutes;
                    } else {
                      minutesElapsed = DateTime.now().toUtc().difference(createdAt).inMinutes;
                    }
                          
                  
                          
                           final id = entry['id'];
                                         
                        void fetchStatus() async {               
                                         
                          final response2 = await Supabase.instance.client.from('detail').select().eq('idreq', id);
                          
                          final filteredData = response2.where((row) => row['process'] == entry['currentprocess'] && row['starttime']
                          == entry['starttime']);
                          
                          for (final match in filteredData){
                final response = await Supabase.instance.client.from('detail').select().eq('id', match['id']).maybeSingle();
                          status = response?['status'];
                          }
                  }
                          
                          
                          
                          fetchStatus();
                          
                    return StatefulBuilder(
                     builder: (context, setLocalState) {
                            void updateGreenStatus() async {
                  final int? status = await fetchStatusForEntry(entry);
                  if (showGreenMap[entry['id']] != (status == 1)) {
                    setLocalState(() {
                      showGreenMap[entry['id']] = (status == 1);
                    });
                  }}
                   WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final cacheKey = '${entry['id']}_${entry['currentprocess']}';
                  if (!showGreenMap.containsKey(entry['id']) && !_statusCache.containsKey(cacheKey)) {
                    final status = await fetchStatusForEntry(entry);
                    setLocalState(() {
                      showGreenMap[entry['id']] = (status == 1);
                    });
                  }
                });
                 final fetchfromt = snapshot.data![0]?[entry['id']] ?? 'N/A';
                       
                           return Container(
                            height: 60,
                            
                            decoration: BoxDecoration(
                                      color:  entry['status'] == 1
                                ?  Color.fromARGB(255, 172, 250, 175) :
                                alone == 'false' ? 
                                      entry['current_user'] != null ? entry['current_user'] == username 
                                      ? const Color.fromARGB(255, 255, 250, 205) : const Color.fromARGB(255, 197, 197, 197) :  Colors.white : Colors.white,
                                 border: const Border(
                                      bottom: BorderSide(width: 1, color: Color.fromARGB(255, 118, 118, 118)),
                            ),
                            ),
                            child: MouseRegion(
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
                              child: Row(
                                children: [
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  
                                    SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.27 : MediaQuery.of(context).size.width *  0.15, child: Text("${entry['id']}", style: TextStyle(fontSize: 15, fontFamily: 'Inter'))),
                                    
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                  
                                    SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.27 : MediaQuery.of(context).size.width *  0.15, child: Text(entry['originalneed'], style: TextStyle(fontSize: 15, fontFamily: 'Inter'))),
                                    
                                       SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                    SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.15 : MediaQuery.of(context).size.width * 0.088, child: Text(entry['neededby'] ?? 'N/A', style: TextStyle(fontSize: 15, fontFamily: 'Inter'))),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                       focusmode ? SizedBox.shrink() :
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text(startTime, style: TextStyle(fontSize: 15))),
                                     SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                      focusmode ? SizedBox.shrink() :
                                         SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text(endTime, style: TextStyle(fontSize: 15, fontFamily: 'Inter'))),
                                                 SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.088, child: Text('$minutesElapsed', style: TextStyle(fontSize: 15, fontFamily: 'Inter'))),
                                 
                                 
                                  SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                                         if (forklifter)
                           
                                SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.15 : MediaQuery.of(context).size.width * 0.088, child: Text(entry['detail_from'] ?? 'N/A', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                                ))),
                            
                            
                                                        SizedBox(width: MediaQuery.of(context).size.width * 0.009),
                              if (forklifter)
                                                      SizedBox(width: focusmode ? MediaQuery.of(context).size.width *  0.13 : MediaQuery.of(context).size.width * 0.088, child: Text(entry['detail_to'] ?? 'N/A', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                                                     ))),
                                                            SizedBox(width: MediaQuery.of(context).size.width * 0.038, child: Row(
                                      children: [
                                      
                                        Tooltip(
                                        message: entry['current_user'] ?? 'Accept\nRequest',
                                        decoration: BoxDecoration(
                                          color: Colors.transparent
                                        ),
                                        textStyle: TextStyle(fontFamily: 'Inter'),
                                          child:
                                          
                                          alone == 'false' ? IconButton(
                                                                                      onPressed: entry['current_user'] != null ? null : () async {
                                                       
                                                               await Supabase.instance.client.from('detail').update({
                                                                'current_user': username,
                                                                'timecurrent_user': DateTime.now().toUtc().toIso8601String()
                                                               }).eq('id', entry['id']);
                                                               setLocalState(() {
                                                                 
                                                               },);
                                           },
                                                                              
                                                                                      icon:( Icon(
                                                                          Icons.thumb_up,
                                                                          color: 
                                                                          entry['current_user'] == null ? Colors.grey : const Color.fromARGB(255, 255, 219, 41),
                                                                          //  entry['status'] == 0 ? const Color.fromARGB(255, 211, 211, 211) : const Color.fromARGB(255, 167, 229, 255),
                                                                          size: 26,
                                                                        )
                                                                            )) : SizedBox.shrink(),
                                        )],
                                      
                                    )
                                    
                                    ),
                                    SizedBox(width: focusmode ? MediaQuery.of(context).size.width * 0.036 : MediaQuery.of(context).size.width * 0.01),
                                     SizedBox(width: MediaQuery.of(context).size.width * 0.032, child: Row(
                                      children: [
                                      
                                        ValueListenableBuilder(
                                          valueListenable: tot,
                                          builder: (context, value, child) {
                                            return ValueListenableBuilder(
                                              valueListenable: fromt,
                                              builder: (context, value, child) {
                                                return Tooltip(
                                                message: 'Finished?',
                                                textStyle: TextStyle(fontFamily: 'Inter'),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent
                                                ),
                                                  child: IconButton(
                                                                                              onPressed: hasID.contains(entry['id']) ? null : alone == 'false' ? 
                                                                                              entry['current_user'] != username ? null :  entry['status'] == 1 ? null : () async {
                                                                                                   print('hasid $hasID entry id ${entry['id']}');
                                                                                                
                                                                                                  if (!hasID.add(entry['id'])) {
  
    print('Duplicate tap blocked');
    return;
  }
                                                           
                                                               
                                                                  print('hasid $hasID entry id ${entry['id']}');
                                                                     whichPopUp(entry, tot.value, fromt.value);
                                                              
                                                              
                                                                     
                                                   } : entry['status'] == 1 ? null : () async {
                                                  whichPopUp(entry, tot.value, fromt.value);
                                                   },
                                                                                      
                                                                                              icon:( Icon(
                                                                                  Icons.check_circle_rounded,

                                                                                  color:  entry['status'] == 1 ? Colors.green : Colors.grey,
                                                                                  size: 26,
                                                                                )
                                                                                    )),
                                                );
                                              }
                                            );
                                          }
                                        )],
                                      
                                    )
                                    
                                    ),
  
                                ],
                              ),
                            ),
                                               );
                         }
                       );
                     },
                    );
                          },
                
            
            ),
                      ),
                      
            ]),
          ),
        ],
      )
    ],),
  ),
);
}
}