import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchMarketPrices() async {
  List<String> states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  String commodity = "Potato"; // You can replace this with any other commodity

  Map<String, Set<String>> stateCityMap = {};

  for (String state in states) {
    var response = await http.get(
      Uri.parse('http://35.208.131.250:5000/market/price').replace(
        queryParameters: {
          'commodity': commodity,
          'state': state,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.isNotEmpty) {
        // Ensure the state is present in the map
        stateCityMap[state] = stateCityMap[state] ?? <String>{};

        for (var item in jsonResponse) {
          String city = item['City'];
          stateCityMap[state]!.add(city); // Add city to the Set
        }
      }
    } else {
      print('Failed to load data for $state');
    }
  }

  // Remove any states with an empty list of cities
  stateCityMap.removeWhere((state, cities) => cities.isEmpty);

  // Convert the Set to List for each state and print the final map
  Map<String, List<String>> finalStateCityMap = {
    for (var state in stateCityMap.keys) state: stateCityMap[state]!.toList()
  };

  print(finalStateCityMap);
}

void main() {
  fetchMarketPrices();
}

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
  "Madhya Pradesh": [
    "Morena",
    "Shajapur",
    "Ujjain",
    "Rajgarh",
    "Katni"
  ],
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
  ]};