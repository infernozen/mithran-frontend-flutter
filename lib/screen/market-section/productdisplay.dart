import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/shopdata.dart';

class ProductDisplay extends StatefulWidget {
  String text;
  String type;
  List<ShopData> shopDataList;
  Color color;
  Icon icon;
  ProductDisplay(
      {super.key,
      required this.type,
      required this.shopDataList,
      required this.text,
      required this.color,
      required this.icon});
  _ProductDisplayState createState() => _ProductDisplayState();
}

class _ProductDisplayState extends State<ProductDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEBF5FF),
      appBar: AppBar(
        title: Text(
          widget.type,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: widget.color,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        widget.icon,
                        const SizedBox(width: 5.0),
                        Text(widget.type,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                            )),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: widget.shopDataList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              widget.shopDataList[index].image,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            width: 130.0,
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              widget.shopDataList[index].title,
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
                            width: 130.0,
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "by ${widget.shopDataList[index].subtitle1}",
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
                              "From ${widget.shopDataList[index].subtitle2}",
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
                              widget.shopDataList[index].subtitle3,
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
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
