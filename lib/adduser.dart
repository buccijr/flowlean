import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'adduserbutton.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'routes.dart';
import 'dart:async';
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


class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
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
              'Created successfully!',
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
class _AddUserState extends State<AddUser> {
Map<String, bool> isCheckedMapEdit = {};
TextEditingController searchController2 = TextEditingController(); 
String updateText = '';
Map<int, bool> isCheckedMap = {};
bool selectAll = false;

 Set<String> permittedProcesses = {};
String username = 'Username';
String role = 'User';
String email = 'Email';
String password = 'Password';
 bool selected1 = false;
bool  selected2 = false;
bool selected3 = true;
bool onDetails = true;
bool selected4 = false;
bool selected5 = false;
bool selected6 = false;

SearchController searchController =   SearchController();
TextEditingController usernameController = TextEditingController();
TextEditingController mailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

Set<String> selected = {'Details'};

@override
initState(){
  super.initState();
      _loadUserRole();
  searchController2.addListener((){
_onSearchChanged2();
        });
  
}


Timer? _debounce;


void _onSearchChanged2() {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    if (!mounted) return;  // <-- Prevent calling setState after dispose
    setState(() {
      // Your state updates here
    });
  });
}

void _onSearchChanged(setLocalState) {
  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () {
    if (!mounted) return;  // <-- Prevent calling setLocalState after dispose
    setLocalState(() {
      // Your state updates here
    });
  });
}



@override
void dispose() {
    _debounce?.cancel(); 
  searchController2.clear();
  searchController2.dispose();  // 
  super.dispose();
}


TextEditingController usereditControl = TextEditingController();



