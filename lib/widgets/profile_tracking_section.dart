import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ProfileTrackingSection<T> extends StatelessWidget {
  final String title;
  final List<T> elements;
  final String noElementsText;
  final Function onPressAdd;
  final double separatorHeight;
  final Widget Function(int index) itemAtIndex;

  const ProfileTrackingSection({
    Key? key,
    required this.title,
    required this.elements,
    this.noElementsText = "No elements",
    required this.onPressAdd,
    required this.itemAtIndex,
    this.separatorHeight = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CustomText(
                text: title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  onPressAdd();
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          kSizeH16,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 227, 227, 227),
            ),
            child: elements.isNotEmpty
                ? ListView.separated(
                    shrinkWrap: true,
                    itemCount: elements.length,
                    itemBuilder: (_, index) {
                      return itemAtIndex(index);
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 8,
                    ),
                  )
                : CustomText(
                    text: noElementsText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
