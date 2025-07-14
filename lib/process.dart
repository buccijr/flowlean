import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'routes.dart';

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

class Process extends StatefulWidget {
const Process({super.key});

  @override
  State <Process> createState() =>  ProcessState();
}

class  ProcessState extends State <Process> {

@override
initState(){
  super.initState();
  _loadUserRole();
  searchPController.addListener((){
  _onSearchChanged();
});
}

final ValueNotifier<bool> snackbarNotifier = ValueNotifier(false);
bool canGo = true;
bool canGot2 = true;
Map<String, bool> isCheckedMapEdit = {};
Map<String, bool> isCheckedMap = {};



Timer? _debounce;
void _onSearchChanged(){
  if (_debounce?.isActive ?? false) _debounce?.cancel();
_debounce = Timer(const Duration(milliseconds: 400), (){
  setState(() {
    
  });
});
}



void viewPopUp(process, id) {
showDialog(
  context: context,
  builder: (_) => StatefulBuilder(
    builder:(context, setLocalState) => 
    ValueListenableBuilder(
      valueListenable: snackbarNotifier,
      builder: (context, value, child) {
        return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.all(0),
          
        content: Container(
          width: 500,
          height: 600,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(30)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height:  30),
            Row(
              children: [
                SizedBox(width: 30),
                Text('User Permissions', textAlign: TextAlign.center,
                style: TextStyle(color:  const Color.fromARGB(255, 156, 211, 255), fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 21),),
                Spacer(),
                IconButton(
                  onPressed: (){
          //  dobController.clear();
          //                                         skuController.clear();
          //                                        descripController.clear();
          //                                        dimentionController.clear();
          //                                        locationController.clear();
          //                                        batchController.clear();
          //                                        expController.clear();
          //                                        nameController.clear();
          isCheckedMapEdit.clear();
                                                 Navigator.pop(context);
                                                 setLocalState((){});
                  },
                icon: Icon(Icons.close)),
                SizedBox(width: 20),
              ],
            ),
            Divider(thickness: 1, indent: 20, endIndent: 20,),
            // SizedBox(height: 25),
            SizedBox(
              height: 400,
              width: 450,
              child: Column(
                children: [
              //     Row(
              //       children: [
              //         SizedBox(width: 30,),
              //         Text('Description', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16)),
              //       ],
              //     ),
                    
              // SizedBox(height: 10,),
              // SizedBox(width: 30),
              // Row(
              //   children: [
              //      SizedBox(width: 30),
              //     Container(
              //       width: 400,
              //       height: 45,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: const Color.fromARGB(255, 235, 235, 235),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: TextField(
              //         controller:  descriptionController,
              //         cursorColor: Colors.black,
              //         decoration: InputDecoration(
              //           enabledBorder: InputBorder.none,
              //           focusedBorder: InputBorder.none,
              //           disabledBorder: InputBorder.none,
              //           labelText: 'Enter the description...',
              //           floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
              //         ),
              //         ),
                   
              //       ),
              //     ),
              //   ],
              // ),
               SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //      SizedBox(width: 30,),
                      //     Text('Permissions', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16)),
                      //   ],
                      // ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          SizedBox(width: 30,),
                          FutureBuilder(
                            future: Future.wait([ Supabase.instance.client.from('user').select(),
                            Supabase.instance.client.from('process_users').select().eq('processpu', process)
                            ]),
                            builder: (context, snapshot) {
                                if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
          }
        
          if (!snapshot.hasData || snapshot.data == null) {
        return Text('No data found');
          }
                             final List<dynamic> data = snapshot.data![0] as List;
        final List<dynamic> data2 = snapshot.data![1] as List;
        
                           if (data.isEmpty){
                            return Center(child: Text('No users found', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)));
                           } 
                 final Set<String> permittedUsers = {
          for (final entry in data2)
            if (entry['userpu'] != null && entry['disabled'] != 'true') entry['userpu'] as String
        };
        
        
        
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                               child: SizedBox(
                                  width: 400,
                                  height: 250,
                               child: Column(
                                 children: data.map((entry)  { 
                                  final usernames = entry['username'];
                                              final isChecked = isCheckedMapEdit[usernames] ?? permittedUsers.contains(usernames);
        
                                  return Align(
                                  alignment: Alignment.topLeft,
                                   child: 
                                      // if (snapshot.connectionState == ConnectionState.waiting){
                                      //   return CircularProgressIndicator();
                                      // }
                                     
                                        CheckboxListTile(
                                        title: Text(usernames, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                                        activeColor: Colors.blue,
                                        value: isChecked,
                                        onChanged: (value){
                                          setLocalState(() {
                                             isCheckedMapEdit[usernames] = value!;
                                          },);
                                       
                                        setLocalState
                                        (() {
                                          
                                        },);
                                        }
                                                         
                                        )
                                    
                                 );}).toList(),
                               )
                                ),
                              );
                            }
                          ),
                        ],
                      )
                 ]),
            ),
            snackbarNotifier.value ? 
            SizedBox(width: 20,) : SizedBox.shrink(),
             snackbarNotifier.value  ?
                        Text('Updated sucessfully.', style: TextStyle(fontFamily: 'Inter', color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16))
                    
                        : SizedBox.shrink(),
                       snackbarNotifier.value ?     SizedBox(width: 20,) : SizedBox.shrink(),
            
                                      SizedBox(height: 30,),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                         children: [
                                           MouseRegion(
                                               cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                onTap: (){
                                                //   dobController.clear();
                                                //   skuController.clear();
                                                //  descripController.clear();
                                                //  dimentionController.clear();
                                                //  locationController.clear();
                                                //  batchController.clear();
                                                //  expController.clear();
                                                //  nameController.clear();
                                                   descriptionController.clear();
                                            errorText = '';
                                            successText = false;
                                            isCheckedMap.clear();
                                            isCheckeder = '';
                                            isCheckedMapEdit.clear();
                                                 Navigator.pop(context);
                                                 setLocalState((){});
                                                },
                                                child: Container(
                                                width: 90,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 12),
                                                      Text('Cancel', style: TextStyle(fontFamily: 'Inter')),
                                                    ],
                                                  ),
                                                ),
                                                ),
                                               ),
                                                                      ),
                                                                      SizedBox(width: 10,),
                                                             MouseRegion(
                                           cursor: SystemMouseCursors.click,
                                           child: GestureDetector(
                                            onTap: () async {


                           if (canGo == true){              
        Map<String, bool> isCheckedMap2 = Map.fromEntries(
          isCheckedMapEdit.entries.where((entry) => entry.value == true)
        );
        List <String> isCheckedMap3 = isCheckedMap2.keys.toList();
          final user = Supabase.instance.client.auth.currentUser;
          final email = user?.email;
          
          final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
          final company = response?['company'];
          final username = response?['username'];
                                            
        for (final entry in isCheckedMap3){
          // if (isCheckedMap3[username] == true) {
        await Supabase.instance.client.from('process_users').upsert({
                                                'company': company,
                                                'userpu': entry,
                                                'usercreate': username,
                                                'processpu': process,
                                              }).eq('id', id).eq('userpu', entry);
                                             
        }
         Map<String, bool> isCheckedMap4 = Map.fromEntries(
          isCheckedMapEdit.entries.where((entry) => entry.value == false)
        );
        List <String> isCheckedMap5 = isCheckedMap4.keys.toList();
        for (final entry in isCheckedMap5){
          final response = await Supabase.instance.client.from('process_users').select().eq('userpu', entry).or('disabled.is.null,disabled.not.eq.true');
          if (response.isNotEmpty){

          await Supabase.instance.client.from('process_users').update({'disabled': 'true'}).eq('id', id).eq('userpu', entry);
          }

          canGo = false;
        }}
        //   } else {
        // await Supabase.instance.client.from('process_users').update({
        //                                             'company': company,
        //                                             'userpu': entry,
        //                                             'usercreate': username,
        //                                           }).eq('id', id).eq('userpu', entry);
        //   }
                                            
        snackbarNotifier.value = true;
        
               Future.delayed(Duration(seconds: 3), () {
          snackbarNotifier.value = false;
          canGo = true;
        });
              setState(() {
                
              });
                                          
                                          
         
                                            
                                             setLocalState((){});
                                            },
                                            child: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 186, 224, 254),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 12),
                                                  Text('Update', style: TextStyle(fontFamily: 'Inter')),
                                                ],
                                              ),
                                            ),
                                            ),
                                           ),
                                                                  ),
                                                                  SizedBox(width: 20),  ],
                                       ),
                                              ],
            ),),
        );
      }
    )
    )
);
}
void dispose2() {
  _debounce?.cancel();
  searchPController.dispose();  // 
  super.dispose();
}



