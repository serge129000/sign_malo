import 'package:flutter/material.dart';

class NoPoses extends StatelessWidget {
  const NoPoses({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: .7, child: Container(
      width: 200,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/sign.png", color: Colors.white,),
          Padding(padding: const EdgeInsets.symmetric(
            vertical: 20
          ),
          
          child: Center(child: Text("Aucune posture detecte", textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall,)),)
        ],
      ),
    ),);
  }
}
