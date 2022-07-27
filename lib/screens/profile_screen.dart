import 'dart:math';
import 'package:e2e_period_tracking/screens/mobile_unlocked_screen.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/utils/crypto_manager.dart';
import 'package:e2e_period_tracking/utils/validator.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  String? aesPassword;

  ProfileScreen({Key? key, this.aesPassword}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.aesPassword == null) {
        await showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) =>
                _ProfileBottomSheet(textController: _passwordController));
        setState(() {
          widget.aesPassword = _passwordController.text.isEmpty
              ? null
              : _passwordController.text;
        });
      }
    });
    // unlocking...
    if (widget.aesPassword == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // unlocked :)
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildMobile(context);
        // if (constraints.maxWidth < 600) {
        //   return _buildMobile(context);
        // } else {
        //   return _buildDesktop(context);
        // }
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    return MobileUnlockedProfile();
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Unlocked Profile Desktop'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("new item");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ProfileBottomSheet extends StatefulWidget {
  final TextEditingController textController;

  const _ProfileBottomSheet({Key? key, required this.textController})
      : super(key: key);

  @override
  State<_ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<_ProfileBottomSheet> {
  bool _isTryingUnlock = false;
  bool _wrongPassword = false;

  _tryUnlock(BuildContext context) async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isTryingUnlock = true;
    });

    if (await CryptoManager.instance
        .testEncryption(widget.textController.text)) {
      CryptoManager.aesPassword = widget.textController.text;
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isTryingUnlock = false;
        _wrongPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Insert Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kSizeH8,
                  const CustomText(
                    text: "We need to unlock your profile to access it.",
                    textAlign: TextAlign.center,
                  ),
                  kSizeH32,
                  TextField(
                    enabled: !_isTryingUnlock,
                    obscureText: true,
                    controller: widget.textController,
                    maxLength: Validator.charNumber,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _tryUnlock(context),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.inter().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  kSizeH32,
                  if (_wrongPassword) ...[
                    const CustomText(
                      text: 'Wrong password',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    kSizeH16,
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 32,
                          ),
                        ),
                        onPressed: widget.textController.text.length !=
                                    Validator.charNumber ||
                                _isTryingUnlock
                            ? null
                            : () => _tryUnlock(context),
                        child: const CustomText(
                          text: "UNLOCK",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isTryingUnlock) ...[
                        kSizeW16,
                        const CircularProgressIndicator(),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