bool isChecked = false;
TextEditingController descriptionController = TextEditingController();
String errorText = '';
bool successText = false;

void processPopUp() {
showDialog(
  context: context,
  builder: (_) => StatefulBuilder(
    builder:(context, setLocalState) => 
    AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.all(0),
  
    content: Container(
      width: 500,
      height: 650,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height:  30),
        Row(
          children: [
            SizedBox(width: 30),
            Text('Add a process', textAlign: TextAlign.center,
            style: TextStyle(color:  const Color.fromARGB(255, 156, 211, 255), fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 21),),
SizedBox(width: 20,),
Text(successText ? 'Added successfully' : errorText, style: TextStyle(fontFamily: 'Inter', color: successText ? Colors.green : Colors.red),),
            Spacer(),
            IconButton(
              onPressed: (){
      //  dobController.clear();
      //                                         skuController.clear();
      //                                        descripController.clear();
      //                                        dimentionController.clear();
      //                                        locationController.clear();
      //                                        batchController.clear();
      //                                        expController.clear();
      //                                        nameController.clear();
         descriptionController.clear();
                                            errorText = '';
                                            successText = false;
                                            isCheckedMap.clear();
                                            isCheckeder = '';
         
                                            errorText = '';
                                            successText = false;
                                            isCheckedMap.clear();
                                            isCheckeder = '';

                                             Navigator.pop(context);
                                             setLocalState((){});
              },
            icon: Icon(Icons.close)),
            SizedBox(width: 20),
          ],
        ),
        Divider(thickness: 1, indent: 20, endIndent: 20,),
        SizedBox(height: 25),
        SizedBox(
          height: 450,
          width: 450,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 30,),
                  Text('Description', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
                
          SizedBox(height: 10,),
     
          SizedBox(width: 30),
          Row(
            children: [
               SizedBox(width: 30),
              Container(
                width: 400,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 235, 235, 235),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                  controller:  descriptionController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelText: 'Enter the description...',
                    floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                  ),
                  ),
               
                ),
              ),
            ],
          ),
          SizedBox(height: 15 ,),
               Row(
                 children: [
                 SizedBox(width: 25,), 
                   Align(
                    alignment: Alignment.topLeft,
                     child: Row(
                       children: [
                         TextButton(
                          onPressed: (){
                            isCheckeder = 'true';
                             setLocalState(() {
                                  
                                },);
                          },
                          child: Text('Y', style: TextStyle(color: const Color.fromARGB(255, 0, 68, 113), fontSize: 18, fontWeight: isCheckeder == 'true' ?
                         FontWeight.bold : FontWeight.normal 
                          ),)),
                         SizedBox(width: 7,),
                           Text('|', style: TextStyle(fontSize: 18),),
                            SizedBox(width: 7,),
                             TextButton( 
                              onPressed: (){
                                isCheckeder = 'false';
                                setLocalState(() {
                                  
                                },);
                              },
                              child: Text('N', style: TextStyle(color: const Color.fromARGB(255, 0, 51, 113), fontSize: 18,  fontWeight: isCheckeder == 'false' ?
                         FontWeight.bold : FontWeight.normal ),)),
                       ],
                     ),
                     
                    //  Checkbox(value: isCheckeder, 
                    //  activeColor: const Color.fromARGB(255, 0, 55, 101),
                    //  onChanged: (value){
                    //  setLocalState(() {
                    //    isCheckeder = value!;
                       
                    //  },);
                    //            }),
                               
                   ),
                   SizedBox(width: 10),
                   Text('Is material movement?', style: TextStyle(fontFamily: 'Inter', fontSize: 16.5, ),)
                 ],
               ),
           SizedBox(height: 20),
                  Row(
                    children: [
                       SizedBox(width: 30,),
                      Text('Set permissions (optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      SizedBox(width: 30,),
                      FutureBuilder(
                        future: Supabase.instance.client.from('user').select(),
                        builder: (context, snapshot) {
                       final data = snapshot.data ?? [];
                       if (data.isEmpty){
                        return Center(child: Text('No users found', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)));
                       } 
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                           child: SizedBox(
                              width: 400,
                              height: 250,
                           child: Column(
                             children: data.map((entry) { 
                              final username = entry['username'];
                              return Align(
                              alignment: Alignment.topLeft,
                               child: CheckboxListTile(
                                title: Text(username, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
                                activeColor: Colors.blue,
                                value: isCheckedMap[username] ?? false,
                                onChanged: (value){
                                  setLocalState(() {
                                     isCheckedMap[username] = value!;
                                  },);
                               
                                setLocalState
                                (() {
                                  
                                },);
                                }
                                                 
                                ),
                             );}).toList(),
                           )
                            ),
                          );
                        }
                      ),
                    ],
                  )
             ]),
        ),
       
        
                                  SizedBox(height: 30,),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                     children: [
                                       MouseRegion(
                                           cursor: SystemMouseCursors.click,
                                           child: GestureDetector(
                                            onTap: (){
                                            //   dobController.clear();
                                            //   skuController.clear();
                                            //  descripController.clear();
                                            //  dimentionController.clear();
                                            //  locationController.clear();
                                            //  batchController.clear();
                                            //  expController.clear();
                                            //  nameController.clear();
                                            descriptionController.clear();
                                            errorText = '';
                                            successText = false;
                                            isCheckedMap.clear();
                                            isCheckeder = '';
                                            isCheckedMapEdit.clear();
                                             Navigator.pop(context);
                                             setLocalState((){});
                                            },
                                            child: Container(
                                            width: 90,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1, color: Colors.grey),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 12),
                                                  Text('Cancel', style: TextStyle(fontFamily: 'Inter')),
                                                ],
                                              ),
                                            ),
                                            ),
                                           ),
                                                                  ),
                                                                  SizedBox(width: 10,),
                                                         MouseRegion(
                                       cursor: SystemMouseCursors.click,
                                       child: GestureDetector(
                                        onTap: () async {
                                         if (descriptionController.text.isEmpty){
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
                  Text('Please do not leave the name field blank.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                                         } else {
         
Map<String, bool> isCheckedMap2 = Map.fromEntries(
  isCheckedMap.entries.where((entry) => entry.value == true)
);

final response56 = await Supabase.instance.client.from('process').select().eq('description', descriptionController.text.trim());

if (isCheckeder == ''){
  errorText = 'Please pick either yes or no';
  setLocalState(() {
    
  },);
} 
                                          else if (response56.isNotEmpty){
errorText = 'Process already exists';
setLocalState(() {
  
},);
                                         }

else {
  successText = true;
List <String> isCheckedMap3 = isCheckedMap2.keys.toList();
  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
  await Supabase.instance.client.from('process').insert({
                                            'company': company,
                                            'description': descriptionController.text.trim(),
                                            'userp': username,
                                           if (isCheckeder == 'true')
                                           'matmov': true,
                                           if (isCheckeder == 'false')
                                           'matmov': false,
                                          });
                                          if (isCheckedMap3.isNotEmpty){
for (final entry in isCheckedMap3){
await Supabase.instance.client.from('process_users').insert({
                                            'company': company,
                                            'processpu': descriptionController.text.trim(),
                                            'userpu': entry,
                                            'usercreate': username,
                                          });
}
                                        
                                         }}
                                         }
                                         setLocalState((){});
                                        },
                                        child: Container(
                                        width: 90,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(255, 186, 224, 254),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 20),
                                              Text('Add', style: TextStyle(fontFamily: 'Inter')),
                                            ],
                                          ),
                                        ),
                                        ),
                                       ),
                                                              ),
                                                              SizedBox(width: 20),  ],
                                   ),
                                          ],
        ),),
    )
    )
);
}

