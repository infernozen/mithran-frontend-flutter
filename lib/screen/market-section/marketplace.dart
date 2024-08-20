import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mithran/models/marketdata.dart';
import 'package:mithran/repositories/marketdataprovider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Market extends StatelessWidget {
  final void Function() onReset;
  const Market({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MarketDataProvider(),
      child: MarketPlace(onReset: onReset),
    );
  }
}

class MarketPlace extends StatefulWidget {
  final void Function() onReset;
  const MarketPlace({super.key, required this.onReset});
  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  List<String> states = [
    "Bihar",
    "Chattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh"
  ];

  Map<String, String> stateAbbreviations = {
    "Assam": "AS",
    "Bihar": "BR",
    "Chattisgarh": "CG",
    "Goa": "GA",
    "Gujarat": "GJ",
    "Haryana": "HR",
    "Himachal Pradesh": "HP",
    "Jharkhand": "JH",
    "Karnataka": "KA",
    "Kerala": "KL",
    "Madhya Pradesh": "MP",
    "Maharashtra": "MH",
    "Manipur": "MN",
    "Meghalaya": "ML",
    "Mizoram": "MZ",
    "Nagaland": "NL",
    "Odisha": "OD",
    "Punjab": "PB",
    "Rajasthan": "RJ",
    "Sikkim": "SK",
    "Tamil Nadu": "TN",
    "Telangana": "TS",
    "Tripura": "TR",
    "Uttar Pradesh": "UP",
    "Uttarakhand": "UK",
    "West Bengal": "WB",
  };

  List<String> crop = [
    "Wheat",
    "Sugarcane",
    "Rice",
    "Soyabean",
    "Mustard",
    "Apple",
    "Banana",
    "Beans",
    "Carrot",
    "Coffee",
    "Maize",
    "Cotton",
    "Tea",
    "Onion",
    "Potato",
    "Tomato"
  ];

