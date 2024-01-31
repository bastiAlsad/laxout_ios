import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/couponsPage.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  bool isConnected = false;

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
        return true;
      }
    // ignore: empty_catches
    } catch (e) {
    }
    isConnected = false;
    return false;
  }

  @override
  void initState() {
    isInternetConnected();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return isConnected ? const InternetShopPage() : const NoInternetShopPage();
  }
}

class InternetShopPage extends StatefulWidget {
  const InternetShopPage({super.key});

  @override
  State<InternetShopPage> createState() => _InternetShopPageState();
}

class _InternetShopPageState extends State<InternetShopPage> {

  final LaxoutBackend _laxoutBackend = LaxoutBackend();

  Stream<String?> _getLaxCoinsStream() async* {
    String? laxCoins = await _laxoutBackend.getLaxoutCoinsAmount();
    yield laxCoins;
  }

  @override
  void initState() {
    clearCouponList();
    getCouponList();
    //getCouponsOfUserList();
    //getCouponsOfUserList();
    super.initState();
  }

  void clearCouponList() {
    setState(() {
      usersCouponList = [];
    });
  }

  void getCouponList() async {
    shopList = await _laxoutBackend.returnCoupons();
  }

  /*void getCouponsOfUserList() async {
    clearCouponList();
    usersCouponList =
        await _backendFunktions.getCouponsFromUser(_hiveDatabase.getUserUid());
    if (usersCouponList.length == 1) {
      setState(() {
        currentIndex = 0;
      });
    } else {
      setState(() {
        currentIndex = usersCouponList.length - 1;
      });
    }
    print(usersCouponList.length.toString());
    print(usersCouponList);
  }
*/
  List shopList = [];
  List usersCouponList = [];
  //int currentIndex = 0;

   
  

  @override
  Widget build(BuildContext context) {
    showErrorMessage() {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text(
                "Sie haben leider nicht genügend Laxout Credits. Diese können sie sich 1 mal täglich durch einen Test verdienen, oder durch das vollenden des Physio Workouts",
                style: TextStyle(fontFamily: "Laxout", fontSize: 14),
              ),
              actions: [
                Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        width: 127,
                        decoration: BoxDecoration(
                            color: Appcolors.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text(
                          "Zurück",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        )),
                      )),
                ),
              ],
            );
          }));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 70,
        leading: const Row(
          children: [],
        ),
        title: const Text(
          "LaxShop",
          style: TextStyle(
              fontSize: 30, color: Colors.black, fontFamily: "Laxout"),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<String?>(
            stream: _getLaxCoinsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Fehler beim Laden der LaxCoins');
              } else {
                String laxCoins = snapshot.data ?? "0";
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset("assets/images/laxCoin.png"),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      laxCoins,
                      style: const TextStyle(
                          fontFamily: "Laxout",
                          fontSize: 25,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      width: 19,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Stack(
            children: [
              FutureBuilder(
                future:_laxoutBackend.returnCoupons(), // Hier wird die asynchrone Funktion aufgerufen
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Zum Beispiel ein Ladekreis
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Wenn die Daten erfolgreich geladen wurden, zeigen Sie die Liste an
                    return ListView.builder(
                        itemCount: shopList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.9,
                              width: MediaQuery.of(context).size.width - 100,
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
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      shopList[index]
                                                          .couponImageUrl))),
                                        ),
                                        Text(
                                          shopList[index].couponName,
                                          style: const TextStyle(
                                              fontFamily: "Laxout",
                                              fontSize: 18,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      shopList[index].couponText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      shopList[index].couponOffer,
                                      style: const TextStyle(
                                          fontFamily: "Laxout",
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/laxCoin.png"))),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  shopList[index]
                                                      .couponPrice
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontFamily: "Laxout",
                                                      fontSize: 18,
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: InkWell(
                                            // Button zum Kaufen des Coupons
                                            onTap: () async{
                                              bool response = await _laxoutBackend.buyCoupon(shopList[index].id);
                                              if(response == false){
                                                showErrorMessage();
                                              }
                                              else{
                                                setState(() {
                                                  
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 140,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      176, 224, 230, 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: const Center(
                                                  child: Text(
                                                "Rabattcode kaufen",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }));
                  }
                },
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromRGBO(176, 224, 230, 1.0),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UsersCouponPage()),
                          (route) => false);
                    },
                    child: const Icon(Icons.card_giftcard_outlined),
                  ))
            ],
          )),
      drawer: const SideNavBar(),
    );
  }
}

class NoInternetShopPage extends StatelessWidget {
  const NoInternetShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Expanded(child: Image.asset("assets/images/wifi.png")),
                const Text(
                  "Bitte überprüfe deine \nInternetverbindung",
                  style: TextStyle(
                      fontFamily: "Laxout", fontSize: 20, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: const SideNavBar(),
    );
  }
}
