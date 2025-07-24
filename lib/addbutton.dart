

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: AddButton()));

}

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class CustomToast {
  static void show(
    BuildContext context,
     {
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 50,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _ToastContent(),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class _ToastContent extends StatelessWidget {
  

  const _ToastContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 250, // 👈 This will now work!
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.task_alt, color: Colors.white),
            SizedBox(width: 10, ),
            Text(
              'Added successfully!',
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class _AddButtonState extends State<AddButton> {
  String? nextProcess;
Map<String, dynamic> responses = {};
bool canGo = true;
bool hasRouter = false; 
final ValueNotifier<String?> namerNotifier = ValueNotifier(null);
final ValueNotifier<bool> snackbarNotifier = ValueNotifier(false);
TextEditingController searchRController = TextEditingController();
ValueNotifier<bool> hasRouterNotifier = ValueNotifier(false);
final selectedStep1Notifier = ValueNotifier<String>('Next Step');



double fontSizeBasedOnLength(String text) {
  if (text.length > 15){
    return 13;
  }
   else if (text.length > 30){
    return 10.00;
  } else {
    return 17;
  }
}
int? hoverIndex;
String selectedMaterial = 'Please select a material';
String selectedTime1 = 'Needed By';
String selectedTime2 = 'Needed By';
String selectedStep2 = 'Please select a step';
String? tor;
String? fromr;
ValueNotifier<String?> fromt = ValueNotifier(null);
ValueNotifier<String?> tot = ValueNotifier(null);
ValueNotifier<String?> fromt2 = ValueNotifier(null);
ValueNotifier<String?> tot2 = ValueNotifier(null);
bool nowm = true;
bool nowp = false;
bool isDone = false;
bool selected = false;
bool forklift = false;
List<String?> selectedValues = []; 
 List<int?> selectedIndex = [];
Map<int?, bool> tappedMap = {};
String selectedP = 'Process';
List<Map<String, dynamic>>? localData;
TextEditingController namec= TextEditingController();
List<String>? selectedProcesses;
int? step;
TextEditingController searchMController = TextEditingController();


Map<int, bool> tapIndexMap = {};
final ValueNotifier<int?> tapIndexNotifier = ValueNotifier(null);
final ValueNotifier<String?> tappedNotifier = ValueNotifier(null);
final ValueNotifier<String?> fromNotifier = ValueNotifier(null);
final ValueNotifier<String?> toNotifier = ValueNotifier(null);
int? tapIndex;


String from = 'Material Location';
String to = 'Current Process';



Future fetchTo() async {
   

    
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();

  final username = response?['username'];
  final response10 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
  final response18 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
    if (response10.length > 1){
   toNotifier.value =  response18?['machine'] ?? 'N/A'; 
  } else {
toNotifier.value = response10[0]['processpu'];
}
  
{ return 
toNotifier.value;
}
}





Future<String> fetchFrom(tappIndexx, taapp) async {
  final responses = await Supabase.instance.client
      .from('materials')
      .select()
      .eq('id', tappIndexx!)
      .maybeSingle();

  final location = responses?['location'];
  fromNotifier.value = location ?? 'N/A';
  return fromNotifier.value!;
}

Future<String> fetchTo2() async {
  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client
      .from('user')
      .select()
      .eq('email', email!)
      .maybeSingle();

  final username = response?['username'];
  final response10 = await Supabase.instance.client
      .from('process_users')
      .select()
      .eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');

  final response18 = await Supabase.instance.client
      .from('user_machine')
      .select()
      .eq('user_mac', username)
      .maybeSingle();

  if (response10.length > 1) {
    fetchtot2 = response18?['machine'] ?? 'N/A';
  } else {
    fetchtot2 = response10[0]['processpu'];
  }

  return fetchtot2!;
}




 fromTo() async {
  showDialog(context: context, 
  barrierDismissible: false,
  builder:(context) {
    
    return AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.all(0),
    content: StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          width: 530,
          height: 350,
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
           Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 50,),
                Text('From', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 15),),
              ],
            )),
                                                   SizedBox(height: 7,),
          Container(
                         width: 400,
                            height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color:Color.fromARGB(255, 0, 74, 123)),),
                        child: ValueListenableBuilder(
                          valueListenable: tappedNotifier,
                          builder: (context, taapp, child) {
                            return ValueListenableBuilder(
                              valueListenable: tapIndexNotifier,
                              builder: (context, tappIndexx, child) {
                                return ValueListenableBuilder(
                                  valueListenable: fromt,
                                  builder: (context, frommt, child) {
                                    return FutureBuilder(
                                      future: fetchFrom(tappIndexx, taapp),
                                      builder: (context, snapshot) {
                                        final fetchh = snapshot.data ?? 'N/A';
                                       
                                        return FutureBuilder(
                                          future: Supabase.instance.client.from('process').select(),
                                          builder: (context, snapshot) {
                                            final data = snapshot.data ?? [];
                                            final filtereddata = data.where((entry) => entry['description'] != fetchh && entry['description'] != 'Material Location'
                                            && entry['description'] != 'Current Process'
                                            );
                                            return StatefulBuilder(
                                              builder:(context, setLocallyState) => 
                                               DropdownButtonHideUnderline(
                                               child: DropdownButton(
                                                   icon: Icon(Icons.keyboard_arrow_down),
                                                             value:  fromt.value ?? fetchh,
                                                             items: [
                                                             DropdownMenuItem(
                                                               value: fetchh,
                                                               child: Row(
                                                                 children: [
                                                                   SizedBox(width: 10,),
                                                                   Text(fetchh),
                                                                 ],
                                                               )),
                                                         
                                                              ...filtereddata.map((entry) {
                                                              return  DropdownMenuItem(
                                                               value: entry['description'] ?? 'N/A',
                                                              child: Text(entry['description'] ?? 'N/A'),
                                                             );}),
                                                           
                                                             ],
                                                             onChanged: (value){
                                                               setLocalState((){
                                                       fromt.value = value!.toString();
                                                      
                                                               });
                                                             setState(() {
                                                               
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
                                );
                              }
                            );
                          }
                        ),
                        ),
                        SizedBox(height: 15,),
                         Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 50,),
                Text('To', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 15),),
              ],
            )),
                                                   SizedBox(height: 7,),
                        Container(
                         width: 400,
                            height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color:Color.fromARGB(255, 0, 74, 123)),),
                        child: ValueListenableBuilder(
                          valueListenable: toNotifier,
                          builder: (context, tots, child) {
                            return  ValueListenableBuilder(
                          valueListenable: tappedNotifier,
                          builder: (context, taapp, child) {
                            return ValueListenableBuilder(
                              valueListenable: tapIndexNotifier,
                              builder: (context, tappIndexx, child) {
                                    return FutureBuilder(
                                       future: fetchFrom(tappIndexx, taapp),
                                              builder: (context, snapshot) {
                                                final fetchh = snapshot.data ?? 'N/A';
                                               
                                        return FutureBuilder(
                                          future: fetchTo(),
                                          builder: (context, snapshot) {
                                            final fetchhedd = snapshot.data ?? 'N /A';
                                                                   
                                            return FutureBuilder(
                                              future: Supabase.instance.client.from('process').select(),
                                              builder: (context, snapshot) {
                                                final data = snapshot.data ?? [];
                                               final filtereddata = data.where((entry) => entry['description'] != fetchhedd && entry['description'] != 'Material Location'
                                                        && entry['description'] != 'Current Process'
                                                        );
                                                return StatefulBuilder(
                                                  builder:(context, setLocallyState) => 
                                                   DropdownButtonHideUnderline(
                                                   child: DropdownButton(
                                                       icon: Icon(Icons.keyboard_arrow_down),
                                                                 value:  tot.value ?? fetchhedd ?? 'N/A',
                                                                 items: [
                                                                 DropdownMenuItem(
                                                                   value: fetchhedd ?? 'N/A',
                                                                   child: Row(
                                                                     children: [
                                                                      SizedBox(width: 10,),
                                                                       Text(fetchhedd ?? 'N / A' ),
                                                                     ],
                                                                   )),
                                                                      DropdownMenuItem(
                                                               value: fetchh,
                                                               child: Row(
                                                                 children: [
                                                                   SizedBox(width: 10,),
                                                                   Text(fetchh),
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
                                                                   setState(() {
                                                                     
                                                                   });
                                                                 print('to ${tot.value}');
                                                                 
                                                              
                                                                 }
                                                   ),
                                                  ),
                                                );
                                              }
                                            );
                                          }
                                        );
                                      }
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
                    valueListenable: tappedNotifier,
                    builder: (context, tapped, child) {
                      return ValueListenableBuilder(
                        valueListenable: selectedStep1Notifier,
                        builder: (context, value, child) {
                          return GestureDetector(
                          onTap: () async {
                                               
                                               
                          setState(() {
                            fromt.value = null;
                            tot.value = null;
                                 from = 'Material Location';
                                               to = 'Current Process';
                      
                                     selectedStep1Notifier.value = 'Next Step';
                                    
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
                  
                  return ValueListenableBuilder(
                    valueListenable: tappedNotifier,
                    builder: (context, value, child) {
          return ValueListenableBuilder<int?>(
            valueListenable: tapIndexNotifier,
            builder: (context, tappedNotifiers, _) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                  if (from != 'From' && to != 'To'){
                  fromNotifier.value = from;
                  toNotifier.value = to;
                  }
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
            }
          );
                    }
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

fromTot() async {
  showDialog(context: context,
   barrierDismissible: false, 
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
                        child: ValueListenableBuilder(
                          valueListenable: tappedNotifier,
                          builder: (context, taapp, child) {
                            return ValueListenableBuilder(
                              valueListenable: tapIndexNotifier,
                              builder: (context, tappIndexx, child) {
                                return ValueListenableBuilder(
                                  valueListenable: fromNotifier,
                                  builder: (context, frommt, child) {
                                    return FutureBuilder(
                                      future: fetchFrom(tappIndexx, taapp),
                                      builder: (context, snapshot) {
                                        final fetchh = snapshot.data ?? 'N/A';
                                       fromNotifier.value = fetchh;
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
                                                             value:  fromNotifier.value,
                                                             items: [
                                                             DropdownMenuItem(
                                                               value: fetchh,
                                                               child: Row(
                                                                 children: [
                                                                   SizedBox(width: 10,),
                                                                   Text(fetchh ),
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
                                                       fromNotifier.value = value!.toString();
                                                      
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
                          valueListenable: toNotifier,
                          builder: (context, tots, child) {
                            return FutureBuilder(
                              future: fetchTo(),
                              builder: (context, snapshot) {
                                final fetchhedd = snapshot.data ?? 'N/A';
                            toNotifier.value = fetchhedd ?? 'N/A';
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
                                                     value:  toNotifier.value,
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
                                               toNotifier.value = value!.toString();
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
                    valueListenable: tappedNotifier,
                    builder: (context, tapped, child) {
                      return ValueListenableBuilder(
                        valueListenable: selectedStep1Notifier,
                        builder: (context, value, child) {
                          return GestureDetector(
                          onTap: () async {
                                               
                                               
                          setState(() {
                                 from = 'Material Location';
                                               to = 'Current Process';
                      
                                     selectedStep1Notifier.value = 'Next Step';
                                    
                         
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
                  
                  return ValueListenableBuilder(
                    valueListenable: tappedNotifier,
                    builder: (context, value, child) {
          return ValueListenableBuilder<int?>(
            valueListenable: tapIndexNotifier,
            builder: (context, tappedNotifiers, _) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                  if (from != 'From' && to != 'To'){
                  fromNotifier.value = from;
                  toNotifier.value = to;
                  }
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
            }
          );
                    }
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
bool showBlue = false;
@override
void initState() {
  super.initState();
  tapIndexNotifier.addListener(() {
 

  tapIndexNotifier.addListener(() {
    tapIndex = tapIndexNotifier.value;

    setState(() {
    });
  });
  });
}


Future<List<dynamic>> getData(int? tapIndex) async {
  Map<String, dynamic> routeResponse = {};

  if (tapIndex != null) {
    final materialResponse = await Supabase.instance.client
        .from('materials')
        .select()
        .eq('id', tapIndex)
        .maybeSingle();


    final materialName = materialResponse?['name'];

    if (materialName != null) {
      final result = await Supabase.instance.client
          .from('route')
          .select()
          .eq('material', materialName)
          .or('disabled.is.null,disabled.not.eq.true')
          .eq('step', 1)
          .maybeSingle();


      if (result != null) {
        routeResponse = result;
      }
    }
  }

  final processResponse = await Supabase.instance.client
      .from('process')
      .select();

  return [routeResponse, processResponse];
}
bool materialSelected = true;
bool processSelected = false;
bool hasRoute = true;

String? fetchfromt;
String? fetchtot; 
String? fetchfromt2;
String? fetchtot2; 


bool dwitsfalse = false;


Future<void> addMaterial(  tappIndexx, taapp, seelectedStep1, tott, frommt, tot2, frommt2, snackbarr) async{

  CustomToast.show(context,);
   Future.delayed(Duration(seconds: 3), () {
 
  canGo = true;
});

  print('nowm: $nowm, taapp: $taapp, tappIndexx: $tappIndexx, nowp: $nowp, selectedTime1: $selectedTime1, selectedTime2: $selectedTime2, selectedProcess $seelectedStep1');
  if ((nowm ? taapp == null : tappIndexx == null)||  (nowm ? selectedTime2 == 'Needed By' : (selectedTime1 == 'Needed By') || (
    nowm == false ?  
    seelectedStep1 == 'Next Step' : dwitsfalse == true ))
  // !forklift || !hasRoute ? 
  // selectedStep1 == 'Next Step' : selectedStep1  == ''
  ){
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
),
        content: SizedBox(
            width: 300,
            height: 150,
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 10),
                 Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 193, 188),
                      ),
                      child: Icon(Icons.error, color: Colors.red,)),
                  SizedBox(height: 10,),
                  Text('Please do not leave a field blank.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  SizedBox(height: 19),
                  Container(
                                  width: 120,
                                  height: 40,
                                  decoration: BoxDecoration(
                                  color: Colors.red,
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
                                            child: Text('Understood', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)))),
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
  } else {
 
           snackbarNotifier.value = true;

    
     final responses = tappIndexx != null && nowm == false ?
      await Supabase.instance.client.from('materials').select().eq('id', tappIndexx!).maybeSingle()
    : {};
  final materialname = responses?['name'];


  final response30  = nowm ? await Supabase.instance.client.from('route').select().eq('material_route', taapp).or('disabled.is.null,disabled.not.eq.true').eq('step', 1)

  
  : await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', materialname).eq('step', 1);

print('$response30 response30');

    if (response30.isNotEmpty && nowm){
print('$response30 response3012');
 final process = response30[0]['process'];
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
   final response10 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');

  final response101 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
  final response18 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
print('r101 $response101, r18 $response18, r10 $response10, $company, $username');
     final insertedMaster =    await Supabase.instance.client
    .from('masterdata')
    .insert({
      'requestitem': nowm ? taapp : materialname,
      'needtime': nowm ? selectedTime2 : selectedTime1,
      'starttime': DateTime.now().toUtc().toIso8601String(),
      'machine': response101.length > 1 ? response18!['machine'] ?? 'N/A' :  response10[0]['processpu'] ?? 'N/A',
      'currentprocess': process,
      'usernamem': username,
      'company': company,
       'created_at': DateTime.now().toUtc().toIso8601String(),
      
    
    }).select()
    .maybeSingle();

    
print('insertedmas $insertedMaster');

final masterId = insertedMaster?['id']; 
print('$masterId masterid');
      for (final response1 in response30){
        print('$masterId masterid');
           final mat = response1['material'];
      fromr = response1['from_route'];
      tor = response1['to_route'];
      final response2  = nowm ? await Supabase.instance.client.from('route').select().eq('material_route', taapp).or('disabled.is.null,disabled.not.eq.true').eq('step', 2)
      : await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', materialname).eq('step', 2);
      if (response2.isNotEmpty){
     nextProcess = response2[0]['process'];
      }
    final process = response1['process'];
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
   final response10 = await Supabase.instance.client.from('process_users').select().eq('processpu', process).or('disabled.is.null,disabled.not.eq.true');

  final response101 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
  final response18 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
if ( response1['to_route']  == 'Material Location'){
       final responseso = await Supabase.instance.client.from('materials').select().eq('name', mat).maybeSingle();
    
  final location = responseso?['location'];
  
fetchtot2 = location ?? 'N/A';
 
} else if ( response1['to_route']  == 'Current Process'){
  
    if (response101.length > 1){
    fetchtot2 =  response18?['machine'] ?? 'N/A'; 
  } else {
fetchtot2 = response10[0]['processpu'] ?? 'N/A';
}
} else {
  fetchtot2 = response1['to_route'];
}

 print('r1ny ${response1['from_route']} ');
if ( response1['from_route']  == 'Material Location'){
       final responseso = await Supabase.instance.client.from('materials').select().eq('name', mat).maybeSingle();
    print('rey3 $responseso');
        print('re43 $mat');
  final location = responseso?['location'];
  print('re6ty $location');
fetchfromt2 = location ?? 'N/A';
 
} else if ( response1['from_route'] == 'Current Process'){
  
    if (response101.length > 1){
    fetchfromt2 =  response18?['machine'] ?? 'N/A'; 
  } else {
fetchfromt2 = response10[0]['processpu'] ?? 'N/A';
}
} else {
  fetchfromt2 = response1['from_route'];
}


await Supabase.instance.client.from('detail').insert({
  'route_name': response1['material_route'],
  'originalneed': nowm ? mat : materialname,
  'starttime': DateTime.now().toUtc().toIso8601String(),
  'process': process,
    'steps': 1,
  'usernamed': username,

if (response1.length > 1)
'nextprocess': nextProcess,
  'idreq': masterId,
  'company': company,
    'created_at': DateTime.now().toUtc().toIso8601String(),

    'detail_from': fetchfromt2 ?? 'N/A',

    'detail_to': fetchtot2 ?? 'N/A',
    'neededby': nowm ? selectedTime2 : selectedTime1,
});

setState(() {});
  } }else {
    
    final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
 
   final response10 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');

final response18 = await Supabase.instance.client.from('user_machine').select().eq('user_mac', username).maybeSingle();
  final response101 = await Supabase.instance.client.from('process_users').select().eq('userpu', username).or('disabled.is.null,disabled.not.eq.true');
    final insertedMaster = await Supabase.instance.client
    .from('masterdata')
    .insert({
      'requestitem': materialname,
      'needtime': selectedTime1,
      'starttime':  DateTime.now().toUtc().toIso8601String(),
      'currentprocess': forklift ? 'Forklift' : seelectedStep1,
            'machine': response101.length > 1 ? response18!['machine'] ?? 'N/A' :  response10[0]['processpu'] ?? 'N/A',
      'usernamem': username,
      'company': company,
        'created_at':  DateTime.now().toUtc().toIso8601String(),
     
    })
    .select()
    .maybeSingle(); 

if (insertedMaster == null || !insertedMaster.containsKey('id')) {

  return;
}
    


  final responses = await Supabase.instance.client
      .from('materials')
      .select()
      .eq('id', tappIndexx!)
      .maybeSingle();

  final location = responses?['location'];
  fromNotifier.value = location ?? 'N/A';


final masterId = insertedMaster['id']; 


await Supabase.instance.client.from('detail').insert({
  'originalneed': materialname,
  'starttime':  DateTime.now().toUtc().toIso8601String(),
  'process': forklift ? 'Forklift' : seelectedStep1,
  'nextprocess': seelectedStep1 == 'Next Step' ? null : forklift ? seelectedStep1 : null,
  'usernamed': username,
  'idreq': masterId,
  'company': company,
  'neededby': selectedTime1,
  'created_at':  DateTime.now().toUtc().toIso8601String(),
    'detail_from': fromt.value ?? 'N/A',
    'detail_to': tot.value ?? 'N/A',
   
});
  }
  }
}




Timer? _debounce;
@override
void dispose() {
  _debounce?.cancel();
  searchMController.dispose();
  super.dispose();
}
void popUp(){
 showDialog(

    context: context, 
    
    builder: (_) => StatefulBuilder(

      builder: (context, setLocalState) {
        
    void onSearchChanged(){
  if (_debounce?.isActive ?? false) _debounce?.cancel();
_debounce = Timer(const Duration(milliseconds: 400), (){
  setLocalState(() {
    
  });
});
}
           searchMController.addListener((){
  onSearchChanged();
});

 
           searchMController.addListener((){
  onSearchChanged();
});

      return ValueListenableBuilder(
        valueListenable: snackbarNotifier,
        builder: (context, value, child) {
          return AlertDialog(
            
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0),
          content: 
            Container(
              height: 1000,
              width: 1520,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(16),
              ),child:  Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  Row(children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                            
                                                                setLocalState(() {
                                                                   nowm = true;
                                                                nowp = false;
                                                                },);
                                                               
                                      },
                                      child: Column( 
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text( 'Route', style: TextStyle(color: nowm ? Color.fromARGB(255, 0, 74, 123) : 
                                                          const Color.fromARGB(255, 210, 210, 210), fontWeight: FontWeight.bold, 
                                                          fontSize: 20, fontFamily: 'Inter' )),
                                                         
                                                        ],
                                                      ),
                                    ),
                                  ),
                    SizedBox(width: 20),
                    ValueListenableBuilder(
                      valueListenable: snackbarNotifier,
                      builder: (context, snackbarr, child) {
                        return Column( 
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                 setLocalState(() {
                              
                                   
                                       setState(() {
                                                   nowp = true;
                                    nowm = false;                    
                                                                    },);
                                   
                                 },);
                                },
                                child: Text( 'Material', style: TextStyle(color:nowp ? Color.fromARGB(255, 0, 74, 123) : 
                                                              const Color.fromARGB(255, 210, 210, 210), fontWeight: FontWeight.bold, 
                                fontSize: 20, fontFamily: 'Inter' )),
                              ),
                            ),
                           
                          ],
                        );
                      }
                    ),
                 
                    Spacer(),
                  //  snackbarNotifier.value  ?
                  //   Text('Added sucessfully.', style: TextStyle(fontFamily: 'Inter', color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16))
                
                  //   : SizedBox.shrink(),
                  //  snackbarNotifier.value ?     SizedBox(width: 20,) : SizedBox.shrink(),
                          MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ValueListenableBuilder(
                      valueListenable: tappedNotifier,
                      builder: (context, tapped, child) {
                        return GestureDetector(
                        onTap: () async {
                        setLocalState(()  {
                          tappedNotifier.value = null;
                               selectedValues.clear();
                                    selectedValues = ['Select a process']; 
                              Navigator.pop(context);
                            },);
                          
                            setLocalState(() {
                               
                                   
                            },);
                          
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width > 600 ? 100 : 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 0.5),
                          ),
                          child: Center(child: MediaQuery.of(context).size.width > 600 ? Text('Cancel', style: TextStyle(fontFamily: 'Inter'),) : Icon(Icons.close)),
                          ),
                        );
                      }
                    )
                    ),
                    SizedBox(width: 10,),
                     FutureBuilder(
            future: Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true'),
            builder: (context, snapshot) {
          
              return ValueListenableBuilder(
          valueListenable: tappedNotifier,
          builder: (context, taapp, child) {
            return ValueListenableBuilder<int?>(
              valueListenable: tapIndexNotifier,
              builder: (context, tappIndexx, _) {
                return ValueListenableBuilder(
                  valueListenable: tot,
                  builder: (context, tott, child) {
                    return ValueListenableBuilder(
                      valueListenable: fromt,
                      builder: (context, frommt, child) {
                        return ValueListenableBuilder(
                          
                          valueListenable: selectedStep1Notifier,
                          builder: (context, value, child) {
                            return ValueListenableBuilder(
                              valueListenable: fromt2,
                              builder: (context, value, child) {
                                return ValueListenableBuilder(
                                  valueListenable: tot2,
                                  builder: (context, value, child) {
                                    return ValueListenableBuilder(
                                      valueListenable: snackbarNotifier,
                                      builder: (context, value, child) {
                                        return MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () async {
                                             final seelectedStep1 = selectedStep1Notifier.value;
                                             if (canGo == true){
                                                selectedStep1Notifier.value = 'Next Step';
                                              print('current entr $tappIndexx, tapindex, taap $taapp, ');
                                              addMaterial(tappIndexx, taapp, seelectedStep1, tot.value, fromt.value, fromt2.value, tot2.value, snackbarNotifier.value);
                                             canGo = false;
                                             } 
         
       
          setState(() {
            
          });
                                            },
                                            child: Container(
                                              width:  MediaQuery.of(context).size.width > 600 ? 100 : 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(255, 142, 204, 251),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child:  MediaQuery.of(context).size.width > 600 ? Text(
                                                  'Add',
                                                  style: TextStyle(fontFamily: 'Inter'),
                                                ) : Icon(Icons.add),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  }
                                );
                              }
                            );
                          }
                        );
                      }
                    );
                  }
                );
              }
            );
          }
              );
            },
          ),
          SizedBox(width: 30),
                    ValueListenableBuilder(
                      valueListenable: tappedNotifier,
                      builder: (context, tapped, child) {
                        return IconButton(
                          onPressed: () async {
                            tappedNotifier.value = null;
                           setLocalState(()  {
                               selectedValues.clear();
                              Navigator.pop(context);
                            },);
                          
                            setLocalState(() {
                               
                                   
                            },);
                           
                          }, 
                          icon: Icon(Icons.close),
                          );
                      }
                    )
                  ],),  
          SizedBox(height: 10,),
          Divider(thickness: 1,),
          SizedBox(height: 10,),
          nowm ? 
           Column(
          children: [
            SizedBox(width: 10),
             Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                SizedBox(width:20),
                 Align(
                  alignment: Alignment.topLeft,
                   child: Container(
                                  width:  MediaQuery.of(context).size.width > 550 ? 270 : 150,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                  controller: searchRController,
                                  
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    label:  Text(  MediaQuery.of(context).size.width > 600 ? 'Search a route...' : 'Search', style: TextStyle(fontFamily: 'Inter'),),
                                    floatingLabelStyle: TextStyle(color:  Color(0xFFFAFAFA),),
                                    enabledBorder: InputBorder.none,
                                      isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  prefixIcon: Icon(Icons.search, color:const Color.fromARGB(255, 23, 85, 161), size: 26 )
                                  ),
                                  ),
                                 ),
                 ),
                 Spacer(),
                  Container(
                            width: 150,
                              height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: 1, color: Colors.grey),),
                          child: FutureBuilder(
                            future: Supabase.instance.client.from('needtime').select(),
                            builder: (context, snapshot) {
                              final data = snapshot.data ?? [];
                              return StatefulBuilder(
                                builder:(context, setLocallyState) => 
                                 DropdownButtonHideUnderline(
                                 child: DropdownButton(
                                     icon: Icon(Icons.keyboard_arrow_down),
                                               value:  selectedTime2,
                                               items: [
                                               DropdownMenuItem(
                                                 value: 'Needed By',
                                                 child: Row(
                                                   children: [
                                                     SizedBox(width: 10,),
                                                     Text('Needed By', style: TextStyle(color: Colors.grey) ),
                                                   ],
                                                 )),
                                                ...data.map((entry) {
                                                return  DropdownMenuItem(
                                                 value: entry['time'],
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10,),
                                                    Text(entry['time']),
                                                  ],
                                                ),
                                               );}),
                                               ],
                                               onChanged: (value){
                                                 setLocallyState((){
                                         selectedTime2 = value!.toString();
                                                 });
                                               
                                               
          
                                               }
                                 ),
                                ),
                              );
                            }
                          ),
                          ),
                             SizedBox(width: MediaQuery.of(context).size.width > 650 ? 20 : 0), 
          
               ]),
                                 
            SizedBox(
            height: MediaQuery.of(context).size.height < 400 ? MediaQuery.of(context).size.height * 0.4 : MediaQuery.of(context).size.height < 350 ? MediaQuery.of(context).size.height * 0.1 : MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.85,
                  
              child: Column(children: [
               SizedBox(height: 10),
                        Row(
              children: [
                SizedBox(width: 30),
            
              ],
                        ),
                      Expanded(
                        child: FutureBuilder(
                                   future: Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').order('material', ascending: true),
                                    builder: (context, snapshot) {
                                      final data = snapshot.data ?? [];
                                      
                                    void onSearchChanged1(){
            if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 400), (){
            setLocalState(() {
              
            });
          });
          }
          searchRController.addListener(onSearchChanged1);
                                      // Group by material
                                      Map<String, List<Map<String, dynamic>>> groupedData = {};
                        
                                      for (final entry in data) {
                                        final material = entry['material'] as String? ?? 'Unknown';
                                
                                        if (!groupedData.containsKey(material)) {
                        groupedData[material] = [];
                                        }
                                        groupedData[material]!.add(Map<String, dynamic>.from(entry));
                                      }
                                   final uniqueMaterials = data
                                  
                                      .where((e)=> searchRController.text.isNotEmpty 
                                      ?   (e['material_route']?.toString().toLowerCase() ?? '')
          .contains(searchRController.text.toLowerCase())
                                      : true)
                            .map((e) => e['material_route'] as String)
                         
                            .toSet()
                            .toList();
                                      return ListView.builder(
                                                        itemCount: uniqueMaterials.length,
                                                        itemBuilder: (context, index) {
                                                        
                                                        final entry = uniqueMaterials[index];
                                                        
                                                        final routesForMaterial = data
                                                            .where((e) => e['material_route'] == entry)
                                                            .toList();
                                                        
                                                        // Sort them by step
                                                        routesForMaterial.sort((a, b) =>
                                                          (a['step'] as int).compareTo(b['step'] as int));
                                                                 
                                                                     final isDuplicates = routesForMaterial.where((entrye) => entrye['step'] == 1).toList();
                                                          return SizedBox(
                                                            child: ValueListenableBuilder(
                                                              valueListenable: tappedNotifier,
                                                              builder: (context, value, child) {
                                                                return MouseRegion(
                                                                  cursor: SystemMouseCursors.click,
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                  tappedNotifier.value = entry;
                                                                  print('here tap $tapIndexNotifier');
                                                                    },
                                                                    child: Padding(
                                                                            padding: EdgeInsets.all(10),
                                                                            child: Material(
                                                                              elevation: 3,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.white,
                                                                              child: Container(
                                                                                decoration: BoxDecoration(
                                                                                                      color: tappedNotifier.value == entry 
                                                                                                    ? const Color.fromARGB(255, 207, 232, 253)
                                                                                                    :  Colors.white,
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                padding: EdgeInsets.all(20),
                                                                                child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                                        // Material header row
                                                                                                                        Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        
                                                                       width: MediaQuery.of(context).size.width * 0.85 - 90,
                                                                        child: Text( entry,   overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Inter', fontSize: 30))),
                                                                     
                                                                        
                                                                      
                                                                                                                        ] 
                                                                                                                        ),
                                                                            
                                                                                                                        SizedBox(height: 20),
                                                                                                                         
                                                                                                                        SizedBox(
                                                                                                                         width: 1300,
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(
                                                                        children: routesForMaterial.map((routeEntry) {
                                                                         
                                                                                                      bool isStepOne = routeEntry['step'] == 1;
                                                                            int occurrenceIndex = isStepOne ? isDuplicates.indexWhere((e) => e == routeEntry) : -1;
                                                                                                    
                                                                                                      bool showArrow = !isStepOne || (isStepOne && occurrenceIndex > 0);
                                                                          return Row(
                                                                            children: [
                                                                              SizedBox(width: 10),
                                                                             showArrow == false ? SizedBox.shrink() : Icon(Icons.arrow_forward),
                                                                              routeEntry['material']  != data[routeEntry['step'] - 1]['material'] ?
                                                                              Container(
                                                                                height: 40,
                                                                                width: 200,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color.fromARGB(255, 0, 98, 178),
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child:  Center(
                                                                                child:  Text(  overflow: TextOverflow.ellipsis,
                                                                                                                  routeEntry['material'] ?? 'N/A',
                                                                                                                      style: TextStyle(fontFamily: 'Inter', fontSize: fontSizeBasedOnLength(  '${routeEntry['material']}'), color: Colors.white),
                                                                                                                    ),
                                                                                
                                                                              ),
                                                                              ) : SizedBox.shrink(),
                                                                                                          Icon(Icons.arrow_forward),
                                                                              SizedBox(width: 5),
                                                                              Container(
                                                                                width: 150, 
                                                                                height: 40,
                                                                                decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                                      color: Color(0xFFEDEDED),
                                                                                ),
                                                                                child: Center(
                                                                                                      child:  Text(
                                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                                routeEntry['process'],
                                                                                                                style: TextStyle(fontFamily: 'Inter', fontSize: fontSizeBasedOnLength('${routeEntry['process']}')),
                                                                                                              ),
                                                                                                      
                                                                                ),
                                                                              ),
                                                                             
                                                                            ],
                                                                          );
                                                                        }).toList(),
                                                                      ),
                                                                    ),
                                                                                                                        ),
                                                                                                      ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            ),
                                                          );
                                                        },
                                      );
                                    },
                                   ),
                      ) ],
                    ),
              )
          ])
          :
                 
                   Column(
                     children: [
                       SizedBox(height: MediaQuery.of(context).size.width > 1000 ? 25 : 5,),
                 MediaQuery.of(context).size.width > 1000 ?      Row (
                         children: [
                          SizedBox(width: 30,),
                           Text('Material', style: TextStyle(fontFamily: 'WorkSans', 
                                        fontWeight: FontWeight.bold,
                                        color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),),
                                        SizedBox(width: 30,),
                                                     Container(
                            width:                                                   300,
                            height: 35,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                            controller: searchMController,
                            
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              label: Text('Search a material, SKU, or type...'),
                              floatingLabelStyle: TextStyle(color:  Color(0xFFFAFAFA),),
                              enabledBorder: InputBorder.none,
                                isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color:const Color.fromARGB(255, 23, 85, 161), size: 26 )
                            ),
                            ),
                           ),
                                      Spacer()
                                        ,
                                   //      Tooltip(
            //                    
            // StatefulBuilder(
          // builder: (context, setLocallyState) {
          //  return Tooltip(
          //     message: 'Needs forklift?',
          //     textStyle: TextStyle(fontFamily: 'Inter'),
          //     decoration: BoxDecoration(
          //       color: Colors.transparent,
          //     ),
          //     child: IconButton(
          //       onPressed: (){
          //         if (selected != true){
          //       forklift = true;
          //       fromTot();
          //    selected = true;
          //    setLocallyState(() {
               
          //    },);
          //       } else {
          //       forklift = false;
          //       selected = false;
          //       setLocallyState
          //       (() {
                  
          //       },);
          //       }
          //       },
          //        icon: Icon(Icons.forklift, color: selected ? Colors.blue : Colors.black)),
          //   );
          // }
          //     ),
            
                          SizedBox(width: 10,),
                          Container(
                          width: 200,
                              height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(width: 1, color: Colors.grey),),
                          child: FutureBuilder(
                            future: Supabase.instance.client.from('needtime').select(),
                            builder: (context, snapshot) {
                              final data = snapshot.data ?? [];
                              return StatefulBuilder(
                                builder:(context, setLocallyState) => 
                                 DropdownButtonHideUnderline(
                                 child: DropdownButton(
                                     icon: Icon(Icons.keyboard_arrow_down),
                                               value:  selectedTime1,
                                               items: [
                                               DropdownMenuItem(
                                                 value: 'Needed By',
                                                 child: Row(
                                                   children: [
                                                      SizedBox(width: 10,),
                                                     Text('Needed By', style: TextStyle(color: Colors.grey) ),
                                                   ],
                                                 )),
                                                ...data.map((entry) {
                                                return  DropdownMenuItem(
                                                 value: entry['time'],
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10,),
                                                    Text(entry['time']),
                                                  ],
                                                ),
                                               );}),
                                               ],
                                               onChanged: (value){
                                                 setLocallyState((){
                                        
                                                 });
                                                 
                                                selectedTime1 = value!.toString();
                                                
                                              
                                                 
                                               }
                                 ),
                                ),
                              );
                            }
                          ),
                          ),
                             SizedBox(width: 20), 
                          Container(
                            width: MediaQuery.of(context).size.width < 1500 ? 200 : 250,
                           height: 35,
                                                  decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           border: Border.all(width: 1, color: Colors.grey),
                                                  ),
                                                child: StatefulBuilder(
                                                  builder: (context, setLocallyState) => 
                                                   ValueListenableBuilder<int?>(
                                                    valueListenable: tapIndexNotifier,
                                                    builder: (context, tapIndex, _) {
                                                      return FutureBuilder(
                                                       future: Supabase.instance.client.from('process').select(),
                                                            
                                                        builder: (context, snapshot)  {
                                                     
                                                      if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    }
                                                    
                                                                final processList = snapshot.data ?? [];

                                                      // final listOfMaps = processList
                                                      // .whereType<Map<String, dynamic>>()
                                                      // .cast<Map<String, dynamic>>()
                                                      // .toList();
                                                              
                                                                 
                                                  
                                                               
                                                  
                                                                                   
                                                          
                                                          
                                                                                               return 
                                                                                                                
                                                                    ValueListenableBuilder(
                                                                      valueListenable: selectedStep1Notifier,
                                                                      builder: (context, value, child) {
                                                                        return DropdownButtonHideUnderline(
                                                                                            child: DropdownButton(
                                                                               icon: Icon(Icons.keyboard_arrow_down),
                                                                               value: value,
                                                                               items: [
                                                                               DropdownMenuItem(
                                                                                 value: 'Next Step',
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(width: 10,),
                                                                                    Text('Next Step', style: TextStyle(color: Colors.grey, fontFamily: 'Inter')),
                                                                                  ],
                                                                                ),
                                                                               ),
                                                                                 ... processList.map((entry){
                                                                               return DropdownMenuItem(
                                                                                 value: entry['description'] ?? 'N/A',
                                                                                child: Row(
                                                                                  children: [
                                                                                    SizedBox(width: 10,),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width < 1500 ? 10 : 200,
                                                                                      child: Text(entry['description'] ?? 'N/A', 
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                       style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontFamily: 'Inter', fontWeight: FontWeight.bold,
                                                                                                                                                 fontSize: 16.5,
                                                                                                                                                  )),
                                                                                    ),
                                                                                  ],
                                                                                ));
                                                                                                                                      } )
                                                                               ],
                                                                               onChanged: (value){
                                                                                 setLocallyState((){
                                                                                      selectedStep1Notifier.value = value.toString();
                                                                                      if (selectedStep1Notifier.value == 'Forklift'){
                                                                                        fromTo();
                                                                                      }
                                                                                 });
                                                                                
                                                                               }
                                                                             ),
                                                                                           );
                                                                      }
                                                                    ); 
                                                                                     
                                                                       }
                                                                     );
                                                    }
                                                  ),
                                                ),
                          ),                           
                     
                               
                         ],) :  Row (
                         children: [
                          SizedBox(width: 30,),
                           Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children:
                              [
                               Align(
                                alignment: Alignment.topLeft,
                                 child: Text('Material', style: TextStyle(fontFamily: 'WorkSans', 
                                              fontWeight: FontWeight.bold,
                                              color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),),
                               ),
                           
                                        SizedBox(height: 16),
                                       
                                                     Container(
                                                                                 width: MediaQuery.of(context).size.width * 0.25,
                                                                                 height: 35,
                                                                                 decoration: BoxDecoration(
                                                                                   border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10),
                                                                                 ),
                                                                                 child: TextField(
                                                                                 controller: searchMController,
                                                                                 
                                                                                 cursorColor: Colors.black,
                                                                                 decoration: InputDecoration(
                                                                                   label: Text('Search'),
                                                                                   floatingLabelStyle: TextStyle(color:  Color(0xFFFAFAFA),),
                                                                                   enabledBorder: InputBorder.none,
                                                                                     isDense: true,
                                                                               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                                                 focusedBorder: InputBorder.none,
                                                                                 disabledBorder: InputBorder.none,
                                                                                 prefixIcon: Icon(Icons.search, color:const Color.fromARGB(255, 23, 85, 161), size: 26 )
                                                                                 ),
                                                                                 ),
                                                                                ),
                                                                                                           
                                                                                           
                                                                                             
                                                                                        //      Tooltip(
                                                                 //                    
                                                                 // StatefulBuilder(
                                                               // builder: (context, setLocallyState) {
                                                               //  return Tooltip(
                                                               //     message: 'Needs forklift?',
                                                               //     textStyle: TextStyle(fontFamily: 'Inter'),
                                                               //     decoration: BoxDecoration(
                                                               //       color: Colors.transparent,
                                                               //     ),
                                                               //     child: IconButton(
                                                               //       onPressed: (){
                                                               //         if (selected != true){
                                                               //       forklift = true;
                                                               //       fromTot();
                                                               //    selected = true;
                                                               //    setLocallyState(() {
                                                                    
                                                               //    },);
                                                               //       } else {
                                                               //       forklift = false;
                                                               //       selected = false;
                                                               //       setLocallyState
                                                               //       (() {
                                                                       
                                                               //       },);
                                                               //       }
                                                               //       },
                                                               //        icon: Icon(Icons.forklift, color: selected ? Colors.blue : Colors.black)),
                                                               //   );
                                                               // }
                                                               //     ),
                                                                   ],
                           ),
                                                                               Spacer(),
                                                                               Column(
                                                                                 children: [
                                                                                   Container(
                                                                                   width: MediaQuery.of(context).size.width * 0.35,
                                                                                       height: 35,
                                                                                     decoration: BoxDecoration(
                                                                                       borderRadius: BorderRadius.circular(7),
                                                                                       border: Border.all(width: 1, color: Colors.grey),),
                                                                                   child: FutureBuilder(
                                                                                     future: Supabase.instance.client.from('needtime').select(),
                                                                                     builder: (context, snapshot) {
                                                                                       final data = snapshot.data ?? [];
                                                                                       return StatefulBuilder(
                                                                                         builder:(context, setLocallyState) => 
                                                                                          DropdownButtonHideUnderline(
                                                                                          child: DropdownButton(
                                                                                              icon: Icon(Icons.keyboard_arrow_down),
                                                                                                        value:  selectedTime1,
                                                                                                        items: [
                                                                                                        DropdownMenuItem(
                                                                                                          value: 'Needed By',
                                                                                                          child: Row(
                                                                                                            children: [
                                                                                                               SizedBox(width: 10,),
                                                                                                              Text('Needed By', style: TextStyle(color: Colors.grey) ),
                                                                                                            ],
                                                                                                          )),
                                                                                                         ...data.map((entry) {
                                                                                                         return  DropdownMenuItem(
                                                                                                          value: entry['time'],
                                                                                                         child: Row(
                                                                                                           children: [
                                                                                                             SizedBox(width: 10,),
                                                                                                             Text(entry['time']),
                                                                                                           ],
                                                                                                         ),
                                                                                                        );}),
                                                                                                        ],
                                                                                                        onChanged: (value){
                                                                                                          setLocallyState((){
                                                                                                 
                                                                                                          });
                                                                                                          
                                                                                                         selectedTime1 = value!.toString();
                                                                                                         
                                                                                                       
                                                                                                          
                                                                                                        }
                                                                                          ),
                                                                                         ),
                                                                                       );
                                                                                     }
                                                                                   ),
                                                                                   ),
                                                                              
                                                                                  SizedBox(height: 10), 
                                                                               Container(
                                                                                 width: MediaQuery.of(context).size.width * 0.35,
                                                                                height: 35,
                                                                                                       decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 1, color: Colors.grey),
                                                                                                       ),
                                                                                                     child: StatefulBuilder(
                                                                                                       builder: (context, setLocallyState) => 
                                                                                                        ValueListenableBuilder<int?>(
                                                                                                         valueListenable: tapIndexNotifier,
                                                                                                         builder: (context, tapIndex, _) {
                                                                                                           return FutureBuilder(
                                                                                                            future: Supabase.instance.client.from('process').select(),
                                                        
                                                                                                             builder: (context, snapshot)  {
                                                                                                          
                                                                                                           if (snapshot.hasError) {
                                                                                                           return Text('Error: ${snapshot.error}');
                                                                                                         }
                                                                                                         
                                                            final processList = snapshot.data ?? [];
                                                     
                                                                                                           // final listOfMaps = processList
                                                                                                           // .whereType<Map<String, dynamic>>()
                                                                                                           // .cast<Map<String, dynamic>>()
                                                                                                           // .toList();
                                                          
                                                             
                                                                                                       
                                                           
                                                                                                       
                                                                               
                                                      
                                                      
                                                                                           return 
                                                                                                            
                                                                ValueListenableBuilder(
                                                                  valueListenable: selectedStep1Notifier,
                                                                  builder: (context, value, child) {
                                                                    return DropdownButtonHideUnderline(
                                                                                        child: DropdownButton(
                                                                           icon: Icon(Icons.keyboard_arrow_down),
                                                                           value: value,
                                                                           items: [
                                                                           DropdownMenuItem(
                                                                             value: 'Next Step',
                                                                            child: Row(
                                                                              children: [
                                                                                SizedBox(width: 10,),
                                                                                Text('Next Step', style: TextStyle(color: Colors.grey, fontFamily: 'Inter')),
                                                                              ],
                                                                            ),
                                                                           ),
                                                                             ... processList.map((entry){
                                                                           return DropdownMenuItem(
                                                                             value: entry['description'] ?? 'N/A',
                                                                            child: Row(
                                                                              children: [
                                                                                SizedBox(width: 10,),
                                                                                Flexible(
                                                                                  child: Text(entry['description'] ?? 'N/A', overflow: TextOverflow.ellipsis, style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontFamily: 'Inter', fontWeight: FontWeight.bold,
                                                                                                                                             fontSize: 16.5,
                                                                                                                                              )),
                                                                                ),
                                                                              ],
                                                                            ));
                                                                                                                                  } )
                                                                           ],
                                                                           onChanged: (value){
                                                                             setLocallyState((){
                                                                                  selectedStep1Notifier.value = value.toString();
                                                                                  if (selectedStep1Notifier.value == 'Forklift'){
                                                                                    fromTo();
                                                                                  }
                                                                             });
                                                                            
                                                                           }
                                                                         ),
                                                                                       );
                                                                  }
                                                                ); 
                                                                                 
                                                                   }
                                                                 );
                                                                                                         }
                                                                                                       ),
                                                                                                     ),
                                                                               ),
                                                                                  ],
                                                                               ),
                                                                               SizedBox(width: 10,)
                               
                         ],),
                     
                                  
                        
                       
                    
             SizedBox(height: 20,),
                    Row(
                      children: [
            Expanded (
             child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
               child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                 child: Row(
                         children: [
                  SizedBox(width: 10),
                  Container(
                    child: Column(children: [
                   
                  
                    
                          SizedBox(
                         width: MediaQuery.of(context).size.width * 0.9, 
                                                     height: MediaQuery.of(context).size.height < 550 ?   MediaQuery.of(context).size.height * 0.5:  MediaQuery.of(context).size.height * 0.6,

                         child: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: SizedBox(
                        width: MediaQuery.of(context).size.width * 2, 
                           height: MediaQuery.of(context).size.height < 600 ?   MediaQuery.of(context).size.height * 0.4 :  MediaQuery.of(context).size.height * 0.6,
                         child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(255, 186, 224, 254),
                            const Color.fromARGB(255, 234, 245, 255)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          SizedBox(
                              width: 70,
                              child: Text('',)),
                                 SizedBox(width: 20),
                          SizedBox(
                              width: 350,
                              child: Text('Name',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 20),
                           SizedBox(
                                                    width: 200,
                                                    child: Text('SKU',
                                                        style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16))),
                                                            SizedBox(width: 20),
                                                              SizedBox(
                                                    width: 200,
                                                    child: Text('Type',
                                                        style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16))),
                                                            SizedBox(width: 20),
                          SizedBox(
                              width: 350,
                              child: Text('Description',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                                      SizedBox(width: 20),
                                      SizedBox(
                                                    width: 250,
                                                    child: Text('Dimensions',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Inter'))),
                                                            SizedBox(width: 20),
                                      SizedBox(
                                                    width: 250,
                                                    child: Text('Vendor',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Inter'))),
                          SizedBox(width: 20),
                          SizedBox(
                              width: 250,
                              child: Text('Location',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 20),
                          SizedBox(
                              width: 250,
                              child: Text('Batch',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 20),
                          SizedBox(
                              width: 150,
                              child: Text('EXP Date',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 20),
                          SizedBox(
                              width: 150,
                              child: Text('DOB',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                       
                    // Expanded with ListView stays exactly the same
                    Expanded(
                      
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: Supabase.instance.client
                            .from('materials').select().order('name', ascending: true),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final data = snapshot.data ?? [];
                          if (data.isEmpty) {
                            return Center(
                                child: Column(
                              children: [
                                SizedBox(height: 70),
                                Stack(
                                  children: [
                                    Image(
                                      image: AssetImage('images/search.png'),
                                      width: 400,
                                      height: 400,
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                        left: 100,
                                        top: 300,
                                        child: Text(
                                          'Nothing here yet...',
                                          style: TextStyle(
                                              color: const Color.fromARGB(255, 0, 55, 100),
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              ],
                            ));
                          }
          
                 
                   
                 
                       
                          final filteredData = data.where((entries) {
                            
                            final searchMControllerr = searchMController.text.toLowerCase();
                            final names = entries['name'].toString().toLowerCase();
                           final sku = entries['sku'].toString().toLowerCase();
                                final type = entries['type'].toString().toLowerCase();
                            if (searchMController.text.isNotEmpty) {
                              if (names.contains(searchMControllerr) || sku.contains(searchMControllerr) || (type.contains(searchMControllerr)) ) {
                                return true;
                              } else {
                                return false;
                              }
                            } else {
                              return true;
                            }
                          }).toList();
                       
                          return ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              return StatefulBuilder(
                                
                                
                                builder: (context, setLocalState) {
                              
                                      final entry = filteredData[index];
            
          tapIndexMap.putIfAbsent(entry['id'], () => false);
                                          
                 
                                  return ValueListenableBuilder(
                                    valueListenable: tapIndexNotifier,
                                    builder: (context, tapIndex, _) {
                                      return Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: const Color.fromARGB(255, 176, 176, 176)),
                                          ),
                                          color: tapIndex == entry['id'] ? const Color.fromARGB(255, 234, 245, 255) : hoverIndex == entry['id']
                                              ? const Color.fromARGB(255, 239, 239, 239)
                                              : 
                                                   Colors.white),
                                      child: SizedBox(
                                        height: 61,
                                        child: MouseRegion(
                                            onHover: (event) {
                                          setLocalState(() {
                                            hoverIndex = entry['id'];
                                          });
                                        },
                                        onExit: (event) {
                                          setLocalState(() {
                                            hoverIndex = null;
                                          });
                                        },
                                          child: Column(
                                            children: [
                                              SizedBox(height: 5),
                                              GestureDetector(
                                                
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 20),
                                                     SizedBox(
                                                                    width: 70,
                                                                    child: ValueListenableBuilder<int?>(
                                                                                        valueListenable: tapIndexNotifier,
                                                                                        builder: (context, selectedId, _) {
                                                final isChecked = selectedId == entry['id'];
                                                return Checkbox(
                                                  activeColor: const Color.fromARGB(255, 0, 75, 137),
                                                  value: isChecked,
                                                  onChanged: (bool? checked) async {
                                                    if (checked == true) {
                                                  
                                                      tapIndexNotifier.value = entry['id'];
                                                      tapIndex = entry['id'];
                                                         final response9 = await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', tapIndex!);
                                                         if (response9.isNotEmpty){
                                                           hasRouterNotifier.value = true;
                                                          print('rout $hasRouter');
                                                         }
                                                         setLocalState((){});
                                                    } else {
                                                      setLocalState(() {
                                                        
                                                      },);
                                                      tapIndexNotifier.value = null;
                                                       hasRouterNotifier.value = false;
                                                      tapIndex = null;
                                                    }
                                                  },
                                                );
                                                                                        },
                                                                                      ),
                                                               
                                                                                        ),
                                                 SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 350,
                                                        child: Text(entry['name'],
                                                            style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 200,
                                                        child: Text(entry['sku'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16))),
                                                                  SizedBox(width: 20),
                                                                SizedBox(
                                                        width: 200,
                                                        child: Text(entry['type'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 350,
                                                        child: Text(entry['description'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontFamily: 'Inter',
                                                                fontSize: 16))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 250,
                                                        child: Text(entry['dimensions'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                                SizedBox(width: 20),
                                                                  SizedBox(
                                                        width: 250,
                                                        child: Text(entry['vendor'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 250,
                                                        child: Text(entry['location'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 250,
                                                        child: Text(entry['batch'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 150,
                                                        child: Text(entry['expdate'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 150,
                                                        child: Text(entry['dob'] ?? 'N/A',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: 'Inter'))),
                                                    SizedBox(width: 1, child: Column(children: [SizedBox(height: 45)])),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                                                  );
                                    }
                                  );
                                },
                              );
                            },
                          );
                        },
                        
                      ),
                    ),
                  ],
                         ),
                       ),
                         ),
                          )
                    ]),
                       )
                         ],
                       ),
               ),
             ),
           ),
                   
                  
             
                      ])
              ],
                    ),
                  
                             ],
                 ),
             
                   ),
               ));
        }
      );
        
      
   } ));
   
    
  
}
  @override
  Widget build(BuildContext context) {
   return  FloatingActionButton(
      elevation: 10,
      backgroundColor:const Color.fromARGB(255, 0, 74, 123),
      focusColor: const Color.fromARGB(255, 255, 207, 49),
      child: Icon(Icons.add, color: const Color.fromARGB(255, 254, 237, 54),),
      onPressed: () async {
         


    popUp();
  setState(() {
  });
});
      
      
   
  }
}