import 'package:flutter/material.dart';

import 'package:remindly_app/widgets/empty_state.dart';

class CourseDetailPage extends StatelessWidget {
  const new({required this.courseId, super.key});

  final int courseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mata Kuliah')),
      body: EmptyState(
        message: '0 dari 0 tugas selesai. Tambah tugas pertama.',
        onAdd: () {},
      ),
    );
  }
}
