import 'package:go_router/go_router.dart';
import '/screens/screens.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: 'welcome',
      builder: (context, state) => BienvenidaScreen(),
    ),

    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegistroScreen(),
    ),

    GoRoute(
      path: '/citas',
      name: 'citas',
      builder: (context, state) => const CalendarioScreen(),
    ),

    GoRoute(
      path: '/asesoria',
      builder: (context, state) => const AsesoriaScreen(),
    ),

    GoRoute(
      path: '/asesoria/cita-inmediata',
      builder: (context, state) => const AlertaInmediataScreen(),
    ),

    GoRoute(
      path: '/asesoria/cita-inmediata/preguntas',
      name: 'preguntas',
      builder: (context, state) => const PreguntasScreen(),
    ),

    GoRoute(
      path: '/asesoria/cita-inmediata/resumen',
      name: 'resumen',
      builder: (context, state) => const ResumenScreen(),
    ),

    GoRoute(
      path: '/historial-citas',
      builder: (context, state) => const HistorialCitasScreen(),
    ),
    
  ],
);
