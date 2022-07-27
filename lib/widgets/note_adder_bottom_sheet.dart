import 'package:e2e_period_tracking/models/symptom.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class NoteAdderBottomSheet extends StatelessWidget {
  final Function(String) onSubmit;
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> _text = ValueNotifier<String>('');

  NoteAdderBottomSheet({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kSizeH16,
                const CustomText(
                  text: "Write a note for this day",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                kSizeH32,
                TextField(
                  maxLines: 10,
                  minLines: 3,
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Note",
                  ),
                  onSubmitted: (text) => onSubmit(text),
                  onChanged: (value) => _text.value = value,
                ),
                kSizeH32,
                ValueListenableBuilder<String>(
                  valueListenable: _text,
                  builder: (context, value, _) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                    ),
                    onPressed: value.isNotEmpty
                        ? () => onSubmit(controller.text)
                        : null,
                    child: const CustomText(
                      text: "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