TextEditingController searchPController = TextEditingController();
  int? hoverIndex;
 bool selected1 = false;
bool  selected2 = false;
bool selected4 = false;
bool selected5 = false;
bool selected6 = true;
bool isMaterial = true;
bool isProcess = false;
bool selected3 = false;
Set<String> selectedButton = {'Material'};
bool process = false;
bool material = true;
String isCheckeder = '';



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
       backgroundColor:  Color(0xFFFAFAFA),
    floatingActionButton: FloatingActionButton.extended(
      backgroundColor:  const Color.fromARGB(255, 193, 223, 247),
      onPressed: (){
     processPopUp();
      },
      
    icon: Icon(Icons.add, color:Color.fromARGB(255, 0, 74, 123),),
    label: Text('Add Process', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),)
      ),
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
                      setState(() {
                       context.go('/admindashboard');
                        selected1 = true;
                        selected2 = false;
                        selected3 = false;
                 selected5 = false;
                        selected4 = false;
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
                              selected5 = false;
                       selected4 = false;
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
                        context.go('/users');
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
        SizedBox(width: 10),
        SizedBox(
          width: 1515,
              height: 825,
          child: Column(children: [
           SizedBox(height: 20),
                    Row(
          children: [
            SizedBox(width: 30),
            Text('Add Process', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
          ],
                    ),
                    SizedBox(height: 35),
                    Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              SizedBox(width: 20),
                    Spacer(),
                  Container(
              width: 400,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
              controller: searchPController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                label: Text('Search a process...'),
                floatingLabelStyle: TextStyle(color:  Color(0xFFFAFAFA),),
                enabledBorder: InputBorder.none,
                  isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              prefixIcon: Icon(Icons.search, color:const Color.fromARGB(255, 23, 85, 161), size: 26 )
              ),
              ),),
            SizedBox(width: 1095,),
           ],
                     ),
            
            
               ],),
              SizedBox(height: 10,),
         
          
                    
                    SizedBox(height: 20),
                  SizedBox(
                     width: 1515,
                      height: 600,
                       child: Column(
                         children: [
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
                                          
                                           SizedBox(width: 20),
                                             SizedBox(width: 400, child: Text('Description', style: TextStyle(fontSize: 15, fontFamily: 'Inter'
                                             , fontWeight: FontWeight.bold))),
                           SizedBox(width: 20),
                           Spacer(),
                                             SizedBox(width: 200, child: Text('', style: TextStyle(fontSize: 15, fontFamily: 'Inter'
                                             , fontWeight: FontWeight.bold))),
                           SizedBox(width: 30),
                            
                                         ],)
                                     ),
                                     Expanded(
                                       child: StreamBuilder<List<Map<String, dynamic>>>(
                                        stream: Supabase.instance.client.from('process').stream(primaryKey: ['id']).order('id'),
                                        builder:(context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting){
                                                      return Center(child: CircularProgressIndicator());
                                          } else if (snapshot.hasError){
                                            return Text('Error: ${snapshot.error}');
                                          }
                                          final data = snapshot.data ?? [];
                                          if (data.isEmpty){
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

                                          final filteredData = data.where((entry){
                                            final searchPControllerr = searchPController.text.toLowerCase();
                                            final names = entry['description'].toString().toLowerCase();
                                            if (searchPController.text.isNotEmpty){
                                              if (names.contains(searchPControllerr)){
                                          return true;
                                          
                                            } else {
                       
                                              return false;
                                              
                                            }
                                          }
                                            else {

                                             
                                               return true;
                                          }}).toList();
                                            
                                          
                                          return ListView.builder(
                                            itemCount: filteredData.length,
                                            itemBuilder:(context, index) {
                                              final entry = filteredData[index];
                                                     return StatefulBuilder(
                                       builder: (context, setLocalState) => 
                                                        Container(
                                                         decoration: BoxDecoration(
                                                           border: Border(bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 118, 118, 118))),
                                                         color: 
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
                                                           child: SizedBox(
                                                             height: 61,
                                                             child: Column(
                                                               children: [
                                                                 SizedBox(height: 5),
                                                                 Row(
                                                                   children: [
                                                                    
                                                                     SizedBox(width: 20),
                                                                                                   SizedBox(width: 400, child: Text('${entry['description']}', style: TextStyle(fontFamily: 'Inter', fontSize: 16))),
                                                                     SizedBox(width: 20),
                                                                     Spacer(),
                                                            SizedBox(width: 50, child: IconButton(
                                                              onPressed: (){
                                                                final process = entry['description'];
                                                                final id = entry['id'];
                                                                
                                                              viewPopUp(process, id);
                                                              },
                                                              icon: Icon(Icons.visibility))),
                                                              SizedBox(width: 30,),
                                                                   ],
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     );
                                            },
                                            );
                                          
                                        },
                                        ),
                                     )
                         ],
                       ),
                     )
          
         ],
          
          ),
        ),
      ],
    )
  ],),
);
    
  }
}