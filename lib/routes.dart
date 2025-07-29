
import 'package:go_router/go_router.dart';
import 'package:mbi2/NotFoundPage.dart';
import 'package:mbi2/ResetPasswordPage.dart';
import 'package:mbi2/addmaterial.dart';
import 'package:mbi2/adduser.dart';
import 'package:mbi2/admindashboard.dart';
import 'package:mbi2/admindata.dart';
import 'package:mbi2/details.dart';
import 'package:mbi2/materialdetail.dart';
import 'package:mbi2/process.dart';
import 'package:mbi2/reports.dart';
import 'package:mbi2/signup.dart';
import 'login.dart';
import 'main.dart';
import 'inbound.dart';
import 'outbound.dart';
import 'addroute.dart';

final GoRouter appRouter = GoRouter(
  
      errorBuilder: (context, state) => const notFoundPage(),
 
  routes: [

    GoRoute(
      path: '/login',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const Login(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
      GoRoute(
      path: '/signup',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const LoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
     GoRoute(
      path: '/admindashboard',
     pageBuilder: (context, state) {
 final extra = state.extra as Map<String, dynamic>?;

    final sendwarning = extra?['sendwarning'] as bool?;
return CustomTransitionPage(
  key: state.pageKey,
    child: AdminDash(sendwarning: sendwarning,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
);
  }),
  GoRoute(
  path: '/reset-password',
  builder: (context, state) {
    final accessToken = state.uri.queryParameters['access_token'];
    final type = state.uri.queryParameters['type'];

    return DetailsR(
      accessToken: accessToken,
      type: type,
    );
  },
),
    
//    
     GoRoute(
      path: '/route',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const Routes(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
     GoRoute(
      path: '/data',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const AdminData(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
     GoRoute(
      path: '/materials',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const AddMaterial(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
     GoRoute(
      path: '/forgotpassword',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const DetailsM(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
    GoRoute(
      path: '/users',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const AddUser(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
    GoRoute(
      path: '/process',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const Process(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
  GoRoute(
      path: '/dashboard',
     pageBuilder: (context, state) {
 final extra = state.extra as Map<String, dynamic>?;

    final sendwarning = extra?['sendwarning'] as bool?;
return CustomTransitionPage(
  key: state.pageKey,
    child: Mbi(sendwarning: sendwarning,),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
);
  }),
    GoRoute(
      path: '/inbound',
    pageBuilder: (context, state) => CustomTransitionPage(
    child: const Inbound(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
   GoRoute(
  path: '/details/:id',
  pageBuilder: (context, state) {
    final idString = state.pathParameters['id']!;
    final id = int.parse(idString);

    // Cast extra as a Map<String, dynamic>? and safely extract values
    final extra = state.extra as Map<String, dynamic>?;

    final route = extra?['route'] as String?;

    return CustomTransitionPage(
      key: state.pageKey,
      child: Details(
        id: id,
       route: route,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  },
),
    GoRoute(
      path: '/outbound',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const Outbound(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
     GoRoute(
      path: '/reports',
     pageBuilder: (context, state) => CustomTransitionPage(
    child: const Reports(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  ),
    ),
  ],
  
// redirect: (context, state) async {
//     final session = Supabase.instance.client.auth.currentSession;
//     final user = Supabase.instance.client.auth.currentUser;
//     final isLoggedIn = session != null;
//     final isLoggingIn = state.fullPath == '/login';

//     if (!isLoggedIn && !isLoggingIn) {
//       return '/login';
//     }

//     if (isLoggedIn && isLoggingIn) {
//       final email = user?.email;
//       if (email == null) return null;

//       final response = await Supabase.instance.client
//           .from('user')
//           .select('role')
//           .eq('email', email)
//           .maybeSingle();

//       final role = response?['role'];

//       if (role == 'admin') {
//         return '/admindashboard';
//       } else {
//         return '/dashboard';
//       }
//     }

//     // No redirect needed
//     return null;
// //   },

//   refreshListenable: supabaseAuthNotifier,
);