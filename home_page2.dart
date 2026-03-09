import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const NumberLearningApp());
}

class NumberLearningApp extends StatelessWidget {
  const NumberLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Numbers',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F1F2),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String home_category_json = '''
[
  {"title":"Basic numbers","file_name":"basic_numbers.json","icon":"numbers"},
  {"title":"Counting numbers","file_name":"counting_numbers.json","icon":"format_list_numbered"},
  {"title":"Phone numbers","file_name":"phone_numbers.json","icon":"phone"},
  {"title":"Money numbers","file_name":"money_numbers.json","icon":"attach_money"},
  {"title":"Time numbers","file_name":"time_numbers.json","icon":"schedule"},
  {"title":"Date numbers","file_name":"date_numbers.json","icon":"calendar_today"},
  {"title":"Floor numbers","file_name":"floor_numbers.json","icon":"apartment"},
  {"title":"Room numbers","file_name":"room_numbers.json","icon":"meeting_room"},
  {"title":"Machine numbers","file_name":"machine_numbers.json","icon":"precision_manufacturing"},
  {"title":"Order numbers","file_name":"order_numbers.json","icon":"receipt_long"},
  {"title":"Page numbers","file_name":"page_numbers.json","icon":"menu_book"},
  {"title":"Bus numbers","file_name":"bus_numbers.json","icon":"directions_bus"},
  {"title":"Train numbers","file_name":"train_numbers.json","icon":"train"},
  {"title":"Address numbers","file_name":"address_numbers.json","icon":"location_on"},
  {"title":"Score numbers","file_name":"score_numbers.json","icon":"sports_score"}
]
''';

  List<Map<String, dynamic>> get home_category_list {
    final List<dynamic> decoded_data = jsonDecode(home_category_json);
    return decoded_data
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  IconData get_icon_data(String icon_name) {
    switch (icon_name) {
      case 'numbers':
        return Icons.numbers;
      case 'format_list_numbered':
        return Icons.format_list_numbered;
      case 'phone':
        return Icons.phone;
      case 'attach_money':
        return Icons.attach_money;
      case 'schedule':
        return Icons.schedule;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'apartment':
        return Icons.apartment;
      case 'meeting_room':
        return Icons.meeting_room;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing;
      case 'receipt_long':
        return Icons.receipt_long;
      case 'menu_book':
        return Icons.menu_book;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'train':
        return Icons.train;
      case 'location_on':
        return Icons.location_on;
      case 'sports_score':
        return Icons.sports_score;
      case 'thermostat':
        return Icons.thermostat;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> category_list = home_category_list;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Learn Numbers',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF66354C),
                      ),
                    ),
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Color(0xFFC94B14),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: category_list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> item_data = category_list[index];

                    return NumberCard(
                      item_data: item_data,
                      icon_data: get_icon_data(item_data['icon'] ?? ''),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberCard extends StatelessWidget {
  final Map<String, dynamic> item_data;
  final IconData icon_data;

  const NumberCard({
    super.key,
    required this.item_data,
    required this.icon_data,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          debugPrint(item_data['file_name'] ?? '');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFC94B14),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F7),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon_data,
                    size: 38,
                    color: const Color(0xFFC94B14),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item_data['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF66354C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item_data['file_name'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8D8286),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
