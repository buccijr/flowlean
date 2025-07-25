
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart';
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
              'Success!',
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 15, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AddMaterial extends StatefulWidget {
  const AddMaterial({super.key});

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}
class _AddMaterialState extends State<AddMaterial> 
{List<Map<String, dynamic>> entries = [];
List<StreamSubscription> pageStreams = [];

int pageSize = 30;
int currentPage = 0;
bool isLoading = false;
bool hasMore = true;

final ScrollController _scrollController2 = ScrollController();

@override
void initState() {
  super.initState();
   _loadUserRole();
  // fetchNextPage();

  // _scrollController.addListener(() {
  //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
  //       !isLoading && hasMore) {
  //     fetchNextPage();
  //   }
  // });

  // Optional: Any periodic UI refresh
  // Timer.periodic(Duration(minutes: 1), (timer) {
  //   setState(() {
      // updateTotalTimeOnce();
  //   });
  // });

  // Optional: Listen to search bar changes
  searchMController.addListener(_onSearchChanged);
  searchPController.addListener(_onSearchChanged);
}
 final ScrollController _scrollController = ScrollController();

 
Future<void> fetchNextPage() async {
  if (isLoading || !hasMore) return;

  setState(() => isLoading = true);

  final from = currentPage * pageSize;
  final to = from + pageSize - 1;

  final response = await Supabase.instance.client
      .from('materials')
      .select()
      .order('id', ascending: false)
      .range(from, to);

  if (response.isEmpty) {
    setState(() {
      hasMore = false;
      isLoading = false;
    });
    return;
  }

  // Filter out duplicates (just in case)
  final newEntries = response.where((item) {
    final id = item['id'];
    return !entries.any((e) => e['id'] == id);
  }).toList();

  // Add new entries
  setState(() {
    entries.addAll(newEntries);
    currentPage++;
    isLoading = false;
  });

entries.sort((a, b) => a['name'].compareTo(b['name']));
  // Subscribe to realtime updates
  final pageIds = newEntries.map((e) => e['id'] as int).toList();
  subscribeToPageStream(pageIds);
}

void subscribeToPageStream(List<int> ids) {
  final sub = Supabase.instance.client
      .from('materials')
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
        entries.sort((a, b) => a['name'].compareTo(b['name']));
    }
  });

  pageStreams.add(sub);
}

@override
void dispose() {
  _scrollController.dispose();
 _scrollController2.dispose();
  for (final sub in pageStreams) {
    sub.cancel();
  }

  searchMController.removeListener(_onSearchChanged);
  searchPController.removeListener(_onSearchChanged);

  super.dispose();
}
int? hoverIndex;

bool canGo = true;
 bool selected1 = false;
bool  selected2 = true;
bool selected4 = false;
bool selected5 = false;
bool selected6 = false;
final ValueNotifier<bool> snackbarNotifier = ValueNotifier(false);

bool isMaterial = true;
bool isProcess = false;
bool selected3 = false;
Set<String> selectedButton = {'Material'};
bool process = false;
bool material = true;


TextEditingController nameController = TextEditingController();
TextEditingController searchMController = TextEditingController();
TextEditingController searchPController = TextEditingController();
TextEditingController descripController = TextEditingController();
TextEditingController skuController = TextEditingController();
TextEditingController dimentionController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController batchController = TextEditingController();
TextEditingController expController = TextEditingController();
TextEditingController dobController = TextEditingController();

TextEditingController processController =  TextEditingController();
TextEditingController locationPController = TextEditingController();
TextEditingController typeController = TextEditingController();
TextEditingController timePController = TextEditingController();
TextEditingController availibleController = TextEditingController();



Timer? _debounce;
void _onSearchChanged(){
  if (_debounce?.isActive ?? false) _debounce?.cancel();
_debounce = Timer(const Duration(milliseconds: 400), (){
  setState(() {
    
  });
});
}


void dispose2() {
  _debounce?.cancel();
  searchPController.dispose();  // 
  super.dispose();
}

