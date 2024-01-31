import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';

class DesignerItem2 extends StatelessWidget {
  final Widget picture;
  final String title;
  final Function navigate;
  const DesignerItem2(this.picture, this.title, this.navigate, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shadowColor: MaterialStateProperty.all(Colors.grey.shade300),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ))),
          onPressed: () {
            navigate();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Laxout",
                    fontSize: 18,
                    height: 1),
                  ),
                  const Text(
                    "2 Minuten",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 17,),
                  Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Appcolors.primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text("Starten",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Laxout",
                              fontSize: 15,
                              height: 1)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 100,
                width: 150,
                child: picture,
              ),
            ],
          )),
    );
  }
}
