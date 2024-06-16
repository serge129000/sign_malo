import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signe_malo/utils/utils.dart';
import 'package:signe_malo/view_model/ai.view_model.dart';
import 'package:signe_malo/view_model/poses.view_model.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              kPopPage(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: kWhiteColor,
            )),
        backgroundColor: kBlackColor,
        title: Text("Traduction ASL/FSL",
            style: Theme.of(context).textTheme.bodyLarge),
        centerTitle: true,
      ),
      body: Consumer2<AiViewModel, PosesViewModel>(
          builder: (context, aiViewModel, posesViewModel, widgets) {
       /*  if (aiViewModel.gettingResponseStatus == Status.initial) {
          return Center(
              child: CupertinoActivityIndicator(
            color: kWhiteColor,
          ));
        } */
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20
          ),
          child: Column(
            children: [
              ...aiViewModel.response.map((res) => Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kBlackColor.withOpacity(.3),
                  border: Border.all(
                    color: Colors.grey.withOpacity(.4),
                    width: .3
                  ),
                  borderRadius: BorderRadius.circular(8)
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(
                      bottom: 10
                    ),
                    child: Text("Resultat :", style: Theme.of(context).textTheme.bodyLarge,),),
                    Text(res.result, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 25
                    ),),
                    Padding(padding: const EdgeInsets.only(
                      bottom: 10
                    ),
                    child: Text("Probabilite :", style: Theme.of(context).textTheme.bodyLarge,),),
                    Text("${res.probability}%", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 25
                    ),),
                    Padding(padding: const EdgeInsets.symmetric(
                      vertical: 10
                    ),
                    child: Text("Description :", style: Theme.of(context).textTheme.bodyLarge,),),
                    Text(res.additionalInfo['sign_details']['sign_description'], style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 12
                    ),),
                    Divider(color: Colors.grey.withOpacity(.4),),
                    Text(res.additionalInfo['translation_notes'], style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 12
                    ),),
                  ],
                ),
              ))
            ],
          ),
        );
      }),
    );
  }
}