  Map<String, List<String>> stateAndCity = {
    "Bihar": [
      "Araria",
      "Bhojpur",
      "Buxar",
      "Jamui",
      "Kishanganj",
      "Madhepura",
      "Madhubani",
      "Patna",
      "Sheohar",
      "Vaishali"
    ],
    "Chattisgarh": ["Durg", "Raigarh", "Rajnandgaon", "Bilaspur"],
    "Goa": ["North Goa"],
    "Gujarat": [
      "Ahmedabad",
      "Anand",
      "Bharuch",
      "Kachchh",
      "Navsari",
      "Dahod",
      "Banaskanth",
      "Rajkot",
      "Kheda",
      "Mehsana",
      "Vadodara(Baroda)",
      "Bhavnagar",
      "Porbandar",
      "Surat",
      "Surendranagar"
    ],
    "Haryana": [
      "Jhajar",
      "Faridabad",
      "Ambala",
      "Panchkula",
      "Hissar",
      "Kaithal",
      "Yamuna Nagar",
      "Sirsa",
      "Gurgaon",
      "Sonipat",
      "Karnal",
      "Palwal",
      "Fatehabad",
      "Kurukshetra",
      "Bhiwani",
      "Panipat",
      "Rohtak",
      "Mahendragarh-Narnaul",
      "Mewat",
      "Rewari",
      "Jind"
    ],
    "Himachal Pradesh": [
      "Kullu",
      "Bilaspur",
      "Hamirpur",
      "Kangra",
      "Mandi",
      "Shimla",
      "Una",
      "Sirmore",
      "Chamba"
    ],
    "Karnataka": [
      "Bangalore",
      "Belgaum",
      "Davangere",
      "Dharwad",
      "Kalburgi",
      "Kolar",
      "Shimoga",
      "Hassan",
      "Chikmagalur",
      "Mysore",
      "Udupi"
    ],
    "Kerala": [
      "Ernakulam",
      "Kollam",
      "Thiruvananthapuram",
      "Kottayam",
      "Thirssur",
      "Alappuzha",
      "Kozhikode(Calicut)",
      "Palakad",
      "Malappuram",
      "Kasargod",
      "Kannur",
      "Idukki"
    ],
    "Madhya Pradesh": ["Morena", "Shajapur", "Ujjain", "Rajgarh", "Katni"],
    "Maharashtra": [
      "Ahmednagar",
      "Sholapur",
      "Akola",
      "Amarawati",
      "Jalgaon",
      "Chandrapur",
      "Chattrapati Sambhajinagar",
      "Nagpur",
      "Pune",
      "Thane",
      "Nashik",
      "Sangli",
      "Satara",
      "Mumbai",
      "Dharashiv(Usmanabad)"
    ],
    "Manipur": [
      "Bishnupur",
      "Imphal East",
      "Imphal West",
      "Kakching",
      "Thoubal"
    ],
    "Meghalaya": ["West Jaintia Hills"],
    "Nagaland": ["Kohima", "Mokokchung"],
    "Odisha": [
      "Khurda",
      "Bargarh",
      "Bhadrak",
      "Boudh",
      "Mayurbhanja",
      "Sonepur",
      "Dhenkanal",
      "Jagatsinghpur",
      "Balasore",
      "Jharsuguda",
      "Kendrapara",
      "Nuapada",
      "Rayagada",
      "Sundergarh",
      "Sambalpur",
      "Kalahandi",
      "Ganjam",
      "Keonjhar"
    ],
    "Punjab": [
      "Amritsar",
      "Mohali",
      "Fatehgarh",
      "Bhatinda",
      "Sangrur",
      "Jalandhar",
      "Mansa",
      "Hoshiarpur",
      "Moga",
      "Gurdaspur",
      "Ludhiana",
      "Fazilka",
      "Ferozpur",
      "Muktsar",
      "Faridkot",
      "Patiala",
      "Nawanshahr",
      "Pathankot",
      "Tarntaran",
      "Kapurthala",
      "Ropar (Rupnagar)",
      "Barnala"
    ],
    "Rajasthan": [
      "Baran",
      "Jaipur Rural",
      "Hanumangarh",
      "Jalore",
      "Jodhpur",
      "Ajmer",
      "Ganganagar",
      "Churu",
      "Udaipur",
      "Balotra",
      "Jhunjhunu",
      "Sikar",
      "Alwar",
      "Bhilwara",
      "Bikaner",
      "Chittorgarh",
      "Jaipur",
      "Kota",
      "Rajsamand",
      "Sanchore",
      "Dungarpur"
    ],
    "Tamil Nadu": [
      "Dharmapuri",
      "Salem",
      "Madurai",
      "Theni",
      "Thiruvannamalai",
      "Ranipet",
      "Ariyalur",
      "Virudhunagar",
      "Krishnagiri",
      "Chengalpattu",
      "Cuddalore",
      "Dindigul",
      "The Nilgiris",
      "Sivaganga",
      "Thirupur",
      "Villupuram",
      "Erode",
      "Vellore",
      "Kallakuruchi",
      "Kancheepuram",
      "Pudukkottai",
      "Karur",
      "Tuticorin",
      "Namakkal",
      "Thanjavur",
      "Coimbatore",
      "Thiruchirappalli",
      "Thiruvarur",
      "Nagapattinam",
      "Thirunelveli",
      "Thirupathur",
      "Ramanathapuram",
      "Thiruvellore",
      "Perambalur",
      "Tenkasi",
      "Nagercoil (Kannyiakumari)"
    ],
    "Telangana": [
      "Hyderabad",
      "Warangal",
      "Ranga Reddy",
      "Mahbubnagar",
      "Medak",
      "Nalgonda"
    ],
    "Tripura": [
      "Sepahijala",
      "Dhalai",
      "North Tripura",
      "Gomati",
      "Khowai",
      "South District",
      "Unokoti",
      "West District"
    ],
    "Uttar Pradesh": [
      "Agra",
      "Mirzapur",
      "Prayagraj",
      "Ambedkarnagar",
      "Aligarh",
      "Amroha",
      "Maharajganj",
      "Bulandshahar",
      "Bareilly",
      "Auraiya",
      "Etah",
      "Azamgarh",
      "Badaun",
      "Baghpat",
      "Bahraich",
      "Ballia",
      "Balrampur",
      "Banda",
      "Unnao",
      "Barabanki",
      "Mainpuri",
      "Etawah",
      "Hamirpur",
      "Kaushambi",
      "Shravasti",
      "Bijnor",
      "Fatehpur",
      "Sambhal",
      "Chandauli",
      "Kannuj",
      "Jhansi",
      "Gorakhpur",
      "Kanpur",
      "Saharanpur",
      "Gautam Budh Nagar",
      "Deoria",
      "Mau(Maunathbhanjan)",
      "Ayodhya",
      "Farukhabad",
      "Firozabad",
      "Ghazipur",
      "Ghaziabad",
      "Lakhimpur",
      "Gonda",
      "Bhadohi(Sant Ravi Nagar)",
      "Hathras",
      "Hardoi",
      "Sitapur",
      "Shahjahanpur",
      "Jalaun (Orai)",
      "Jaunpur",
      "Raebarelli",
      "Shamli",
      "Chitrakut",
      "Kasganj",
      "Sant Kabir Nagar",
      "Mathura",
      "Lalitpur",
      "Lucknow",
      "Mahoba",
      "Khiri (Lakhimpur)",
      "Meerut",
      "Rampur",
      "Muzaffarnagar",
      "Siddharth Nagar",
      "Pillibhit",
      "Pratapgarh",
      "Kanpur Dehat",
      "Amethi",
      "Kushinagar",
      "Sonbhadra",
      "Basti",
      "Varanasi"
    ]
  };

