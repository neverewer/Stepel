import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
            height: 500,
            width: double.infinity,
            child: DecoratedBox(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 0.1,
                )
              ]),
            )),
      ),
    );
  }
}
