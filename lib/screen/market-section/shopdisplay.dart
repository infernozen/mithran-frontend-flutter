import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../models/shopdata.dart';

class ShopDisplay extends StatefulWidget {
  List<ShopData> shopDataList;
  ShopDisplay({super.key, required this.shopDataList});
  _ShopDisplayState createState() => _ShopDisplayState();
}

class _ShopDisplayState extends State<ShopDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AgriShops",
          style: TextStyle(
            fontFamily: "poppins",
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                children: [
                  Icon(Icons.verified, color: Color(0xff549DE2)),
                  const SizedBox(width: 10.0),
                  Text(
                    "Verified agrishops",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text("Highly responsive retailers"),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.shopDataList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: Image.network(
                        widget.shopDataList[index].image,
                      ),
                      title: Text(
                        widget.shopDataList[index].title,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${widget.shopDataList[index].subtitle2} - ${widget.shopDataList[index].subtitle1}"),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(Icons.verified, color: Color(0xff549DE2)),
                              const SizedBox(width: 10.0),
                              const Text(
                                "Verified",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff549DE2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        size: 40.0,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
