import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class NoteSection extends StatelessWidget {
  final TextEditingController noteController;
  final ScrollController noteScrollController;

  const NoteSection({
    Key? key,
    required this.noteController,
    required this.noteScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return _buildSectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(s.note),
          _buildNoteTextField(s),
        ],
      ),
    );
  }

  Widget _buildNoteTextField(S s) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 5 * 24.0,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        controller: noteScrollController,
        child: SingleChildScrollView(
          controller: noteScrollController,
          child: TextField(
            controller: noteController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: s.enterNote,
              hintStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.grey[700],
      ),
    );
  }
}
