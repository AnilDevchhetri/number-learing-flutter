import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const NumberPracticeApp());
}

class NumberPracticeApp extends StatelessWidget {
  const NumberPracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Practice',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F2F3),
      ),
      home: const PracticePage(),
    );
  }
}

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>
    with TickerProviderStateMixin {
  /////////////////////////////////////////////////////////////////////////////
  // JSON DATA
  /////////////////////////////////////////////////////////////////////////////
  static const String practice_json = '''
[
  {
    "id": 1,
    "word": "465",
    "reading": "よんひゃくろくじゅうご",
    "answer": ["よん", "ひゃく", "ろく", "じゅう", "ご"],
    "option": ["ご", "よん", "なな", "ひゃく", "ろく", "じゅう", "に"],
    "detail": "465 = 400 + 60 + 5. In Japanese, 400 is よんひゃく, 60 is ろくじゅう, and 5 is ご."
  },
  {
    "id": 2,
    "word": "120",
    "reading": "ひゃくにじゅう",
    "answer": ["ひゃく", "に", "じゅう"],
    "option": ["に", "ひゃく", "じゅう", "ご", "なな", "よん"],
    "detail": "120 = 100 + 20. 100 is ひゃく and 20 is にじゅう."
  },
  {
    "id": 3,
    "word": "908",
    "reading": "きゅうひゃくはち",
    "answer": ["きゅう", "ひゃく", "はち"],
    "option": ["ひゃく", "はち", "きゅう", "さん", "に", "じゅう"],
    "detail": ""
  },
  {
    "id": 4,
    "word": "36",
    "reading": "さんじゅうろく",
    "answer": ["さん", "じゅう", "ろく"],
    "option": ["ろく", "じゅう", "さん", "よん", "はち", "きゅう"]
  },
  {
    "id": 5,
    "word": "700",
    "reading": "ななひゃく",
    "answer": ["なな", "ひゃく"],
    "option": ["なな", "ひゃく", "ご", "じゅう", "ろく"],
    "detail": "700 is ななひゃく."
  },
  {
    "id": 6,
    "word": "999",
    "reading": "きゅうひゃくきゅうじゅうきゅう",
    "answer": ["きゅう", "ひゃく", "きゅう", "じゅう", "きゅう"],
    "option": ["きゅう", "じゅう", "ひゃく", "よん", "ご", "きゅう", "に", "きゅう"],
    "detail": "999 = 900 + 90 + 9. So it becomes きゅうひゃく + きゅうじゅう + きゅう."
  }
]
''';

  final Random random = Random();

  late final List<Map<String, dynamic>> question_list;
  final List<int> used_id_list = [];

  Map<String, dynamic>? current_item;

  List<String?> selected_answer_list = [];
  List<Map<String, dynamic>> option_list = [];

  int current_question_number = 0;
  int correct_count = 0;
  int wrong_count = 0;
  bool is_finished = false;

  bool answer_checked = false;
  bool last_answer_correct = false;
  String feedback_text = '';
  Color feedback_color = Colors.transparent;

  late AnimationController fade_controller;
  late Animation<double> fade_animation;

  late AnimationController shake_controller;

  @override
  void initState() {
    super.initState();

    final List<dynamic> decoded_data = jsonDecode(practice_json);
    question_list = decoded_data
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    fade_controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    fade_animation = CurvedAnimation(
      parent: fade_controller,
      curve: Curves.easeOut,
    );

    shake_controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    load_next_question();
  }

  @override
  void dispose() {
    fade_controller.dispose();
    shake_controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> make_unique_option_list(List<String> raw_option_list) {
    final List<Map<String, dynamic>> unique_option_list = [];

    for (int i = 0; i < raw_option_list.length; i++) {
      unique_option_list.add({
        'option_id': i,
        'text': raw_option_list[i],
        'is_used': false,
      });
    }

    unique_option_list.shuffle(random);
    return unique_option_list;
  }

  void load_next_question() {
    if (used_id_list.length >= question_list.length) {
      setState(() {
        is_finished = true;
        current_item = null;
      });
      return;
    }

    final List<Map<String, dynamic>> remaining_list = question_list.where((item) {
      return !used_id_list.contains(item['id']);
    }).toList();

    final Map<String, dynamic> next_item =
        remaining_list[random.nextInt(remaining_list.length)];

    final List<String> raw_answer_list =
        List<String>.from(next_item['answer'] ?? []);
    final List<String> raw_option_list =
        List<String>.from(next_item['option'] ?? []);

    setState(() {
      current_item = next_item;
      used_id_list.add(next_item['id'] as int);
      current_question_number++;

      selected_answer_list = List<String?>.filled(raw_answer_list.length, null);
      option_list = make_unique_option_list(raw_option_list);

      answer_checked = false;
      last_answer_correct = false;
      feedback_text = '';
      feedback_color = Colors.transparent;
    });

    fade_controller.forward(from: 0);
  }

  void place_option_in_answer(int option_index) {
    if (answer_checked) return;
    if (option_list[option_index]['is_used'] == true) return;

    final int empty_index = selected_answer_list.indexOf(null);
    if (empty_index == -1) return;

    setState(() {
      selected_answer_list[empty_index] = option_list[option_index]['text'];
      option_list[option_index]['is_used'] = true;
    });

    check_if_answer_complete();
  }

  void place_dragged_option_in_answer(int option_id) {
    if (answer_checked) return;

    final int option_index = option_list.indexWhere(
      (item) => item['option_id'] == option_id,
    );

    if (option_index == -1) return;
    if (option_list[option_index]['is_used'] == true) return;

    final int empty_index = selected_answer_list.indexOf(null);
    if (empty_index == -1) return;

    setState(() {
      selected_answer_list[empty_index] = option_list[option_index]['text'];
      option_list[option_index]['is_used'] = true;
    });

    check_if_answer_complete();
  }

  void remove_answer_at(int answer_index) {
    if (answer_checked) return;

    final String? removed_text = selected_answer_list[answer_index];
    if (removed_text == null) return;

    final int option_index = option_list.indexWhere((item) {
      return item['text'] == removed_text && item['is_used'] == true;
    });

    if (option_index == -1) return;

    setState(() {
      selected_answer_list[answer_index] = null;
      option_list[option_index]['is_used'] = false;
    });
  }

  void check_if_answer_complete() {
    if (selected_answer_list.contains(null)) return;
    check_answer();
  }

  void check_answer() {
    if (current_item == null) return;

    final List<String> correct_answer_list =
        List<String>.from(current_item!['answer'] ?? []);
    final List<String> user_answer_list =
        selected_answer_list.map((item) => item ?? '').toList();

    final bool is_correct = list_equals(user_answer_list, correct_answer_list);

    setState(() {
      answer_checked = true;
      last_answer_correct = is_correct;

      if (is_correct) {
        correct_count++;
        feedback_text = 'Correct! → ${current_item!['reading']}';
        feedback_color = const Color(0xFF1FA35B);
      } else {
        wrong_count++;
        feedback_text = 'Wrong. Correct answer: ${current_item!['reading']}';
        feedback_color = const Color(0xFFD64646);
      }
    });

    if (!is_correct) {
      shake_controller.forward(from: 0);
    }
  }

  bool list_equals(List<String> first_list, List<String> second_list) {
    if (first_list.length != second_list.length) return false;

    for (int i = 0; i < first_list.length; i++) {
      if (first_list[i] != second_list[i]) return false;
    }

    return true;
  }

  void go_next_question() {
    load_next_question();
  }

  void restart_session() {
    setState(() {
      used_id_list.clear();
      current_item = null;
      selected_answer_list = [];
      option_list = [];
      current_question_number = 0;
      correct_count = 0;
      wrong_count = 0;
      is_finished = false;
      answer_checked = false;
      last_answer_correct = false;
      feedback_text = '';
      feedback_color = Colors.transparent;
    });

    load_next_question();
  }

  bool get has_detail {
    if (current_item == null) return false;

    final String detail_text = (current_item!['detail'] ?? '').toString().trim();
    return detail_text.isNotEmpty;
  }

  void show_detail_modal() {
    if (current_item == null) return;
    if (!has_detail) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2D7DA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Detail - ${current_item!['word']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF66354C),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  current_item!['reading'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC94B14),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  current_item!['detail'] ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF5C5457),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: is_finished ? build_result_screen() : build_practice_screen(),
      ),
    );
  }

  Widget build_result_screen() {
    final int total_count = question_list.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Practice Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF66354C),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Great job finishing this session.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A7D82),
                ),
              ),
              const SizedBox(height: 24),
              build_score_card('Total', '$total_count'),
              const SizedBox(height: 12),
              build_score_card('Correct', '$correct_count'),
              const SizedBox(height: 12),
              build_score_card('Wrong', '$wrong_count'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: restart_session,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC94B14),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Play Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build_score_card(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7D5D9),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF66354C),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFFC94B14),
            ),
          ),
        ],
      ),
    );
  }

  Widget build_practice_screen() {
    if (current_item == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final int total_count = question_list.length;
    final double progress_value = current_question_number / total_count;

    return FadeTransition(
      opacity: fade_animation,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool is_small_device = constraints.maxWidth < 390;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    build_top_bar(),
                    const SizedBox(height: 18),
                    build_progress_card(progress_value, total_count),
                    const SizedBox(height: 18),
                    build_question_card(is_small_device),
                    const SizedBox(height: 18),
                    build_answer_card(),
                    const SizedBox(height: 18),
                    build_option_area(is_small_device),
                    const SizedBox(height: 16),
                    build_bottom_action_row(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget build_top_bar() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Number Practice',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66354C),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x13000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            '$current_question_number / ${question_list.length}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFFC94B14),
            ),
          ),
        ),
      ],
    );
  }

  Widget build_progress_card(double progress_value, int total_count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Session Progress',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF66354C),
                  ),
                ),
              ),
              Text(
                '$current_question_number of $total_count',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A7D82),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress_value,
              minHeight: 12,
              backgroundColor: const Color(0xFFEADDE0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFC94B14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build_question_card(bool is_small_device) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(is_small_device ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6D3B52),
            Color(0xFF8B4D67),
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
            'Read this number',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFF5DEE6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            current_item!['word'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: is_small_device ? 46 : 58,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x22FFFFFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              current_item!['reading'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: is_small_device ? 18 : 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFF4F8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget build_answer_card() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
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
          const Text(
            'Build the correct reading',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66354C),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: shake_controller,
            builder: (context, child) {
              final double shake_value =
                  sin(shake_controller.value * pi * 6) * 8;
              return Transform.translate(
                offset: Offset(shake_value, 0),
                child: child,
              );
            },
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                selected_answer_list.length,
                (index) => build_answer_slot(index),
              ),
            ),
          ),
          if (feedback_text.isNotEmpty) ...[
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: feedback_color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: feedback_color.withOpacity(0.25)),
              ),
              child: Text(
                feedback_text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: feedback_color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget build_answer_slot(int index) {
    final String? text = selected_answer_list[index];
    final bool is_filled = text != null;

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => !is_filled && !answer_checked,
      onAcceptWithDetails: (details) {
        place_dragged_option_in_answer(details.data);
      },
      builder: (context, candidate_data, rejected_data) {
        final bool is_hovering = candidate_data.isNotEmpty;

        return GestureDetector(
          onTap: () {
            if (is_filled) {
              remove_answer_at(index);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 92,
            height: 66,
            decoration: BoxDecoration(
              color: is_filled
                  ? const Color(0xFFFFF5EF)
                  : is_hovering
                      ? const Color(0xFFFFE6D9)
                      : const Color(0xFFF7F3F4),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: is_hovering
                    ? const Color(0xFFC94B14)
                    : is_filled
                        ? const Color(0xFFC94B14)
                        : const Color(0xFFE2D7DA),
                width: is_hovering || is_filled ? 2 : 1.5,
              ),
            ),
            child: Center(
              child: Text(
                text ?? '＿',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: is_filled
                      ? const Color(0xFF66354C)
                      : const Color(0xFFBCB1B4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build_option_area(bool is_small_device) {
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
          const Text(
            'Pick from the tiles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66354C),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              option_list.length,
              (index) => build_option_tile(index, is_small_device),
            ),
          ),
        ],
      ),
    );
  }

  Widget build_option_tile(int index, bool is_small_device) {
    final bool is_used = option_list[index]['is_used'] == true;
    final String option_text = option_list[index]['text'];
    final int option_id = option_list[index]['option_id'];

    final Widget tile_child = AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: is_used ? 0.28 : 1,
      child: GestureDetector(
        onTap: is_used ? null : () => place_option_in_answer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: is_small_device ? 80 : 92,
          height: 60,
          decoration: BoxDecoration(
            gradient: is_used
                ? null
                : const LinearGradient(
                    colors: [
                      Color(0xFFFFF2EA),
                      Color(0xFFFFE1CF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            color: is_used ? const Color(0xFFF0E6E1) : null,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: is_used
                  ? const Color(0xFFD6C5BD)
                  : const Color(0xFFC94B14),
              width: 1.8,
            ),
            boxShadow: is_used
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              option_text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: is_small_device ? 18 : 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF66354C),
              ),
            ),
          ),
        ),
      ),
    );

    if (is_used) {
      return tile_child;
    }

    return Draggable<int>(
      data: option_id,
      feedback: Material(
        color: Colors.transparent,
        child: build_drag_feedback(option_text),
      ),
      childWhenDragging: Opacity(
        opacity: 0.18,
        child: tile_child,
      ),
      child: tile_child,
    );
  }

  Widget build_drag_feedback(String option_text) {
    return Transform.scale(
      scale: 1.06,
      child: Container(
        width: 96,
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFF2EA),
              Color(0xFFFFD9C1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFC94B14),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 14,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            option_text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF66354C),
            ),
          ),
        ),
      ),
    );
  }

  Widget build_bottom_action_row() {
    if (!answer_checked) {
      return Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF6D3B52),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            'Correct: $correct_count   Wrong: $wrong_count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        if (has_detail) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: show_detail_modal,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: const BorderSide(
                  color: Color(0xFFC94B14),
                  width: 1.6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                foregroundColor: const Color(0xFFC94B14),
              ),
              child: const Text(
                'View Detail',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: ElevatedButton(
            onPressed: go_next_question,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: const Color(0xFFC94B14),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
