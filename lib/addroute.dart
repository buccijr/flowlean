import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admindata.dart';
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

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}



class _RoutesState extends State<Routes> {
  List fetchedIds= [];
  Map fromToTo = {};
  String? namer;
  List<Map<String, dynamic>> entries = [];
List<StreamSubscription> pageStreams = [];
Map<int, bool> delete = {};
int pageSize = 30;
int currentPage = 0;
bool isLoading = false;
bool hasMore = true;

final ScrollController _scrollController = ScrollController();




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
void initState() {
  super.initState();
      _loadUserRole();
  fetchDropdownItems();
  fetchNextPage();

  _scrollController.addListener(() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !isLoading && hasMore) {
      print('📩 Near bottom → fetchNextPage triggered');
      fetchNextPage();
    }
  });
}


bool gapsPresent() {
  final steps = selectedValues.toSet().toList()..sort();
  print('selectedValues: $selectedValues');
  print('steps (sorted unique): $steps');
  
  for (int i = 0; i < steps.length - 1; i++) {
    print('Comparing ${steps[i]} and ${steps[i+1]}');
    if (steps[i + 1] != steps[i]! + 1) {
      print('Gap found between ${steps[i]} and ${steps[i + 1]}');
      return true; // Gap found
    }
  }
  return false; // No gaps
}

Future<void> fetchNextPage() async {

  if (isLoading || !hasMore) return;

  setState(() => isLoading = true);

  final from = currentPage * pageSize;
  final to = from + pageSize - 1;

  

  final response = await Supabase.instance.client
      .from('route')
      .select()
      .or('disabled.is.null,disabled.not.eq.true')
      .order('material_route', ascending: true)
      .range(from, to)
      ;

  if (response.isEmpty) {
    print('⛔ No more data found, setting hasMore to false');
    setState(() {
      hasMore = false;
      isLoading = false;
    });
    return;
  }

  final newEntries = response.where((item) {
    final id = item['id'];
    return !entries.any((e) => e['id'] == id);
  }).toList();


  setState(() {
    entries.addAll(newEntries);
    currentPage++;
    isLoading = false;
  });


  final pageIds = newEntries.map((e) => e['id'] as int).toList();
  subscribeToPageStream(pageIds);
}

void subscribeToPageStream(List<int> ids) {
  final sub = Supabase.instance.client
      .from('masterdata')
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
  }}
  TextEditingController searchMController = TextEditingController();
  TextEditingController namerController = TextEditingController();
  final ValueNotifier<String> selectedProcess = ValueNotifier('Select a process...'); 
Map<int, String> processed = {0 : 'Select a process...'};
TextEditingController materialRoute = TextEditingController();
Map<String, String> combine = {'0': 'Default'};
String sucessText = '';

void materialRoutePopUp(setLocalState){
   showDialog(context: context, 
  builder:(context) {
    return AlertDialog(
    backgroundColor: Colors.transparent,
    contentPadding: EdgeInsets.all(0),
    content: StatefulBuilder(
      builder: (context, setLocaltState) {
        return Container(
          width: 530,
          height: 302,
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
                  Text('Please enter the route name below.', style: TextStyle(fontFamily: 'Inter', color: const Color.fromARGB(255, 0, 0, 0), 
                  fontSize: 17),),
                ],
              ),
            ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 9),
           Text(errorText1, style: TextStyle(fontFamily: 'Inter', color: Colors.red)),
                                                   SizedBox(height: 7,),
  
                        SizedBox(height:7,),
                         Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 50,),
                Text('Name', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold, fontSize: 15),),
              ],
            )),
                                                   SizedBox(height: 7,),
                        Container(
                         width: 400,
                            height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(width: 1, color:Color.fromARGB(255, 0, 74, 123)),),
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: materialRoute,
                          decoration: InputDecoration(
                            hintText: 'Route name...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                             enabledBorder: InputBorder.none,
                             focusedBorder: InputBorder.none,
                             disabledBorder: InputBorder.none,
                          ),
                        )
                             
                        ),
                           SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                           MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: () async {
                                           
                                           
                    
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
                      )
                    
                  
                  ),
                  SizedBox(width: 10,),
                   ValueListenableBuilder(
                     valueListenable: snackbarNotifier,
                     builder: (context, value, child) {
                       return ValueListenableBuilder<int?>(
                         valueListenable: tapIndexNotifier,
                         builder: (context, tappedNotifiers, _) {
                           return MouseRegion(
                             cursor: SystemMouseCursors.click,
                             child: GestureDetector(
                                          onTap: () async {
                                        final response = await Supabase.instance.client.from('route').select().eq('material_route', materialRoute.text).or('disabled.is.null,disabled.not.eq.true');
                                        print('responseee $response');
                                        if (response.isEmpty){
                                            if (materialRoute.text.isNotEmpty){
                                    sucessText = 'Added Successfully!';
  setLocalState(() {
    
  },);     
     snackbarNotifier.value = true;
                       sucessText = 'Added Successfully!';
  setLocalState(() {
    
  },);
                                  Future.delayed(Duration(seconds: 3), () {
                         snackbarNotifier.value = false;});
  Navigator.pop(context);
  sucessText = 'Added Successfully!';
  setLocalState(() {
    
  },);
                                         for (int i = 0; i < selectedValues.length; i++) {
                                           print('Adding route for index $i');
                       addRoute(i, tapIndex);
                                         }
                                       } else {
                                        errorText1 = 'Error! Please enter a name!';
                                           setLocaltState(() {
                                            
                                          },);
                                       }
                                        } else {

                                          errorText1 = 'Route already exists.';
                                          setLocaltState(() {
                                            
                                          },);
                                        } 
                                          
                         setLocaltState(() {
                           
                         });
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

  final ValueNotifier<Map<int, bool>> selected = ValueNotifier({0: true});
  Map<int, int> tapIndexes = {0 : -1};
final ValueNotifier<bool> snackbarNotifier = ValueNotifier(false);
 bool showFuture = false;
 double fontSizeBasedOnLength(String text) {
  if (text.length > 15){
    return 14.5;
  }
   else if (text.length > 30){
    return 10.00;
  } else {
    return 17;
  }
}
String ifFForklift = 'From'; 
String ifTForklift = 'To'; 
bool empty = false;
String selectedP = 'Process';
List<Map<String, dynamic>>? localData;
TextEditingController namec= TextEditingController();
List<String>? selectedProcesses;
int? step;
Map<int, bool> tapIndexMap = {};
final ValueNotifier<int?> tapIndexNotifier = ValueNotifier(null);
final ValueNotifier<String?> namerNotifier = ValueNotifier(null);
int? tapIndex;
int? ids;
String? process;
int? hoverIndex;

void deletePopUp(routeId){
    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        
        backgroundColor: Colors.transparent,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          ),
            width: 400,
            height: 220,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 255, 193, 188),
                      ),
                      child: Icon(Icons.delete, color: Colors.red,)),
                    SizedBox(height: 20,),
                    Text('Are you sure you want to delete this route?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, 
                    fontFamily: 'Inter'),),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                                        width: 110,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: const Color.fromARGB(255, 189, 189, 189)),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 21),
                                              MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: GestureDetector
                                                ( onTap: (){
                                                Navigator.pop(context);
                                                },
                                                  child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontFamily: 'Inter', color: const Color.fromARGB(255, 0, 0, 0)))),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                          MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                             onTap: () async{
                                                    setState(() {
                                                      
                                                    });
                                                  
                                                
                                                setState(() {
                                                  
                                                });
                                                Navigator.pop(context);
                                                },
                                              child: Container(
                                                                                  width: 110,
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                    color:  Colors.red,
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    child: Row(
                                                                                      children: [
                                              SizedBox(width: 24),
                                              Text('Delete', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Inter')),
                                              
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                            ),
                                          )
                      ],
                    ),
                         
                         ] ),
              ),
            ),
          )
      ),
      );
  
}

String selectedMat = 'Select a material';

   bool selected1 = false;
