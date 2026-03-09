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
      title: 'Basic Numbers',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F1F2),
        useMaterial3: false,
      ),
      home: const BasicNumberListPage(),
    );
  }
}

class BasicNumberListPage extends StatelessWidget {
  const BasicNumberListPage({super.key});

  /////////////////////////////////////////////////////////////////////////////
  // JSON DATA
  /////////////////////////////////////////////////////////////////////////////
  static const String basic_number_json = '''
{
  "category_id": "basic_number",
  "category_title": "Basic Numbers",
  "category_subtitle": "Learn how to read Japanese numbers",
  "item_list": [
    {
      "id": 1,
      "value": "1",
      "hiragana": "いち",
      "romaji": "ichi",
      "meaning": "one",
      "description": "1 is read as いち in basic Japanese number reading.",
      "has_audio": true
    },
    {
      "id": 2,
      "value": "2",
      "hiragana": "に",
      "romaji": "ni",
      "meaning": "two",
      "description": "2 is read as に.",
      "has_audio": true
    },
    {
      "id": 3,
      "value": "3",
      "hiragana": "さん",
      "romaji": "san",
      "meaning": "three",
      "description": "3 is read as さん.",
      "has_audio": true
    },
    {
      "id": 4,
      "value": "4",
      "hiragana": "よん",
      "romaji": "yon",
      "meaning": "four",
      "description": "4 can sometimes be read as し, but よん is very common for basic counting.",
      "has_audio": true
    },
    {
      "id": 5,
      "value": "5",
      "hiragana": "ご",
      "romaji": "go",
      "meaning": "five",
      "description": "5 is read as ご.",
      "has_audio": true
    },
    {
      "id": 6,
      "value": "6",
      "hiragana": "ろく",
      "romaji": "roku",
      "meaning": "six",
      "description": "6 is read as ろく.",
      "has_audio": true
    },
    {
      "id": 7,
      "value": "7",
      "hiragana": "なな",
      "romaji": "nana",
      "meaning": "seven",
      "description": "7 can also be read as しち in some cases, but なな is common in basic learning.",
      "has_audio": true
    },
    {
      "id": 8,
      "value": "8",
      "hiragana": "はち",
      "romaji": "hachi",
      "meaning": "eight",
      "description": "8 is read as はち.",
      "has_audio": true
    },
    {
      "id": 9,
      "value": "9",
      "hiragana": "きゅう",
      "romaji": "kyuu",
      "meaning": "nine",
      "description": "9 can also be read as く in some compounds, but きゅう is common here.",
      "has_audio": true
    },
    {
      "id": 10,
      "value": "10",
      "hiragana": "じゅう",
      "romaji": "juu",
      "meaning": "ten",
      "description": "10 is read as じゅう.",
      "has_audio": true
    },
    {
      "id": 11,
      "value": "11",
      "hiragana": "じゅういち",
      "romaji": "juu ichi",
      "meaning": "eleven",
      "description": "11 = 10 + 1, so it becomes じゅう + いち = じゅういち.",
      "has_audio": true
    },
    {
      "id": 12,
      "value": "12",
      "hiragana": "じゅうに",
      "romaji": "juu ni",
      "meaning": "twelve",
      "description": "12 = 10 + 2, so it becomes じゅうに.",
      "has_audio": true
    },
    {
      "id": 13,
      "value": "20",
      "hiragana": "にじゅう",
      "romaji": "ni juu",
      "meaning": "twenty",
      "description": "20 = 2 x 10, so it becomes にじゅう.",
      "has_audio": true
    },
    {
      "id": 14,
      "value": "21",
      "hiragana": "にじゅういち",
      "romaji": "ni juu ichi",
      "meaning": "twenty-one",
      "description": "21 = 20 + 1, so it becomes にじゅういち.",
      "has_audio": true
    },
    {
      "id": 15,
      "value": "99",
      "hiragana": "きゅうじゅうきゅう",
      "romaji": "kyuu juu kyuu",
      "meaning": "ninety-nine",
      "description": "99 = 90 + 9, so it becomes きゅうじゅうきゅう.",
      "has_audio": true
    },
    {
      "id": 16,
      "value": "100",
      "hiragana": "ひゃく",
      "romaji": "hyaku",
      "meaning": "one hundred",
      "description": "100 is read as ひゃく.",
      "has_audio": true
    },
    {
      "id": 17,
      "value": "101",
      "hiragana": "ひゃくいち",
      "romaji": "hyaku ichi",
      "meaning": "one hundred one",
      "description": "101 = 100 + 1, so it becomes ひゃくいち.",
      "has_audio": true
    },
    {
      "id": 18,
      "value": "110",
      "hiragana": "ひゃくじゅう",
      "romaji": "hyaku juu",
      "meaning": "one hundred ten",
      "description": "110 = 100 + 10, so it becomes ひゃくじゅう.",
      "has_audio": true
    },
    {
      "id": 19,
      "value": "111",
      "hiragana": "ひゃくじゅういち",
      "romaji": "hyaku juu ichi",
      "meaning": "one hundred eleven",
      "description": "111 = 100 + 10 + 1, so it becomes ひゃくじゅういち.",
      "has_audio": true
    },
    {
      "id": 20,
      "value": "300",
      "hiragana": "さんびゃく",
      "romaji": "sanbyaku",
      "meaning": "three hundred",
      "description": "300 is an important exception. It is さんびゃく, not さんひゃく.",
      "has_audio": true
    }
  ]
}
''';

