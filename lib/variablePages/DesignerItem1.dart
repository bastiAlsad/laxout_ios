import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';

class DesignerItem1 extends StatelessWidget {
  final Widget picture;
  final String title;
  final Function navigate;
  const DesignerItem1(this.picture, this.title, this.navigate, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigate();
      },
      child: Container(
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: 240,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              boxShadow: [
                const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-5, -5),
                    blurRadius: 15),
                BoxShadow(
                    color: Colors.grey.shade300,
                    offset: const Offset(-5, -5),
                    blurRadius: 15),
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(height: 110, child: picture),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                        child: Text(
                      title,
                      style: const TextStyle(
                          fontFamily: "Laxout",
                          fontSize: 18,
                          height: 1,
                          color: Colors.black),
                    ))),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Appcolors.primary,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                      child: Text(
                    "Starten",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Laxout",
                        fontSize: 15),
                  )),
                ),
              )
            ],
          )),
    );
  }
}
