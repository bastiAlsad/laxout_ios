import 'package:flutter/material.dart';


class DifferentWorkouts extends StatelessWidget {
  final Widget picture;
  final String title;
  final Function navigate;
  const DifferentWorkouts(this.picture, this.title, this.navigate, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      
      decoration: const BoxDecoration(
        
      ),
      child: ElevatedButton(
        
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                return const Color.fromRGBO(
                    176, 224, 230, 1.0);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ))),
        onPressed: () {
          navigate();
        },
        child: Column(
          children: <Widget>[
            picture,
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}