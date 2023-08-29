import 'package:stepel/imports.dart';

class LoadingForm extends StatelessWidget {
  const LoadingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircularProgressIndicator(
        color: Colors.blue,
      )),
    );
  }
}
