
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: AddNewUser()));

}

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {

String selectedRole = 'Role';
bool successPage = false;
bool selectAll = false; 
bool isChecked = false;
String errorText = '';
bool notEdit = true;
SearchController searchController =   SearchController();
TextEditingController usernameController = TextEditingController();
TextEditingController mailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController usereditControl = TextEditingController();
int allCount = 0;
int clearCount = 0;

final ValueNotifier<bool> snackbarNotifier = ValueNotifier(false);
Map<int, bool> isCheckedMap = {};

Timer? _debounce;

  void addUserPopUp(){
    
    
 showDialog(
    context: context, 
    builder: (_) => StatefulBuilder(
      builder: (context, setLocalState) {
        
void onSearchChanged(){
  if (_debounce?.isActive ?? false) _debounce?.cancel();

_debounce = Timer(const Duration(milliseconds: 400), (){
  setLocalState((){});
});

}
        usereditControl.addListener((){
onSearchChanged();
        });

      return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: 
        Container(
          height: 600,
          width: 500,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: successPage ? Column(children: [
            Container(
               height: 230,
               width: double.infinity,
               decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                color: const Color.fromARGB(255, 76, 175, 114),
               ), 
               child: Center(
                 child: Stack(
                  children: [
                  Icon(Icons.task_alt, color: const Color.fromARGB(255, 4, 101, 61), size: 100),
                  Positioned(
                    left: 5,
                    top: 5,
                    child: Icon(Icons.task_alt, color: Colors.white, size: 100))
                 ],),
               ),
            ),
            SizedBox(height: 30),
            Text('Success!', style: TextStyle(fontWeight: FontWeight.bold, color:  const Color.fromARGB(255, 76, 175, 114), fontSize: 30),),
            SizedBox(height: 10),
            Text('User added successfully.', style: TextStyle(color: Colors.grey),),
            SizedBox(height: 60),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  notEdit = true;
                  successPage = false;
                  usernameController.clear();
                  passwordController.clear();
                  mailController.clear();
                  isCheckedMap.clear();
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        colors: [const Color.fromARGB(255, 76, 175, 114),  const Color.fromARGB(255, 4, 101, 61)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(width: 67),
                          Text('Close', style: TextStyle(color: Colors.white, fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],) :  Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              Row(children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromARGB(255, 215, 215, 215)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(notEdit ? Icons.person_add : Icons.lock_open
                  ,  size: 30),
                ),
                SizedBox(width: 10),
                Column( 
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notEdit ? 'Create User' : 'Set Permission', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold, 
                    fontSize: 22, fontFamily: 'Inter' )),
                    SizedBox(height: 4),
                    Text(notEdit ? "Enter the user's information below" : 'Choose what materials the user can acess',
                     style:  TextStyle(color: Colors.grey, fontSize: 15, fontFamily:  'Inter' ),)
                  ],
                ),
                SizedBox(width: notEdit ? 90 : 30),
                IconButton(
                  onPressed: (){
                    setLocalState(() {
                      Navigator.pop(context);
                    },);
                  
                      errorText = '';
                      isCheckedMap.clear();
                      notEdit = true;
                      mailController.clear();
                      usernameController.clear();
                      passwordController.clear();
                    setLocalState(() {
                      
                    },);
                  }, 
                  icon: Icon(Icons.close),
                  )
              ],),  
              SizedBox(height: 10),
              Divider(thickness: 1),
              SizedBox(height: 15),
           Column( 
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              Center(child: Text(errorText, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
             SizedBox(height: 5),
               Row(
                 children: [
                  SizedBox(width: 12,),
                   Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                 ],
               ),
                    SizedBox(height: 5),           
              Row(
                children: [
                  SizedBox(width: 10),
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
                      child: TextField(
                        
                      cursorColor: Colors.black,
                      controller: usernameController,
                      decoration: InputDecoration(
                        floatingLabelStyle:TextStyle( color: const Color.fromARGB(255, 238, 238, 238),),
                        label: Text('Username' ),
                        enabledBorder: InputBorder.none,
                        suffixIcon: Icon(Icons.person),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 12),
                  Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
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
                      child: TextField(
                      cursorColor: Colors.black,
                      controller: mailController,
                      decoration: InputDecoration(
                        floatingLabelStyle:TextStyle( color: const Color.fromARGB(255, 238, 238, 238)),
                        label: Text('Email', ),
                        enabledBorder: InputBorder.none,
                        suffixIcon: Icon(Icons.mail),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 12),
                  Text('Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          value: selectedRole,
                          items: [
                             DropdownMenuItem(
                              value: 'Role',
                              child: Text('Role'),
                            ),
                            DropdownMenuItem(
                              value: 'user',
                              child: Text('User'),
                            ),
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text('Admin'),
                            ),
                          ],
                          onChanged: (value){
                            setLocalState((){
                            selectedRole = value!;
                            });
                          })
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 12),
                  Text('Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
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
                      child: TextField(
                        obscureText: true,
                      cursorColor: Colors.black,
                      controller: passwordController,
                      decoration: InputDecoration(
                        floatingLabelStyle:TextStyle(color:  const Color.fromARGB(255, 238, 238, 238),),
                        label: Text('Password', ),
                        enabledBorder: InputBorder.none,
                        suffixIcon: Icon(Icons.lock),
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
              ],
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                             notEdit ? SizedBox.shrink() :  TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white
                              ),
                              onPressed: (){
                                setLocalState(() {
                                isCheckedMap.updateAll((key, value) => true);

                                setLocalState(() {
                                  
                                },);
                                },);
                              } ,
                          
                              child: Text('Select all', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),)),
                              SizedBox(width: 7),
                              
                             
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                       notEdit ?
                        setLocalState(() {
                          Navigator.pop(context);
                                 usernameController.clear();
                         mailController.clear();
                         errorText = '';
                         passwordController.clear();
                         isCheckedMap.clear();
                         notEdit = true;
                        },) :
                  
                      setLocalState(() {
                        notEdit = true;
                      errorText = '';
                        
                      
                      },);
                     
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: notEdit ? 7 : 17),
                              Text( notEdit ? 'Cancel' : 'Back', style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                    ),
                  ),
                ),
                
                SizedBox(width: 5),
                 MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (selectedRole != 'Role' && usernameController.text.isNotEmpty && passwordController.text.isNotEmpty
                      && mailController.text.isNotEmpty){
                      addUser();
                      successPage = true;
                      // Navigator.pop(context);
                      } else {
                        errorText = "Please don't leave a field blank";
                      }
                      setLocalState(() {
                        
                      },);
                      if(usernameController.text.isNotEmpty && passwordController.text.isNotEmpty && mailController.text.isNotEmpty){
                     
                             errorText = '';
                              setLocalState(() {
                                
          notEdit = false;
        },);
                          
        setLocalState(() {
        },);
        
                      } else {
                           setLocalState((){errorText = " * Please don't leave any fields blank!";});
                      }
                    
                    },
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  const Color.fromARGB(255, 142, 204, 255)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: 17),
                              Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                    ),
                  ),
                ),
              ],)
            ],),
          ),
        ),
      );
   } ));
   
    
  }