void editUserButton(usernamer){
 showDialog(
  context: context, 
  builder: (_)  => StatefulBuilder(
    builder: (context, setLocalState) {
      usereditControl.addListener((){
_onSearchChanged(setLocalState);
        });

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0),
          
          content: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(children: [
              SizedBox(height: 40),
              SizedBox(
                width: 350,
                child: SegmentedButton(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  selectedBackgroundColor:  const Color.fromARGB(255, 204, 232, 255),
                side: BorderSide(color: const Color.fromARGB(255, 0, 36, 97), width: 0.4),
  
  
                  elevation: 10,
                  
                  ),
                  selected: selected,
                  selectedIcon: Icon(Icons.edit),
                  segments: 
                  <ButtonSegment<String>>[
                  
                    ButtonSegment<String>(
                    value: 'Details',
                    label: Text('Details', style: TextStyle(fontSize: 18, fontFamily: 'WorkSans', color: Colors.black),),
                    ),
                    ButtonSegment<String>(
                    value: 'Permissions',
                    label: Text('Permissions',style: TextStyle(fontSize: 18, fontFamily: 'WorkSans', color: Colors.black)),
                    ),
                  ],
                  onSelectionChanged: (p0) {
                    setLocalState(() {
                      
                    });
                    selected = p0;
                final value = selected.first;
                    if (value == 'Permissions'){
                    onDetails = false;
                    } 
                    if (value == 'Details'){
                      onDetails = true;
                    }
                    setLocalState(() {
                      
                    },);
                  },
                      ),
              ),
              SizedBox(height: 15),
              Text(updateText, style: TextStyle(color: Colors.green),),
              SizedBox(height: 10),
                onDetails ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Row(
                       children: [
                        SizedBox(width: 30,),
                         Text('Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                       ],
                                 ),
                    ),
        
                    SizedBox(height: 5),           
                             Row(
                children: [
                  SizedBox(width: 30),
                  Container(
                    height: 45,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 238, 238, 238),
                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonHideUnderline(child: DropdownButton(
                        value: role,
                        items: [
                          DropdownMenuItem(
                            value: role,
                            child: Text(role)
                            ),
                          if (  role == 'Admin' || role ==  'admin' )
                             DropdownMenuItem(
                            value: 'user',
                            child: Text('user', style: TextStyle(fontFamily: 'Inter'),)
                            ),
                                                      if (  role == 'user' || role ==  'User' )
                             DropdownMenuItem(
                            value: 'admin',
                            child: Text('admin', style: TextStyle(fontFamily: 'Inter'))
                            ),

                        ], 
                        onChanged: (value){
                         setLocalState(() {
                           role = value!;
                         },);
                        }))
                    ),
                  ),
                ],
                             ),
                           onDetails ?  SizedBox(height: 220,) : SizedBox(height: 0,),
                            
                 
                             Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                     isCheckedMap.clear();
                          usernameController.clear();
                          mailController.clear();
                          passwordController.clear();
                          selected = {'Details'};
                          onDetails = true;
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.5, color: Colors.grey),
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold) )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (onDetails){
                                    await Supabase.instance.client.from('users').update({
                                   'role': role,
                                    });
                                    }
                                  
                                      updateText = 'Changes saved.';
                                    
                                    setLocalState(() {
                                      
                                    },);
                                    
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 142, 204, 255),
                                      borderRadius: BorderRadiusDirectional.circular(10),
                                    ),
                                    child: Center(
                                      
                                      child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold) )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30,)
                             ],)
                                ],
                ) : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Container(
                    height: 35,
                    width: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 238, 238, 238),
                          border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                      child: TextField(
                      controller: usereditControl,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        label: Text('Search for a process',style: TextStyle()),
                        floatingLabelStyle: TextStyle(color: const Color.fromARGB(255, 238, 238, 238),),
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                 
                        Row(
                          children: [
                            SizedBox(width: 0),
                            FutureBuilder(
                              future: Supabase.instance.client.from('process').select(),
                              builder: (context, snapshot) {
                             
                               if (snapshot.hasError){
                                  return Text('Error: ${snapshot.error}');
                                } 
                                    
                                final data = snapshot.data ?? [];
                                if (data.isEmpty){
                                  return Text('');
                                }
                                  
                                    
                               return Align(
                                alignment: Alignment.topLeft,
                                 child: Column(
                                   children: [
                                     Row(
                                       children: [
                                      
                                                    Column(
                                                      children: [
                                                               
                                                   
                                                          
                                                            Row(
                                                              children: [
                                                                SizedBox(width: 30,),
                                                                FutureBuilder(
                                                                  future: Future.wait([ Supabase.instance.client.from('process').select(),
                                                                  Supabase.instance.client.from('process_users').select().eq('userpu', usernamer),
                                                                 
                                                                  ]),
                                                                  builder: (context, snapshot) {
                                                                      if (snapshot.hasError) {
                                                            return Text('Error: ${snapshot.error}');
                                                              }
                                                            
                                                            // if (snapshot.connectionState == ConnectionState.waiting){
                                                            //   return Center(child: CircularProgressIndicator(color: Colors.blue));
                                                            // }
                                                              if (!snapshot.hasData || snapshot.data == null) {
                                                            return Text('No data found');
                                                              }
                                                                   final  data = snapshot.data![0];
                                                            final  data2 = snapshot.data![1];
                                                            
                                                                 if (data.isEmpty){
                                                                  return Center(child: Text('No users found', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)));
                                                                 } 
                                                     permittedProcesses = {
                                                              for (final entry in data2)
                                                                if (entry['processpu'] != null && entry['disabled'] != 'true') entry['processpu'] as String
                                                            };
                                                            
                                                            
                                                            print('permittedproccessses $permittedProcesses');
                                                            
                                                              
                                    
                                final filteredData = data.where(
                                  ((row) => row['description'].toString().toLowerCase().contains(usereditControl.text.toLowerCase()))).toList();
                                
                                 
                                                                    return SizedBox(
                                                                      width: 450,
                                                                      height: 180,
                                                                      child: SingleChildScrollView(
                                                                        scrollDirection: Axis.vertical,
                                                                       child: SizedBox(
                                                                        width: 450,
                                                                        
                                                                         child: Column(
                                                                           children: filteredData.map((entry)  { 
                                                                            final usernames = entry['description'];
                                                                                        final isChecked = isCheckedMapEdit[usernames] ?? permittedProcesses.contains(usernames);
                                                                                                                                
                                                                            return CheckboxListTile(
                                                                            title: Text(entry['description'],  overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 16)),
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
                                                                                             
                                                                            );}).toList(),
                                                                         ),
                                                                       ),
                                                                      ),
                                                                    );
                                                                  }
                                                                ),
                                                              ],
                                                            )
                                                       ]),
                                       ],
                                     ),
                                     
                                   ],
                                 ),
                                 
                               );
                              }
                            ),
                          ],
                        ),
                        SizedBox(height: 60),
                        Row(children: [
                          SizedBox(width: 10,),
                          TextButton(
                            onPressed: () {
        
                              isCheckedMapEdit.updateAll((key, value) => true,);
                              setLocalState(() {
                                
                              },);
                            },
                            child: Text('Select all', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'WorkSans'),)),
                            
                          
                          SizedBox(width: 7),
                           TextButton(
                            onPressed: () {
                               isCheckedMapEdit.updateAll((key, value) => false,);
                               setLocalState(() {
                                 
                               },);
                            },
                            child: Text('Clear all', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'WorkSans'))),
                        SizedBox(width: 80),
                          MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (){
                          isCheckedMap.clear();

                          usernameController.clear();
                          mailController.clear();
                          passwordController.clear();
                          onDetails = true;
                           selected = {'Details'};
                         Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.grey)),
                            child: Center(child: Text( 'Cancel', style: TextStyle(fontWeight: FontWeight.bold),))
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async {
                          
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
        if (permittedProcesses.contains(entry)) {
  await Supabase.instance.client.from('process_users').update({
    'company': company,
    'userpu': usernamer,
    'usercreate': username,
    'processpu': entry,
  }).eq('processpu', entry).eq('userpu', usernamer);
}     else {
  await Supabase.instance.client.from('process_users').insert({
    'company': company,
    'userpu': usernamer,
    'usercreate': username,
    'processpu': entry,
  });
}            
        }
         Map<String, bool> isCheckedMap4 = Map.fromEntries(
          isCheckedMapEdit.entries.where((entry) => entry.value == false)
        );
        List <String> isCheckedMap5 = isCheckedMap4.keys.toList();
     
        for (final entry in isCheckedMap5){
          
   final response = await Supabase.instance.client.from('process_users').select().eq('userpu', usernamer).eq('processpu', entry).or('disabled.is.null,disabled.not.eq.true');
          if (response.isNotEmpty){
          
          await Supabase.instance.client.from('process_users').update({'disabled': 'true'}).eq('processpu', entry).eq('userpu', usernamer);
          }
          
          }
          },
                        
                        
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 142, 204, 255),),
                            child: Center(child: Text( 'Save', style: TextStyle(fontWeight: FontWeight.bold),))
                        ),
                      ),
                    ),
                    SizedBox(width: 13.5)
                        ],)
                  ],),
                             
              ],),
          ),
        );
      }
    );
    }
    )
  );

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


   return  Scaffold(
      floatingActionButton: AddNewUser(
          onSuccess: () => CustomToast.show(context),
      ),
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
                  Text('User Data', style: TextStyle( fontFamily: 'Inter',
                    color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
                ],
                                ),
                                SizedBox(height: 20),
                               Align(
                                alignment: Alignment.topLeft,
                                 child: Row(
                 children: [
                   SizedBox(width: 15,),
                   Container(
                    width: 400,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                    controller: searchController2,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      label: Text('Search by username...'),
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
                 ],
                                 ),
                               ),
                                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width:  MediaQuery.of(context).size.width >  1500 ?  MediaQuery.of(context).size.width * 0.866  :  MediaQuery.of(context).size.width >  1450 ? 
                      MediaQuery.of(context).size.width *  0.85 :
                    MediaQuery.of(context).size.width *  0.84,
                        height: 60,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                                      colors: [ const Color.fromARGB(255, 186, 224, 254), const Color.fromARGB(255, 234, 245, 255) ],
                                    begin: Alignment.centerLeft, end: Alignment.centerRight),
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))
                              ),
                        width: double.infinity,
                        child: Row(children: [
                          SizedBox(width: 20),
                            SizedBox(width: 350, child: Text('Email', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                            fontFamily: 'Inter' ))),
                               SizedBox(width: 20),
                               SizedBox(width: 150, child: Text('Username', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                               fontFamily: 'Inter' ))),
                                SizedBox(width: 20),
                                 SizedBox(width: 150, child: Text('Role', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                               fontFamily: 'Inter' ))),
                                Spacer(),
                               SizedBox(width: 80, child: Text('')),
                        ],)
                    ),
                  ),
                ),
                                Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width:   MediaQuery.of(context).size.width >  1500 ?  MediaQuery.of(context).size.width * 0.866  :  MediaQuery.of(context).size.width >  1450 ? 
                      MediaQuery.of(context).size.width *  0.85 :
                    MediaQuery.of(context).size.width *  0.84,
                      height: MediaQuery.of(context).size.height * 0.68,
                  child: StreamBuilder(
                stream: Supabase.instance.client
                    .from('user')
                    .stream(primaryKey: ['id'])
                    .order('id'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                    
                
                
                  final data = snapshot.data ?? [];
                  
                  final filteredData = data.where((entry) => entry['username'].toString().contains(searchController2.text),).toList();
                
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
                
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1, color: const Color.fromARGB(255, 118, 118, 118))),
                        color: (entry['closed'] == 1)
                            ? Color.fromARGB(255, 172, 250, 175)
                            : Colors.white),
                        child: SizedBox(
                          height: 61,
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  
                                  SizedBox(width: 20),
                                  SizedBox(width: 350, child: Text(entry['email'] ?? 'N/A', style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                  SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text(entry['username'] ?? 'N/A',  style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                                       SizedBox(width: 20),
                                  SizedBox(width: 150, child: Text(entry['role'] ?? 'N/A',  style: TextStyle(fontSize: 16, fontFamily: 'Inter'))),
                             Spacer(),
                             SizedBox(width: 80, child: IconButton(onPressed:() {
                             final usernamer = entry['username'] ?? 'N/A';
                            role = entry['role'] ?? 'N/A';
                             password = entry['password'] ?? 'N/A';
                           email = entry['email'] ?? 'N/A';
                              editUserButton(usernamer);
                               setState(() {
                                 
                               });
                             }, icon: Icon(Icons.edit)
                             )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                  ),
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