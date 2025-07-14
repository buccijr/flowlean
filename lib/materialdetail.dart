import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: DetailsM(materialname: 'N/A')));

}

class DetailsM extends StatefulWidget {
  final String materialname;
  const DetailsM({super.key, required this.materialname});

  @override
  State<DetailsM> createState() => _DetailsMState();
}

class _DetailsMState extends State<DetailsM> {

@override
void initState(){
  
  super.initState();
Timer.periodic(Duration(minutes: 1), (timer){
  setState(() {
    
  });
});

}


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
          Navigator.pop(context);
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
          child: Column(children: [
           SizedBox(height: 20),
                    Row(
          children: [
            SizedBox(width: 40),
            Text('Details', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
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
                  SizedBox(width: 100, child: Text('Id', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                  SizedBox(width: 20),
                  SizedBox(width: 350, child: Text('Request Item', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                     SizedBox(width: 20),
                  SizedBox(width: 250, child: Text('Process', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                     SizedBox(width: 20),
                  SizedBox(width: 150, child: Text('Start time', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                     SizedBox(width: 20),
                  SizedBox(width: 150, child: Text('End time', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                     SizedBox(width: 20),
                  SizedBox(width: 79, child: Text('Status', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                     SizedBox(width: 100),
                  SizedBox(width: 150, child: Text('Needed', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
                    SizedBox(width: 20),
                  SizedBox(width: 150, child: Text('Total Time (min)', style: TextStyle(fontSize: 15,  fontFamily: 'Inter', fontWeight: FontWeight.bold))),
              ],)
          ),
          Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: Supabase.instance.client
            .from('masterdata')
            .stream(primaryKey: ['id'])
            .order('id'),
                    builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
                    
          final data = snapshot.data ?? [];
          final filteredData = data
              .where((entry) => entry['requestitem'] == widget.materialname)
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
                    
               final startTimeStr = DateTime.parse(entry['starttime']);
            final startTime = DateFormat("MM-dd h:mm a").format(startTimeStr);
            
            
            final endTime = (entry['finishedtime'] != null) ? DateFormat("MM-dd h:mm a").format(DateTime.parse(entry['finishedtime'])) : 'N/A';
           
                    
                    
                     
                    
              return Container(
                decoration: BoxDecoration(
                    color: (entry['closed'] == 1)
                    ? Color.fromARGB(255, 172, 250, 175)
                    : Colors.white,
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
                                        SizedBox(width: 100, child: Text(entry['id'].toString(), style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                        SizedBox(width: 20),
                                        SizedBox(width: 340, child: Text(entry['requestitem'], style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                           SizedBox(width: 20),
                                        SizedBox(width: 250, child: Text(entry['currentprocess'], style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                           SizedBox(width: 20),
                                        SizedBox(width: 150, child: Text(startTime, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                           SizedBox(width: 20),
                                        SizedBox(width: 150, child: Text(endTime, style: TextStyle(fontSize: 15,  fontFamily: 'Inter', ))),
                                           SizedBox(width: 20),
                                        SizedBox(width: 79, child: Container(
                                          width: 79,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                          color: (entry['closed'] == 1) ? const Color.fromARGB(255, 184, 251, 186) : const Color.fromARGB(255, 255, 245, 207),
                                          border: Border.all(width: 0.5, color: (entry['status'] == 1) 
                                          ? const Color.fromARGB(255, 235, 255, 235)
                                          : const Color.fromARGB(255, 255, 255, 227),
                                          )
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Row(
                                              children: [
                                                SizedBox(width: entry['closed'] == 1 ? 12 : 2),
                                                Text((entry['closed'] == 1) 
                                                ? 'Done'
                                                : 'Pending'
                                                , style: TextStyle(fontSize: 15,
                                                fontFamily: 'Inter',
                                                color: (entry['closed'] == 1)
                                                ? const Color.fromARGB(255, 0, 130, 4)
                                                :  const Color.fromARGB(255, 205, 170, 0),
                                                )),
                                              ],
                                            ),
                                          ))),
                                           SizedBox(width: 100),
                                        SizedBox(width: 150, child: Text(entry['needtime'], style: TextStyle(fontSize: 15))),
                                           SizedBox(width: 20),
                                           SizedBox(width: 150, child: Text(entry['totaltime'].toString(), style: TextStyle(fontSize: 15))),
                                         
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
                    },
          ),)
          ]),
        ),
      ],
    )
],
  )
  );
  }
}