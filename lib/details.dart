import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
setUrlStrategy(PathUrlStrategy());
  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp.router(
  debugShowCheckedModeBanner: false,
  routerConfig: appRouter,));

}

class Details extends StatefulWidget {
  final int id;
    final String? route; 
  const Details({super.key, required this.id, required this.route});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

@override
void initState(){
  
  super.initState();
Timer.periodic(Duration(minutes: 1), (timer){
  setState(() {
  });
  



});

}
String? mat;
bool loadingUser = false;
  @override
  Widget build (BuildContext context){
  return Scaffold(
  backgroundColor: Color(0xFFFAFAFA),
  body: Column(
children: [
  SizedBox(height: 50),
    MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector (
        onTap: (){
        context.go(widget.route!);
        },
  child: Align(
    alignment: Alignment.topLeft,
    child: Row(children: [
      SizedBox(width: 50),
     Icon(Icons.keyboard_backspace),
     SizedBox(width: 10),
  Text('Back', style: TextStyle(fontSize: 20),)]),
    ),
      )),
    Row(
      children: [
        SizedBox(width: 10),
        SizedBox(
            width: 1710,
                  height: 750,
          child: Expanded(
            child: Column(children: [
             SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 40),
              FutureBuilder(
                future: Supabase.instance.client.from('detail').select().eq('idreq', widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                   return CircularProgressIndicator();
                  }
                  final data = snapshot.data ?? [];
                    if (data.isNotEmpty) {
                   mat = data[0]['originalneed'];
                    }
                  return Text('Details - $mat', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30));
                }
              ),
            ],
          ),
          SizedBox(height: 80),
            Container(
              
               decoration: BoxDecoration(
                        gradient: LinearGradient(
                                    colors: [ const Color.fromARGB(255, 186, 224, 254), const Color.fromARGB(255, 234, 245, 255) ],
                                  begin: Alignment.centerLeft, end: Alignment.centerRight),
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                            ),
                height: 50,
                width: double.infinity,
                child: Row(children: [
                  SizedBox(width: 20),
                  
                    SizedBox(width: 250, child: Text('Process', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Request Time', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                     
                    SizedBox(width: 150, child: Text('Start time', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('End time', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 80, child: Text('Status', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 40),
                    SizedBox(width: 250, child: Text('Next process', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Current User', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                       SizedBox(width: 20),
                    SizedBox(width: 150, child: Text('Total Time (min)', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                ],)
            ),
            Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: Supabase.instance.client
              .from('detail')
              .stream(primaryKey: ['id'])
              .order('id'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
             loadingUser = true;
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          
            final data = snapshot.data ?? [];
            final filteredData = data
                .where((entry) => entry['idreq'] == widget.id)
                .toList();
          
            if (filteredData.isEmpty) {
              return Center(child: Column(
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
              ));
            }
          
            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final entry = filteredData[index];
          
                 final startTimeStr = DateTime.parse(entry['starttime']).toLocal();
              final startTime = DateFormat("MM-dd h:mm a").format(startTimeStr);
              
                        
              final startTimeU = (entry['timecurrent_user'] != null) ? DateFormat("MM-dd h:mm a").format(DateTime.parse(entry['timecurrent_user']).toLocal()) : 'N/A';
              
              final endTime = (entry['endtime'] != null) ? DateFormat("MM-dd h:mm a").format(DateTime.parse(entry['endtime']).toLocal()) : 'N/A';
             
          
              final idreq = widget.id;
          
           final process = entry['process'];
          final originalneed = entry['originalneed'];
          final username = entry['usernamed'];
          
                return FutureBuilder(
                  future:  Supabase.instance.client.from('process_users').select().eq('processpu', entry['process']).or('disabled.is.null,disabled.not.eq.true'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: SizedBox(
                          width: 50
                          , height: 50,
                          child: Text('')),
                      );
                    }


                             
                  int minutesElapsed;
                final createdAt = DateTime.parse(entry['starttime']).toUtc();
                  if (entry['endtime'] != null && entry['status'] == 1) {
                    minutesElapsed = DateTime.parse(entry['endtime']).toUtc()
                        .difference(createdAt)
                        .inMinutes;
                  } else {
                    minutesElapsed = DateTime.now().toUtc().difference(createdAt).inMinutes;
                  }
                    
              
                      bool? alone;
                                                          final data = snapshot.data ?? [];
                                                          if (data.length > 1){
                                                            alone = false;
                                                          } else {
                                                            alone = true;
                                                          }
                    return Container(
                      decoration: BoxDecoration(
                               color: //  alone == true ?
                             (entry['status'] == 1)
                            ? const Color.fromARGB(255, 220, 255, 221)
                               : const Color.fromARGB(255, 255, 255, 255),
                            // :   entry['current_user'] == null ? const Color.fromARGB(255, 215, 215, 215) : 
                            //                                   (entry['status'] == 1)
                            //                                     ? const Color.fromARGB(255, 182, 255, 185)
                            //    : const Color.fromARGB(255, 255, 242, 175),
                                                         
                          border: Border(bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 118, 118, 118) ))
                      ),
                      
                      child: SizedBox(
                        height: 55,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                              
                                                 SizedBox(width: 20),
                                              SizedBox(width: 250, child: Text(process, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                                 SizedBox(width: 20),
                                              SizedBox(width: 150, child: Text(startTime, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                                 SizedBox(width: 20),
                                              SizedBox(width: 150, child: Text(startTimeU, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                                 SizedBox(width: 20),
                                                    SizedBox(width: 150, child: Text(endTime, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                                 SizedBox(width: 20),
                                              SizedBox(width: 80, child: Container(
                                                width: 80,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                color: 
                                                 alone == false ?
                              entry['current_user'] == null ? const Color.fromARGB(255, 196, 196, 196) : 
                                                              (entry['status'] == 1)
                                                                ? const Color.fromARGB(255, 182, 255, 185)
                               : const Color.fromARGB(255, 255, 242, 175) :  (entry['status'] == 1)
                                                                ? const Color.fromARGB(255, 182, 255, 185)
                               : const Color.fromARGB(255, 255, 242, 175),
                                                border: Border.all(width: 0.5, color: (entry['status'] == 1) 
                                                ? const Color.fromARGB(255, 235, 255, 235)
                                                : const Color.fromARGB(255, 255, 255, 227),
                                                )
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: entry['status'] == 1 ? 6 : 0),
                                                      alone == true ?
                                                         Center(
                                                           child: Text(
                                                              (entry['status'] == 1) 
                                                                ? 'Done'
                                                                : 'Pending',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily: 'Inter',
                                                                color: (entry['status'] == 1)
                                                                  ? const Color.fromARGB(255, 0, 130, 4)
                                                                  : const Color.fromARGB(255, 205, 170, 0),
                                                              ),
                                                            ),
                                                         ) : Center(
                                                           child: Row(
                                                             children: [
                                                               Center(
                                                                 child: Text(
                                                                     entry['current_user'] == null ? 
                                                                     'Pending' :
                                                                    (entry['status'] == 1) 
                                                                      ? 'Done'
                                                                      : 'Active',
                                                                    style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontFamily: 'Inter',
                                                                      color: 
                                                                      entry['current_user'] == null ? const Color.fromARGB(255, 73, 73, 73) : 
                                                                      (entry['status'] == 1)
                                                                        ? const Color.fromARGB(255, 0, 130, 4)
                                                                        : const Color.fromARGB(255, 205, 170, 0),
                                                                    ),
                                                                  ),
                                                               ),
                                                             ],
                                                           ),
                                                         ) 
                                                        
                                                      
                                                    ],
                                                  ),
                                                ))),
                                                 SizedBox(width: 40),
                                              SizedBox(width: 250, child: Text(entry['nextprocess'] ?? 'N/A', style: TextStyle(fontSize: 15))),
                                               SizedBox(width: 20),
                                                 SizedBox(width: 150, child: Text(entry['current_user'] ?? entry['user_unique'] ?? 'N/A', style: TextStyle(fontSize: 15))),
                                                 SizedBox(width: 20),
                                                 SizedBox(width: 150, child: Text('$minutesElapsed' ?? 'N/A', style: TextStyle(fontSize: 15))),
                                              
                              ],
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
            ),)
            ]),
          ),
        ),
      ],
    )
],
  )
  );
  }
}