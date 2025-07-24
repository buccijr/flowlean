import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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



   runApp(MyApp());
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


class notFoundPage extends StatefulWidget {
  const notFoundPage({super.key});

  @override
  State<notFoundPage> createState() => _notFoundPageState();
}

class  _notFoundPageState extends State<notFoundPage> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 10,),
            //     SizedBox(
            //                     width: 120,
            //   height: 120,
            //       child: Icon(Icons.forklift, size: 150, color: const Color.fromARGB(255, 71, 148, 255))),
            //     Column(
            //       children: [
            //         Icon(Icons.question_mark, size: 80, color: Colors.grey),
                   
            //       ],
            //     ),
             
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  ShaderMask(
                                                       shaderCallback: (bounds) => LinearGradient(
                                                         colors: [const Color.fromARGB(255, 102, 171, 255),const Color.fromARGB(255, 255, 135, 7)],
                                                       ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                                       blendMode: BlendMode.srcIn,
                                                       child: Text(
                                                        '404',
                                                         style: TextStyle(
                                                           fontSize:  MediaQuery.of(context).size.width * 0.2,
                                                           fontWeight: FontWeight.bold,
                                                           fontFamily: 'Inter',
                                                           color: Colors.white, // Needed for ShaderMask to work
                                                         ),
                                                       ),
                                                     ),
                // SizedBox(width: 5,),
                 
                //   Icon(Icons.settings, color: Colors.blue, size: 90),
                 
                
                // SizedBox(width: 5,),
                //   Text(
                //   '4',
                //   style: TextStyle(fontSize: 100, color: const Color.fromARGB(255, 18, 105, 255), fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                // ),
                // SizedBox(width: 5,),
                SizedBox(width: 27,)
              ],
            ),
            Text('Page not found!', style: TextStyle(fontFamily: 'WorkSans', color: Colors.blue, fontSize: 34, ),),
            
           SizedBox(height: 20,),
           MouseRegion(
            cursor: SystemMouseCursors.click,
             child: GestureDetector(
              onTap: (){
                context.go('/login');
              },
               child: Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 138, 33),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(child: Text('LOGIN', style: TextStyle(fontFamily: 'Inter', color: Colors.white, fontSize: 18),),),
               ),
             ),
           )
          ],
        ),
      ),
    );
  }
}