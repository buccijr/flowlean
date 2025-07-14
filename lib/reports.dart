import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes.dart';

 List<PieChartSectionData> showingSections(data) {

final data1 = data.where((entry) {
return entry['status'] == 1;
}).toList();
final data2 = data.where((entry) {
return entry['status'] == 0 && (entry['current_user'] ==  null) && entry['user_unique'] == null;
}).toList();
final data3 = data.where((entry) {
return entry['status'] == 0 && (entry['current_user'] !=  null || entry['user_unique'] != null) ;
}).toList();
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 51, 151, 1),
        value: (data1.length)/data.length,
        title: '${(((data1.length)/data.length) * 100).toStringAsFixed(2)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter'),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 193, 193, 193),
        value: (data2.length)/data.length,
        title: '${((data2.length)/data.length * 100).toStringAsFixed(2)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter'),
      ),
     PieChartSectionData(
        color: const Color.fromARGB(255, 246, 255, 120),
        value: (data3.length)/data.length,
        title: '${((data3.length)/data.length*100).toStringAsFixed(2)}%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter'),
      ),
    ];
  }




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



class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}


class _ReportsState extends State<Reports> {
 
 bool loadingUser = true;
  bool selected1 = false;
bool  selected2 = false;
bool selected3 = false; 
bool selected4 = false;
String subcat = 'Overview';
bool selected6 = false;
bool selected5 = false;
bool selectted7 = true;
String frequency = 'Process';
String cat = 'Overview';

String subcatter = 'Overview';
String catter = 'Overview';
String router = 'Select a category...';
String errorText = '';
bool subcatTrue = false;
bool overview = true;
String frequency2 = 'Process';
bool weekly = true;
bool monthly = false;
bool yearly = false;



@override

void initState() {
  super.initState();
   _loadUserRole();

  }