  Map<String, dynamic> get page_data {
    return Map<String, dynamic>.from(jsonDecode(basic_number_json));
  }

  List<Map<String, dynamic>> get item_list {
    final List<dynamic> decoded_item_list = page_data['item_list'] ?? [];
    return decoded_item_list
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  void show_detail_modal(
    BuildContext context,
    Map<String, dynamic> item_data,
  ) {
    final String description =
        (item_data['description'] ?? '').toString().trim();

    if (description.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 52,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1D7DA),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Detail for ${item_data['value'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF66354C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item_data['hiragana'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFC94B14),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item_data['romaji'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A7D82),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color: Color(0xFF534B4E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void open_detail_page(
    BuildContext context,
    Map<String, dynamic> item_data,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicNumberDetailPage(
          item_data: item_data,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String category_title = page_data['category_title'] ?? '';
    final String category_subtitle = page_data['category_subtitle'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              decoration: const BoxDecoration(
                color: Color(0xFFF6F1F2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category_title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF66354C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category_subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A7D82),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                itemCount: item_list.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  final Map<String, dynamic> item_data = item_list[index];

                  return BasicNumberListCard(
                    item_data: item_data,
                    on_tap: () => open_detail_page(context, item_data),
                    on_sound_tap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Audio later: ${item_data['hiragana'] ?? ''}',
                          ),
                        ),
                      );
                    },
                    on_info_tap: () => show_detail_modal(context, item_data),
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

class BasicNumberListCard extends StatelessWidget {
  final Map<String, dynamic> item_data;
  final VoidCallback on_tap;
  final VoidCallback on_sound_tap;
  final VoidCallback on_info_tap;

  const BasicNumberListCard({
    super.key,
    required this.item_data,
    required this.on_tap,
    required this.on_sound_tap,
    required this.on_info_tap,
  });

  bool get has_description {
    final String description = (item_data['description'] ?? '').toString().trim();
    return description.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bool has_audio = item_data['has_audio'] == true;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: on_tap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFC94B14),
              width: 1.6,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    item_data['value'] ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF66354C),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item_data['hiragana'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF66354C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item_data['romaji'] ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8A7D82),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item_data['meaning'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5E5659),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  if (has_audio)
                    _CircleIconButton(
                      icon_data: Icons.volume_up_rounded,
                      on_tap: on_sound_tap,
                    ),
                  if (has_audio && has_description) const SizedBox(height: 10),
                  if (has_description)
                    _CircleIconButton(
                      icon_data: Icons.info_outline_rounded,
                      on_tap: on_info_tap,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon_data;
  final VoidCallback on_tap;

  const _CircleIconButton({
    required this.icon_data,
    required this.on_tap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F2F3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: on_tap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon_data,
            size: 22,
            color: const Color(0xFFC94B14),
          ),
        ),
      ),
    );
  }
}

class BasicNumberDetailPage extends StatelessWidget {
  final Map<String, dynamic> item_data;

  const BasicNumberDetailPage({
    super.key,
    required this.item_data,
  });

  bool get has_description {
    final String description = (item_data['description'] ?? '').toString().trim();
    return description.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final String value = item_data['value'] ?? '';
    final String hiragana = item_data['hiragana'] ?? '';
    final String romaji = item_data['romaji'] ?? '';
    final String meaning = item_data['meaning'] ?? '';
    final String description = item_data['description'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF66354C),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Number Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF66354C),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Audio later: $hiragana'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.volume_up_rounded,
                      color: Color(0xFFC94B14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6D3B52),
                            Color(0xFF8A4B66),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Basic Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFF3E0E7),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            value,
                            style: const TextStyle(
                              fontSize: 62,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x22FFFFFF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              hiragana,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            romaji,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFFF3E0E7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _DetailSectionCard(
                      title: 'Meaning',
                      child: Text(
                        meaning,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF534B4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _DetailSectionCard(
                      title: 'Reading',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(
                            label: 'Hiragana',
                            value: hiragana,
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            label: 'Romaji',
                            value: romaji,
                          ),
                        ],
                      ),
                    ),
                    if (has_description) ...[
                      const SizedBox(height: 14),
                      _DetailSectionCard(
                        title: 'Description',
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Color(0xFF534B4E),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _DetailSectionCard(
                      title: 'Quick Note',
                      child: Text(
                        '$value is read as $hiragana in Japanese.',
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: Color(0xFF534B4E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66354C),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4ED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC94B14),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF534B4E),
            ),
          ),
        ),
      ],
    );
  }
}
