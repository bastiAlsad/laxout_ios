// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';

class UsersCouponPage extends StatefulWidget {
  const UsersCouponPage({super.key});

  @override
  State<UsersCouponPage> createState() => _UsersCouponPageState();
}

class _UsersCouponPageState extends State<UsersCouponPage> {
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  // ignore: non_constant_identifier_names
  void copyToClipboard(String Stext) {
    Clipboard.setData(ClipboardData(text: Stext))
        .then((value) =>(){})
        
        .catchError((error) => (){});
  }

  void showCopyToClipboardSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(
            seconds:
                5), // Zeit in Sekunden, bevor die Benachrichtigung verschwindet
      ),
    );
  }

  @override
  void initState() {
    getCouponsOfUserList();
    super.initState();
  }

  void getCouponsOfUserList() async {
    _usersCouponList =
        await _laxoutBackend.returnCouponsForSpecificUSer();
    if (_usersCouponList.length == 1) {
      setState(() {
        currentIndex = 0;
      });
    } else {
      setState(() {
        currentIndex = _usersCouponList.length - 1;
      });
    }
  }

  List _usersCouponList = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyBottomNavigationBar(startindex: 3,)),
                (route) => false),
            icon: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 70,
        title: const Text(
          "Deine Coupons",
          style: TextStyle(
              color: Colors.black, fontFamily: "Laxout", fontSize: 30),
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _laxoutBackend.returnCouponsForSpecificUSer(), // Hier wird die asynchrone Funktion aufgerufen
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Zum Beispiel ein Ladekreis
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: _usersCouponList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width - 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            boxShadow: [
                              const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(5, 5),
                                  blurRadius: 15),
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: const Offset(-5, -5),
                                  blurRadius: 15),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(11.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                _usersCouponList[index]
                                                    .couponImageUrl))),
                                  ),
                                  Text(
                                    _usersCouponList[index].couponName,
                                    style: const TextStyle(
                                        fontFamily: "Laxout",
                                        fontSize: 18,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              Text(
                                _usersCouponList[index].couponOffer,
                                style: const TextStyle(
                                    fontFamily: "Laxout",
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        copyToClipboard(
                                            _usersCouponList[index].rabatCode);
                                        showCopyToClipboardSnackbar(context,
                                            "Couponcode in die Zwischenablage kopiert");
                                      },
                                      child: Container(
                                        width: 121,
                                        height: 33,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color.fromRGBO(
                                              176, 224, 230, 1.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _usersCouponList[index].rabatCode,
                                            style: const TextStyle(
                                                fontFamily: "Laxout",
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                        _laxoutBackend.deleteCoupon(_usersCouponList[index].id);
                                        },
                                        icon: SizedBox(
                                            height: 29,
                                            child: Image.asset(
                                                "assets/images/delete.png")))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: Text(
                  "Keine Coupons vorhanden",
                  style: TextStyle(fontFamily: "Laxout", fontSize: 20),
                ),
              );
            }
            // Wenn die Daten erfolgreich geladen wurden, zeigen Sie die Liste an
          }
        },
      ),
    );
  }
}
