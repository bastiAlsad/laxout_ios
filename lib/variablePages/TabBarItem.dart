import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TabBarItem extends StatefulWidget {
  String title;
  String dauer;
  String imagePath;
  VoidCallback onPressed;
  TabBarItem({
    Key? key,
    required this.title,
    required this.dauer,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<TabBarItem> createState() => _TabBarItemState();
}

class _TabBarItemState extends State<TabBarItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 200,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(176, 224, 230, 1.0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 20,
                offset: Offset(5, 0),
                color: Colors.black12,
              )
            ]),
        child: Stack(
          children: [
            Positioned(
                top: 20,
                left: 10,
                child: Image.asset(
                  widget.imagePath,
                  scale: 3,
                )),
            Positioned(
                top: 20,
                right: 55,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.watch_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          Text(
                            widget.dauer,
                            style: const TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: widget.onPressed,
                          child: Container(
                              height: 35,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              )))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