bool  selected2 = false;
bool selected3 = false; 
bool selected4 = false;
bool selected6 = false;
bool selected5 = true;
void addRoute(i, tapIndex) async {
  
  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
    final responses = await Supabase.instance.client.from('materials').select().eq('id', tapIndexes[i]!).maybeSingle();
  final materialname = responses?['name'];
  final processname = responses?['process'];
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
  print({
  'material': materialname,
  'step': i +1,
  'process': processed[i],
  'company': company,
  'userr': username,
  'from_route': fromTo[i]?['From'] ?? 'N/A',
  'to_route': fromTo[i]?['To'] ?? 'N/A',
  'material_route': materialRoute.text,
});
                   final insertResponse = await Supabase.instance.client.from('route').insert({
  'material': materialname,
  'step': selectedValues[i] ?? -1 +1,
  'process': processed[i],
  'company': company,
  'userr': username,
  'from_route': fromTo[i]?['From'] ?? 'N/A',
  'to_route': fromTo[i]?['To'] ?? 'N/A',
  'material_route': materialRoute.text,
}).select();

print('Insert response: $insertResponse');

               
}


void editRoute(i, entry) async {

  final user = Supabase.instance.client.auth.currentUser;
  final email = user?.email;
    final responses = await Supabase.instance.client.from('materials').select().eq('id', tapIndexes[i]!).maybeSingle();
  final materialname = responses?['name'];
  final processname = responses?['process'];
  final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
  final company = response?['company'];
  final username = response?['username'];
  
final responser = await Supabase.instance.client.from('route').select().eq('step', i+1).eq('material_route', entry).or('disabled.is.null,disabled.not.eq.true');
if (responser.isNotEmpty){
  print('delete ${delete}');
  print('fetchid $fetchedIds');
  if (delete[i] == true){
    
 await Supabase.instance.client.from('route').update({'disabled': 'true'}).eq('material_route', entry).eq('id', fetchedIds[i]);
  } 
  
  else
   {
                  await Supabase.instance.client.from('route').update({
  'material': materialname,
  'step': selectedValues[i] ?? -1 +1,
  'process': processed[i],
  'company': company,
  'userr': username,
  'from_route': fromTo[i]?['From'] ?? 'N/A',
  'to_route': fromTo[i]?['To'] ?? 'N/A',
  'material_route': entry,
  
}).eq('material_route', entry).eq('step', i+1);
} } else {
       await Supabase.instance.client.from('route').insert({
  'material': materialname,
  'step':  selectedValues[i] ?? -1 +1,
  'process': processed[i],
  'company': company,
  'userr': username,
  'from_route': fromTo[i]?['From'] ?? 'N/A',
  'to_route': fromTo[i]?['To'] ?? 'N/A',
  'material_route': entry,
});
}


               
}

 List<int?> selectedValues = [1]; 
 List<int?> selectedIndex = [];
 Map<int, Map<String, String>> fromTo = {};
  List<String> options = [];
 

  Future<void> fetchDropdownItems() async {
  final response = await Supabase.instance.client
        .from('process') 
        .select();


    if ( response.isNotEmpty) {
      setState(() {
        options = (response as List)
            .map((item) => item['description'] as String)
            .toList();
        
      });
    } else {
   
    }
  }


String errorText = '';
String errorText1 = '';

