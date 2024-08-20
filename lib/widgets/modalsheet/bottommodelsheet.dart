import 'package:flutter/material.dart';

class BottomSheet extends StatelessWidget {
  final List<String> fields;
  final String selectedField;
  final ValueChanged<String> onFieldSelected;

  BottomSheet({
    required this.fields,
    required this.selectedField,
    required this.onFieldSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                child: Text(
              "Select Field",
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
                fontSize: 12.0,
              ),
            )),
          ],
        ),
      ),
    );
    // return Container(
    //   color: Colors.white,
    //   child: SingleChildScrollView(
    //     child: SafeArea(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             padding: EdgeInsets.only(left: 15.0),
    //             child: Text(
    //               'Select Field',
    //               style: TextStyle(
    //                 fontFamily: "Poppins",
    //                 fontWeight: FontWeight.w700,
    //                 fontSize: 18.0,
    //               ),
    //             ),
    //           ),
    //           ListView(
    //             children: fields.map((String value) {
    //               return SizedBox(
    //                 height: 100.0,
    //                 child: Column(
    //                   children: [
    //                     Text(
    //                       value,
    //                       style: TextStyle(
    //                         fontFamily: "Poppins",
    //                         fontWeight: FontWeight.w500,
    //                         color: Colors.black,
    //                         fontSize: 16.0,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 10.0),
    //                     Text("Wheat",
    //                         style: TextStyle(
    //                           fontFamily: "Poppins",
    //                           fontWeight: FontWeight.w500,
    //                           fontSize: 14.0,
    //                           color: Colors.grey[100],
    //                         )),
    //                   ],
    //                   // onTap: () {
    //                   //   onFieldSelected(value);
    //                   //   Navigator.pop(context);
    //                   // },
    //                 ),
    //               );
    //             }).toList(),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
