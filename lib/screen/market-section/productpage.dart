import 'package:flutter/material.dart';
import 'package:mithran/models/shopdata.dart';
import 'package:mithran/screen/market-section/shopdisplay.dart';
import '../../data/data.dart';
import 'productdisplay.dart';

class ProductPage extends StatefulWidget {
  final void Function() onReset;
  ProductPage({super.key, required this.onReset});
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ShopData> shopDataList = [];
  List<ShopData> fertilizersDataList = [];
  List<ShopData> pesticidesDataList = [];
  List<ShopData> herbicidesDataList = [];
  List<ShopData> seedsDataList = [];
  void decodeJson(data, shopList) {
    for (int i = 0; i < data.length; i++) {
      shopList.add(ShopData(data[i]['title'], data[i]['subtitle1'],
          data[i]['subtitle2'], data[i]['subtitle3'], data[i]['image']));
    }
  }

  @override
  void initState() {
    super.initState();
    decodeJson(agriShops, shopDataList);
    decodeJson(fertilizersData, fertilizersDataList);
    decodeJson(PesticidesData, pesticidesDataList);
    decodeJson(HerbicidesData, herbicidesDataList);
    decodeJson(seedsData, seedsDataList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff7f7f7),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: SizedBox(
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_outlined,
              ),
              onPressed: () {
                widget.onReset();
                Navigator.pop(context);
              },
            ),
          ),
          title: Text(
            "Namba kadai",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE4EBFE),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.shopping_cart_sharp)),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Agrishops",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: (() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShopDisplay(
                                          shopDataList: shopDataList))),
                            }),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1056C6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shopDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right:
                                index == shopDataList.length - 1 ? 13.0 : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the desired border radius
                                child: Image.network(
                                  shopDataList[index]
                                      .image, // Your image URL or asset path
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit
                                      .fill, // This adjusts the image to fit within the ClipRRect bounds
                                ),
                              ),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  shopDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  shopDataList[index].subtitle1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  shopDataList[index].subtitle2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.verified,
                                        color: Color(0xff549DE2)),
                                    const SizedBox(width: 10.0),
                                    const Text(
                                      "Verified",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: Color(0xff549DE2),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE4EBFE),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.shopping_cart_sharp)),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Fertilizers",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: (() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDisplay(
                                          color: Colors.lightGreen,
                                          icon: Icon(
                                            Icons.shopping_cart_sharp,
                                            size: 30.0,
                                          ),
                                          text:
                                              "Organic or chemical products that improve growth and productiveness of crops.",
                                          type: "Fertilizer",
                                          shopDataList: fertilizersDataList)))
                            }),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1056C6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fertilizersDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right: index == fertilizersDataList.length - 1
                                ? 13.0
                                : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the desired border radius
                                child: Image.network(
                                  fertilizersDataList[index]
                                      .image, // Your image URL or asset path
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit
                                      .fill, // This adjusts the image to fit within the ClipRRect bounds
                                ),
                              ),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  fertilizersDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "by ${fertilizersDataList[index].subtitle1}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "From  ${fertilizersDataList[index].subtitle2}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6BAEA7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  fertilizersDataList[index].subtitle3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE4EBFE),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.shopping_cart_sharp)),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Herbicides",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: (() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDisplay(
                                          color: Colors.lightBlue,
                                          icon: Icon(Icons.shopping_cart_sharp),
                                          text:
                                              "Organic or chemical products that kill or inhibit the growth of agricultural weeds and invasive species",
                                          type: "Herbicides",
                                          shopDataList: herbicidesDataList)))
                            }),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1056C6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: herbicidesDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right: index == herbicidesDataList.length - 1
                                ? 13.0
                                : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the desired border radius
                                child: Image.network(
                                  herbicidesDataList[index]
                                      .image, // Your image URL or asset path
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit
                                      .fill, // This adjusts the image to fit within the ClipRRect bounds
                                ),
                              ),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  herbicidesDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "by ${herbicidesDataList[index].subtitle1}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "From  ${herbicidesDataList[index].subtitle2}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6BAEA7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  herbicidesDataList[index].subtitle3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE4EBFE),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.shopping_cart_sharp)),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Pesticides",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: (() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDisplay(
                                          color: Colors.pink,
                                          icon: Icon(Icons.shopping_cart_sharp),
                                          text:
                                              "Organic or chemical products that control ir prevent insects,fungi,bacteria causing economical damage on crops",
                                          type: "Pesticides",
                                          shopDataList: pesticidesDataList)))
                            }),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1056C6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pesticidesDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right: index == pesticidesDataList.length - 1
                                ? 13.0
                                : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the desired border radius
                                child: Image.network(
                                  pesticidesDataList[index]
                                      .image, // Your image URL or asset path
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit
                                      .fill, // This adjusts the image to fit within the ClipRRect bounds
                                ),
                              ),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  pesticidesDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "by ${pesticidesDataList[index].subtitle1}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "From  ${pesticidesDataList[index].subtitle2}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6BAEA7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  pesticidesDataList[index].subtitle3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 25.0),
                  child: Row(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE4EBFE),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Icon(Icons.shopping_cart_sharp)),
                      const SizedBox(width: 15.0),
                      const Text(
                        "Seeds",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: (() => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDisplay(
                                          color: Colors.brown,
                                          icon: Icon(Icons.shopping_cart_sharp),
                                          text: "Seeds that are used to plant ",
                                          type: "Seeds",
                                          shopDataList: seedsDataList)))
                            }),
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1056C6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 270.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seedsDataList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 13.0 : 8.0,
                            right:
                                index == seedsDataList.length - 1 ? 13.0 : 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the desired border radius
                                child: Image.network(
                                  seedsDataList[index]
                                      .image, // Your image URL or asset path
                                  width: 150.0,
                                  height: 150.0,
                                  fit: BoxFit
                                      .fill, // This adjusts the image to fit within the ClipRRect bounds
                                ),
                              ),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  seedsDataList[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                width: 120.0,
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "by ${seedsDataList[index].subtitle1}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "From  ${seedsDataList[index].subtitle2}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff6BAEA7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  seedsDataList[index].subtitle3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