void routeEditPopUp(entry) async {
    final response = await Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', entry).order('step', ascending: true);

selectedValues = [];
processed = {};
tapIndexes = {};
  combine = {};
fetchedIds= [];
for (final entrye in response){

  processed[selectedValues.length] = entrye['process'];
  delete[selectedValues.length] = false;
  fromm = entrye['from_route'];
    too = entrye['to_route'];
    print('length ${selectedValues.length}');
      fetchedIds.add(entrye['id']);
    if (fromm != null && too != null){
      fromTo[selectedValues.length] = {'From': fromm!, 'To': too!};
    }
  final response1 = await Supabase.instance.client.from('materials').select().eq('name', entrye['material']).single();

 tapIndexes[selectedValues.length] = response1['id'];

// Always parse step as int and add to selectedValues
final int stepIndex = int.tryParse(entrye['step'].toString()) ?? -1;
selectedValues.add(stepIndex);
print('selectedval $selectedValues ');
print('step $stepIndex');

// Count how many times this stepIndex appears
final count = selectedValues.where((val) => val == stepIndex).length;

// Only create combine entries if stepIndex appears more than once
if (count > 1) {
  for (int i = 0; i < selectedValues.length; i++) {
    if (selectedValues[i] == stepIndex) {
      combine[i.toString()] = stepIndex.toString();
      print('🔗 Synced combine[$i] = $stepIndex');
    }
  }
} else {
  for (int i = 0; i < selectedValues.length; i++) {
    if (selectedValues[i] == stepIndex) {
      combine[i.toString()] = 'Default';
      print('🔗 Synced combine[$i] = $stepIndex');
    }
  }
}
}
 showDialog(
  barrierDismissible: false,
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

      return AlertDialog(
        
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: 
        Container(
          height: 1000,
          width: 1520,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),child:  Padding(
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
                  child: Icon(Icons.fork_left
                  ,  size: 30),
                ),
                SizedBox(width: 10),
                ValueListenableBuilder(
                  valueListenable: snackbarNotifier,
                  builder: (context, value, child) {
                    return Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( 'Edit Route', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold, 
                        fontSize: 22, fontFamily: 'Inter' )),
                        SizedBox(height: 4),
                        Text( "Fill out the route below.",
                         style:  TextStyle(color: Colors.grey, fontSize: 15, fontFamily:  'Inter' ),)
                      ],
                    );
                  }
                ),
                SizedBox(width: 30),
                // Container(
                //   width: 350, 
                //   height: 40,
                //   decoration: BoxDecoration(
                //     border: Border.all(width: 1, color: Colors.blue),
                //   ),
                //   child: TextField(
                //     controller: namec,
                //   )
                // ),
                Spacer(),
                                   snackbarNotifier.value  ?
                    Text('Updated sucessfully.', style: TextStyle(fontFamily: 'Inter', color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16))
                
                    : SizedBox.shrink(),
                   snackbarNotifier.value ?     SizedBox(width: 20,) : SizedBox.shrink(),
                      MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ValueListenableBuilder(
                  valueListenable: tapIndexNotifier,
                  builder: (context, tapIndex, _) {
                    return ValueListenableBuilder(
                      valueListenable: namerNotifier,
                      builder: (context, namer, _) {
                        return GestureDetector(
                        onTap: () async {
                        
                        selectedValues.clear();
                                      selectedValues = [1];
                        selected.value = {0: true};
                        processed = {0 : 'Select a process...'};
                           selectedProcess.value = 'Select a process...';
                                    tapIndex = null;
                                    materialRoute.clear();
                                    tapIndexNotifier.value = null;
                                    combine.clear();
                                    errorText= '';
                        setLocalState(() {
                          Navigator.pop(context);
                        
                        },);
                                      
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
print('selectedValues: $selectedValues');
    return ValueListenableBuilder<int?>(
      valueListenable: tapIndexNotifier,
      builder: (context, tapIndex, _) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
             
print('selectedValues: $selectedValues');

bool gapsPresent() {
  final steps = selectedValues.toSet().toList()..sort();
  print('selectedValues: $selectedValues');
  print('steps (sorted unique): $steps');
  
  for (int i = 0; i < steps.length - 1; i++) {
    print('Comparing ${steps[i]} and ${steps[i+1]}');
    if (steps[i + 1] != steps[i]! + 1) {
      print('Gap found between ${steps[i]} and ${steps[i + 1]}');
      return true; // Gap found
    }
  }
  return false; // No gaps
}
                print('from true ? ${fromTo.values.any((innerMap) => 
    innerMap.containsValue('From')) } full $fromTo');
     print('to true ? ${fromTo.values.any((innerMap) => 
    innerMap.containsValue('To')) } full $fromTo');
           if (
            //route
  processed.containsValue('Select a process...') ||
  tapIndexes.containsValue(null) ||
  fromTo.values.any((innerMap) => 
    innerMap.containsValue('From') || innerMap.containsValue('To')
  )
) {
  setLocalState(() {
  errorText = "Please don't leave a field blank";
});

Future.delayed(Duration(seconds: 5), () {
  setLocalState(() {
    errorText = '';
  });
});

            } else if (!selectedValues.contains(1) || gapsPresent()
            ){
              setLocalState(() {
                errorText = 'Step sequence is incomplete. Make sure Step 1 exists and all steps are in order without gaps.';
                Future.delayed(Duration(seconds: 5), () {
  setLocalState(() {
    errorText = '';
  });
});
              },);
            }
else {
             for (int i = 0; i < selectedValues.length; i++) {
                               print('Adding route for index $i');  

                       editRoute(i, entry);
                                         }
                                       
}
           
         
               setState(() {
 });
            },
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 142, 204, 251),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child:  Text( 'Update',
                  style: TextStyle(fontFamily: 'Inter')),
               
              ),
            ),
          ),
        );
      }
    );
  },
),
SizedBox(width: 30),
                ValueListenableBuilder(
                  valueListenable: tapIndexNotifier,
                  builder: (context, tapIndex, _) {
                    return ValueListenableBuilder(
                      valueListenable: selectedProcess,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                          valueListenable: selected,
                          builder: (context, value, _) {
                            return IconButton(
                              onPressed: () async { 
                            selectedValues = [1];
                            selected.value = {0: true};
                           processed = {0 : 'Select a process...'};
                           selectedProcess.value = 'Select a process...';
                                        selectedIndex.clear();
                                        fromTo.clear();
                                        materialRoute.clear();
                                        combine.clear();
                                        errorText= '';
                            setLocalState(() {
                              Navigator.pop(context);
                              tapIndexNotifier.value = null;
                                            selectedP = 'Process';
                            
                            },);
                              }, 
                              icon: Icon(Icons.close),
                              );
                          }
                        );
                      }
                    );
                  }
                )
              ],),  

              SizedBox(height: 10),
              Divider(thickness: 1),
              Center(child: Text(errorText, style: TextStyle(color: Colors.red, fontFamily: 'Inter'),)),
               Row(
                 children: [
                  SizedBox(width: 30,),
                   Text('Material', style: TextStyle(fontFamily: 'WorkSans', 
                                fontWeight: FontWeight.bold,
                                color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),),
                                SizedBox(width: 30,),
                                             Container(
                    width: 400,
                    height: 40,
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
                                SizedBox(width: 600),
                                    Center(child: Text('Steps', style: TextStyle(fontFamily: 'WorkSans', 
             fontWeight: FontWeight.bold,
             color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),)),
             SizedBox(width: 15),
           
                   SizedBox(width: 5),
                   
                 ],
               ),
             empty ? Text('Error! Please choose both a material and process.', style: TextStyle(color: const Color.fromARGB(255, 255, 53, 53), 
             fontFamily: 'Inter'
             ),) : SizedBox.shrink(),
             SizedBox(height: 10,),
                Row(
                  children: [

  Expanded(
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
                    
                     child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2, 
                      
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
                SizedBox(
                  height: 500,
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
                                          Row(
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
                                            onChanged: (bool? checked) {
                                              if (checked == true) {
                                            
                                                tapIndexNotifier.value = entry['id'];
                                              } else {
                                                setLocalState(() {
                                                  
                                                },);
                                                tapIndexNotifier.value = null;
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
               
              
                
               
           StatefulBuilder(
               builder: (context, setLocallyState) {
                 return Column(
                   children: [
                          
                   SizedBox(width: 200),
                    SizedBox(height: 10,),
//                
                    Align(
                      alignment: Alignment.topCenter,
                           
                       child: SizedBox(
                        height: 500,
                         child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                           child: Container(
                           
                            child: Padding(
                              padding: EdgeInsets.all(13),
                              child: Column(
                                children: [
                                  selectedValues.isEmpty ? Row(
                                    children: [
                                      SizedBox(width: 600,)
                                    ],
                                  ) :
                                  ValueListenableBuilder(
                                    valueListenable: selected,
                                    builder: (context, value, child) {
                                      return Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        // add nedit new
                                        ...List.generate(selectedValues.length, (index) {
                                        
  String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}
                                        double fontSizeBasedOnLength(String text) {
  if (text.length > 15){
    return 13.5;
  }
   else if (text.length > 30){
    return 10.00;
  } else {
    return 17;
  }
}

                                            return 
                                        Column(
                                         
                                          children: [
                                            SizedBox(width: 50),
                                            Row(
                                              children: [
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                          SizedBox(height: 10), 
                                                                                          // new gesture  
                                                                                        MouseRegion(
                                                                                          cursor: SystemMouseCursors.click,
                                                                                          child: ValueListenableBuilder(
                                                                                            valueListenable: selectedProcess,
                                                                                            builder: (context, value, child) {
                                                                                              return ValueListenableBuilder(
                                                                                                valueListenable: tapIndexNotifier,
                                                                                                builder: (context, value, child) {
                                                                                                  return GestureDetector(
                                                                                                    onTap: (){
                                                                                                    selected.value.updateAll((key, _) => false);
                                                                                                  selected.value[index] = true;
                                                                                                  selected.notifyListeners(); 
                                                                                                  tapIndexNotifier.value = tapIndexes[index];
                                                                                                  selectedProcess.value = processed[index] ?? 
                                                                                                 'Select a process....';
                                                                                                     setState(() {
                                                                                                       
                                                                                                     });
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      width: 50,
                                                                                                      height: 50,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        color: selected.value[index] == true ? const Color.fromARGB(255, 121, 195, 255) : const Color.fromARGB(255, 193, 223, 247),
                                                                                                      ),
                                                                                                      child: Center(child: Text('${selectedValues[index] ?? -1 +1}', style: TextStyle(fontSize: 20, fontFamily: 'Inter',
                                                                                                        color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),),)
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              );
                                                                                            }
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 20),   
                                                                                                 
                                                                                        ]),
                                            
                                                                                       SizedBox(width: 10,),
                                                                                         Column(
                                                                                           children: [
                                                                                             ValueListenableBuilder(
                                                                                               valueListenable: tapIndexNotifier,
                                                                                               builder: (context, value, child) {
                                                                                                
                                                                                                 return ValueListenableBuilder(
                                                                                                   valueListenable: selected,
                                                                                                   builder: (context, value, child) {
                                                                                                  
                                                                                                     return Container(
                                                                                                       width: 190,
                                                                                                       height: 49,
                                                                                                              decoration: BoxDecoration(
                                                                                                             borderRadius: BorderRadius.circular(15),
                                                                                    color:  const Color.fromARGB(255, 238, 238, 238),
                                                                                  border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                      ), child:  Padding(
                                                                                           padding: const EdgeInsets.all(8.0),
                                                                               child:  
                                                                                   selected.value[index] == true ?
                                                                                    FutureBuilder(
                                                                                      future: Supabase.instance.client.from('materials').select().eq('id', tapIndexNotifier.value ?? tapIndexes[index] ?? 'Select a material...').maybeSingle(),


                                                                                  builder: (context, snapshot) {
                                                                                 
                                                                                   
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
                                                                                   final data = snapshot.data ?? {};
                                                                                   tapIndexes[index] = tapIndexNotifier.value ?? tapIndexes[index] ?? -1;
                                                                                   
                                                                                   if (data.isEmpty){
                                                                                  return Center(child: Text('Select a material...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),));
                                                                                     }
                                                                                   
                                                                                      return Center(child: Text(truncateWithEllipsis(31, data['name'] ?? 'Select a material...'), style: TextStyle(fontFamily: 'Inter', color: Colors.black, 
                                                                                    fontSize:  (data['name'] == null || data['name'].toString().isEmpty)
    ? 16.5
    : fontSizeBasedOnLength(data['name'].toString())),));
                                                                                      }
                                                                                     )
                                                                                     : 
                                                                                     FutureBuilder(
                                                                                    future: Supabase.instance.client.from('materials').select().eq('id', tapIndexes[index] ?? -1).maybeSingle(),
                                                                                 builder: (context, asyncSnapshot) {
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
                                                                                       final data = asyncSnapshot.data ?? {};
                                                                                if (data.isEmpty){
                                                                             return Center(child: Text('Select a material...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),));
                                                                              }
                                                                             return Center(
                                                                               child: Text(tapIndexes[index] == -1 ? 'Select a material...' : truncateWithEllipsis(31, data['name'] ?? 'Select a material...'), 
                                                                               style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 
                                                                                 (data['name'] == null || data['name'].toString().isEmpty)
    ? 16.5
    : fontSizeBasedOnLength(data['name'].toString())),),
                                                                             ); }
                                                                                                                                                                                                ),
                                                                                                                                                                   
                                                                                                                                                                    ),
                                                                                                                                                                  );
                                                                                                   }
                                                                                                 );
                                                                                               }
                                                                                             ),
                                                                 SizedBox(height: 10,),
                                                                                           ],
                                                                                         ),
                                                                                               
                                                                              
                                                              SizedBox(width: 15),
                                                                                Column(
                                                                                 children: [
                                                                                   Container(
                                                                                     width: 190,
                                                                                     height: 49 ,
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(15),
                                                 color: const Color.fromARGB(255, 238, 238, 238),
                                                 border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.all(0),
                                                 child: Column(
                                                   children: [
                                                        Row(
                                                       children: [
                                                      
                                                    selected.value[index] == true ?
                                                                      FutureBuilder(
                                                                        // processer
                                                                        future: Supabase.instance.client.from('process').select() ,
                                                                       
                                                                        builder:(context, snapshot) {
                                                                       
                                                                            if (snapshot.connectionState != ConnectionState.done ||
        snapshot.hasError) {
      return Center(child: Text('Loading...', style: TextStyle(fontFamily: 'Inter', fontSize: 16.5),));
      
    }
                                                                        
                                                                          final data = snapshot.data ?? [];

                                                                          
                                                                          return ValueListenableBuilder(
                                                                            valueListenable: selectedProcess,
                                                                            builder: (context, value, child) {
                                                                              return DropdownButtonHideUnderline(
                                                                                child: Column(
                                                                                  children: [
                                                                                     Row(
                                                                                      children: [
                                                                                        SizedBox(width: 10,),
                                                                                        DropdownButton(
                                                                                          value: processed[index] == 'Select a process...' ? selectedProcess.value  : processed[index],
                                                                                          
                                                                                          items: [
                                                                                            DropdownMenuItem(
                                                                                              value: 'Select a process...',
                                                                                              child: Center(
                                                                                                child: Text('Select a process...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5
                                                                                                ,),),
                                                                                              )),
                                                                                              ...data.map((entry){
                                                                                                return DropdownMenuItem(
                                                                                                  value: entry['description']  ?? 'N/A',
                                                                                                  child: Center(child: Text(truncateWithEllipsis(31, entry['description'] ?? 'N/A'), style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)));
                                                                                              })
                                                                                          ],
                                                                                           onChanged: (value){
                                                                                           selectedProcess.value = value!.toString();
                                                                                           processed[index] = selectedProcess.value;
                                                                                           print('combine: $combine ${combine[selectedValues[index].toString()]}');
                                                                                    // Check if selectedValues[index] is a value anywhere in combine
                                                                                    final step = selectedValues[index];

for (int i = 0; i < selectedValues.length; i++) {
  if (selectedValues[i] == step) {
    processed[i] = selectedProcess.value;
    print('✅ Synced processed[$i] = ${selectedProcess.value}');
  }
}
// if (combine.values.contains(selectedValues[index].toString())) {
//   // Update processed at the current index (or key)
//   processed[selectedValues[index]!] = selectedProcess.value;
//   print('Updated processed[${selectedValues[index]}] to $selectedProcess.value');
// }
setLocallyState(() {
  
},);
                                                                                           }),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                                );
                                                                            }
                                                                          );
                                                                        },
                                                                        )
                                                                      :
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(height: 10,),
                                                                          Row(
                                                                            children: [
                                                                              SizedBox(width: 10,),
                                                                              Center(child: Text(truncateWithEllipsis(31,  processed[index] ?? 'Select a process...') ,style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ) 
                                                       ],
                                                     ),
                                                     
                                                   ],
                                                 ),
                                               ),
                                                                                    ),
                                                                                    
                                                                                     SizedBox(height: 10,),]),
                                                                                                                        
                                                     SizedBox(width: 5,),          
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                          onPressed: index == 0 ? null : () async {
                                                                           
                                                                            selectedValues.removeAt(index);
                                                                              selected.value.remove(index);
                                                                              tapIndexes.remove(index);
                                                                        ;                                                                          fromTo.remove(index);
                                                                              processed.remove(index);
                                                                            setLocallyState(() {
                                                                              
                                                                            },);
                                                                          },
                                                                         icon: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 112, 102))),
                                                                    
                                                                       SizedBox(width: 15,),
                                                                         DropdownButtonHideUnderline(child: DropdownButton(
                                                                          value: combine[index.toString()],
                                                                          items: [
                                                                            DropdownMenuItem(
                                                                              value: 'Default',
                                                                              child: Icon(Icons.join_full_sharp, color: const Color.fromARGB(255, 255, 218, 108), size: 30)),
                                                                              ...selectedValues.toSet().map((entry){
                                                                                                return DropdownMenuItem(
                                                                                                  value: entry.toString(),
                                                                                                  child: Center(child: Text('$entry', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)));
                                                                                              })
                                                                          ], 
                                                                          onChanged: (value){
                                                                            setLocalState(() {
                                                                            
                                                                              combine[index.toString()] = value!.toString();
                                                                             combine[index.toString()] == 'Default' ? selectedValues[index] = index+1:
                                                                              selectedValues[index] = int.parse(combine[index.toString()] ?? '-1');
                                                                          for (int i = 0; i < selectedValues.length; i++) {
  if (i != index && selectedValues[i] == selectedValues[index]) {
    combine[i.toString()] = value;
    print('raw $processed index ${processed[index]} i ${processed[i]}');

    processed[index] = processed[i]!;
    selectedProcess.value = processed[i]!;
    print('process $processed and ${selectedProcess.value}'); // sync to the existing value
    print('🔗 Synced combine[$index] = ${processed[index]} from [$i]');
    
    break; // break after syncing to the first match
  }
}
//                                                                               if (selectedValues.contains(int.parse(combine[index.toString()]!))) {
//  combine[selectedValues[index].toString()] = value;
//   print('Updated processed[${selectedValues[index]}] to $selectedProcess.value');
// }
                                                                            });
                                                                           setState(() {
                                                                             
                                                                           });
                                                                          })),
                                                                     SizedBox(height: 13,)
                                                                  ],
                                                                ),
                                                                  ],
                                                                    ),
                                                                                    ],
                                            ), 
                                                                                          
                                                                                       ValueListenableBuilder(
                                                                                       valueListenable: selectedProcess,
                                                                                       builder: (context, value, child) {
                                                                                         return FutureBuilder<List<dynamic>>(
                                                                                                                                                  future:
                                                                                                                                                  Future.wait([
                                                                                                                                                   Supabase.instance.client.from('route').select().or('disabled.is.null,disabled.not.eq.true').eq('material_route', namerNotifier.value ?? 'Hi'
                                                                                                                                                   ).eq('step', index+1).maybeSingle(),
                                                                                                                                                   Supabase.instance.client.from('process').select().eq('description', processed[index] ?? 'Hi').maybeSingle(),
                                                                                                                                                   Supabase.instance.client.from('process').select()

                                                                                                                                                  ]),
                                                                                                                                                builder: (context, snapshot) {
                                                                                                                                                  final data = snapshot.data?[0] ?? {};
                                                                                                                                                  final   data2 = snapshot.data?[1] ?? {};
                                                                                                                                                  final List<dynamic> datas = snapshot.data?[2] ?? [];
                                                                                                                                                  if (fromTo[index]?['From'] == null){
                                                                                                                                                 fromTo[index] = {};
                                                                                                                                                  }
                                                                                                                                                  if (data2['matmov'] == true) {
                                                                                                                                                    return Row(children: [
                                                                                                                                          Container(
                                                                                         width: 190,
                                                                                         height: 41 ,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                                      color: const Color.fromARGB(255, 238, 238, 238),
                                                                                                                                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                                                                                    ),
                                                                                                                                    child: Padding(
                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                       child: 
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      DropdownButtonHideUnderline(
                                                                                                                                       child: DropdownButton(
                                                                                                                                         value: fromTo[index]?['From'] ?? 'From',
                                                                                                                                         items: [
                                                                                                                                           DropdownMenuItem(
                                                                                                                                             value: 'From',
                                                                                                                                             child: Text('From')
                                                                                                                                             ),
                                                                                                                                             ...datas.map((entry) {
                                                                                                                                              return DropdownMenuItem(
                                                                                                                                             value: entry['description'] ?? 'N/A',
                                                                                                                                             child: Text(truncateWithEllipsis(25, entry['description'] ?? 'N/A'))
                                                                                                                                             );}),
                                                                                                                                         ],
                                                                                                                                         onChanged: (value){
                                                                                                                                           fromTo[index]?['From'] = value!.toString();
                                                                                                                                           setLocallyState((){});
                                                                                                                                       
                                                                                                                                         }
                                                                                                                                         )),
                                                                                                                                    ),
                                                                                                                                                                         ),
                                                                                               SizedBox(width: 15,),    
                                                                                                                                 Container(
                                                                                         width: 190,
                                                                                         height: 41 ,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                                      color: const Color.fromARGB(255, 238, 238, 238),
                                                                                                                                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                                                                                    ),
                                                                                                                                    child: Padding(
                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                      child: DropdownButtonHideUnderline(
                                                                                                                                       child: DropdownButton(
                                                                                                                                         value:  fromTo[index]?['To'] ?? 'To',
                                                                                                                                         items: [
                                                                                                                                           DropdownMenuItem(
                                                                                                                                             value: 'To',
                                                                                                                                             child: Text('To')
                                                                                                                                             ),
                                                                                                                                             ...datas.map((entry) {
                                                                                                                                              return DropdownMenuItem(
                                                                                                                                             value: entry['description'] ?? 'N/A', 
                                                                                                                                             child: Text(truncateWithEllipsis(25, entry['description'] ?? 'N/A'))
                                                                                                                                             );}),
                                                                                                                                         ],
                                                                                                                                         onChanged: (value){
                                                                                                                                          
                                                                                                                                          fromTo[index]?['To'] = value!.toString();
                                                                                                                                            setLocallyState((){});
                                                                                                                                         }
                                                                                                                                         )),
                                                                                                                                    ),
                                                                                                                                    
                                                                                                                                                                         ), 
                                                                                         SizedBox(width: 55,),          
                                                                                                                                                     Column(
                                                                                                                                                       children: [
                                                                                                                                                        
                                                                                                                                                          SizedBox(height: 13,)
                                                                                                                                                       ],
                                                                                                                                                     ),                     
                                                                                                                                                    ],);
                                                                                                                                                  } else {
                                                                                                                                                    return SizedBox.shrink();
                                                                                                                                                  }
                                                                                                                                                  
                                                                                                                                                }
                                                                                                                                              );
                                                                                       }
                                                                                     ),
                                                     SizedBox(height: 15,)
                                          ],
                                      ); }),
                                      // add edit button
                                       ValueListenableBuilder(
                                         valueListenable: selectedProcess,
                                         builder: (context, value, child) {
                                           return ValueListenableBuilder(
                                             valueListenable: tapIndexNotifier,
                                             builder: (context, value, child) {
                                               return Align(
                                                alignment: Alignment.topLeft,
                                                 child: Container(
                                                                width: 50,
                                                                  height: 50,
                                                                     decoration: BoxDecoration(
                                                                 shape: BoxShape.circle,
                                                                 color:  const Color.fromARGB(255, 214, 214, 214),  ),
                                                                     child: Center(
                                                                          child: IconButton(
                                                                          onPressed: (){
                                                                            setLocallyState(() {
                                                                              
                                                                            },);
                                                                            final original = tapIndexes[0];
                                                                            selected.value.updateAll((key, value) => value = false);
                                                                   
                                                                              selected.value[selectedValues.length] = true;
                                                                          
                                                                             selectedValues.add(selectedValues.length+1);
                                                                            
                                                                              
                                                                           
                                                                            tapIndexes[selectedValues.length] = -1;
                                                                           tapIndexNotifier.value = null;
                                                                           selectedProcess.value = 'Select a process...';
                                                                           processed[selectedValues.length-1] = 'Select a process...';
                                                                         
                                                                           tapIndexes[0] = original!;
                                                                           
                                                                             setLocallyState(() {
                                                                              
                                                                            },);
                                                                                     setState(() {
                                                
                                                                                     });
                                                                                    },
                                               icon: Icon(Icons.add),
                                                                                 )
                                                                               
                                                                                 )));
                                             }
                                           );
                                         }
                                       )]);
                                       
                                    }
                                  ),
                                
                                    
                                   ] ) )
                                     ),
                         ),
                       ),
                     ),
                  
                 SizedBox(height: 30,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                  SizedBox(width: 200,),
                           
                      SizedBox(width: 10),
                           
                  ],
                 ),
                   ],
                 );
               }
             ),
                  ])
    ],
                ),
           ),
        ));
      
   } ));
   
    
  
}
Timer? _debounce;
void disposer() {
  _debounce?.cancel();
  searchMController.dispose();
  super.dispose();
}


