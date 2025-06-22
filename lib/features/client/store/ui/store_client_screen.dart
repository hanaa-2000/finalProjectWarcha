import 'package:flutter/material.dart';
import 'package:warcha_final_progect/features/client/store/ui/widgets/store_client_body.dart';

class StoreClientScreen  extends StatelessWidget {
  const StoreClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StoreClientBody(),
    );
  }
}
