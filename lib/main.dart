import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/domain/bloc/auth_bloc.dart';
import 'features/demandes/domain/bloc/demandes_bloc.dart';
import 'features/home/domain/bloc/dashboard_bloc.dart';
import 'features/profil/domain/bloc/profile_bloc.dart';
import 'features/splash/presentation/pages/splash0.dart';
import 'features/travaux/domain/bloc/travaux_bloc.dart';
import 'features/wallet/domain/bloc/wallet_bloc.dart';
import 'firebase_options.dart';
import 'core/services/fcm_service.dart';
import 'features/auth/data/services/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmService.init();
  await UserSession.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<DashboardBloc>(create: (_) => DashboardBloc()),
        BlocProvider<DemandesBloc>(create: (_) => DemandesBloc()),
        BlocProvider<TravauxBloc>(create: (_) => TravauxBloc()),
        BlocProvider<WalletBloc>(create: (_) => WalletBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: 'Solimus Prestataire',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Splash0(),
      ),
    );
  }
}
