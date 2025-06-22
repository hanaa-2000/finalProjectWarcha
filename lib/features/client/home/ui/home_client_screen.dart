import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warcha_final_progect/core/helper/extension.dart';
import 'package:warcha_final_progect/core/routing/routes.dart';
import 'package:warcha_final_progect/features/client/home/logic/workshops_cubit.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/chat_bot_screen.dart';
import 'package:warcha_final_progect/features/client/home/ui/widgets/home_body.dart';

class HomeClientScreen  extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  @override
  void initState() {
    super.initState();
    // جلب قائمة الورش عند بداية الشاشة
    context.read<WorkshopsCubit>().fetchWorkshops();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
     BlocProvider.of<WorkshopsCubit>(context).fetchWorkshops();
    ModalRoute.of(context)!.addScopedWillPopCallback(_Willpop);


  }

  Future<bool> _Willpop() async {
    BlocProvider.of<WorkshopsCubit>(context).fetchWorkshops();
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: HomeClientBody(),
     floatingActionButton: FloatingActionButton(
       backgroundColor: Colors.blue,
       onPressed: () {
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatBotScreen(),));
     },

     child: Icon(Icons.auto_awesome, color: Colors.white,),
     ),
    );
  }
}
