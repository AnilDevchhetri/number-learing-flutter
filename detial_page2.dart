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
  "category_id": "counter_country",
  "category_title": "Country Counter",
  "category_subtitle": "How to count countries in Japanese",
  "item_list": [
    {
      "id": 1,
      "value": "1か国か国か国",
      "hiragana": "いっかこく",
      "romaji": "ikkakoku",
      "meaning": "one country",
      "description": "In Japanese, countries are counted using the counter か国 (かこく). The number 1 changes slightly when combined with the counter, so 1 + か国 becomes いっかこく instead of いちかこく.",
      "has_audio": true
    },
    {
      "id": 2,
      "value": "2か国",
      "hiragana": "にかこく",
      "romaji": "nikakoku",
      "meaning": "two countries",
      "description": "2か国 means two countries. The number に is combined with the counter か国 without changing pronunciation.",
      "has_audio": true
    },
    {
      "id": 3,
      "value": "3か国",
      "hiragana": "さんかこく",
      "romaji": "sankakoku",
      "meaning": "three countries",
      "description": "3か国 means three countries. さん combines smoothly with the counter か国.",
      "has_audio": true
    },
    {
      "id": 4,
      "value": "4か国",
      "hiragana": "よんかこく",
      "romaji": "yonkakoku",
      "meaning": "four countries",
      "description": "4か国 means four countries. The number よん is used here instead of し because よん is more common and easier to pronounce with counters.",
      "has_audio": true
    },
    {
      "id": 5,
      "value": "5eereか国",
      "hiragana": "ごかこく",
      "romaji": "gokakoku",
      "meaning": "five countries",
      "description": "5か国 means five countries. The number ご combines normally with the counter.",
      "has_audio": true
    },
    {
      "id": 6,
      "value": "6か国",
      "hiragana": "ろっかこく",
      "romaji": "rokkakoku",
      "meaning": "six countries",
      "description": "6か国 means six countries. The pronunciation changes slightly from ろく to ろっ when followed by counters like か国.",
      "has_audio": true
    },
    {
      "id": 7,
      "value": "7か国",
      "hiragana": "ななかこく",
      "romaji": "nanakakoku",
      "meaning": "seven countries",
      "description": "7か国 means seven countries. The number なな combines directly with the counter か国.",
      "has_audio": true
    },
    {
      "id": 8,
      "value": "8か国",
      "hiragana": "はっかこく",
      "romaji": "hakkakoku",
      "meaning": "eight countries",
      "description": "8か国 means eight countries. The number はち changes to はっ before counters like か国 for smoother pronunciation.",
      "has_audio": true
    },
    {
      "id": 9,
      "value": "9か国",
      "hiragana": "きゅうかこく",
      "romaji": "kyuukakoku",
      "meaning": "nine countries",
      "description": "9か国 means nine countries. The number きゅう combines normally with the counter.",
      "has_audio": true
    },
    {
      "id": 10,
      "value": "10か国",
      "hiragana": "じゅっかこく",
      "romaji": "jukkakoku",
      "meaning": "ten countries",
      "description": "10か国 means ten countries. The number じゅう changes to じゅっ before counters like か国.",
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
                constraints: const BoxConstraints(
                  minWidth: 74,
                  maxWidth: 96,
                  minHeight: 74,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    item_data['value'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
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