  List<String> cities = [];
  String selectedState = "";
  String selectedCrop = "";
  String selectedCity = "";

  @override
  void initState() {
    super.initState();
    selectedCrop = "Potato";
    selectedState = "Tamil Nadu";
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    dataProvider.fetchData(selectedCrop, selectedState);
  }

  void _fetchData(String selectedCrop, String selectedState) {
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    dataProvider.fetchData(selectedCrop, selectedState);
  }

  void _filterByCity(String selectedCity) {
    final dataProvider =
        Provider.of<MarketDataProvider>(context, listen: false);
    List<MarketData> filteredData =
        dataProvider.getFilteredDataByCity(selectedCity.toLowerCase());
    setState(() {
      dataProvider.marketDataList = filteredData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<MarketDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Market Place",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      body: Container(
        color: const Color.fromRGBO(247, 247, 247, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(children: [
                const Spacer(),
                Container(
                  color: Colors.white,
                  child: DropdownMenu<String>(
                    label: const Text("State"),
                    width: 120.0,
                    menuHeight: 350,
                    menuStyle: const MenuStyle(
                        side: MaterialStatePropertyAll(BorderSide(
                            color: Color.fromRGBO(210, 213, 218, 1))),
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    dropdownMenuEntries:
                        states.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)));
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedState = value!;
                        selectedCity = "";
                        cities = List.from(stateAndCity[selectedState]!);
                        _fetchData(selectedCrop, selectedState);
                      });
                    },
                    initialSelection: selectedState,
                  ),
                ),
                const Spacer(),
                Container(
                  color: Colors.white,
                  child: DropdownMenu<String>(
                    label: const Text("City"),
                    width: 120.0,
                    menuHeight: 350,
                    menuStyle: const MenuStyle(
                        side: MaterialStatePropertyAll(BorderSide(
                            color: Color.fromRGBO(210, 213, 218, 1))),
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    dropdownMenuEntries:
                        cities.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)));
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedCity = value!;
                        _filterByCity(selectedCity);
                      });
                    },
                    initialSelection: selectedCity,
                  ),
                ),
                const Spacer(),
                Container(
                  color: Colors.white,
                  child: DropdownMenu<String>(
                    label: const Text("Crop"),
                    width: 120.0,
                    menuHeight: 350,
                    menuStyle: const MenuStyle(
                        side: MaterialStatePropertyAll(BorderSide(
                            color: Color.fromRGBO(210, 213, 218, 1))),
                        elevation: MaterialStatePropertyAll(0),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    dropdownMenuEntries:
                        crop.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value,
                          label: value,
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white)));
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedCrop = value!;
                        _fetchData(selectedCrop, selectedState);
                      });
                    },
                    initialSelection: selectedCrop,
                  ),
                ),
                const Spacer(),
              ]),
            ),
            const SizedBox(height: 20),
            !dataProvider.isLoading
                ? dataProvider.marketDataList.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: dataProvider.marketDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 110,
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 20.0),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            210, 213, 218, 1))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 15.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 225.0,
                                              child: Text(
                                                  dataProvider
                                                          .marketDataList[index]
                                                          .city[0]
                                                          .toUpperCase() +
                                                      dataProvider
                                                          .marketDataList[index]
                                                          .city
                                                          .substring(1)
                                                          .toLowerCase(),
                                                  style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16.0,
                                                      overflow: TextOverflow
                                                          .ellipsis)),
                                            ),
                                            Text(selectedCrop,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[500]!,
                                                  fontSize: 12.0,
                                                )),
                                            const SizedBox(height: 5.0),
                                            Text(
                                              '₹ ${(double.tryParse(dataProvider.marketDataList[index].modelPrice) ?? 0.0) / 1000}K / Quintal',
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                              dataProvider
                                                  .marketDataList[index].date
                                                  .split('T')
                                                  .first,
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            SizedBox(
                                                height: 40,
                                                width: 100,
                                                child: Image.asset(dataProvider
                                                                .cityMeanPriceMap[
                                                            dataProvider
                                                                .marketDataList[
                                                                    index]
                                                                .city]! <
                                                        double.tryParse(
                                                            dataProvider
                                                                .marketDataList[
                                                                    index]
                                                                .modelPrice)!
                                                    ? 'assets/graph_green.png'
                                                    : 'assets/graph_red.png')),
                                          ],
                                        ),
                                        const SizedBox(width: 10.0),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 60, left: 30, right: 30),
                            child: LottieBuilder.asset(
                              "assets/NotFound.json",
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            width: 350,
                            child: Text(
                              "No market data available at the moment for the above combination, Please try again later ⏰",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                : Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 90,
                            margin: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromRGBO(210, 213, 218, 1)),
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
