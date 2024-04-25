import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navPages/couponsPage.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/sovendus/sovendus_voucher.dart';

class SovendusPersonalData {
  String? salutation;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  int? yearOfBirth;
  String? street;
  String? streetNumber;
  String? zipcode;
  String? city;
  String? country;

  SovendusPersonalData({
    this.salutation,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.yearOfBirth,
    this.street,
    this.streetNumber,
    this.zipcode,
    this.city,
    this.country,
  });
}

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
    } catch (e) {}
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
    return const InternetShopPage();
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

  String uniqueCustomerUid = "";

   void initializeCustomerUid()async{
    uniqueCustomerUid = await _laxoutBackend.getUniqueUserUid();
    print((uniqueCustomerUid));
  }

  @override
  void initState() {
    initializeCustomerUid();
    clearCouponList();
    super.initState();
  }

  void clearCouponList() {
    setState(() {
      usersCouponList = [];
    });
  }

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

    showSovendusCoupon() {
      DateTime now = DateTime.now();
      int purchaseSecond = now.millisecondsSinceEpoch ~/ 1000;
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text(
                "Hier können Sie sich einen Rabattcode Ihrer Wahl aussuchen:",
                style: TextStyle(fontFamily: "Laxout", fontSize: 14),
              ),
              content: SovendusVoucherBanner(
                trafficSourceNumber: 7495,
                trafficMediumNumberVoucherNetwork: 1,
                orderUnixTime: purchaseSecond,
                sessionId: uniqueCustomerUid,
                orderId: uniqueCustomerUid,
                netOrderValue: 120.5,
                currencyCode: "EUR",
                usedCouponCode: "CouponCodeFromThePurchase",
                customerData: SovendusPersonalData(
                  salutation: "Mr.",
                  firstName: "Vorname",
                  lastName: "Nachname",
                  email: "example@example.com",
                  phone: "+4915546456456",
                  yearOfBirth: 1990,
                  street: "Street",
                  streetNumber: "99",
                  zipcode: "76135",
                  city: "Karlsruhe",
                  country: "DE",
                ),
                // Until the banner is loaded we're showing a loading indicator,
                // optionally you can pass a custom loading spinner with the type Widget
                customProgressIndicator: RefreshProgressIndicator(),
                ),
              
              actions: [
                Center(child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Coupon Später einlösen",textAlign: TextAlign.center, style: TextStyle(fontFamily: "Laxout", fontSize: 18, color: Colors.black, decoration: TextDecoration.underline)),))
               
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
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    Text(
                      "Was ist der Shop?",
                      style: TextStyle(fontFamily: "Laxout", fontSize: 20),
                    ),
                    Text(
                      "Im Shop können Sie Ihre LaxCoins gegen Prämien von unseren Partnern eintauschen. Sie erhalten die Coins, wenn Sie das Physio-Workout durchführen. Haben Sie ein odere mehrere Coupons gekauft, können Sie auf den blauen Button rechts unten drücken. Sie gelangen dann zu einer Ansicht, in der all Ihre Couponcodes aufgelistet werden. Drücken Sie dann auf den Code, um ihn in die Zwischenablage zu kopieren. Anschließend können Sie den Code auf der Website des Couponanbieters oder beim Anbieter persönlich einlösen.",
                      style: TextStyle(fontFamily: "Laxout", fontSize: 13),
                    )
                  ],
                ),
              ),
            );
          },
          icon: Icon(Icons.info),
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
      body: FutureBuilder<List>(
        future: _laxoutBackend.returnCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SpinKitFadingFour(
                  color: Appcolors.primary,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: SpinKitFadingFour(
                  color: Appcolors.primary,
                ),
              ),
            );
          } else {
            List shopList = snapshot.data ?? [];
            // shopList.add(Coupon(id: 0, couponName: "Wunschcoupon", couponText: "Als Belohnung für das fleißige Durchführen Ihres Workouts erhalten Sie von unserem Partner Sovendus einen Gutschein Ihrer Wahl. Kaufen Sie diesen Coupon und Sie erhalten anschließend Zugang zu über 1000 Rabattcodes von Firmen wie Otto, S.Oliver, ShopAphoteke und vielen weiteren Partnern, von denen Sie sich einen aussuchen dürfen!", couponImageUrl: "https://laxoutapp.com/wp-content/uploads/elementor/thumbs/Original-on-Transparent-2-Kopie-qdvaef4t4wosp4blnwuth1860qdc3tupxko88fkwvo.png", couponPrice: 300, couponOffer: "Einen Rabattcode Ihrer Wahl", rabatCode: ""));
            // List laxList = snapshot.data ?? [];
            // for(var item in laxList){
            //   shopList.add(item);
            // }
            return ListView.builder(
              itemCount: shopList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
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
                          blurRadius: 15,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(-5, -5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      shopList[index].couponImageUrl,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                shopList[index].couponName,
                                style: const TextStyle(
                                  fontFamily: "Laxout",
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
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
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            shopList[index].couponOffer,
                            style: const TextStyle(
                              fontFamily: "Laxout",
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            "assets/images/laxCoin.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      shopList[index].couponPrice.toString(),
                                      style: const TextStyle(
                                        fontFamily: "Laxout",
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: InkWell(
                                  onTap: () async {
                                    if(index > 0){
                                      bool response = await _laxoutBackend
                                        .buyCoupon(shopList[index].id);
                                    if (response == false) {
                                      showErrorMessage();
                                    } else {
                                      setState(() {});
                                    }
                                    }else{
                                      if(index == 0){
                                        _laxoutBackend.buySovendusCoupon(shopList[index].id);
                                        showSovendusCoupon();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Appcolors.primary,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Kaufen",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Appcolors.primary,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  UsersCouponPage(uniqueCustomerUid: uniqueCustomerUid,)),
              (route) => false);
        },
        child: const Icon(Icons.card_giftcard_outlined),
      ),
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
