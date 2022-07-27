import 'dart:convert';

import 'package:e2e_period_tracking/models/symptom.dart';
import 'package:e2e_period_tracking/models/tracking_day.dart';
import 'package:e2e_period_tracking/screens/welcome_screen.dart';
import 'package:e2e_period_tracking/utils/constants.dart';
import 'package:e2e_period_tracking/utils/crypto_manager.dart';
import 'package:e2e_period_tracking/utils/download.dart';
import 'package:e2e_period_tracking/widgets/custom_text.dart';
import 'package:e2e_period_tracking/widgets/note_adder_bottom_sheet.dart';
import 'package:e2e_period_tracking/widgets/period_selector_bottom_sheet.dart';
import 'package:e2e_period_tracking/widgets/period_track_item.dart';
import 'package:e2e_period_tracking/widgets/profile_tracking_section.dart';
import 'package:e2e_period_tracking/widgets/symptom_selector_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileUnlockedProfile extends StatefulWidget {
  MobileUnlockedProfile({Key? key})
      : assert(CryptoManager.aesPassword.isNotEmpty),
        super(key: key);

  @override
  State<MobileUnlockedProfile> createState() => _MobileUnlockedProfileState();
}

class _MobileUnlockedProfileState extends State<MobileUnlockedProfile> {
  final _today = DateTime.now();
  late DateTime _currentDay;

  late List<DateTime> _currentDays;
  TrackingDay? _currentTrackingDay;
  late Map<String, TrackingDay> _userTrackingDays;

  @override
  void initState() {
    _userTrackingDays = {};
    _currentDay = _today;
    _currentDays = _buildDates(centerDay: _currentDay);
    _initTackingDays();

    super.initState();
  }

  List<DateTime> _buildDates({required DateTime centerDay}) {
    final prevs = [
      centerDay.subtract(const Duration(days: 3)),
      centerDay.subtract(const Duration(days: 2)),
      centerDay.subtract(const Duration(days: 1)),
    ];

    final nexts = [
      centerDay.add(const Duration(days: 1)),
      centerDay.add(const Duration(days: 2)),
      centerDay.add(const Duration(days: 3)),
    ];

    return [...prevs, centerDay, ...nexts];
  }

  _initTackingDays() async {
    _userTrackingDays = await CryptoManager.instance.getTrackingDays();
    setState(() {
      _currentTrackingDay =
          _userTrackingDays[CryptoManager.getTrackingDayKeyMap(_currentDay)];
    });
  }