void materialEditPopUp(entry) {
  TextEditingController nameController = TextEditingController(text: entry['name']);

TextEditingController descripController = TextEditingController(text: entry['description']);
TextEditingController skuController = TextEditingController(text: entry['sku']);
TextEditingController dimentionController = TextEditingController(text: entry['dimensions']);
TextEditingController locationController = TextEditingController(text: entry['location']);
TextEditingController batchController = TextEditingController(text: entry['batch']);
TextEditingController expController = TextEditingController(text: entry['expdate']);
TextEditingController dobController = TextEditingController(text: entry['dob']);

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
                Text('Add a material', textAlign: TextAlign.center,
                style: TextStyle(color:  const Color.fromARGB(255, 156, 211, 255), fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 21),),
                Spacer(),
                IconButton(
                  onPressed: (){
           dobController.clear();
                                                  skuController.clear();
                                                 descripController.clear();
                                                 dimentionController.clear();
                                                 locationController.clear();
                                                 batchController.clear();
                                                 expController.clear();
                                                 nameController.clear();
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
              height: 400,
              width: 450,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        Text('Name', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
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
                        controller: nameController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: 'Enter the name...',
                               contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                        ),
                        ),
                     
                      ),
                    ),
                  ],
                ),
                   SizedBox(height: 15,),
                    Column(
                      children: [
                        Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Text('SKU (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                  ],
                                ),
                     
                          
                        SizedBox(height: 10,),
                        
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
                    controller: skuController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Enter the SKU...',
                       contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                      floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                    ),
                    ),
                 
                  ),
                ),
                          ]),
                           ],
                    ),
                SizedBox(height: 15,),
                    Row(
                          children: [
                SizedBox(width: 30,),
                Text('Description (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 10,),
                     
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
                                controller: descripController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                                  labelText: 'Enter the description...',
                                  floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                ),
                                ),
                             
                              ),
                            ),
                          ],
                        ),
                          SizedBox(height: 15,),
                            Row(
                                  children: [
                        SizedBox(width: 30,),
                        Text('Dimensions (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                               
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
                                        controller: dimentionController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                                          labelText: 'Enter the dimensions...',
                                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                        ),
                                        ),
                                     
                                      ),
                                    ),
                                  ],
                                ),
                                  SizedBox(height: 15,),
                                 
                                    Row(
                                      children: [
                                           SizedBox(width: 30,),
                                        Text('Location (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                        SizedBox(height: 10,),
                                   
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
                                                controller: locationController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                                                  labelText: 'Enter the location...',
                                                  floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                ),
                                                ),
                                             
                                              ),
                                            ),
                                          ],
                                        ),
                                          SizedBox(height: 15,),
                                            SizedBox(width: 30,),
                                            Row(
                                              children: [
                                                       SizedBox(width: 30,),
                                                Text('Batch (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                                SizedBox(height: 10,),
                                                
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
                                                        controller: batchController,
                                                        cursorColor: Colors.black,
                                                        decoration: InputDecoration(
                                                          enabledBorder: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                          disabledBorder: InputBorder.none,
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                                                          labelText: 'Enter the batch...',
                                                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                        ),
                                                        ),
                                                     
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                  SizedBox(height: 15,),
                                                    Row(
                                                          children: [
                                                SizedBox(width: 30,),
                                                Text('EXP date (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
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
                                                                controller: expController,
                                                                cursorColor: Colors.black,
                                                                
                                                                 inputFormatters: [
        LengthLimitingTextInputFormatter(10),
          DateTextInputFormatter(),
          ],
                                                                decoration: InputDecoration(
                                                                  enabledBorder: InputBorder.none,
                                                                  focusedBorder: InputBorder.none,
                                                                    contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 15),
                                                                  disabledBorder: InputBorder.none,
                                                                  labelText: 'MM/DD/YYYY',
                                                                  floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                                ),
                                                                ),
                                                             
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                          SizedBox(height: 15,),
                                                            Row(
                                                                  children: [
                                                        SizedBox(width: 30,),
                                                        Text('DOB (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
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
                                                            controller: dobController,
                                                            cursorColor: Colors.black,
                                                            inputFormatters: [
        LengthLimitingTextInputFormatter(10),
          DateTextInputFormatter(),
          ],
                                                            decoration: InputDecoration(
                                                              enabledBorder: InputBorder.none,
                                                                contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 13),
                                                              focusedBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                              labelText: 'MM/DD/YYYY',
                                                              floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                            ),
                                                            ),
                                                         
                                                          ), 
                                                        ),
                            ]),
                      
                ]),
              ),
            )    ,
            
                                      SizedBox(height: 30,),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
        
                                         children: [
                                                             snackbarNotifier.value  ?
                        Text('Invalid date.', style: TextStyle(fontFamily: 'Inter', color:Colors.red, fontWeight: FontWeight.bold, fontSize: 16))
                    
                        : SizedBox.shrink(),
                       snackbarNotifier.value ?     SizedBox(width: 20,) : SizedBox.shrink(),
                       Spacer(),
                                           MouseRegion(
                                               cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                onTap: (){
                                                  dobController.clear();
                                                  skuController.clear();
                                                 descripController.clear();
                                                 dimentionController.clear();
                                                 locationController.clear();
                                                 batchController.clear();
                                                 expController.clear();
                                                 nameController.clear();
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
                                               final response56 = await Supabase.instance.client.from('process').select().eq('description', nameController.text).maybeSingle();
                                             if (nameController.text.isEmpty){
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
                  Text('Please do not leave the name field blank.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                                             } 
                                             
                                             else if (response56 != null ? response56.isNotEmpty : response56 != null ){
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
                  Text('Error: Material already exists.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                                             }
                                             else {
         setState(() {
           
         });
           
                                             
                                             final expText = expController.text;
final dobText = dobController.text;

bool isValidDate(String input) {
  try {
    final parsedDate = DateFormat('MM/dd/yyyy').parseStrict(input);
    return true;
  } catch (_) {
    return false;
  }
}

final isExpValid = expText.isEmpty || isValidDate(expText);
final isDobValid = dobText.isEmpty || isValidDate(dobText);



if (!isExpValid || !isDobValid) {
  snackbarNotifier.value = true;
        
               Future.delayed(Duration(seconds: 3), () {
          snackbarNotifier.value = false;
        });
              setState(() {
                
              });
  return;
}
                                              final actualexpdate = expController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(expController.text)) : '';
        
                                              
                                              final actualdobdate = dobController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text)) : '';
                                    
          CustomToast.show(context);
                                              await Supabase.instance.client.from('materials').update({
                                              
                                                'name': nameController.text,
                                                if (skuController.text.isNotEmpty)
                                                'sku': skuController.text,
                                                   if (descripController.text.isNotEmpty)
                                                'description': descripController.text,
                                                   if (dimentionController.text.isNotEmpty)
                                                'dimensions': dimentionController.text,
                                                   if (locationController.text.isNotEmpty)
                                                'location': locationController.text,
                                                  if (batchController.text.isNotEmpty)
                                                'batch': batchController.text,
          if (expController.text.isNotEmpty)
                                                'expdate': actualexpdate,
                                                  if (dobController.text.isNotEmpty)
                                                'dob': actualdobdate
                                              }).eq('id', entry['id']);
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
                                                  Text('Save', style: TextStyle(fontFamily: 'Inter')),
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

void materialPopUp() {
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
                Text('Add a material', textAlign: TextAlign.center,
                style: TextStyle(color:  const Color.fromARGB(255, 156, 211, 255), fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 21),),
                Spacer(),
                IconButton(
                  onPressed: (){
           dobController.clear();
                                                  skuController.clear();
                                                 descripController.clear();
                                                 dimentionController.clear();
                                                 locationController.clear();
                                                 batchController.clear();
                                                 expController.clear();
                                                 nameController.clear();
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
              height: 400,
              width: 450,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        Text('Name', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
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
                        controller: nameController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          labelText: 'Enter the name...',
                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                        ),
                        ),
                     
                      ),
                    ),
                  ],
                ),
                   SizedBox(height: 15,),
                    Column(
                      children: [
                        Row(
                                  children: [
                                    SizedBox(width: 30,),
                                    Text('SKU (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                  ],
                                ),
                     
                          
                        SizedBox(height: 10,),
                        
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
                    controller: skuController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      labelText: 'Enter the SKU...',
                      floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                    ),
                    ),
                 
                  ),
                ),
                          ]),
                           ],
                    ),
                SizedBox(height: 15,),
                    Row(
                          children: [
                SizedBox(width: 30,),
                Text('Description (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 10,),
                     
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
                                controller: descripController,
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
                          SizedBox(height: 15,),
                            Row(
                                  children: [
                        SizedBox(width: 30,),
                        Text('Dimensions (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 10,),
                               
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
                                        controller: dimentionController,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          labelText: 'Enter the dimensions...',
                                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                        ),
                                        ),
                                     
                                      ),
                                    ),
                                  ],
                                ),
                                  SizedBox(height: 15,),
                                 
                                    Row(
                                      children: [
                                           SizedBox(width: 30,),
                                        Text('Location (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                        SizedBox(height: 10,),
                                   
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
                                                controller: locationController,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  enabledBorder: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                  labelText: 'Enter the location...',
                                                  floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                ),
                                                ),
                                             
                                              ),
                                            ),
                                          ],
                                        ),
                                          SizedBox(height: 15,),
                                            SizedBox(width: 30,),
                                            Row(
                                              children: [
                                                       SizedBox(width: 30,),
                                                Text('Batch (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                                SizedBox(height: 10,),
                                                
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
                                                        controller: batchController,
                                                        cursorColor: Colors.black,
                                                        decoration: InputDecoration(
                                                          enabledBorder: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                          disabledBorder: InputBorder.none,
                                                          labelText: 'Enter the batch...',
                                                          floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                        ),
                                                        ),
                                                     
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                  SizedBox(height: 15,),
                                                    Row(
                                                          children: [
                                                SizedBox(width: 30,),
                                                Text('EXP date (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
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
                                                                controller: expController,
                                                                cursorColor: Colors.black,
                                                                 inputFormatters: [
        LengthLimitingTextInputFormatter(10),
          DateTextInputFormatter(),
          ],
                                                                decoration: InputDecoration(
                                                                  enabledBorder: InputBorder.none,
                                                                  focusedBorder: InputBorder.none,
                                                                  disabledBorder: InputBorder.none,
                                                                  labelText: 'MM/DD/YYYY',
                                                                  floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                                ),
                                                                ),
                                                             
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                          SizedBox(height: 15,),
                                                            Row(
                                                                  children: [
                                                        SizedBox(width: 30,),
                                                        Text('DOB (Optional)', style: TextStyle(fontFamily: 'WorkSans', fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 10,),
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
                                                            controller: dobController,
                                                            cursorColor: Colors.black,
                                                            inputFormatters: [
        LengthLimitingTextInputFormatter(10),
          DateTextInputFormatter(),
          ],
                                                            decoration: InputDecoration(
                                                              enabledBorder: InputBorder.none,
                                                              focusedBorder: InputBorder.none,
                                                              disabledBorder: InputBorder.none,
                                                              labelText: 'MM/DD/YYYY',
                                                              floatingLabelStyle: TextStyle(color:const Color.fromARGB(255, 235, 235, 235),),
                                                            ),
                                                            ),
                                                         
                                                          ), 
                                                        ),
                            ]),
                      
                ]),
              ),
            )    ,
            
                                      SizedBox(height: 30,),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
        
                                         children: [
                                                             snackbarNotifier.value  ?
                        Text('Invalid date.', style: TextStyle(fontFamily: 'Inter', color:Colors.red, fontWeight: FontWeight.bold, fontSize: 16))
                    
                        : SizedBox.shrink(),
                       snackbarNotifier.value ?     SizedBox(width: 20,) : SizedBox.shrink(),
                       Spacer(),
                                           MouseRegion(
                                               cursor: SystemMouseCursors.click,
                                               child: GestureDetector(
                                                onTap: (){
                                                  dobController.clear();
                                                  skuController.clear();
                                                 descripController.clear();
                                                 dimentionController.clear();
                                                 locationController.clear();
                                                 batchController.clear();
                                                 expController.clear();
                                                 nameController.clear();
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
                                               final response56 = await Supabase.instance.client.from('process').select().eq('description', nameController.text).maybeSingle();
                                             if (nameController.text.isEmpty){
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
                  Text('Please do not leave the name field blank.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                                             } 
                                             
                                             else if (response56 != null ? response56.isNotEmpty : response56 != null ){
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
                  Text('Error: Material already exists.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
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
                                             }
                                             else {
         setState(() {
           
         });
           
                                             
                                             final expText = expController.text;
final dobText = dobController.text;

bool isValidDate(String input) {
  try {
    final parsedDate = DateFormat('MM/dd/yyyy').parseStrict(input);
    return true;
  } catch (_) {
    return false;
  }
}

final isExpValid = expText.isEmpty || isValidDate(expText);
final isDobValid = dobText.isEmpty || isValidDate(dobText);



if (!isExpValid || !isDobValid) {
  snackbarNotifier.value = true;
        
               Future.delayed(Duration(seconds: 3), () {
          snackbarNotifier.value = false;
        });
              setState(() {
                
              });
  return;
}
                                              final actualexpdate = expController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(expController.text)) : '';
        
                                              
                                              final actualdobdate = dobController.text.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateFormat('MM/dd/yyyy').parse(dobController.text)) : '';
                                              final user = Supabase.instance.client.auth.currentUser;
          final email = user?.email;
          final response = await Supabase.instance.client.from('user').select().eq('email', email!).maybeSingle();
          final company = response?['company'];
          
          final username = response?['username'];
          CustomToast.show(context);
                                              await Supabase.instance.client.from('materials').insert({
                                                'company': company,
                                                'usermat': username,
                                                'name': nameController.text,
                                                if (skuController.text.isNotEmpty)
                                                'sku': skuController.text,
                                                   if (descripController.text.isNotEmpty)
                                                'description': descripController.text,
                                                   if (dimentionController.text.isNotEmpty)
                                                'dimensions': dimentionController.text,
                                                   if (locationController.text.isNotEmpty)
                                                'location': locationController.text,
                                                  if (batchController.text.isNotEmpty)
                                                'batch': batchController.text,
          if (expController.text.isNotEmpty)
                                                'expdate': actualexpdate,
                                                  if (dobController.text.isNotEmpty)
                                                'dob': actualdobdate
                                              });
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
        );
      }
    )
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
Widget build(BuildContext context){
  final searchTerm = searchMController.text.toLowerCase();
entries.sort((a, b) => a['name'].compareTo(b['name']));
    final filteredEntries = entries.where((entry) {
      final name = (entry['name'] ?? '').toString().toLowerCase();
      final sku = (entry['sku'] ?? '').toString().toLowerCase();
      final type = (entry['type'] ?? '').toString().toLowerCase();

      if (searchTerm.isEmpty) return true;

      return name.contains(searchTerm) || sku.contains(searchTerm) || type.contains(searchTerm);
    }).toList();

filteredEntries.sort((a, b) => a['name'].compareTo(b['name']));

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

  return Scaffold(
       backgroundColor: Color.fromARGB(255, 236, 244, 254),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor:  const Color.fromARGB(255, 193, 223, 247),
          onPressed: (){
            if (canGo == true){
        materialPopUp();
        canGo = false;
            }
      
            Future.delayed(Duration(seconds: 3), () {
      canGo = true;
            });
      
          },
          
        icon: Icon(Icons.add, color:Color.fromARGB(255, 0, 74, 123),),
        label: Text('Add Material' , style: TextStyle(color: Color.fromARGB(255, 0, 74, 123), fontWeight: FontWeight.bold),)
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
                     selected5 = false;
                        selected6 = false;
                            selected4 = false;
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
           Expanded(
             child: Scrollbar(
              controller: _scrollController2,
              thumbVisibility: true,
               child: SingleChildScrollView(
                controller: _scrollController2, 
                     scrollDirection: Axis.horizontal,
                 child: Row(
                         children: [
                  SizedBox(width: 10),
                  SizedBox(
                  
                        height: 1825,
                    child: Column(children: [
                     SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 30),
                      Text('Add Material', style: TextStyle(color: const Color.fromARGB(255, 23, 85, 161), fontWeight: FontWeight.bold, fontSize: 30)),
                   SizedBox(width: 2400),   
                    ],
                              ),
                              SizedBox(height: 35),
                              Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                       
                          SizedBox(width: 30),
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
                          label: Text('Search a material, SKU or type...'),
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
                       SizedBox(width: 2200,),
                     ],
                               ),
                    
                         ],),
                        SizedBox(height: 10,),
                  
                    
                              
                              SizedBox(height: 20),
                          SizedBox(
                        
                         child: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: SizedBox(
                         // Keep the fixed width you had for the content
                            width: 2620,
                         child: Column(
                  children: [
                    // Your header container stays the same
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
                              width: 10,

                              ),
                              SizedBox(width: 40),
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
                      height: MediaQuery.of(context).size.height * 0.62,
                      // child: StreamBuilder<List<Map<String, dynamic>>>(
                      //   stream: Supabase.instance.client
                      //       .from('materials')
                      //       .stream(primaryKey: ['id']).order('name', ascending: true),
                      //   builder: (context, snapshot) {
                      //     // if (snapshot.connectionState == ConnectionState.waiting) {
                      //     //   return Center(child: CircularProgressIndicator());
                      //     // } 
                      //     // else 
                          
                      //     if (snapshot.hasError) {
                      //       return Text('Error: ${snapshot.error}');
                      //     }
                      //     final data = snapshot.data ?? [];
                      //     if (data.isEmpty) {
                      //       return Center(
                      //           child: Column(
                      //         children: [
                      //           SizedBox(height: 70),
                      //           Stack(
                      //             children: [
                      //               Image(
                      //                 image: AssetImage('images/search.png'),
                      //                 width: 400,
                      //                 height: 400,
                      //                 fit: BoxFit.contain,
                      //               ),
                      //               Positioned(
                      //                   left: 100,
                      //                   top: 300,
                      //                   child: Text(
                      //                     'Nothing here yet...',
                      //                     style: TextStyle(
                      //                         color: const Color.fromARGB(255, 0, 55, 100),
                      //                         fontSize: 25,
                      //                         fontWeight: FontWeight.bold),
                      //                   )),
                      //             ],
                      //           )
                      //         ],
                      //       ));
                      //     }
                     
                     
                     
                       
                      //     final filteredData = data.where((entries) {
                      //       final searchMControllerr = searchMController.text.toLowerCase();
                      //       final names = entries['name'].toString().toLowerCase();
                      //      final sku = entries['sku'].toString().toLowerCase();
                      //           final type = entries['type'].toString().toLowerCase();
                      //       if (searchMController.text.isNotEmpty) {
                      //         if (names.contains(searchMControllerr) || sku.contains(searchMControllerr) || (type.contains(searchMControllerr)) ) {
                      //           return true;
                      //         } else {
                      //           return false;
                      //         }
                      //       } else {
                      //         return true;
                      //       }
                      //     }).toList();
                       
                      //     return
                    child: FutureBuilder(
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
                              controller: _scrollController,
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                if (index == filteredData.length) {
                                  // Loading indicator at bottom
                                  return SizedBox.shrink();
                                }
                                final entry = filteredData[index];
                                  return StatefulBuilder(
                                    
                                    
                                    builder: (context, setLocalState) {
                                         
                              
                                      return Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: const Color.fromARGB(255, 118, 118, 118)),
                                          ),
                                          color: hoverIndex == entry['id']
                                              ? const Color.fromARGB(255, 247, 247, 247)
                                              : (entry['closed'] == 1)
                                                  ? Color.fromARGB(255, 172, 250, 175)
                                                  : Colors.white),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
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
                                        child: GestureDetector(
                                          onTap: () {
                                      
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => DetailsM(
                                            //               materialname: entry['name'],
                                            //             )));
                                          },
                                          child: SizedBox(
                                            height: 61,
                                            child: Column(
                                              children: [
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 20),
                                                     SizedBox(
                              width: 40,
                              child: IconButton(
onPressed: (){
  materialEditPopUp(entry);
},
                                icon: Icon(Icons.edit),
                              )),
                                                    SizedBox(width: 20),
                                                    SizedBox(
                                                        width: 350,
                                                        child: Text(entry['name'] ?? 'N/A',
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
                                      ),
                                    );
                                    },
                                  );
                                },
                              );
                      }
                    )
                      //   },
                      // ),
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
           )
          ],),
      );
    
}
}
class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formatted = '';

    if (digitsOnly.length >= 2) {
      formatted += '${digitsOnly.substring(0, 2)}/';
    } else {
      formatted += digitsOnly;
    }

    if (digitsOnly.length >= 4) {
      formatted += '${digitsOnly.substring(2, 4)}/';
    } else if (digitsOnly.length > 2) {
      formatted += digitsOnly.substring(2);
    }

    if (digitsOnly.length > 4) {
      formatted += digitsOnly.substring(4);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}