Future<void> addUser() async {



  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
  final response1 = await Supabase.instance.client.from('user').select().eq('email', email.toString()).maybeSingle();
  final company = response1?['company'];


  final accessToken = Supabase.instance.client.auth.currentSession?.accessToken;

    if (accessToken == null) {
    print('Error: no user signed in or no access token found.');
    return;
  }
  final response = await http.post(
    Uri.parse('https://rmotaezqlbiiiwwiaomh.supabase.co/functions/v1/add-user-admin'),
    
   headers: {
    
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken', 
  },
    body: jsonEncode({
      'email': mailController.text.trim(),
      'password': passwordController.text.trim(),
      'username': usernameController.text.trim(),
      'role': selectedRole,
      'company': company,
    }),
  );

  if (response.statusCode == 200) {
     snackbarNotifier.value = true;

           Future.delayed(Duration(seconds: 3), () {
  snackbarNotifier.value = false;
});
          setState(() {
            
          });
    print('User created successfully!');
  } else {
    print('Failed to create user: ${response.body}');
  }
}
  
  @override
  Widget build (BuildContext context){
    return FloatingActionButton.extended(
       backgroundColor:  const Color.fromARGB(255, 193, 223, 247),
    onPressed: (){
      addUserPopUp();
    },
    icon: Icon(Icons.add, color:Color.fromARGB(255, 0, 74, 123),),
    label: Text('Add User', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),)

    );
  }
}