  _changePeriod() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => PeriodSelectorBottomSheet(
        onSelectPeriod: (period) {
          if (_currentTrackingDay == null) {
            setState(() {
              _currentTrackingDay = TrackingDay(
                date: _currentDay,
                period: period,
                symptoms: [],
                notes: [],
              );
              _userTrackingDays[
                      CryptoManager.getTrackingDayKeyMap(_currentDay)] =
                  _currentTrackingDay!;
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          } else {
            setState(() {
              _currentTrackingDay!.period = period;
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  _addSymptom() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SymptomsSelectorBottomSheet(
        onSelectSymptom: (symptom) {
          if (_currentTrackingDay == null) {
            setState(() {
              _currentTrackingDay = TrackingDay(
                date: _currentDay,
                symptoms: [symptom],
                notes: [],
              );
              _userTrackingDays[
                      CryptoManager.getTrackingDayKeyMap(_currentDay)] =
                  _currentTrackingDay!;
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          } else {
            if (_currentTrackingDay!.symptoms == null) {
              setState(() {
                _currentTrackingDay!.symptoms = [symptom];
                CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
              });
              Navigator.pop(context);
              return;
            }

            if (_currentTrackingDay!.symptoms?.contains(symptom) == true) {
              Navigator.pop(context);
              return;
            }

            setState(() {
              _currentTrackingDay!.symptoms?.add(symptom);
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  _addNote() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NoteAdderBottomSheet(
        onSubmit: (note) {
          if (_currentTrackingDay == null) {
            setState(() {
              _currentTrackingDay = TrackingDay(
                date: _currentDay,
                notes: [note],
                symptoms: [],
              );
              _userTrackingDays[
                      CryptoManager.getTrackingDayKeyMap(_currentDay)] =
                  _currentTrackingDay!;
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          } else {
            if (_currentTrackingDay!.notes == null) {
              setState(() {
                _currentTrackingDay!.notes = [note];
                CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
              });
              Navigator.pop(context);
              return;
            }

            if (_currentTrackingDay!.notes?.contains(note) == true) {
              Navigator.pop(context);
              return;
            }
            setState(() {
              _currentTrackingDay!.notes?.add(note);
              CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
            });
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  _askDeleteSymptom({required Symptom symptom}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete symptom'),
        content:
            Text('Are you sure you want to delete "${symptom.description}"?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              if (_currentTrackingDay == null) {
                Navigator.pop(context);
                return;
              }
              if (_currentTrackingDay!.symptoms?.contains(symptom) == true) {
                setState(() {
                  _currentTrackingDay!.symptoms!.remove(symptom);
                  CryptoManager.instance
                      .upsertTrackingDay(_currentTrackingDay!);
                });
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _askDeleteNote({required int index}) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete note'),
        content: Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              if (_currentTrackingDay == null) {
                Navigator.pop(context);
                return;
              }
              setState(() {
                _currentTrackingDay!.notes?.removeAt(index);
                CryptoManager.instance.upsertTrackingDay(_currentTrackingDay!);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _askDeleteAccount() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete account'),
        content: Text(
            'Are you sure you want to delete your data?\n\nYou will be logged out.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const WelcomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: CustomText(
                text: 'E2E Period Tracker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomText(
                    text: "Download your data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  kSizeW8,
                  Icon(
                    Icons.download,
                  )
                ],
              ),
              onTap: () async => download(
                  json.encode(_userTrackingDays).codeUnits,
                  downloadName: "e2e_period_decrypted_data.json"),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CustomText(
                    text: "Destroy your data",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  kSizeW8,
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  )
                ],
              ),
              onTap: () async => _askDeleteAccount(),
            ),
            ListTile(
              title: const CustomText(
                text: "Lougout",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CustomText(
                text: DateFormat("MMMM, yyyy").format(_currentDay),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              kSizeH16,
              SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        _currentDay =
                            _currentDay.subtract(const Duration(days: 7));
                        _currentDays = _buildDates(centerDay: _currentDay);
                      }),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    kSizeW16,
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _currentDays.length,
                      itemBuilder: (context, index) {
                        final day = _currentDays[index];
                        return InkWell(
                          onTap: () => setState(() {
                            _currentDay = day;
                            _currentTrackingDay = _userTrackingDays[
                                CryptoManager.getTrackingDayKeyMap(day)];
                            _currentDays = _buildDates(centerDay: _currentDay);
                          }),
                          child: PeriodTrackItem(
                            day: day,
                            isCenter: index == 3,
                            trackingDay: _userTrackingDays[
                                CryptoManager.getTrackingDayKeyMap(day)],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 4,
                      ),
                    ),
                    kSizeW16,
                    IconButton(
                      onPressed: () => setState(() {
                        _currentDay = _currentDay.add(const Duration(days: 7));
                        _currentDays = _buildDates(centerDay: _currentDay);
                      }),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              kSizeH32,
              ProfilePeriodSection(
                period: _currentTrackingDay?.period ?? Period.noFlow,
                onTapChange: () async => await _changePeriod(),
              ),
              kSizeH8,
              ProfileTrackingSection(
                title: "Symptoms",
                elements: _currentTrackingDay?.symptoms ?? [],
                noElementsText: "No symptoms",
                onPressAdd: () async => await _addSymptom(),
                itemAtIndex: (index) => InkWell(
                  onTap: () async => await _askDeleteSymptom(
                    symptom: _currentTrackingDay!.symptoms![index],
                  ),
                  child: CustomText(
                    text:
                        _currentTrackingDay?.symptoms?[index].description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              kSizeH8,
              ProfileTrackingSection(
                title: "Notes",
                elements: _currentTrackingDay?.notes ?? [],
                noElementsText: "No notes",
                onPressAdd: () async => await _addNote(),
                separatorHeight: 12,
                itemAtIndex: (index) => InkWell(
                  onTap: () async => await _askDeleteNote(index: index),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.black54,
                      ),
                      kSizeW8,
                      CustomText(
                        text: _currentTrackingDay?.notes?[index] ?? '',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePeriodSection extends StatelessWidget {
  final Period period;
  final Function onTapChange;
  const ProfilePeriodSection({
    Key? key,
    required this.period,
    required this.onTapChange,
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
              const CustomText(
                text: "Period",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  onTapChange();
                },
                child: const CustomText(
                  text: "Change",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          kSizeH16,
          CustomText(
            text: period.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