String? fromm;
String? too;


// final response = await Supabase.instance.client.from('route').select().eq('material_route', entry);



// for (final entrye in response){
//   selectedValues.add(entrye['process']);
//   fromm = entrye['from_route'];
//     too = entrye['to_route'];
//   fromToTo[entrye['from_route']] = entrye['to_route'];
//   final response1 = await Supabase.instance.client.from('materials').select().eq('name', entrye['material']).single();
//   print('r11111 $response1');
//   selectedIndex.add(response1['id']);
// }


void routePopUp(){
 showDialog(
  barrierDismissible: false,
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

      return AlertDialog(
        
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0),
      content: 
        Container(
          height: 1000,
          width: 1520,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),child:  Padding(
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
                  child: Icon(Icons.fork_left
                  ,  size: 30),
                ),
                SizedBox(width: 10),
                ValueListenableBuilder(
                  valueListenable: snackbarNotifier,
                  builder: (context, value, child) {
                    return Column( 
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( 'Create Route', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold, 
                        fontSize: 22, fontFamily: 'Inter' )),
                        SizedBox(height: 4),
                        Text( "Fill out the route below.",
                         style:  TextStyle(color: Colors.grey, fontSize: 15, fontFamily:  'Inter' ),)
                      ],
                    );
                  }
                ),
                SizedBox(width: 30),
                // Container(
                //   width: 350, 
                //   height: 40,
                //   decoration: BoxDecoration(
                //     border: Border.all(width: 1, color: Colors.blue),
                //   ),
                //   child: TextField(
                //     controller: namec,
                //   )
                // ),
                Spacer(),
                    Text(sucessText, style: TextStyle(fontFamily: 'Inter', color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(width: 20,) ,
                      MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ValueListenableBuilder(
                  valueListenable: tapIndexNotifier,
                  builder: (context, tapIndex, _) {
                    return ValueListenableBuilder(
                      valueListenable: namerNotifier,
                      builder: (context, namer, _) {
                        return GestureDetector(
                        onTap: () async {
                       
                        selectedValues.clear();
                                      selectedValues = [1];
                        selected.value = {0: true};
                        processed = {0 : 'Select a process...'};
                           selectedProcess.value = 'Select a process...';
                                    tapIndex = null;
                                    materialRoute.clear();
                                    tapIndexNotifier.value = null;
                        setLocalState(() {
                          Navigator.pop(context);
                        
                        },);
                                      
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
print('selectedV: $selectedValues');
    return ValueListenableBuilder<int?>(
      valueListenable: tapIndexNotifier,
      builder: (context, tapIndex, _) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () async {
           if (
  processed.containsValue('Select a process...') ||
  tapIndexes.containsValue(null) ||
  fromTo.values.any((innerMap) => 
    innerMap.containsValue('From') || innerMap.containsValue('To')
  )
) {
  setLocalState(() {
  errorText = "Please don't leave a field blank";
});

Future.delayed(Duration(seconds: 5), () {
  setLocalState(() {
    errorText = '';
  });
});
            } else if (!selectedValues.contains(1) || gapsPresent() == true
            ){
              setLocalState(() {
                errorText = 'Step sequence is incomplete. Make sure Step 1 exists and all steps are in order without gaps.';
              Future.delayed(Duration(seconds: 5), () {
  setLocalState(() {
    errorText = '';
  });
});
             } );

} else {
            materialRoutePopUp(setLocalState);
}
           
         
               setState(() {
 });
            },
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 142, 204, 251),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child:  Text( 'Add',
                  style: TextStyle(fontFamily: 'Inter')),
               
              ),
            ),
          ),
        );
      }
    );
  },
),
SizedBox(width: 30),
                ValueListenableBuilder(
                  valueListenable: tapIndexNotifier,
                  builder: (context, tapIndex, _) {
                    return ValueListenableBuilder(
                      valueListenable: selectedProcess,
                      builder: (context, value, child) {
                        return ValueListenableBuilder(
                          valueListenable: selected,
                          builder: (context, value, _) {
                            return IconButton(
                              onPressed: () async { 
                            selectedValues = [1];
                            selected.value = {0: true};
                           processed = {0 : 'Select a process...'};
                           selectedProcess.value = 'Select a process...';
                                        selectedIndex.clear();
                                        fromTo.clear();
                                        materialRoute.clear();
                            setLocalState(() {
                              Navigator.pop(context);
                              tapIndexNotifier.value = null;
                                            selectedP = 'Process';
                            
                            },);
                              }, 
                              icon: Icon(Icons.close),
                              );
                          }
                        );
                      }
                    );
                  }
                )
              ],),  

              SizedBox(height: 10),
              Divider(thickness: 1),
              Center(child: Text(errorText, style: TextStyle(color: Colors.red, fontFamily: 'Inter'),)),
               Row(
                 children: [
                  SizedBox(width: 30,),
                   Text('Material', style: TextStyle(fontFamily: 'WorkSans', 
                                fontWeight: FontWeight.bold,
                                color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),),
                                SizedBox(width: 30,),
                                             Container(
                    width: 400,
                    height: 40,
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
                                SizedBox(width: 600),
                                    Center(child: Text('Steps', style: TextStyle(fontFamily: 'WorkSans', 
             fontWeight: FontWeight.bold,
             color:  const Color.fromARGB(255, 0, 75, 132), fontSize: 21 ),)),
             SizedBox(width: 15),
           
                   SizedBox(width: 5),
                   
                 ],
               ),
             empty ? Text('Error! Please choose both a material and process.', style: TextStyle(color: const Color.fromARGB(255, 255, 53, 53), 
             fontFamily: 'Inter'
             ),) : SizedBox.shrink(),
             SizedBox(height: 10,),
                Row(
                  children: [

  Expanded(
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
                    
                     child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: SizedBox(
                    width: MediaQuery.of(context).size.width * 2, 
                      
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
                SizedBox(
                  height: 500,
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
                                          Row(
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
                                            onChanged: (bool? checked) {
                                              if (checked == true) {
                                            
                                                tapIndexNotifier.value = entry['id'];
                                              } else {
                                                setLocalState(() {
                                                  
                                                },);
                                                tapIndexNotifier.value = null;
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
               
              
                
               
           StatefulBuilder(
               builder: (context, setLocallyState) {
                 return Column(
                   children: [
                          
                   SizedBox(width: 200),
                    SizedBox(height: 10,),
//                
                    Align(
                      alignment: Alignment.topCenter,
                           
                       child: SizedBox(
                        height: 500,
                         child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                           child: Container(
                           
                            child: Padding(
                              padding: EdgeInsets.all(13),
                              child: Column(
                                children: [
                                  selectedValues.isEmpty ? Row(
                                    children: [
                                      SizedBox(width: 600,)
                                    ],
                                  ) :
                                  ValueListenableBuilder(
                                    valueListenable: selected,
                                    builder: (context, value, child) {
                                      return Column(
                                         mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        // add new
                                        
                                        ...List.generate(selectedValues.length, (index) {
                                        
                          

  String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
}
                                        double fontSizeBasedOnLength(String text) {
  if (text.length > 15){
    return 13.5;
  }
   else if (text.length > 30){
    return 10.00;
  } else {
    return 17;
  }
}

                                            return 
                                        Column(
                                         
                                          children: [
                                            SizedBox(width: 50),
                                            Row(
                                              children: [
                                                Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                          SizedBox(height: 10), 
                                                                                          // new gesture  
                                                                                        MouseRegion(
                                                                                          cursor: SystemMouseCursors.click,
                                                                                          child: ValueListenableBuilder(
                                                                                            valueListenable: selectedProcess,
                                                                                            builder: (context, value, child) {
                                                                                              return ValueListenableBuilder(
                                                                                                valueListenable: tapIndexNotifier,
                                                                                                builder: (context, value, child) {
                                                                                                  return GestureDetector(
                                                                                                     onTap: (){

                                                                                                        selectedProcess.value = processed[index] ?? 
                                                                                                       
                                                                                                 'Select a process....';
                                                                                               
                                                                                                    selected.value.updateAll((key, _) => false);
                                                                                                  selected.value[index] = true;
                                                                                                  selected.notifyListeners(); 
                                                                                                  tapIndexNotifier.value = tapIndexes[index];
                                                                                                
                                                                                                
                                                                                                     setState(() {
                                                                                                       
                                                                                                     });
                                                                                                
                                                                                                    },
                                                                                                    child: Container(
                                                                                                      width: 50,
                                                                                                      height: 50,
                                                                                                      decoration: BoxDecoration(
                                                                                                        shape: BoxShape.circle,
                                                                                                        color: selected.value[index] == true ? const Color.fromARGB(255, 121, 195, 255) : const Color.fromARGB(255, 193, 223, 247),
                                                                                                      ),
                                                                                                      child: Center(child: Text('${selectedValues[index]}', style: TextStyle(fontSize: 20, fontFamily: 'Inter',
                                                                                                        color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),),)
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              );
                                                                                            }
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(height: 20),   
                                                                                                 
                                                                                        ]),
                                            
                                                                                       SizedBox(width: 10,),
                                                                                         Column(
                                                                                           children: [
                                                                                             ValueListenableBuilder(
                                                                                               valueListenable: tapIndexNotifier,
                                                                                               builder: (context, value, child) {
                                                                                                
                                                                                                 return ValueListenableBuilder(
                                                                                                   valueListenable: selected,
                                                                                                   builder: (context, value, child) {
                                                                                                  
                                                                                                     return Container(
                                                                                                       width: 190,
                                                                                                       height: 49,
                                                                                                              decoration: BoxDecoration(
                                                                                                             borderRadius: BorderRadius.circular(15),
                                                                                    color:  const Color.fromARGB(255, 238, 238, 238),
                                                                                  border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                      ), child:  Padding(
                                                                                           padding: const EdgeInsets.all(8.0),
                                                                               child:  
                                                                                   selected.value[index] == true ?
                                                                                    FutureBuilder(
                                                                                      future: Supabase.instance.client.from('materials').select().eq('id', tapIndexNotifier.value ?? -1).maybeSingle(),


                                                                                  builder: (context, snapshot) {
                                                                                 
                                                                                   

                                                                                   final data = snapshot.data ?? {};
                                                                                   tapIndexes[index] = tapIndexNotifier.value ?? -1;
                                                                                   if (data.isEmpty){
                                                                                  return Center(child: Text('Select a material...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),));
                                                                                     }
                                                                                     tapIndexes[index] = tapIndexNotifier.value ?? -1;
                                                                                      return Center(child: Text(truncateWithEllipsis(31, data['name'] ?? 'Select a material...'), style: TextStyle(fontFamily: 'Inter', color: Colors.black, 
                                                                                    fontSize: data['name'] == null ? 16.5 : fontSizeBasedOnLength(data['name'])),));
                                                                                      }
                                                                                     )
                                                                                     : tapIndexes[index] != null ? FutureBuilder(
                                                                                    future: Supabase.instance.client.from('materials').select().eq('id', tapIndexes[index] ?? -1).maybeSingle(),
                                                                                 builder: (context, asyncSnapshot) {
                                                                                       final data = asyncSnapshot.data ?? {};
                                                                                if (data.isEmpty){
                                                                              Center(child: Text('Select a material...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),));
                                                                              }
                                                                             return Center(
                                                                               child: Text(tapIndexes[index] == -1 ? 'Select a material...' : truncateWithEllipsis(31, data['name'] ?? 'Select a material...') ,
                                                                               style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize:
                                                                               data['name'] == null ? 16.5 : 
                                                                                fontSizeBasedOnLength(data['name'])),),
                                                                             ); }
                                                                                                                                                                                                ) : Center(
                                                                               child: Text('Select a material...',
                                                                               style: TextStyle(fontFamily: 'Inter', color: Colors.black,),
                                                                                                                                                                   
                                                                                                                                                                    ),
                                                                                                                                                                  )));
                                                                                                   }
                                                                                                 );
                                                                                               }
                                                                                             ),
                                                                 SizedBox(height: 10,),
                                                                                           ],
                                                                                         ),
                                                                                               
                                                                              
                                                              SizedBox(width: 15),
                                                                                Column(
                                                                                 children: [
                                                                                   Container(
                                                                                     width: 190,
                                                                                     height: 49 ,
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(15),
                                                 color: const Color.fromARGB(255, 238, 238, 238),
                                                 border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.all(0),
                                                 child: Column(
                                                   children: [
                                                     Row(
                                                       children: [
                                                      
                                                    selected.value[index] == true ?
                                                                      FutureBuilder(
                                                                        // processer
                                                                        future: Supabase.instance.client.from('process').select() ,
                                                                       
                                                                        builder:(context, snapshot) {
                                                                       
                                                                            if (snapshot.connectionState != ConnectionState.done ||
        snapshot.hasError) {
      return Center(child: Text('Loading...', style: TextStyle(fontFamily: 'Inter', fontSize: 16.5),));
      
    }
                                                                        
                                                                          final data = snapshot.data ?? [];

                                                                          
                                                                          return ValueListenableBuilder(
                                                                            valueListenable: selectedProcess,
                                                                            builder: (context, value, child) {
                                                                              return DropdownButtonHideUnderline(
                                                                                child: Column(
                                                                                  children: [
                                                                                     Row(
                                                                                      children: [
                                                                                        SizedBox(width: 10,),
                                                                                        DropdownButton(
                                                                                          value: processed[index] == 'Select a process...' ? selectedProcess.value  : processed[index],
                                                                                          
                                                                                          items: [
                                                                                            DropdownMenuItem(
                                                                                              value: 'Select a process...',
                                                                                              child: Center(
                                                                                                child: Text('Select a process...', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5
                                                                                                ,),),
                                                                                              )),
                                                                                              ...data.map((entry){
                                                                                                return DropdownMenuItem(
                                                                                                  value: entry['description']  ?? 'N/A',
                                                                                                  child: Center(child: Text(truncateWithEllipsis(31, entry['description'] ?? 'N/A'), style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)));
                                                                                              })
                                                                                          ],
                                                                                           onChanged: (value){
                                                                                           selectedProcess.value = value!.toString();
                                                                                           processed[index] = selectedProcess.value;
                                                                                           print('combine: $combine ${combine[selectedValues[index].toString()]}');
                                                                                    // Check if selectedValues[index] is a value anywhere in combine
                                                                                    final step = selectedValues[index];

for (int i = 0; i < selectedValues.length; i++) {
  if (selectedValues[i] == step) {
    processed[i] = selectedProcess.value;
    print('✅ Synced processed[$i] = ${selectedProcess.value}');
  }
}
// if (combine.values.contains(selectedValues[index].toString())) {
//   // Update processed at the current index (or key)
//   processed[selectedValues[index]!] = selectedProcess.value;
//   print('Updated processed[${selectedValues[index]}] to $selectedProcess.value');
// }
setLocallyState(() {
  
},);
                                                                                           }),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                                );
                                                                            }
                                                                          );
                                                                        },
                                                                        )
                                                                      :
                                                                      Column(
                                                                        children: [
                                                                          SizedBox(height: 10,),
                                                                          Row(
                                                                            children: [
                                                                              SizedBox(width: 10,),
                                                                              Center(child: Text(truncateWithEllipsis( 31, processed[index] ?? 'Select a process...') ,style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ) 
                                                       ],
                                                     ),
                                                     
                                                   ],
                                                 ),
                                               ),
                                                                                    ),
                                                                                    
                                                                                     SizedBox(height: 10,),]),
                                                                                                                        
                                                     SizedBox(width: 5,),          
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        IconButton(
                                                                         onPressed: index == 0 ? null : () async {


  
  selectedValues.removeAt(index);
  selected.value.remove(index);
  fromTo.remove(index);
  tapIndexes.remove(index);
  processed.remove(index);
  combine.remove(index.toString());
  
delete[index] = true;
  // void shiftKeysDownFrom(Map map, int deletedIndex) {
  //   final keysToShift = map.keys
  //       .where((key) => int.tryParse(key.toString()) != null)
  //       .map((key) => int.parse(key.toString()))
  //       .where((k) => k > deletedIndex)
  //       .toList()
  //     ..sort(); // ascending


  //   for (final oldKey in keysToShift) {
  //     final newKey = oldKey - 1;
  //     map[newKey.toString()] = map.remove(oldKey.toString());
    
  //   }
  // }

  // shiftKeysDownFrom(selected.value, index);
  // shiftKeysDownFrom(fromTo, index);
  // shiftKeysDownFrom(tapIndexes, index);
  // shiftKeysDownFrom(processed, index);
  // shiftKeysDownFrom(combine, index);



  setLocallyState(() {});
},
                                                                         icon: Icon(Icons.delete, color: const Color.fromARGB(255, 255, 112, 102))),
                                                                         SizedBox(width: 15,),
                                                                         DropdownButtonHideUnderline(child: DropdownButton(
                                                                          value: combine[index.toString()],
                                                                          items: [
                                                                            DropdownMenuItem(
                                                                              value: 'Default',
                                                                              child: Icon(Icons.join_full_sharp, color: const Color.fromARGB(255, 255, 218, 108), size: 30)),
                                                                              ...selectedValues.toSet().map((entry){
                                                                                                return DropdownMenuItem(
                                                                                                  value: entry.toString(),
                                                                                                  child: Center(child: Text('$entry', style: TextStyle(fontFamily: 'Inter', color: Colors.black, fontSize: 16.5),)));
                                                                                              })
                                                                          ], 
                                                                          onChanged: (value){
                                                                            setLocalState(() {
                                                                            
                                                                              combine[index.toString()] = value!.toString();
                                                                             combine[index.toString()] == 'Default' ? selectedValues[index] = index+1:
                                                                              selectedValues[index] = int.parse(combine[index.toString()] ?? '-1');
                                                                                  for (int i = 0; i < selectedValues.length; i++) {
      if (i != index && selectedValues[i] == selectedValues[index]) {
        combine[i.toString()] = value;
        
    processed[index] = processed[i]!;
    selectedProcess.value = processed[i]!;
        print('🔗 Synced combine[$i] = $selected');
      }
    }
//                                                                               if (selectedValues.contains(int.parse(combine[index.toString()]!))) {
//  combine[selectedValues[index].toString()] = value;
//   print('Updated processed[${selectedValues[index]}] to $selectedProcess.value');
// }
                                                                            });
                                                                           setState(() {
                                                                             
                                                                           });
                                                                          }))
                                                                      ],
                                                                    ),
                                                                     SizedBox(height: 13,)
                                                                  ],
                                                                ),
                                                                                    ],
                                            ), 
                                                                                          
                                                                                   ValueListenableBuilder(
                                                                                       valueListenable: selectedProcess,
                                                                                       builder: (context, value, child) {
                                                                                         return FutureBuilder<List<dynamic>>(
                                                                                                                                                  future:
                                                                                                                                                  Future.wait([
                                                                                                                                                   Supabase.instance.client.from('route').select().eq('material_route', namerNotifier.value ?? 'Hi'
                                                                                                                                                   ).eq('step', index+1).or('disabled.is.null,disabled.not.eq.true').maybeSingle(),
                                                                                                                                                   Supabase.instance.client.from('process').select().eq('description', processed[index] ?? 'Hi').maybeSingle(),
                                                                                                                                                   Supabase.instance.client.from('process').select()

                                                                                                                                                  ]),
                                                                                                                                                builder: (context, snapshot) {
                                                                                                                                                  final data = snapshot.data?[0] ?? {};
                                                                                                                                                  final   data2 = snapshot.data?[1] ?? {};
                                                                                                                                                  final List<dynamic> datas = snapshot.data?[2] ?? [];
                                                                                                                                                  if (fromTo[index]?['From'] == null){
                                                                                                                                                 fromTo[index] = {};
                                                                                                                                                  }
                                                                                                                                                  if (data2['matmov'] == true) {
                                                                                                                                                    return Row(children: [
                                                                                                                                          Container(
                                                                                         width: 190,
                                                                                         height: 41 ,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                                      color: const Color.fromARGB(255, 238, 238, 238),
                                                                                                                                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                                                                                    ),
                                                                                                                                    child: Padding(
                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                       child: 
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      DropdownButtonHideUnderline(
                                                                                                                                       child: DropdownButton(
                                                                                                                                         value: fromTo[index]?['From'] ?? 'From',
                                                                                                                                         items: [
                                                                                                                                           DropdownMenuItem(
                                                                                                                                             value: 'From',
                                                                                                                                             child: Text('From')
                                                                                                                                             ),
                                                                                                                                             ...datas.map((entry) {
                                                                                                                                              return DropdownMenuItem(
                                                                                                                                             value: entry['description'] ?? 'N/A',
                                                                                                                                             child: Text(truncateWithEllipsis(25, entry['description'] ?? 'N/A'))
                                                                                                                                             );}),
                                                                                                                                         ],
                                                                                                                                         onChanged: (value){
                                                                                                                                           fromTo[index]?['From'] = value!.toString();
                                                                                                                                           setLocallyState((){});
                                                                                                                                       
                                                                                                                                         }
                                                                                                                                         )),
                                                                                                                                    ),
                                                                                                                                                                         ),
                                                                                               SizedBox(width: 15,),    
                                                                                                                                 Container(
                                                                                         width: 190,
                                                                                         height: 41 ,
                                                                                                                                    decoration: BoxDecoration(
                                                                                                                                      borderRadius: BorderRadius.circular(15),
                                                                                                                                      color: const Color.fromARGB(255, 238, 238, 238),
                                                                                                                                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 215, 214, 214)),
                                                                                                                                    ),
                                                                                                                                    child: Padding(
                                                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                                                      child: DropdownButtonHideUnderline(
                                                                                                                                       child: DropdownButton(
                                                                                                                                         value:  fromTo[index]?['To'] ?? 'To',
                                                                                                                                         items: [
                                                                                                                                           DropdownMenuItem(
                                                                                                                                             value: 'To',
                                                                                                                                             child: Text('To')
                                                                                                                                             ),
                                                                                                                                             ...datas.map((entry) {
                                                                                                                                              return DropdownMenuItem(
                                                                                                                                             value: entry['description'] ?? 'N/A', 
                                                                                                                                             child: Text(truncateWithEllipsis(25, entry['description'] ?? 'N/A'))
                                                                                                                                             );}),
                                                                                                                                         ],
                                                                                                                                         onChanged: (value){
                                                                                                                                          
                                                                                                                                          fromTo[index]?['To'] = value!.toString();
                                                                                                                                            setLocallyState((){});
                                                                                                                                         }
                                                                                                                                         )),
                                                                                                                                    ),
                                                                                                                                    
                                                                                                                                                                         ), 
                                                                                         SizedBox(width: 55,),          
                                                                                                                                                     Column(
                                                                                                                                                       children: [
                                                                                                                                                        
                                                                                                                                                          SizedBox(height: 13,)
                                                                                                                                                       ],
                                                                                                                                                     ),                     
                                                                                                                                                    ],);
                                                                                                                                                  } else {
                                                                                                                                                    return SizedBox.shrink();
                                                                                                                                                  }
                                                                                                                                                  
                                                                                                                                                }
                                                                                                                                              );
                                                                                       }
                                                                                     ),
                                                     SizedBox(height: 15,)
                                          ],
                                      ); }),
                                      // add ebutton
                                       ValueListenableBuilder(
                                         valueListenable: selectedProcess,
                                         builder: (context, value, child) {
                                           return ValueListenableBuilder(
                                             valueListenable: tapIndexNotifier,
                                             builder: (context, value, child) {
                                               return Align(
                                                alignment: Alignment.topLeft,
                                                 child: Container(
                                                                width: 50,
                                                                  height: 50,
                                                                     decoration: BoxDecoration(
                                                                 shape: BoxShape.circle,
                                                                 color:  const Color.fromARGB(255, 214, 214, 214),  ),
                                                                     child: Center(
                                                                          child: IconButton(
                                                                          onPressed: (){
                                                                            setLocallyState(() {
                                                                              
                                                                            },);
                                                                            selected.value.updateAll((key, value) => value = false);
                                                                              selected.value[selectedValues.length] = true;
                                                                              
                                                                            selectedValues.add(selectedValues.last!+1);
                                                                            tapIndexes[selectedValues.length] = -1;
                                                                           tapIndexNotifier.value = null;
                                                                           selectedProcess.value = 'Select a process...';
                                                                           processed[selectedValues.length-1] = 'Select a process...';
                                                                           combine[(selectedValues.length-1).toString()] = 'Default';
                                                                             setLocallyState(() {
                                                                              
                                                                            },);
                                                                                     setState(() {
                                                
                                                                                     });
                                                                                    },
                                               icon: Icon(Icons.add),
                                                                                 )
                                                                               
                                                                                 )));
                                             }
                                           );
                                         }
                                       )]);
                                       
                                    }
                                  ),
                                
                                    
                                   ] ) )
                                     ),
                         ),
                       ),
                     ),
                  
                 SizedBox(height: 30,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                  SizedBox(width: 200,),
                           
                      SizedBox(width: 10),
                           
                  ],
                 ),
                   ],
                 );
               }
             ),
                  ])
    ],
                ),
           ),
        ));
      
   } ));
   
    
  
}
  @override
  Widget build(BuildContext context) {
            Map<String, List<Map<String, dynamic>>> groupedData = {};

              for (final entry in entries) {
                final material = entry['material'] as String? ?? 'Unknown';
          ids = entry['id'];
 process = entry['process'];
                if (!groupedData.containsKey(material)) {
                  groupedData[material] = [];
                }
                groupedData[material]!.add(Map<String, dynamic>.from(entry));
              }
           final uniqueMaterials = entries
           .where((entry) => entry['disabled'] != 'true')
    .map((e) => e['material_route'])
    .toSet()
    .toList();
  
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


   return 

 Scaffold(
          floatingActionButton: FloatingActionButton.extended(
          backgroundColor:  const Color.fromARGB(255, 193, 223, 247),
          onPressed: (){
          routePopUp();
          },
          
        icon: Icon(Icons.add, color:Color.fromARGB(255, 0, 74, 123),),
        label: Text('Add Route', style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),)
          ),
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
                          setState(() {
                           context.go('/admindashboard');
                            selected1 = true;
                            selected2 = false;
                            selected3 = false;
                            selected4 = false;
                            selected5 = false;
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
                            selected4 = false;
                             selected5 = false;
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
                            
                            selected1 = false;
                            selected2 = false;
                            selected3 = true;
                            selected4 = false;
                             selected5 = false;
                                selected6 = false;
       Navigator.push(
         context,
                                PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AdminData(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
         )
       );                 
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
                Text('Routes', style: TextStyle( fontFamily: 'Inter',
                  color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
              ],
                        ),
                         SizedBox(height: 20,),
                       Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: uniqueMaterials.length  + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                          if (index == uniqueMaterials.length) {
          return SizedBox.shrink();
        }
       final entry = uniqueMaterials[index];
       
       final routesForMaterial = entries
        .where((e) => e['material_route'] == entry)
        .toList();
       
       // Sort them by step
       routesForMaterial.sort((a, b) =>
         (a['step'] as int).compareTo(b['step'] as int));
              
              
       
       
         String truncateWithEllipsis(int cutoff, String myString) {
         return (myString.length <= cutoff) ? myString : '${myString.substring(0, cutoff)}...';
       }
                        return Padding(
              padding: EdgeInsets.all(10),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Material header row
                      Row(
                        children: [
                          Text(truncateWithEllipsis(72, entry), style: TextStyle(fontFamily: 'Inter', fontSize: 30)),
                          Spacer(),
                          ValueListenableBuilder(
                            valueListenable: tapIndexNotifier,
                            builder: (context, tapIndex, _) {
                              return IconButton(
                                onPressed: (){
                                 
                                 routeEditPopUp(entry);
                                },
                                icon: Icon(Icons.edit));
                            }
                          ),
                          SizedBox(width: 10),
                          IconButton(
                                onPressed: () {
                               
              final routeId = uniqueMaterials[index]; 
                               deletePopUp(routeId);
                                },
                                icon:  Icon(Icons.delete, color: Colors.red),
                              )
                            
                          
                      ] 
                      ),
              
                      SizedBox(height: 20),
                       
                      SizedBox(
                       width: 1450,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: routesForMaterial.map((routeEntry) {
                             double fontSizeBasedOnLength(String text) {
         if (text.length > 15){
        return 13.5;
         }
       else if (text.length > 30){
        return 10.00;
         } else {
        return 17;
         }
       }
       
                              return Row(
                                children: [
                                  SizedBox(width: 10),
                                  routeEntry['step'] == 1 ? SizedBox.shrink() : Icon(Icons.arrow_forward),
                                  routeEntry['material']  != entries[routeEntry['step'] - 1]['material'] ?
                                  Container(
                                    height: 40,
                                    width: 200,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 0, 98, 178),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:  Center(
                                    child: Text(
                                              truncateWithEllipsis(31, routeEntry['material'] ?? ''),
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
                                      child: Text(
                                        
                                        truncateWithEllipsis(31, routeEntry['process'] ?? ''),
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
                        );
                      },
                    ),
                  )
               ],
                    ),
        )
          ])
         
          ])
       );
  
    
  }
}