 String? _role;
  bool _loading = true;


  
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
  Widget build(BuildContext context) {
    
    
    if (_role == 'user') {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'images/restrict.png',
            width: 400,
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    
    return Scaffold(
backgroundColor: Color(0xFFFAFAFA),
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
          
          SizedBox(height: 140),
         Align(
          alignment: Alignment.centerLeft,
           child: Row(
             children: [
              SizedBox(width: 10), 
               MouseRegion(
                cursor: SystemMouseCursors.click,
                 child: GestureDetector(
                     onTap: (){
                     context.go('/admindashboard');
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
            SizedBox(height:25),
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
         SizedBox(height: 25,),
          Align(
          alignment: Alignment.centerLeft,
           child: Row(
             children: [
              SizedBox(width: 10), 
               MouseRegion(
                cursor: SystemMouseCursors.click,
                 child: GestureDetector(
                     onTap: (){
                    
                    
                      },
                      child: Container(
                        width: 165,
                        height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                       color: selectted7 ?  const Color.fromARGB(255, 0, 55, 100) : null,
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
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 30),
                          Text('Reports', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', color:  const Color.fromARGB(255, 23, 85, 161), fontSize: 30 )),
                          SizedBox(width: 30,),
                         Column(
                           children: [
                             Row(
                               children: [
                               
                                 MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: GestureDetector(
                                                onTap: (){
                                              setState(() {
                                                monthly = false;
                                                weekly = true;
                                                yearly = false;
                                              
                                              });
                                                },
                                                child: Container(
                                                  width: 90,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: weekly ?const Color.fromARGB(255, 159, 212, 255) : const Color.fromARGB(255, 240, 240, 240),
                                                    border: Border.all(width: 1, color: weekly ? Colors.blue  : const Color.fromARGB(255, 198, 198, 198)),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Center(child: Text('Week', style: TextStyle(fontFamily: 'Inter', color: weekly ? Colors.blue : const Color.fromARGB(255, 190, 190, 190),
                                                  fontSize: 18),)),
                                                ),
                                              ),
                                            ),
                             
                                        SizedBox(width: 15,),
                                         MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: (){
                                          setState(() {
                                            monthly =true;
                                            weekly = false;
                                            yearly = false;
                                          
                                          });
                                            },
                                     child:   Container(
                                          width: 90,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: monthly ?const Color.fromARGB(255, 159, 212, 255) : const Color.fromARGB(255, 244, 244, 244),
                                            border: Border.all(width: 1, color: monthly ? Colors.blue  : const Color.fromARGB(255, 198, 198, 198)),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(child: Text('Month', style: TextStyle(fontFamily: 'Inter', color: monthly ? Colors.blue : const Color.fromARGB(255, 190, 190, 190),
                                          fontSize: 18),)),
                                        ))),
                                        SizedBox(width: 15,),
                                         MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: (){
                                          setState(() {
                                            monthly = false;
                                            weekly = false;
                                            yearly = true;
                                          
                                          });
                                            },
                                            child:
                                        Container(
                                          width: 90,
                                          height: 35,
                                          decoration: BoxDecoration(
                                            color: yearly ?const Color.fromARGB(255, 159, 212, 255) : const Color.fromARGB(255, 245, 245, 245),
                                            border: Border.all(width: 1, color: yearly ? Colors.blue  : const Color.fromARGB(255, 198, 198, 198)),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(child: Text('Year', style: TextStyle(fontFamily: 'Inter', color: yearly ? Colors.blue : const Color.fromARGB(255, 190, 190, 190),
                                          fontSize: 18),)),
                                        ))),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                                        SizedBox(width: 20,),
                                        StatefulBuilder(
                                          builder: (context, setLocalState) {
                                            return Container(
                                              width: 140,
                                              height: 45,
                                              decoration: BoxDecoration(border: Border.all(width:  1, color: const Color.fromARGB(255, 0, 73, 132)), borderRadius: BorderRadius.circular(10), color: Colors.white),
                                              child: Center(
                                                child: DropdownButtonHideUnderline(child: DropdownButton(
                                                  value: cat,
                                                  items: [
                                                DropdownMenuItem(
                                                  value: 'Overview',
                                                  child: Text('Overview', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 78, 143), fontSize: 20),)
                                                  ),
                                                  DropdownMenuItem(
                                                  value: 'Material',
                                                  child: Text('Material', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 78, 143), fontSize: 20),)
                                                  ),
                                                  DropdownMenuItem(
                                                  value: 'User',
                                                  child: Text('User', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 78, 143), fontSize: 20),)
                                                  ),
                                                  DropdownMenuItem(
                                                  value: 'Route',
                                                  child: Text('Route', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 78, 143), fontSize: 20),)
                                                  ),
                                                
                                                  DropdownMenuItem(
                                                  value: 'Process',
                                                  child: Text('Process', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 78, 143), fontSize: 20),)
                                                  ),
                                                              
                                                  ],
                                                   onChanged: (value){
                                                    setState(() {
                                                      cat = value!;
                                                      subcatTrue = false;
                                                      subcat  = 'Overview';
                                                    });
                                                   })),
                                              ),
                                            );
                                          }
                                        ),
                                        SizedBox(width: 25,),
                                        
                                       Container(
                                        width: 325,
                                          height: 45,
                                          decoration: BoxDecoration(border: Border.all(width:  1, color: const Color.fromARGB(255, 0, 73, 132)), borderRadius: BorderRadius.circular(10), color: Colors.white),
                                         child: Center(
                                           child: FutureBuilder(
                                             future: Supabase.instance.client
                                                 .from(cat == 'Route'
                                                     ? 'route'
                                                     : cat == 'User'
                                                         ? 'user'
                                                         : cat == 'Process'
                                                             ? 'process'
                                                             : 'materials')
                                                 .select(),
                                             builder: (context, asyncSnapshot) {
                                               if (!asyncSnapshot.hasData) {
                                                 return CircularProgressIndicator();
                                               }
                                           

                                               final List<dynamic> rawData = asyncSnapshot.data as List<dynamic>;
                                               final List<Map<String, dynamic>> data =
                                                   rawData.cast<Map<String, dynamic>>();
                                           
                                           final Set<String> seen = {};
final List<String> uniqueValues = data.map((entry) {
  return entry[
    cat == 'Route' ? 'material_route' :
    cat == 'User' ? 'username' :
    cat == 'Process' ? 'description' :
    'name'
  ]?.toString() ?? 'Unknown';
}).where((val) => seen.add(val)).toList();
                                               return DropdownButtonHideUnderline(
                                                 child: Padding(
                                                   padding: const EdgeInsets.all(8.0),
                                                   child: DropdownButton<String>(
                                                     value: subcat,
                                                     
                                                     items: [
                                                       DropdownMenuItem(
                                                         value: 'Overview',
                                                         child: Text(
                                                           'Overview',
                                                           style: TextStyle(
                                                             fontFamily: 'Inter',
                                                             fontWeight: FontWeight.bold,
                                                             color: Color.fromARGB(255, 0, 78, 143),
                                                             fontSize: 20,
                                                           ),
                                                         ),
                                                       ),
                                                       if (cat != 'Overview')
                                                      ...uniqueValues.map((val) {
                                                     
                                                                                              
                                                                                              
                                                                                                String truncateWithEllipsis(int cutoff, String myString) {
                                                                                                return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
                                                                                              }
                                                            double fontSizeOnLength(int length){
                                                             if (length > 10){
                                                               return 17;
                                                             } else if (length > 15){
                                                               return 16;
                                                             } else if (length > 20){
                                                               return 14;
                                                             } else if (length > 25){
                                                               return 13;
                                                             } else {
                                                               return 20;
                                                             }
                                                            }   
                                                                                                return DropdownMenuItem<String>(
                                                                                                  value: val,
                                                                                                  child: Text(
                                                   truncateWithEllipsis(25, val),
                                                   style: TextStyle(
                                                     fontFamily: 'Inter',
                                                     fontWeight: FontWeight.bold,
                                                     color: Color.fromARGB(255, 0, 78, 143),
                                                     fontSize: fontSizeOnLength(val.length),
                                                   ),
                                                                                                  ),
                                                                                                );
                                                                                              }),
                                                     ],
                                                     onChanged: (value) {
                                                       setState(() {
                                                         subcat= value!;
                                                         subcatTrue = true;
                                                       });
                                                     },
                                                   ),
                                                 ),
                                               );
                                             },
                                           ),
                                         ),
                                       ),
                                       SizedBox(width: 20,),
                                      //  IconButton(onPressed: (){
                                      //   if (catter == 'Overview'){
                                      //     cat = catter;
                                      //     subcat = subcatter;
                                      //   } else
                                      // if (subcat != 'Select...'){
                                      //  cat == catter;
                                      //  subcat == subcatter;
                                      // } else {
                                      //   errorText = 'Please select a subcategory';
                                      // }
                                      //  }, icon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0), size: 30))

                                                     ],
                                                   ),
                           ],
                         )
                        ],
                         ),
                      ),
       
     Expanded(
       child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              SizedBox(height: 5,),
             Row(
              children: [
                SizedBox(width: 10,),
                SizedBox(
                  width: 1515,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                          
                
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Container(
                  //     width: 400,
                  //     height: 400,
                  //    decoration: BoxDecoration
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //    ),
                  //    child: Padding(
                  //     padding: EdgeInsets.all(8),
                  //     child: Column(
                  //       children: [
                  //         Text('Requests per process', style: TextStyle(
                  //           fontFamily: 'Inter',
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //         ),),
                  //         SizedBox(height: 10,),
                        Row(
                          children: [
                            SizedBox(width: 10,),
                 //                 FutureBuilder(
                 //                   future: Supabase.instance.client.from('masterdata').select(),
                 //                   builder: (context, snapshot) {
                 //                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                 //   return CircularProgressIndicator();
                 // }
                 //                     print('snap ${snapshot.data}');
                 //                               final data3 = snapshot.data ?? [];
                 //                               print(' data3 le ${data3.length}');
                 //                                   double roundMaxY(double maxY) {
                 //                             if (maxY <= 5) return 5;
                                      
                 //                             // Find the nearest multiple of 5 or 10 above maxY
                 //                             int base = 10;
                 //                             if (maxY < 20) base = 5;
                 //                             return (maxY / base).ceil() * base.toDouble();
                 //                           }
                 //                            final value =
                 //                       data3.length >= 5 ?
                 //                                                         data3.length == 0 ? 10 : data3.length % 5 == 0 ? data3.length : roundMaxY(data3.length.toDouble())/5 : 1;
                 //                     return Column(
                 //                      children: [
                 //                     Text('${value}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133))),
                 //                      Text('${value + value}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133)),),
                 //                       Text('${value + value + value}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133)),),
                 //                        Text('${value+ value+ value+ value}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133)),),
                 //                         Text('${value+ value+value+value+value}', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 133, 133, 133)),),
                 //                      ]
                 //                     );
                 //                   }
                 //                 ),
                            StatefulBuilder(
                              builder: (context, setLocalState) {
                                return FutureBuilder(
                                  future: frequency == 'Process' ? Supabase.instance.client.from('process').select('description') : frequency == 'Material' ? Supabase.instance.client.from('materials').select('name') : Supabase.instance.client.from('route').select('material_route').or('disabled.is.null,disabled.not.eq.true'),
                                  builder: (context,snapshot) {
                                    final data = snapshot.data ?? [];
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 900,
                                        height: 314,
                                         decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 212, 243, 255),
                                                  borderRadius: BorderRadius.circular(20),
                                                 ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child:Builder(builder: (context) {
                                            final barCount = data.length; 
                                        
                                            final barWidth = 120;         
                                            final chartWidth = barCount * (barWidth);
                                    
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 16,),
                                                Row(
                                                 
                                                  children: [
                                                    SizedBox(width: 30,),
                                                    Row(
                                                      children: [
                                                        Text('Frequency by', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17),),
                                                        SizedBox(width: 10,),
                                                        DropdownButtonHideUnderline(child: DropdownButton(
                                                          value: frequency,
                                                          items: [
                                                            DropdownMenuItem(
                                                              value: 'Process',
                                                              child: Text('Process',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                              
                                                              ),
                                                                DropdownMenuItem(
                                                              value: 'Material',
                                                              child: Text('Material',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                              
                                                              ),
                                                               DropdownMenuItem(
                                                              value: 'Route',
                                                              child: Text('Route',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                              
                                                              )
                                                          ],
                                                          
                                                          onChanged: (value){
                                frequency = value!;
                                setLocalState(() {
                                  
                                },);
                                                          }))
                                                      ],
                                                    )]),
                                                    frequency == 'Process' ?
                                                SizedBox(
                                                  width: chartWidth < 900 ? 900 : chartWidth.toDouble(), // minimum 700 to fill container
                                     
                                                  height: 250,
                                                                              
                                                    child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: FutureBuilder(
                                                    future: Future.wait([
    () {
      if (cat == 'Overview' || subcatTrue == false) {
        return Supabase.instance.client.from('detail').select();
      } else if (subcat != null && subcat != 'Select..') {
        return Supabase.instance.client
            .from('detail')
            .select()
            .eq(
              cat == 'Route'
                  ? 'route_name'
                  : cat == 'User'
                      ? 'usernamed'
                      : cat == 'Process'
                          ? 'process'
                          : 'originalneed',
              subcat,
            ).not('endtime', 'is', null);
      } else {
        return Supabase.instance.client.from('detail').select().limit(0); // no results
      }
    }(),
    Supabase.instance.client.from('process').select(),
  ]),
                                                    
                                                    builder: (context, snapshot) {

                                                      if (snapshot.connectionState == ConnectionState.waiting){
                                                        return Text('');
                                                      }
                                                      final data1 = snapshot.data?[0] ?? [];
                                                      final data2 = snapshot.data?[1] ?? [];
                                                                                                                                                 if (data1.isEmpty || data2.isEmpty ){
                                                        return Text('');
                                                      }    

if (data1.isEmpty){
  return SizedBox.shrink();
}

  String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}
                                                         double roundMaxY(double maxY) {
                                                    if (maxY <= 5) return 5;
                                                  
                                                  
                                                    int base = 10;
                                                    if (maxY < 20) base = 5;
                                                    return (maxY / base).ceil() * base.toDouble();
                                                  }
                                
                                                                    
                                         Map<String, int> processFrequency = {};
                                
                                
                                data2.sort((a, b) {
                                  final freqA = processFrequency[a['process']] ?? 0;
                                  final freqB = processFrequency[b[ 'process']] ?? 0;
                                
                                  if (freqA != freqB) {
                                    return freqB.compareTo(freqA); // highest count first
                                  } else {
                                    return (b['id'] ?? 0).compareTo(a['id'] ?? 0); // fallback by ID
                                  }

                                });

                             bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}


                       
                            
                             final datar = data1.where((entry){
                                 return weekly ? 
                                  isThisWeek(DateTime.parse(entry['starttime'])) == true
                                  :  monthly ? isThisMonth(DateTime.parse(entry['starttime'])) == true : 
                                  isThisYear(DateTime.parse(entry['starttime'])) == true;
                                  

                                }).toList();

                                if (datar.isEmpty){
                                  return Text('No data', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold));
                                }
                                                      return BarChart(
                                                                    
                                                                   
                                                                    BarChartData(
                                                                       alignment: BarChartAlignment.spaceAround,

                                                                       
                                                                  barTouchData: BarTouchData(
                                                              
                                                                    // enabled: true,

                                                                    
 touchTooltipData: BarTouchTooltipData(
                                                                      tooltipBorderRadius: BorderRadius.circular(13),
                                                                      maxContentWidth: 40,
                                                                    
                                                                      getTooltipColor: (groups){
                                                                        return Colors.transparent;
                                                                      } ,
                                                                      tooltipMargin: -14,
                                                                      tooltipHorizontalOffset: 20,
                                                                      getTooltipItem:(group, groupIndex, rod, rodIndex) {
                                                                return BarTooltipItem(
                                                                '${rod.toY.toInt()}',
                                                                TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter', fontSize: 20, height: 0)
                                                               
                                                                );
                                                                
                                                                      },
                                                                    ),
                                                                  ),

                                                                
                                                                  
                                                                             maxY: roundMaxY(datar.length.toDouble()),
                                                                           borderData: FlBorderData(show: false),
                                                                           gridData: FlGridData(show: false),
                                                          // 
                                                  
                                                  
                                                  
                                                                   barGroups: [
                                                                    ...data2.reversed.toList().asMap().entries.map((entry) {
                                                                    
                                                                      final index = entry.key;
                                                                      final item = entry.value;
                                                  
                                                 final processName = item['description'] ?? '';
                                                                            final data4 = datar.where((entry) => entry['process'] == processName);
                                        
                                                                      
                                //                                                                     finalFilter.sort((a, b) {
                                //   final closedA = a['closed'] ?? 1;
                                //   final closedB = b['closed'] ?? 1;
                                //   if (closedA != closedB) {
                                //     return closedA.compareTo(closedB); // closed = 0 first
                                //   } else {
                                //     return (b['id'] ?? 0).compareTo(a['id'] ?? 0); // higher id first
                                //   }
                                // });
                                                                 return  
                                                                 BarChartGroupData(x: index ,barRods: [BarChartRodData(toY: data4.isEmpty ? 0 : data4.length.toDouble(),  width: 25, gradient:LinearGradient(colors: [const Color.fromARGB(255, 0, 94, 171), const Color.fromARGB(197, 19, 101, 169)],
                                                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                                                    ),
                                                                     borderRadius: BorderRadius.circular(10))]);
                                                                     
                                                                   },)
                                                                   ],
                                                                   
                                                                     
                                                                             titlesData: FlTitlesData(
                                                                           leftTitles: AxisTitles(
                                                                            sideTitles: SideTitles(
                                                                              
                                                                             showTitles: true,
                                                                             interval:
                                                                             datar.length >= 5 ?
                                                                             (datar.length == 0 ? 5 : datar.length % 5 == 0 ? datar.length : roundMaxY(datar.length.toDouble()))/5 : 1,
                                                                              getTitlesWidget: (value, meta) {
                                                                               
                                                                                return Text('${value.toInt()}', style: TextStyle(fontFamily: 'Inter', color:const Color.fromARGB(255, 0, 94, 171), fontSize: 16),);
                                                                           
                                                                              },
                                                                            )
                                                                           ),
                                                                        topTitles: AxisTitles(
                                                                          sideTitles: SideTitles(showTitles: false),
                                                                        ),
                                                                   bottomTitles: AxisTitles(
                                                                     sideTitles: SideTitles(
                                                                       showTitles: true,
                                                                       reservedSize: 40,
                                                                       getTitlesWidget: (value, meta) {
                                               int index = value.toInt();
                                               if (index < 0 || index >= data2.length) return Container();
                                             
                                               String label = data2.reversed.toList()[index]['description'];
           label = truncateWithEllipsis(20, label); 
                              String formatLabel(String label) {
  if (label.length <= 10) return label;

  // Check if it's a single long word
  bool isSingleWord = !label.contains(' ');
  if (isSingleWord && label.length > 12) {
    int midpoint = (label.length / 2).round();
    return '${label.substring(0, midpoint)}-\n${label.substring(midpoint)}';
  }

  // Normal behavior for multi-word or moderately long words
  int midpoint = (label.length / 2).round();
  bool shouldHyphenate = label[midpoint - 1] != ' ' && label[midpoint] != ' ';

  String firstHalf = label.substring(0, midpoint).trim();
  String secondHalf = label.substring(midpoint).trim();

  return shouldHyphenate
      ? '$firstHalf-\n$secondHalf'
      : '$firstHalf\n$secondHalf';
}
label = formatLabel(label);
                                
double fontSizeOnLength(int length){
                                                             if (length > 10 && length < 15){
                                                               return 13;
                                                             } else if (length > 15 && length < 17){
                                                               return 12.5;
                                                             } else if (length >= 17){
                                                               return 12;
                                                             } else if (length > 25){
                                                               return 11;
                                                             } else {
                                                               return 15;
                                                             }
                                                            }               
                                             
                                               return Padding(
                                                 padding: const EdgeInsets.only(top:3),
                                                 child: Text(
                                              label,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: fontSizeOnLength(label.length),
                                                fontFamily: 'WorkSans',
                                                color: const Color.fromARGB(255, 83, 83, 83),
                                              ),
                                                 ),
                                               );
                                             },
                                                                     )
                                                                   ),
                                                                         rightTitles: AxisTitles(
                                                                          
                                                                           sideTitles: SideTitles(showTitles: false,
                                                                         
                                                                   
                                                                           ),
                                                                           
                                                                         
                                                                         ),),  
                                                                   
                                                                   ),
                                                                   
                                                                          
                                                                    );
                                                    }
                                          )
                                                )
                                                ) :  SizedBox(
                                                  width: chartWidth < 900 ? 900 : chartWidth.toDouble(), // minimum 700 to fill container
                                                  height: 250,
                                                                              
                                                    child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: FutureBuilder(
                                                    future: Future.wait([
                                                      cat == 'Overview' || subcatTrue == false ?
                                                      Supabase.instance.client.from('detail').select().not('endtime', 'is', null)
                                                       : Supabase.instance.client.from('detail').select().eq(cat == 'Route' ? 'route_name'  : cat== 'User' ?
                                                       'usernamed' : cat == 'Process' ? 'process' : 'originalneed', subcat), 
                                                    Supabase.instance.client.from(frequency == 'Material' ? 'materials'  : 'route').select(),
                                                    Supabase.instance.client.from('detail').select(),
                                                    ]),
                                                    
                                                    builder: (context, snapshot) {

                                                      if (snapshot.connectionState == ConnectionState.waiting ){
                                                        return Text('');
                                                      }
                                                      final data1 = snapshot.data?[0] ?? [];
                                                      final data6 = snapshot.data?[1] ?? [];
                                                      final data3 = snapshot.data?[2] ?? [];
                                                                            
                                                                             if (data1.isEmpty || data6.isEmpty || data3.isEmpty ){
                                                        return Text('');
                                                      }
                                                                         List<Map<String, dynamic>> uniqueByField(List<Map<String, dynamic>> list, String field) {
  final seen = <dynamic>{};
  final uniqueList = <Map<String, dynamic>>[];

  for (var item in list) {
    var key = item[field];
    if (!seen.contains(key)) {
      seen.add(key);
      uniqueList.add(item);
    }
  }
  return uniqueList;
}
final field = frequency == 'Material' ? 'name' : 'material_route';

// Get unique full maps by field value
final data2 = uniqueByField(data6.cast<Map<String, dynamic>>(), field);

                                                         double roundMaxY(double maxY) {
                                                    if (maxY <= 5) return 5;
                                                  
                                                  
                                                    int base = 10;
                                                    if (maxY < 20) base = 5;
                                                    return (maxY / base).ceil() * base.toDouble();
                                                  }
                                
                                                                    
                                         Map<String, int> processFrequency = {};

                                                      bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}

                       
                            
                             final datar = data1.where((entry){
                                 return weekly ? 
                                  isThisWeek(DateTime.parse(entry['starttime'])) == true
                                  :  monthly ? isThisMonth(DateTime.parse(entry['starttime'])) == true : 
                                  isThisYear(DateTime.parse(entry['starttime'])) == true;
                                  

                                }).toList();

                                  
                                if (datar.isEmpty){
                                  return Text('No data', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold));
                                }
for (final entry in datar) {
  final rawProcess = entry[frequency == 'Material' ? 'originalneed' : 'route_name'];

  if (rawProcess == null || rawProcess is! String) {
    continue;
  }

  final process = rawProcess.trim(); // clean string
  processFrequency[process] = (processFrequency[process] ?? 0) + 1;
  
}
data2.sort((a, b) {
  final nameA = a[frequency == 'Material' ? 'name' : 'material_route'];
  final nameB = b[frequency == 'Material' ? 'name' : 'material_route'];

  final hasA = processFrequency.containsKey(nameA);
  final hasB = processFrequency.containsKey(nameB);

  // Push entries not in processFrequency to the bottom
  if (hasA && !hasB) return -1;
  if (!hasA && hasB) return 1;

  final freqA = processFrequency[nameA] ?? 0;
  final freqB = processFrequency[nameB] ?? 0;

  if (freqA != freqB) {
    return freqB.compareTo(freqA);
  } else {
    return (b['id'] ?? 0).compareTo(a['id'] ?? 0);
  }
  
});            String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}

     
                                                      return BarChart(
                                                                    
                                                                   
                                                                    BarChartData(
                                                                       alignment: BarChartAlignment.spaceAround,
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
                                                                  
                                                                             maxY: roundMaxY(datar.length.toDouble()),
                                                                           borderData: FlBorderData(show: false),
                                                                           gridData: FlGridData(show: false),
                                                          // 
                                                  
                                                  
                                                  
                                                                   barGroups: [
                                                                    ...data2.toList().asMap().entries.map((entry) {
                                                                    
                                                                      final index = entry.key;
                                                                      final item = entry.value; 
                                                  
                                              
                                        
                                                            
                                                                 return  
                                                                 BarChartGroupData(
                                                                
                                                                  
                                                                  
                                                                  x: index ,barRods: [BarChartRodData(toY: processFrequency[item[frequency == 'Material' ? 'name' : 'material_route']]== null ? 0 
                                                                  : processFrequency[item[frequency == 'Material' ? 'name' : 'material_route']]!.toDouble(),  width: 25, gradient:LinearGradient(colors:
                                                                   [const Color.fromARGB(255, 0, 94, 171), const Color.fromARGB(197, 19, 101, 169)],
                                                                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                                                    ),
                                                                     borderRadius: BorderRadius.circular(10))]);
                                                                     
                                                                   },)
                                                                   ],
                                                                   
                                                                     
                                                                             titlesData: FlTitlesData(
                                                                           leftTitles: AxisTitles(
                                                                            sideTitles: SideTitles(
                                                                              
                                                                             showTitles: true,
                                                                             interval:
                                                                             datar.length >= 5 ?
                                                                             (datar.length == 0 ? 10 : datar.length % 5 == 0 ? datar.length : roundMaxY(datar.length.toDouble()))/5 : 1,
                                                                              getTitlesWidget: (value, meta) {
                                                                               
                                                                                return Text('${value.toInt()}', style: TextStyle(fontFamily: 'Inter', color:const Color.fromARGB(255, 0, 94, 171), fontSize: 16),);
                                                                           
                                                                              },
                                                                            )
                                                                           ),
                                                                        topTitles: AxisTitles(
                                                                          sideTitles: SideTitles(showTitles: false),
                                                                        ),
                                                                   bottomTitles: AxisTitles(
                                                                     sideTitles: SideTitles(
                                                                       showTitles: true,
                                                                       reservedSize: 40
                                                                       ,
                                                                       getTitlesWidget: (value, meta) {
                                                int index = value.toInt();
                                               if (index < 0 || index >= data2.length) return Container();
                                             
                                               String label = data2.toList()[index][frequency == 'Material' ? 'name' : 'material_route'];
                                             
                                              label = truncateWithEllipsis(25, label); 
                              String formatLabel(String label) {
  if (label.length <= 8) return label;

  // Check if it's a single long word
  bool isSingleWord = !label.contains(' ');
  if (isSingleWord && label.length > 12) {
    int midpoint = (label.length / 2).round();
    return '${label.substring(0, midpoint)}-\n${label.substring(midpoint)}';
  }

  // Normal behavior for multi-word or moderately long words
  int midpoint = (label.length / 2).round();
  bool shouldHyphenate = label[midpoint - 1] != ' ' && label[midpoint] != ' ';

  String firstHalf = label.substring(0, midpoint).trim();
  String secondHalf = label.substring(midpoint).trim();

  return shouldHyphenate
      ? '$firstHalf-\n$secondHalf'
      : '$firstHalf\n$secondHalf';
}
label = formatLabel(label);
                                
double fontSizeOnLength(int length){
                                                             if (length > 10 && length < 15){
                                                               return 12.5;
                                                             } else if (length > 15 && length < 17){
                                                               return 12.5;
                                                             } else if (length >= 17){
                                                               return 12;
                                                             } else if (length > 25){
                                                               return 11;
                                                             } else {
                                                               return 15;
                                                             }
                                                            }               
                                             
                                          
                                               return Padding(
                                                 padding: const EdgeInsets.only(top:3),
                                                 child: Text(
  label,
  textAlign: TextAlign.center,
  softWrap: true, // Ensures wrapping is allowed
  maxLines: 2,    // Optional: controls max height
  overflow: TextOverflow.visible, // Important: show full split label
  style: TextStyle(
    fontFamily: 'WorkSans',
    fontSize: fontSizeOnLength(label.length),
    color: const Color.fromARGB(255, 83, 83, 83),
  ),
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
                                                                   
                                                                          
                                                                    );
                                                    }
                                                  ),
                                                )
                                                ),
                                              ],
                                            );
                                             }),
                                        ),
                                      ),
                                      
                                    );
                                  }
                                );
                              }
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: 560,
                              height: 310,
                              decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 229, 235, 240),
                              borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Text('Request Status', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20),),
                                         SizedBox(height: 20,), 
                                  
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        height: 200,
                                        child: FutureBuilder(
                                          future:    cat == 'Overview' || subcatTrue == false?
                                                           Supabase.instance.client.from('detail').select()
                                                       : Supabase.instance.client.from('detail').select().eq(cat == 'Route' ? 'route_name'  : cat == 'User' ?
                                                       'usernamed' : cat == 'Process' ? 'process' : 'originalneed', subcat), 
                                        
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null){
                                              return SizedBox(
                                                width: 10,
                                                height: 50,
                                                child: CircularProgressIndicator(color: Colors.blue,));
                                            }
                                            final data = snapshot.data ?? [];
                                                   bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}
                       
                            
                             final datar = data.where((entry){
                                 return weekly ? 
                                  isThisWeek(DateTime.parse(entry['starttime'])) == true
                                  :  monthly ? isThisMonth(DateTime.parse(entry['starttime'])) == true : 
                                  isThisYear(DateTime.parse(entry['starttime'])) == true;
                                  

                                }).toList();
                                     
                                if (datar.isEmpty){
                                  return Text('No data', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold));
                                }
                                            return PieChart(
                                              
                                            PieChartData(
                                              centerSpaceRadius: 40,
                                              sections: showingSections(datar),
          //                                     pieTouchData:  PieTouchData(touchCallback: (event, response) {
          //   if (event is FlPointerHoverEvent && response != null && response.touchedSection != null) {
          //     setState(() {
          //       touchedIndex = response.touchedSection!.touchedSectionIndex;
          //     });
          //   } else {
          //     setState(() {
          //       touchedIndex = null;
          //     });
          //   }
          // },
                                              
      
          //                                   )
                                            
                                            
                                            ),
                                            
                                            );
                                          }
                                        ),
                                      ),
                                         SizedBox(width: 30,),
                                                FutureBuilder(
                                                  future: Supabase.instance.client.from('detail').select(),
                                                  builder: (context, snapshot) {
                                                    final data = snapshot.data ?? [];
                                                   final data1 = data.where((entry) {
return entry['status'] == 1;
}).toList();
final data2 = data.where((entry) {
return entry['status'] == 0 && (entry['current_user'] ==  null) && entry['user_unique'] == null;
}).toList();
final data3 = data.where((entry) {
return entry['status'] == 0 && (entry['current_user'] !=  null || entry['user_unique'] != null) ;
}).toList();
                                                    return Column(
                                                      
                                                      children: [
                                                                                          Row(
                                                                                            
                                                                                            children: [
                                                                                              SizedBox(width: 15,),
                                                                                              Container(
                                                                                                color: Colors.green,
                                                                                                width: 20,
                                                                                               height: 20,
                                                                                              ),
                                                                                              SizedBox(width: 15,),
                                                                                              Text('Completed (${data1.length})', style: TextStyle(fontFamily: 'Inter',),)
                                                                                            ],
                                                                                          ),
                                                                                        
                                                                                            SizedBox(height: 15),
                                                                                           Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                color: const Color.fromARGB(255, 246, 255, 120),
                                                                                                width: 20,
                                                                                               height: 20,
                                                                                              ),
                                                                                              SizedBox(width: 15,),
                                                                                              Text('Active (${data3.length})', style: TextStyle(fontFamily: 'Inter',),),
                                                                                              SizedBox(width: 15,),
                                                                                            ],
                                                                                          ),
                                                                                            SizedBox(height: 15),
                                                                                           Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                color: const Color.fromARGB(255, 218, 218, 218),
                                                                                                width: 20,
                                                                                               height: 20,
                                                                                              ),
                                                                                              SizedBox(width: 15,),
                                                                                              Text('Pending (${data2.length})', style: TextStyle(fontFamily: 'Inter',),)
                                                                                            ],
                                                                                          )
                                                    ],);
                                                  }
                                                )
                                    ],
                                  ),
                                ],
                              ),),
                            )
                          ],
                        ),
                  //       ],
                  //     ),
                  //    ),
                  //   ),
                  // )
                  SizedBox(height: 20,),
                     Row(
                       children: [
                        SizedBox(width: 10,),
                         StatefulBuilder(
                           builder: (context, setLocalState) {
                             return FutureBuilder(
                                      future: frequency2 == 'Process' ? Supabase.instance.client.from('process').select('description') : frequency2 == 'Material' ? Supabase.instance.client.from('materials').select('name') : 
                                      frequency2 == 'Route' ? Supabase.instance.client.from('route').select('material_route').or('disabled.is.null,disabled.not.eq.true') : Supabase.instance.client.from('user').select('username'),
                                      builder: (context,snapshot) {
                                     final data = snapshot.data ?? [];
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            width: 900,
                                            height: 314,
                                             decoration: BoxDecoration(
                                                      color: const Color.fromARGB(255, 234, 249, 255),
                                                      borderRadius: BorderRadius.circular(20),
                                                     ),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child:Builder(builder: (context) {
                                                final barCount = data.length; 
                                                final barWidth = 120;         
                                                final chartWidth = barCount * (barWidth);
                                        
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 16,),
                                                    Row(
                                                     
                                                      children: [
                                                        SizedBox(width: 30,),
                                                        Row(
                                                          children: [
                                                            Text('Average time (min) by', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17),),
                                                            SizedBox(width: 10,),
                                                            DropdownButtonHideUnderline(child: DropdownButton(
                                                              value: frequency2,
                                                              items: [
                                                                DropdownMenuItem(
                                                                  value: 'Process',
                                                                  child: Text('Process',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                                  
                                                                  ),
                                                                    DropdownMenuItem(
                                                                  value: 'Material',
                                                                  child: Text('Material',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                                  
                                                                  ),
                                                                   DropdownMenuItem(
                                                                  value: 'Route',
                                                                  child: Text('Route',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                                  
                                                                  ),
                                                                  DropdownMenuItem(
                                                                  value: 'User',
                                                                  child: Text('User',style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17) ),
                                                                  
                                                                  )
                                                              ],
                                                              
                                                              onChanged: (value){
                                                               
                                                                                frequency2 = value!;
                                                                                setLocalState(() {
                                                                                  
                                                                                },);
                                                              }))
                                                          ],
                                                        )]),
                                                    SizedBox(
                                                      width: chartWidth < 900 ? 900 : chartWidth.toDouble(), 
                                                      height: 250,
                                                                                  
                                                        child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: FutureBuilder(
                                                        future: Future.wait([
                                                           cat =='Overview' || subcatTrue == false?
                                                           Supabase.instance.client.from('detail').select().not('endtime', 'is', null)
                                                       : Supabase.instance.client.from('detail').select().eq(cat == 'Route' ? 'route_name'  : cat== 'User' ?
                                                       'usernamed' : cat == 'Process' ? 'process' : 'originalneed', subcat).not('endtime', 'is', null),
                                                       Supabase.instance.client.from(frequency2 == 'Process' ? 'process' : frequency2 == 'Material' ?  'materials' : frequency2 == 'Route' ? 'route' : 'user').select(),
                                                        ]),
                                                        
                                                        builder: (context, snapshot) {
                                                
                                                          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                                                           return Column(
                                                             children: [
                                                               Align(
                                                                alignment: Alignment.centerLeft,
                                                                 child: SizedBox(
                                                                                                             width: 50,
                                                                                                             height: 50,
                                                                                                             child: CircularProgressIndicator(
                                                                                                              color: Colors.blue,
                                                                 )),
                                                               ),
                                                             ],
                                                           );
                                                          }
                                                        
                                                          final data1 = snapshot.data?[0] ?? [];
                                                       
                                                          final data2 = snapshot.data?[1] ?? [];
                                                
                                                                     final barCount = data.length;
                                                    final chartWidth = barCount * barWidth;
                                                           
                                                                if (data1.isEmpty || data2.isEmpty){
                                                                  return Text('No Data', style: TextStyle(fontFamily: 'Inter'),);
                                                                }                
                                                             double roundMaxY(double maxY) {
                                                        if (maxY <= 5) return 5;
                                                      
                                                      
                                                        int base = 10;
                                                        if (maxY < 20) base = 5;
                                                        return (maxY / base).ceil() * base.toDouble();
                                                      }
                                                    
                                                            bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}


                       
                            
                             final datar = data1.where((entry){
                                 return weekly ? 
                                  isThisWeek(DateTime.parse(entry['starttime'])) == true
                                  :  monthly ? isThisMonth(DateTime.parse(entry['starttime'])) == true : 
                                  isThisYear(DateTime.parse(entry['starttime'])) == true;
                                  

                                }).toList();

                                if (datar.isEmpty){
                                  return Text('No data', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold));
                                }
                                                
                                                    List totalTime = [];
                                                       final List<Map<String, dynamic>> processAverages = [];
                                                
                                                for (final processRow in data2) {
                                                  final processName = processRow[frequency2 ==  'Process'  ? 'description' : frequency2 == 'Material' ? 'name' : frequency2 == 'Route'
                                                  ? 'material_route' : 'username'];
                                                
                                                
                                                
                                                  final matchingEntries = datar.where((entry) {
                                                   
                                                   return entry[frequency2  == 'Process' ? 'process' : frequency2 == 'Material' ? 'originalneed' : 
                                                   frequency2 == 'Route' ? 'route_name' : 'usernamed'] == processName &&
                                                    entry['starttime'] != null &&
                                                    entry['endtime'] != null;
                                                }).toList();
                                                  double avg = 0;
                                                  if (matchingEntries.isNotEmpty) {
                                                    int total = 0;
                                                    for (final entry in matchingEntries) {
                                                      final start = DateTime.parse(entry['starttime']);
                                                      
                                                      final end = DateTime.parse(entry['endtime']);
                                                     
                                                      total += end.difference(start).inSeconds;
                                                      
                                                    }
                                                    avg = total / matchingEntries.length / 60;
                                                    totalTime.add(avg);
                                                  }
                                                
                                                  processAverages.add({
                                                    'process': processName,
                                                    'avg': avg.toDouble(),
                                                  });
                                                }                                 
                                                                                    double getNiceInterval(double maxY) {
                                                  if (maxY <= 10) return 2;
                                                  if (maxY <= 30) return 5;
                                                  if (maxY <= 60) return 10;
                                                  if (maxY <= 200) return 20;
                                                    if (maxY <= 300) return 40;
                                                     if (maxY <= 400) return 60;
                                                      if (maxY <= 500) return 80;
                                                    if (maxY <=1000) return 200;
                                                  return (maxY / 5).ceilToDouble();
                                                }
                                                
                                                          
                                                     processAverages.sort((a, b) {
                                                  final avgA = a['avg'] ?? 0;
                                                  final avgB = b['avg'] ?? 0;
                                                
                                                  if (avgA != avgB) {
                                                    return avgB.compareTo(avgA); // descending order by avg
                                                  } else {
                                                    // No 'id' field present in your maps?
                                                    // If you have an 'id' field, do this fallback:
                                                    // return (b['id'] ?? 0).compareTo(a['id'] ?? 0);
                                                    // Otherwise just return 0 (equal)
                                                    return 0;
                                                  }
                                                });
                                                
                                                             
                                                          return BarChart(
                                                              
                                                                       
                                                                        BarChartData(
                                                                          
                                                                           alignment: BarChartAlignment.spaceAround,
                                                                      barTouchData: BarTouchData(
                                                                    
                                                                        enabled: true,
                                                                 touchTooltipData: BarTouchTooltipData(
                                                                      tooltipBorderRadius: BorderRadius.circular(13),
                                                                      maxContentWidth: 70,
                                                                    
                                                                      getTooltipColor: (groups){
                                                                        return Colors.transparent;
                                                                      } ,
                                                                      tooltipMargin: -14,
                                                                      tooltipHorizontalOffset: 20,
                                                                      getTooltipItem:(group, groupIndex, rod, rodIndex) {
                                                                return BarTooltipItem(
                                                                '${rod.toY.toStringAsFixed(2)}',
                                                                TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontFamily: 'Inter', fontSize: 20,)
                                                               
                                                                );
                                                                
                                                                      },
                                                                    ),
                                                                      ),
                                                                      
                                                                                 maxY:
                                                                                  roundMaxY(
                                                                                  totalTime.isNotEmpty ?
                                                                                  totalTime.reduce((a, b) => a > b ? a : b).toDouble(): 1,
                                                                                  ),
                                                                               borderData: FlBorderData(show: false),
                                                                               gridData: FlGridData(show: false),
                                                              // 
                                                      
                                                      
                                                      
                                                                       barGroups: [
                                                                        
                                                                        ...processAverages
                                                                        .asMap().entries.map((entry) {
                                                                        
                                                                           final index = entry.key;
                                                    final avg = entry.value['avg'];
                                                                   
                                                                     return  
                                                                     BarChartGroupData(x:index ,barRods: 
                                                                     
                                                                     [BarChartRodData(toY: avg,  width: 30, color: const Color.fromARGB(255, 0, 67, 123),
                                                                         borderRadius: BorderRadius.circular(10)),
                                                
                                                                         
                                                                         
                                                                         ]
                                                                         );
                                                                         
                                                                       },)
                                                                       ],
                                                                       
                                                                         
                                                                                 titlesData: FlTitlesData(
                                                                               leftTitles: AxisTitles(
                                                                                sideTitles: SideTitles(
                                                                                  
                                                                                 showTitles: true,
                                                                                 interval:
                                                                                 
                                                                                getNiceInterval(totalTime.reduce((a, b) => a > b ? a : b).toDouble()),
                                                                                  getTitlesWidget: (value, meta) {
                                                                                 
                                                                                    return Text('${value.toInt()}', style: TextStyle(fontFamily: 'Inter', color:const Color.fromARGB(255, 0, 94, 171), fontSize: 16),);
                                                                               
                                                                                  },
                                                                                )
                                                                               ),
                                                                            topTitles: AxisTitles(
                                                                              sideTitles: SideTitles(showTitles: false),
                                                                            ),
                                                                       bottomTitles: AxisTitles(
                                                                         sideTitles: SideTitles(
                                                                           showTitles: true,
                                                                           reservedSize: 40,
                                                                           getTitlesWidget: (value, meta) {
                                                                                        int index = value.toInt();
                                                                                        if (index < 0 || index >= processAverages.length) return Container();
                                                                                      
                                                                                      String label = processAverages[index]['process'] ?? '';
                                                                                      
                                                     String truncateWithEllipsis(int cutoff, String myString) {
                                                                                                return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
                                                                                              }
                                              label = truncateWithEllipsis(20, label); 
                              String formatLabel(String label) {
  if (label.length <= 8) return label;

  // Check if it's a single long word
  bool isSingleWord = !label.contains(' ');
  if (isSingleWord && label.length > 12) {
    int midpoint = (label.length / 2).round();
    return '${label.substring(0, midpoint)}-\n${label.substring(midpoint)}';
  }

  // Normal behavior for multi-word or moderately long words
  int midpoint = (label.length / 2).round();
  bool shouldHyphenate = label[midpoint - 1] != ' ' && label[midpoint] != ' ';

  String firstHalf = label.substring(0, midpoint).trim();
  String secondHalf = label.substring(midpoint).trim();

  return shouldHyphenate
      ? '$firstHalf-\n$secondHalf'
      : '$firstHalf\n$secondHalf';
}
label = formatLabel(label);
                                
double fontSizeOnLength(int length){
                                                             if (length > 10 && length < 15){
                                                               return 12.5;
                                                             } else if (length > 15 && length < 17){
                                                               return 12.5;
                                                             } else if (length >= 17){
                                                               return 12;
                                                             } else if (length > 25){
                                                               return 11;
                                                             } else {
                                                               return 15;
                                                             }
                                                            }               
                                             
                                                                                      
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.only(top:3),
                                                                                          child: Text(
                                                                                       label,
                                                                                       maxLines: 2,
                                                                                       textAlign: TextAlign.center,
                                                                                       overflow: TextOverflow.ellipsis,
                                                                                       style: TextStyle(
                                                                                         fontFamily: 'WorkSans',
                                                                                         fontSize: fontSizeOnLength(label.length),
                                                                                         color: const Color.fromARGB(255, 83, 83, 83),
                                                                                       ),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                         )
                                                                       ),
                                                                             rightTitles: AxisTitles(
                                                                              
                                                                               sideTitles: SideTitles(showTitles: false,
                                                                             
                                                                       
                                                                               ),
                                                                               
                                                                             
                                                                             ),),  
                                                                       
                                                                       ),
                                                                       
                                                                              
                                                                        );
                                                        }
                                                      ),
                                                    )
                                                    ),
                                                  ],
                                                );
                                                 }),
                                            ),
                                          ),
                                          
                                        );
                                      }
                                    );
                           }
                         ),
                                SizedBox(width: 20,),
                                StatefulBuilder(
                                  builder: (context, setLocalState) {
                                    return Container(
                                      width: 560,
                                      height: 310,
                                      decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 213, 236, 255),
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                                                                          SizedBox(height:  10,),
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 20,),
                                                        Text('Average Time', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 17),),

                                                      ],
                                                    ),
                                                    SizedBox(height: 20,),
                                          SizedBox(
                                            width: 530,
                                           height: 250 ,
                                            child: FutureBuilder(
                                              future:    cat =='Overview' || subcatTrue == false ?
                                                           Supabase.instance.client.from('detail').select().not('endtime', 'is', null)
                                                       : Supabase.instance.client.from('detail').select().eq(cat == 'Route' ? 'route_name'  : cat == 'User' ?
                                                       'usernamed' : cat == 'Process' ? 'process' : 'originalneed', subcat).not('endtime', 'is', null),
                                              builder: (context, snapshot) {
                                                
                                                              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                                                               return Column(
                                                                 children: [
                                                                   Align(
                                                                    alignment: Alignment.centerLeft,
                                                                     child: SizedBox(
                                                                                                                 width: 50,
                                                                                                                 height: 50,
                                                                                                                 child: CircularProgressIndicator(
                                                                                                                  color: Colors.blue,
                                                                     )),
                                                                   ),
                                                                 ],
                                                               );
                                                              }
                                                            
                                                              final data1 = snapshot.data ?? [];
                                                           
                                                          
                                            
                                                                                 
                                                                    if (data1.isEmpty ){
                                                                      return Text('No Data', style: TextStyle(fontFamily: 'Inter'),);
                                                                    }                
                                                                 double roundMaxY(double maxY) {
                                                            if (maxY <= 5) return 5;
                                                          
                                                          
                                                            int base = 10;
                                                            if (maxY < 20) base = 5;
                                                            return (maxY / base).ceil() * base.toDouble();
                                                          }
                                                        
                                                        
                                                    
                                                        List totalTime = [];
                                                           final List processAverages = [];
                                                          Map weekAvg = {DateTime.monday:0, DateTime.tuesday:0, DateTime.wednesday: 0, DateTime.thursday:0, DateTime.friday:0, DateTime.saturday: 0, DateTime.sunday: 0};
                                                           Map yearAvg = {DateTime.january:0, DateTime.february:0, DateTime.march: 0, DateTime.april:0, DateTime.may:0, DateTime.june: 0, DateTime.july: 0, 
                                                           DateTime.august:0, DateTime.september:0, DateTime.october: 0, DateTime.november:0, DateTime.december:0};
                                                           DateTime? start;
                                                           DateTime? end;
                                                        
                                                        double avg = 0;
                                            Map<int, double> monthAvg = {};
                                            
                                            List weekdays = [DateTime.monday, DateTime.tuesday, DateTime.wednesday, DateTime.thursday, DateTime.friday, DateTime.saturday, DateTime.sunday];
                                             List months = [DateTime.january, DateTime.february, DateTime.march, DateTime.april, DateTime.may, DateTime.june, DateTime.july, DateTime.august, DateTime.september, DateTime.october, DateTime.november, DateTime.december];


                                            final monthdays = data1.where((entry){
                                              return entry['endtime'] != null && DateTime.parse(entry['endtime']).month == DateTime.now().month;
                                            });
                                                                   Map<int, List<Map>> groupedmonthdays = {};
                                                                               bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
           
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}


                                                                    if (weekly == true){  for (final week in weekdays){
                                            if (data1.isNotEmpty) {
                                              final data6 = data1.where((entry){
                                                return DateTime.parse(entry['starttime']).weekday == week && isThisWeek(DateTime.parse(entry['starttime']));
                                              }).toList();

                                                
                                              if (data6.isNotEmpty){
                                                double total = 0;
                                                
                                              for (final entry in data6) {
                                               
                                                  final startRaw = entry['starttime'];
                                                  final endRaw = entry['endtime'];
                                            
                                                  if (startRaw == null || endRaw == null) continue;
                                            
                                                  final start = DateTime.parse(startRaw);
                                                  final end = DateTime.parse(endRaw);
                                             print('start:   $start, end: $end');
                                                  total += end.difference(start).inSeconds;
                                               
                                                }
                                            
                                                double avg = total / data6.length / 60;
                                              totalTime.add(avg.toInt());
                                            
                                              processAverages.add(avg);
                                            weekAvg[week] = avg;
                                              }
                                            
                                              
                                            }            
                                            }                
                                                                    } else if (monthly == true) {
for (final entry in monthdays){final date = DateTime.parse(entry['starttime']);
  final day = date.day;

  groupedmonthdays.putIfAbsent(day, () => []);

if (isThisMonth(DateTime.parse(entry['starttime']))){
  groupedmonthdays[day]!.add(entry);
  if (groupedmonthdays[day] != null){
  }                                 
                                                double total = 0;
                                                
                                              for (final entry in groupedmonthdays[day]!) {
                                                  final startRaw = entry['starttime'];
                                                  final endRaw = entry['endtime'];
                                            
                                                  if (startRaw == null || endRaw == null) continue;
                                            
                                                  final start = DateTime.parse(startRaw);
                                                  final end = DateTime.parse(endRaw);
                                            
                                                  total += end.difference(start).inSeconds;
                                                
                                                }
                                            
                                                
                                             
                                                double avg = total / groupedmonthdays[day]!.length / 60;
                                              totalTime.add(avg.toInt());
                                            
                                              processAverages.add(avg);
                                            monthAvg[day] = avg;
                                              }
                                            
}
                                                                    }      else {
                                                                      for (final month in months){
                                            if (data1.isNotEmpty) {
                                              final data6 = data1.where((entry){
                                                return DateTime.parse(entry['starttime']).month == month && isThisYear(DateTime.parse(entry['starttime']));
                                              }).toList();
                                              if (data6.isNotEmpty){
                                                double total = 0;
                                                
                                              for (final entry in data6) {
                                                  final startRaw = entry['starttime'];
                                                  final endRaw = entry['endtime'];
                                            
                                                  if (startRaw == null || endRaw == null) continue;
                                            
                                                  final start = DateTime.parse(startRaw);
                                                  final end = DateTime.parse(endRaw);
                                            
                                                  total += end.difference(start).inSeconds;
                                                
                                                }
                                            
                                                
                                             
                                                double avg = total / data6.length / 60;
                                              totalTime.add(avg);
                                            
                                              processAverages.add(avg);
                                            yearAvg[month] = avg;
                                              }
                                            
                                              
                                            }            
                                            }          
                                                                    }
                                                                    
                                                                    print('weekavg $weekAvg');
                                                              
                                              //    processAverages.sort((a, b) {
                                              // final avgA = a['avg'] ?? 0;
                                              // final avgB = b['avg'] ?? 0;
                                            
                                              // if (avgA != avgB) {
                                              //   return avgB.compareTo(avgA); // descending order by avg
                                              // } else {
                                              //   // No 'id' field present in your maps?
                                              //   // If you have an 'id' field, do this fallback:
                                              //   // return (b['id'] ?? 0).compareTo(a['id'] ?? 0);
                                              //   // Otherwise just return 0 (equal)
                                              //   return 0;
                                              // }
                                              //    });
                                            
                                            
                                              // double roundMaxY(double maxY) {
                                              //             if (maxY <= 5) return 5;
                                                        
                                                        
                                              //             int base = 10;
                                              //             if (maxY < 20) base = 5;
                                              //             return (maxY / base).ceil() * base.toDouble();
                                              //           }
                                          List<FlSpot> lol;

if (weekly == true) {
  lol = weekAvg.entries.map((e) {
    final day = e.key;
    final double avg = e.value;
    return FlSpot(day.toDouble(), double.parse(avg.toStringAsFixed(2)));
  }).toList();
} else if (yearly == true) {
  lol = yearAvg.entries.map((e) {
    final day = e.key;
    final double avg = e.value;
    return FlSpot(day.toDouble(), double.parse(avg.toStringAsFixed(2)));
  }).toList();
} else {
  lol = monthAvg.entries.map((e) {
    final day = e.key;
    final double avg = e.value;
    return FlSpot(day.toDouble(), double.parse(avg.toStringAsFixed(2)));
  }).toList();
}final sortedSpots = lol..sort((a, b) => a.x.compareTo(b.x));
                                                return Padding(
                                                  padding: const EdgeInsets.all(3),
                                                  child: LineChart(
                                                                                    
                                                    LineChartData(
                                                      lineTouchData: LineTouchData(
                                                        touchTooltipData: LineTouchTooltipData(
                                                               getTooltipColor: (groups){
                                                                        return Colors.blue;
                                                                      } ,
                                                              getTooltipItems: (touchedSpots) {
        return touchedSpots.map((LineBarSpot spot) {
          return LineTooltipItem(
            '${spot.y.toStringAsFixed(2)}',
            const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        }).toList();
      },

                                                        )
                                                      ),
                                                      minX: monthly
      ? 0
      : 1,
  maxX: weekly
      ? 7
      : yearly ? 12 
      : DateTime(DateTime.now().year, DateTime.now().month+1, 0).day.toDouble()+1,
      

                                                      maxY: weekly ? roundMaxY( weekAvg.values.isNotEmpty 
                                                ? weekAvg.values.reduce((a, b) => a > b ? a : b) 
                                                : 0,
                                                      )
                                                      
                                                      : yearly ? roundMaxY( yearAvg.values.isNotEmpty 
                                                ? yearAvg.values.reduce((a, b) => a > b ? a : b) 
                                                : 0,
                                                      ) :  roundMaxY( monthAvg.values.isNotEmpty 
                                                ? monthAvg.values.reduce((a, b) => a > b ? a : b) 
                                                : 0,),
                                                       minY: 0, 
                                                      gridData: FlGridData(show: false),
                                                      borderData: FlBorderData(show: false),
                                                      lineBarsData: [
                                                  LineChartBarData(
                                                    isCurved: true,
                                                    curveSmoothness: 0.2,
                                                    color: const Color.fromARGB(255, 74, 174, 255),
                                                    barWidth: 3,
                                                         dotData: FlDotData(
                                        show: true,
                                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                          radius: 4,
                                          color: const Color.fromARGB(255, 84, 185, 243),
                                        ),
                                                         ),
                                                  
                                                    spots: sortedSpots,
                                                        belowBarData:    BarAreaData(
                                                            cutOffY: 0,  
                                                            applyCutOffY: true,
                                                          show: true,
                                                          color: Colors.blue.withAlpha(100),
                                                        )                        
                                                  )
                                                      ],
                                                  
                                    
                                                      titlesData: FlTitlesData(
                                                        leftTitles: AxisTitles(
                                                          sideTitles: SideTitles(
                                                            showTitles: true,
                                                            interval:  weekly ? weekAvg.values.reduce((a, b) => a > b ? a : b)  >= 5 ?
                                                                                   (weekAvg.values.reduce((a, b) => a > b ? a : b) == 0 ? 10 : weekAvg.values.reduce((a, b) => a > b ? a : b) % 5 == 0 ?
                                                                                    weekAvg.values.reduce((a, b) => a > b ? a : b) : roundMaxY(weekAvg.values.reduce((a, b) => a > b ? a : b).toDouble()))/5 : 1 :
                                                                                    yearly ? yearAvg.values.reduce((a, b) => a > b ? a : b)  >= 5 ?
                                                                                   (yearAvg.values.reduce((a, b) => a > b ? a : b) == 0 ? 10 : yearAvg.values.reduce((a, b) => a > b ? a : b) % 5 == 0 ?
                                                                                   yearAvg.values.reduce((a, b) => a > b ? a : b) : roundMaxY(yearAvg.values.reduce((a, b) => a > b ? a : b).toDouble()))/5 : 1 :
                                                                                  monthAvg.values.reduce((a, b) => a > b ? a : b)  >= 5 ?
                                                                                   (monthAvg.values.reduce((a, b) => a > b ? a : b) == 0 ? 10 : monthAvg.values.reduce((a, b) => a > b ? a : b) % 5 == 0 ?
                                                                                    monthAvg.values.reduce((a, b) => a > b ? a : b) : roundMaxY(monthAvg.values.reduce((a, b) => a > b ? a : b).toDouble()))/5 : 1,
                                                            reservedSize: 40,
                                                            getTitlesWidget: (value, meta) {
                                                            
                                                              return Text('$value', style: TextStyle(fontFamily: 'Inter', color:const Color.fromARGB(255, 0, 88, 161)));
                                                            }, 
                                                          )
                                                        ),
                                                        topTitles: AxisTitles(
                                                          sideTitles: SideTitles(showTitles: false)
                                                        ),
                                                          rightTitles: AxisTitles(
                                                          sideTitles: SideTitles(showTitles: false)
                                                        ),
                                                          bottomTitles: AxisTitles(
                                                          sideTitles: SideTitles(showTitles: true,
                                                          interval: monthly ? 2 : 1,
                                                          getTitlesWidget:(value, meta) {
                                                           if (weekly) {
        const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        if (value.toInt() < 1 || value.toInt() > 7) return Container();
        return Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            labels[value.toInt() - 1],
            style: TextStyle(fontFamily: 'Inter', color: Colors.grey),
          ),
        );
      } else if (monthly) {
        if (value < 1 || value > 31) return Container();
        return Padding(

          padding: EdgeInsets.all(3),
          child: Text(
            
            '${value.toInt()}',
            style: TextStyle(fontFamily: 'Inter', color: Colors.grey),
          ),
        );
      } else if (yearly){
              const labels = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        if (value.toInt() < 1 || value.toInt() > 12) return Container();
        return Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            labels[value.toInt() - 1],
            style: TextStyle(fontFamily: 'Inter', color: Colors.grey),
          ),
        );
      } else {
        return Container();
      }}
                                                          )
                                                        ),
                                                      )
                                                    ),
                                                  
                                                  ),
                                                );
                                              
                                              }),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                )
                       ],
                     ),

   Column(
     children: [
      SizedBox(height: 10,),
      Align(
        alignment: Alignment.topLeft,
        
        
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Material Leaderboard', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20),),
        )),
      SizedBox(height: 10,),
       Align(
        alignment: Alignment.topLeft,
         child: Container(
                    decoration: BoxDecoration(
                       gradient: LinearGradient(
                            colors: [ const Color.fromARGB(255, 186, 224, 254), const Color.fromARGB(255, 234, 245, 255) ],
                          begin: Alignment.centerLeft, end: Alignment.centerRight),
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                    ),
                    height: 60,
                    width: 1500,
                    child: Row(children: [
                    
                        SizedBox(width: 20),
                          SizedBox(width: 150, child: Text('Rank', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                           SizedBox(width: 20),
                        SizedBox(width: 350, child: Text('Name', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                           SizedBox(width: 20),
                        SizedBox(width: 350, child: Text('Amount of Requests', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                           SizedBox(width: 20),
                        SizedBox(width: 150, child: Text('Average Completion Time (min)', style: TextStyle(fontSize: 15, fontFamily: 'Inter',
                        fontWeight: FontWeight.bold))),
                           SizedBox(width: 20),
                          
                        
                    ],)
                ),
       ),
     
                    SizedBox(
                      height: 700,
                      child: FutureBuilder(
                                    future:     cat == 'Overview' || subcatTrue == false ?
                                                      Supabase.instance.client.from('detail').select().not('endtime', 'is', null)
                                                       : Supabase.instance.client.from('detail').select().eq(cat == 'Route' ? 'route_name'  : cat== 'User' ?
                                                       'usernamed' : cat == 'Process' ? 'process' : 'originalneed', subcat).not('endtime', 'is', null), 
                                    builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                                    
                          final data = snapshot.data ?? [];
                              print('dataaa $data');
                                                 final List<Map<String, dynamic>> routeAverages = [];

                                                          bool isThisWeek(DateTime day) { final now = DateTime.now();
  final sevenDaysAgo = now.subtract(Duration(days: 7));
  return day.isAfter(sevenDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisMonth(DateTime day) {
  final now = DateTime.now();
  final thrityDaysAgo = now.subtract(Duration(days: 30));
  
 return day.isAfter(thrityDaysAgo) && day.isBefore(now.add(Duration(days: 1)));
}
bool isThisYear(DateTime day) {
  final now = DateTime.now();

final oneYearAgo = now.subtract(Duration(days: 365));

 return day.isAfter(oneYearAgo) && day.isBefore(now.add(Duration(days: 1)));
}
                       
                            
                             final datar = data.where((entry){
                                 return weekly ? 
                                  isThisWeek(DateTime.parse(entry['starttime'])) == true
                                  :  monthly ? isThisMonth(DateTime.parse(entry['starttime'])) == true : 
                                  isThisYear(DateTime.parse(entry['starttime'])) == true;
                                  

                                }).toList();

                                if (datar.isEmpty){
                                  return Text('No data', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold));
                                }

for (final entry in datar) {
  if (!routeAverages.any((e) => e['originalneed'] == entry['originalneed'])){
  final processName = entry['originalneed'];

  final matchingEntries = data.where((entry) {

     return entry['originalneed'] == processName &&
           entry['starttime'] != null &&
           entry['endtime'] != null;
  }).toList();


  double avg = 0;
  if (matchingEntries.isNotEmpty) {
    int total = 0;
    for (final match in matchingEntries) {
      
        final start = DateTime.parse(match['starttime']);
        final end = DateTime.parse(match['endtime']);
        
        final duration = end.difference(start).inSeconds;
        
        total += duration;
     
    }
    avg = total / matchingEntries.length / 60; // to minutes
  }


  routeAverages.add({
    'originalneed': processName,
    'avg': avg,
  });
}
}


                 
print('✅ Final routeAverages: $routeAverages');
                              

                                  Map<String, int> lister = {};
                                   for (final entry in data){
                                    if (lister.containsKey(entry['originalneed'])){
                                   lister.update(entry['originalneed'], (value) => value + 1);
                                    } else {
                                      lister[entry['originalneed']] = 1;
                                    }
                                   }
                          
                            if (data.isEmpty) {
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
                       
                     

        routeAverages.sort((a, b) {
  final freqA = lister[a['originalneed']] ?? 0;
  final freqB = lister[b['originalneed']] ?? 0;

  return freqB.compareTo(freqA); // descending
});
print('✅ Final routeAverages: $routeAverages');
                     

                   data.sort((a, b) {
  final freqA = lister[a['originalneed']] ?? 0;
  final freqB = lister['originalneed'] ?? 0;

  return freqB.compareTo(freqA); // descending
});

Map<String, List<Map<String, dynamic>>> grouped = {};

for (final entry in data) {
  
  
  final key = entry['originalneed'];
  grouped.putIfAbsent(key, () => []).add(entry);
}
final sortedData = grouped.entries.toList();
                          return ListView.builder(
                            itemCount: sortedData.length,
                            itemBuilder: (context, index) {
                              final group = sortedData[index];
                              final entry = group.value.first;
                              
                                
                          
                                 final requestItem = entry['originalneed'];
final routeAvgEntry = routeAverages.firstWhere(
  (e) => e['originalneed'] == requestItem,
  orElse: () => {'avg': null},
);  
                              return StatefulBuilder(
                                builder: (context, setLocalState) => 
                               Container(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 118, 118, 118))),
                            color: 
                              
                                  
                                   
                                    Colors.white),
                                    
                                  child: SizedBox(
                                    height: 61,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                             SizedBox(width: 20),
                                             SizedBox(width: 150, child: Text('${index+1} ', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                           
                                            SizedBox(width: 20),
                                            SizedBox(width: 350, child: Text(entry['originalneed'] ?? 'N/A', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                             SizedBox(width: 20),
                                            SizedBox(width: 350, child: Text('${lister[entry['originalneed']] ?? 'N/A'}', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                            SizedBox(width: 20),
                                            
                                            SizedBox(width: 150, child: Text(routeAvgEntry['avg'] != null
        ? '${(routeAvgEntry['avg'] as double).toStringAsFixed(2)}'
        : 'N/A', style: TextStyle(fontSize: 16,fontFamily: 'Inter'))),
                                            SizedBox(width: 20),
                                         
                                            SizedBox(width: 70, child: Column(children: [
                                              SizedBox(height: 45,),
                                            ],)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                                    },
                          
                        
                      ),
                    )
                     
                 ])
                 
                 
                    ]), 
                 )]
                 
                 ),
                 
           ],
         ),
       ),
     )
      ],
      ),
  ])
    );
  }
}
