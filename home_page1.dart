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
  {
    "title": "Basic numbers",
    "file_name": "basic_numbers.json",
    "icon": "numbers"
  },
  {
    "title": "Counting numbers",
    "file_name": "counting_numbers.json",
    "icon": "format_list_numbered"
  },
  {
    "title": "Phone numbers",
    "file_name": "phone_numbers.json",
    "icon": "phone"
  },
  {
    "title": "Money numbers",
    "file_name": "money_numbers.json",
    "icon": "attach_money"
  },
  {
    "title": "Time numbers",
    "file_name": "time_numbers.json",
    "icon": "schedule"
  },
  {
    "title": "Date numbers",
    "file_name": "date_numbers.json",
    "icon": "calendar_today"
  },
  {
    "title": "Floor numbers",
    "file_name": "floor_numbers.json",
    "icon": "apartment"
  },
  {
    "title": "Room numbers",
    "file_name": "room_numbers.json",
    "icon": "meeting_room"
  },
  {
    "title": "Machine numbers",
    "file_name": "machine_numbers.json",
    "icon": "precision_manufacturing"
  },
  {
    "title": "Order numbers",
    "file_name": "order_numbers.json",
    "icon": "receipt_long"
  },
  {
    "title": "Page numbers",
    "file_name": "page_numbers.json",
    "icon": "menu_book"
  },
  {
    "title": "Bus numbers",
    "file_name": "bus_numbers.json",
    "icon": "directions_bus"
  },
  {
    "title": "Train numbers",
    "file_name": "train_numbers.json",
    "icon": "train"
  },
  {
    "title": "Address numbers",
    "file_name": "address_numbers.json",
    "icon": "location_on"
  },
  {
    "title": "Score numbers",
    "file_name": "score_numbers.json",
    "icon": "sports_score"
  },
  {
    "title": "Temperature numbers",
    "file_name": "temperature_numbers.json",
    "icon": "thermostat"
  }
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

  List<List<Map<String, dynamic>>> make_chunk_list(
    List<Map<String, dynamic>> item_list,
    int chunk_size,
  ) {
    final List<List<Map<String, dynamic>>> chunk_list = [];

    for (int i = 0; i < item_list.length; i += chunk_size) {
      final int end_index =
          (i + chunk_size < item_list.length) ? i + chunk_size : item_list.length;

      chunk_list.add(item_list.sublist(i, end_index));
    }

    return chunk_list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> home_category_data = home_category_list;
    final List<List<Map<String, dynamic>>> section_list =
        make_chunk_list(home_category_data, 4);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
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

                ConnectedNumberSections(
                  section_list: section_list,
                  get_icon_data: get_icon_data,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConnectedNumberSections extends StatelessWidget {
  final List<List<Map<String, dynamic>>> section_list;
  final IconData Function(String) get_icon_data;

  const ConnectedNumberSections({
    super.key,
    required this.section_list,
    required this.get_icon_data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(section_list.length, (section_index) {
        final List<Map<String, dynamic>> current_section =
            List<Map<String, dynamic>>.from(section_list[section_index]);

        while (current_section.length < 4) {
          current_section.add({
            'title': '',
            'file_name': '',
            'icon': '',
            'is_empty': true,
          });
        }

        final bool is_last_section = section_index == section_list.length - 1;

        return ConnectedSectionBlock(
          item_list: current_section,
          get_icon_data: get_icon_data,
          is_last_section: is_last_section,
        );
      }),
    );
  }
}

class ConnectedSectionBlock extends StatelessWidget {
  final List<Map<String, dynamic>> item_list;
  final IconData Function(String) get_icon_data;
  final bool is_last_section;

  const ConnectedSectionBlock({
    super.key,
    required this.item_list,
    required this.get_icon_data,
    required this.is_last_section,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double total_width = constraints.maxWidth;
        final double card_height = 248;
        final double circle_size = total_width * 0.24;
        final double half_circle = circle_size / 2;
        final double center_x = total_width / 2;
        final double block_height = card_height * 2;

        return SizedBox(
          height: block_height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: center_x - 1,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: const Color(0xFFC94B14),
                ),
              ),

              Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: NumberCard(
                            title: item_list[0]['title'] ?? '',
                            file_name: item_list[0]['file_name'] ?? '',
                            icon_data: get_icon_data(item_list[0]['icon'] ?? ''),
                            is_empty: item_list[0]['is_empty'] == true,
                            show_left_border: true,
                            show_top_border: true,
                            show_right_border: false,
                            show_bottom_border: true,
                          ),
                        ),
                        Expanded(
                          child: NumberCard(
                            title: item_list[1]['title'] ?? '',
                            file_name: item_list[1]['file_name'] ?? '',
                            icon_data: get_icon_data(item_list[1]['icon'] ?? ''),
                            is_empty: item_list[1]['is_empty'] == true,
                            show_left_border: false,
                            show_top_border: true,
                            show_right_border: true,
                            show_bottom_border: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: NumberCard(
                            title: item_list[2]['title'] ?? '',
                            file_name: item_list[2]['file_name'] ?? '',
                            icon_data: get_icon_data(item_list[2]['icon'] ?? ''),
                            is_empty: item_list[2]['is_empty'] == true,
                            show_left_border: true,
                            show_top_border: false,
                            show_right_border: false,
                            show_bottom_border: is_last_section,
                          ),
                        ),
                        Expanded(
                          child: NumberCard(
                            title: item_list[3]['title'] ?? '',
                            file_name: item_list[3]['file_name'] ?? '',
                            icon_data: get_icon_data(item_list[3]['icon'] ?? ''),
                            is_empty: item_list[3]['is_empty'] == true,
                            show_left_border: false,
                            show_top_border: false,
                            show_right_border: true,
                            show_bottom_border: is_last_section,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Positioned(
                left: (total_width - circle_size) / 2,
                top: card_height - half_circle,
                child: CenterFlagCircle(circle_size: circle_size),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NumberCard extends StatelessWidget {
  final String title;
  final String file_name;
  final IconData icon_data;
  final bool is_empty;
  final bool show_left_border;
  final bool show_top_border;
  final bool show_right_border;
  final bool show_bottom_border;

  const NumberCard({
    super.key,
    required this.title,
    required this.file_name,
    required this.icon_data,
    required this.is_empty,
    required this.show_left_border,
    required this.show_top_border,
    required this.show_right_border,
    required this.show_bottom_border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color:
                show_left_border ? const Color(0xFFC94B14) : Colors.transparent,
            width: 2,
          ),
          top: BorderSide(
            color:
                show_top_border ? const Color(0xFFC94B14) : Colors.transparent,
            width: 2,
          ),
          right: BorderSide(
            color:
                show_right_border ? const Color(0xFFC94B14) : Colors.transparent,
            width: 2,
          ),
          bottom: BorderSide(
            color: show_bottom_border
                ? const Color(0xFFC94B14)
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: is_empty
          ? const SizedBox.expand()
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF66354C),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        file_name,
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

class CenterFlagCircle extends StatelessWidget {
  final double circle_size;

  const CenterFlagCircle({
    super.key,
    required this.circle_size,
  });

  @override
  Widget build(BuildContext context) {
    final double inner_dot_size = circle_size * 0.42;

    return Container(
      width: circle_size,
      height: circle_size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF2EFEF),
        border: Border.all(
          color: const Color(0xFFC94B14),
          width: 3,
        ),
      ),
      child: Center(
        child: Container(
          width: inner_dot_size,
          height: inner_dot_size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFF1E1E),
          ),
        ),
      ),
    );
  }
}
