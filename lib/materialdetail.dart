import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbi2/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rmotaezqlbiiiwwiaomh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJtb3RhZXpxbGJpaWl3d2lhb21oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk2NDcxMDUsImV4cCI6MjA2NTIyMzEwNX0.wW_Ynh1N8C5HFFV_xl-K1i1DOLYULcStX1Y2QAX6d8s',
  );

  runApp(DetailsM());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
class DetailsM extends StatefulWidget {
  const DetailsM({super.key});


  @override
  State<DetailsM> createState() => _DetailsMState();
}

class _DetailsMState extends State<DetailsM> {


bool hover = false;
TextEditingController emailControl = TextEditingController();
String errorText = '';
  @override
  Widget build (BuildContext context){
  return Scaffold(
  backgroundColor: Color(0xFFFAFAFA),
  body: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){
              context.go('/login');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                   SizedBox(width: 5,),
                Icon(Icons.keyboard_backspace, size: 24, color: Colors.blue),
                SizedBox(width: 15,),
                Text('Back', style: TextStyle(fontFamily: 'WorkSans', fontSize: 24),),
                SizedBox(width: 300,)
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Container(
          width: 400,
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: const Color.fromARGB(255, 114, 183, 239)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
         
            children: [
              SizedBox(height: 80,),
              Container(
                width: 70,
                height: 70,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 194, 227, 255),
          shape: BoxShape.circle
        ),
        child: Center(child: Icon(Icons.lock, size: 40, color: const Color.fromARGB(255, 76, 171, 249)),),
              ),
              SizedBox(height: 20,),
              Text(
                'Forgot Password?', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'WorkSans', fontSize: 24),
              ),
              SizedBox(height: 10,),
                Text(
                    "Enter the email and we'll \nsend instructions shortly", style: 
                    TextStyle(color: Colors.grey, fontFamily: 'WorkSans', fontSize: 15),
                             ),
                              SizedBox(height: 40,),
              //  Row(
              //    children: [
              //       SizedBox(width: 50),
              //      Text(
              //       'Email', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter', fontSize: 17),
              //                ),
                           
              //    ],
              //  ),
                SizedBox(height: 8,),
              Container(width: 300, height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: Colors.grey)),
              child: TextField(
                controller: emailControl,
                onSubmitted: (value) async {
                     try {
          await Supabase.instance.client.auth
              .resetPasswordForEmail(emailControl.text, redirectTo: 'https://app.flowleansolutions.com/reset-password');
        
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 173, 218, 255),
              content: Row(children: [
                const SizedBox(width: 10),
                const Icon(Icons.task_alt, color: Colors.white),
                const SizedBox(width: 30),
                const Text(
                  'Check your inbox',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ]),
            ),
          );
        } catch (e) {
          errorText = 'Error: $e';
          setState(() {
            
          });
          print(e);
        }
        //   } else {
        //     errorText = 'Error: Email not registered';
        //   }
        // setState(() {
          
        // });
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 16),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
              ),
              SizedBox(height: 20,),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
        onTap: () async {
          //     final response = await Supabase.instance.client.from('user').select().eq('email', emailControl.text).maybeSingle();
          //   print('email ${emailControl.text} and $response');
          // if (response != null) {
        try {
          await Supabase.instance.client.auth
              .resetPasswordForEmail(emailControl.text);
        
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 173, 218, 255),
              content: Row(children: [
                const SizedBox(width: 10),
                const Icon(Icons.task_alt, color: Colors.white),
                const SizedBox(width: 30),
                const Text(
                  'Check your inbox',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ]),
            ),
          );
        } catch (e) {
          errorText = 'Error: $e';
          setState(() {
            
          });
          print(e);
        }
        //   } else {
        //     errorText = 'Error: Email not registered';
        //   }
        // setState(() {
          
        // });
        },
        child: StatefulBuilder(
          builder: (context, setLocalState) {
            return MouseRegion(
              onEnter: (event) {
                setLocalState(() {
                  hover = true;
                },);
              },
               onExit: (event) {
                setLocalState(() {
                  hover = false;
                },);
              },
              child: Align(
                alignment: Alignment.center,
                child: AnimatedPadding(
                  duration: Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: hover ? 310 :300,
                    height: hover ? 45 : 40,
                    decoration: BoxDecoration(color: hover ? const Color.fromARGB(255, 75, 164, 237) : const Color.fromARGB(255, 156, 210, 255), borderRadius: BorderRadius.circular(5)),
                    child: Center(child: Text('Reset password', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 17),),),
                  ),
                ),
              ),
            );
          }
        ),
          ),
        ) ,
        SizedBox(height: 20,),
        Text(errorText, style: TextStyle(fontFamily: 'Inter', color: Colors.red, fontSize: 15),)
                 ],
          ),
        ),
      ],
    ),
  )
  );
  }
}