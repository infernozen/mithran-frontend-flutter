import 'package:flutter/material.dart';
import 'package:mithran/widgets/charts/cropexpensechart.dart';
import 'package:mithran/models/expensedata.dart';

class CropExpense extends StatefulWidget {
  List<double> cropProfits;
  int index;
  String cropName;
  void Function() calculateTotalProfit;
  void Function(int index, double value) addCropProfit;
  CropExpense(
      {super.key,
      required this.cropProfits,
      required this.index,
      required this.cropName,
      required this.calculateTotalProfit,
      required this.addCropProfit});

  @override
  _CropExpenseState createState() => _CropExpenseState();
}

class _CropExpenseState extends State<CropExpense> {
  bool addExpenseClicked = false;
  double income = 0;
  double totalExpense = 0;
  double totalProfit = 0;
  final priceController = TextEditingController();
  final yieldController = TextEditingController();
  final expenseNameController = TextEditingController();
  final expensePriceController = TextEditingController();
  String selectedExpenseType = "Fertilizer";
  String selectedUnit = "kg";
  List<String> units = ["kg", "lb", "dozen", "other"];
  List<double> cropExpenses = [100, 500, 1500, 1000, 400, 550, 600];
  List<String> imagePaths = [
    "Fertilizer",
    "Labour",
    "Land Rent",
    "Machinery",
    "Pesticides",
    "seedlings",
    "Other",
  ];
  List<String> expensesTypes = [
    "Fertilizer",
    "Labour",
    "Land Rent",
    "Machinery",
    "Pesticides",
    "Seedlings",
    "Others"
  ];
  List<ExpenseData> expenseDataList = [];
  List<bool> expenseDataEdit = [];

  void _calculateTotal() {
    double yieldValue = double.tryParse(yieldController.text) ?? 0.0;
    double priceValue = double.tryParse(priceController.text) ?? 0.0;
    setState(() {
      income = yieldValue * priceValue;
      totalProfit = widget.cropProfits[widget.index] + (income);
    });
  }

  void _calculateTotalExpense() {
    double expense = 0.0;
    for (int i = 0; i < expenseDataList.length; i++) {
      expense += expenseDataList[i].price;
    }
    setState(() {
      totalExpense = expense;
    });
  }

  void addCropExpense(selectedExpenseType, value) {
    switch (selectedExpenseType) {
      case "Fertilizer":
        setState(() {
          cropExpenses[0] += value;
        });
      case "Labour":
        setState(() {
          cropExpenses[1] += value;
        });
      case "Land Rent":
        setState(() {
          cropExpenses[2] += value;
        });
      case "Machinery":
        setState(() {
          cropExpenses[3] += value;
        });
      case "Pesticides":
        setState(() {
          cropExpenses[4] += value;
        });
      case "Seedlings":
        setState(() {
          cropExpenses[5] += value;
        });
      case "Others":
        setState(() {
          cropExpenses[6] += value;
        });
      default:
        break;
    }
  }

  void initState() {
    super.initState();
    totalProfit = widget.cropProfits[widget.index];
    yieldController.addListener(_calculateTotal);
    priceController.addListener(_calculateTotal);
  }

  void dispose() {
    yieldController.removeListener(_calculateTotal);
    priceController.removeListener(_calculateTotal);
    yieldController.dispose();
    priceController.dispose();
    expensePriceController.dispose();
    expenseNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("${widget.cropName} expenses",
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: const Color(0xff0158DB)),
                      color: const Color(0xffE7F0FF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const SizedBox(width: 15.0),
                            Text(
                              '${widget.cropName} Total profit',
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(width: 5.0),
                            const Icon(Icons.info_outline),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "₹${totalProfit}",
                            style: const TextStyle(
                              color: Color(0xff009C87),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          height: 50.0,
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0158DB),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                // widget.cropProfits[widget.index] +=
                                //     (income - totalExpense);
                                widget.addCropProfit(
                                    widget.index, income - totalExpense);
                                widget.calculateTotalProfit();
                                yieldController.text = '';
                                priceController.text = '';
                                Navigator.pop(context);
                              });
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_graph),
                                SizedBox(width: 10.0),
                                Text(
                                  "See financial overview",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Income ₹$income",
                        style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ))),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: yieldController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Yield',
                          suffixIcon: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUnit,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedUnit = newValue!;
                                });
                              },
                              items: units.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              icon: Icon(Icons.arrow_drop_down),
                            ),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: '₹ 0',
                          labelText: 'Price per kilo',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          hintStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffE7F0FF),
                        border: Border.all(color: const Color(0xff0158DB)),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text("Expenses ₹$totalExpense",
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0,
                                    ))),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: CropExpenseChart(
                                imagePaths: imagePaths,
                                cropExpenses: cropExpenses),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          height: 50.0,
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffE7F0FF),
                              foregroundColor: const Color(0xff0158DB),
                              side: const BorderSide(
                                color: const Color(
                                    0xff0158DB), // Blue color for the border
                                width: 1.25, // Adjust the width as needed
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                addExpenseClicked = !addExpenseClicked;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  expenseDataList.isEmpty || addExpenseClicked
                                      ? "Cancel"
                                      : "Add new expense",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        expenseDataList.isEmpty || addExpenseClicked
                            ? Container(
                                padding:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15.0),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "New expense",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Container(
                                        height: 70.0,
                                        padding: EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Category',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedExpenseType,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedExpenseType =
                                                      newValue!;
                                                });
                                              },
                                              items: expensesTypes.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              icon: Icon(Icons.arrow_drop_down),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: TextFormField(
                                          controller: expenseNameController,
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: 'Expense name',
                                            labelText:
                                                'Expense name (optional)',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: TextFormField(
                                          controller: expensePriceController,
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: '₹0',
                                            labelText: 'Price',
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                expensePriceController
                                                        .text.isNotEmpty
                                                    ? const Color(0xff0158DB)
                                                    : Colors.grey,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              expenseDataList.add(ExpenseData(
                                                  selectedExpenseType,
                                                  expenseNameController.text,
                                                  double.parse(
                                                      expensePriceController
                                                          .text
                                                          .toString())));
                                              expenseDataEdit.add(true);
                                              totalExpense += double.parse(
                                                  expensePriceController.text
                                                      .toString());
                                              addCropExpense(
                                                  selectedExpenseType,
                                                  double.parse(
                                                      expensePriceController
                                                          .text
                                                          .toString()));
                                              expensePriceController.text = '';
                                              expenseNameController.text = '';
                                            });
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Save to expenses",
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 15.0),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Container(
                            height: 230.0 * expenseDataList.length,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: expenseDataList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 20.0),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            expenseDataList[index]
                                                    .expenseName
                                                    .isEmpty
                                                ? "Expense"
                                                : expenseDataList[index]
                                                    .expenseName,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Icon(Icons.more_vert),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: TextFormField(
                                        readOnly: expenseDataEdit[index],
                                        controller: TextEditingController(
                                            text: expenseDataList[index]
                                                .category),
                                        enabled: true,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText: 'Fertilizer',
                                          labelText: 'Category',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: TextFormField(
                                        readOnly: expenseDataEdit[index],
                                        controller: TextEditingController(
                                            text: expenseDataList[index]
                                                .price
                                                .toString()),
                                        enabled: true,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          hintText: '₹0',
                                          labelText: 'Price',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          hintStyle: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    index != expenseDataList.length - 1
                                        ? const Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0, right: 15.0),
                                            child: const Divider(
                                              height: 1,
                                              thickness: 2,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
