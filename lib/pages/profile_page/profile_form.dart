import 'package:stepel/blocs/profile_page/profile_cubit.dart';
import 'package:stepel/blocs/profile_page/profile_state.dart';
import 'package:stepel/imports.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return state.map(
        idle: (_) => const LoadingForm(),
        processing: (_) => const LoadingForm(),
        successful: (state) => DataWidget(
          stepsTarget: state.stepsTarget,
          cardioPointsTarget: state.cardioPointsTarget,
          isSleepingModeActive: state.isSleepingModeActive,
          wakeUpTIme: state.wakeUpTime,
          timeToSleep: state.timeToSleep,
        ),
        error: (_) => const SizedBox(),
      );
    });
  }
}

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 24,
                  color: Colors.black,
                )),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
            )
          ],
        ));
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.grey.shade900),
        ));
  }
}

class SectionLabelWithSwitch extends StatefulWidget {
  const SectionLabelWithSwitch({super.key, required this.text, required this.value});
  final String text;
  final bool value;

  @override
  State<SectionLabelWithSwitch> createState() => _SectionLabelWithSwitchState();
}

class _SectionLabelWithSwitchState extends State<SectionLabelWithSwitch> {
  late bool isSwitched;

  @override
  void initState() {
    isSwitched = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade900,
                )),
            Switch(
                value: isSwitched,
                onChanged: (onChanged) {
                  setState(() {
                    isSwitched = !isSwitched;
                    context.read<ProfileCubit>().activeDailySleepingModeNotifications(isSwitched);
                  });
                })
          ],
        ));
  }
}

class InfoBox extends StatefulWidget {
  const InfoBox({super.key, required this.label, required this.value, this.onTap, this.isActive = true});
  final String label;
  final String value;
  final bool isActive;
  final Function()? onTap;

  @override
  State<InfoBox> createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  final FocusNode _focusNode = FocusNode();
  bool _selected = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _selected = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.isActive
            ? () {
                FocusScope.of(context).requestFocus(_focusNode);
                if (widget.onTap != null) {
                  widget.onTap!.call();
                }
              }
            : null,
        child: SizedBox(
          height: 65,
          width: 160,
          child: Stack(
            children: [
              Positioned.fill(
                  top: 6,
                  left: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                        border: Border.all(
                            color: _selected
                                ? Colors.blue
                                : widget.isActive
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300,
                            width: _selected ? 2 : 1)),
                  )),
              Positioned(
                  top: 2,
                  left: 15,
                  child: DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(widget.label,
                              style: TextStyle(
                                  color: _selected
                                      ? Colors.blue
                                      : widget.isActive
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300,
                                  fontSize: 12))))),
              Positioned.fill(
                  left: 10,
                  top: 6,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: widget.isActive ? Colors.grey.shade700 : Colors.grey.shade300,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: widget.isActive ? Colors.grey.shade700 : Colors.grey.shade300,
                            )
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }
}

class SleepingModeBox extends StatelessWidget {
  const SleepingModeBox({super.key, required this.isActive, required this.wakeUpTime, required this.timeToSleep});
  final bool isActive;
  final TimeOfDay wakeUpTime;
  final TimeOfDay timeToSleep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InfoBox(
          isActive: isActive,
          label: 'Отход ко сну',
          value: timeToSleep.format(context),
          onTap: () async {
            var pickedTime = await showTimePicker(
              context: context,
              initialTime: timeToSleep,
              initialEntryMode: TimePickerEntryMode.input,
              helpText: 'ВЫБОР ВРЕМЕНИ',
              hourLabelText: 'Час',
              minuteLabelText: 'Минуты',
              cancelText: 'Отмена',
              confirmText: 'ОК',
            );

            if (pickedTime != null && context.mounted) {
              context.read<ProfileCubit>().setTimeToSleep(pickedTime);
            }
          },
        ),
        InfoBox(
          isActive: isActive,
          label: 'Пробуждение',
          value: wakeUpTime.format(context),
          onTap: () async {
            var pickedTime = await showTimePicker(
              context: context,
              initialTime: wakeUpTime,
              initialEntryMode: TimePickerEntryMode.input,
              helpText: 'ВЫБОР ВРЕМЕНИ',
              hourLabelText: 'Час',
              minuteLabelText: 'Минуты',
              cancelText: 'Отмена',
              confirmText: 'ОК',
            );

            if (pickedTime != null && context.mounted) {
              context.read<ProfileCubit>().setWakeUpTime(pickedTime);
            }
          },
        ),
      ],
    );
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget(
      {super.key,
      required this.stepsTarget,
      required this.cardioPointsTarget,
      required this.isSleepingModeActive,
      required this.wakeUpTIme,
      required this.timeToSleep});
  final int stepsTarget;
  final int cardioPointsTarget;
  final bool isSleepingModeActive;
  final TimeOfDay wakeUpTIme;
  final TimeOfDay timeToSleep;

  Future<int?> showValuePicker(
      {required BuildContext context,
      required String title,
      required int currentValue,
      required int minValue,
      required int maxValue,
      required int step}) async {
    return await showDialog<int>(
        context: context,
        builder: (_) {
          var curValue = currentValue;
          return AlertDialog(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 120),
            title: Text(title),
            content: StatefulBuilder(builder: (_, setState) {
              return NumberPicker(
                  itemHeight: 50,
                  minValue: minValue,
                  maxValue: maxValue,
                  step: step,
                  value: curValue,
                  haptics: true,
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(width: 1.5, color: Colors.grey.shade700),
                    bottom: BorderSide(width: 1.5, color: Colors.grey.shade700),
                  )),
                  onChanged: (value) {
                    setState(() => curValue = value);
                  });
            }),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, curValue);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          actions: const [AppBarActions()],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: PageTitle(
                    title: 'Профиль',
                    titleFontSize: 36,
                  )),
              const SizedBox(height: 20),
              const SectionLabel(text: 'Фитнес-цели'),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.5,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoBox(
                      label: 'Шаги',
                      value: stepsTarget.toString(),
                      onTap: () async {
                        int? result = await showValuePicker(
                          context: context,
                          title: 'Шаги',
                          currentValue: stepsTarget,
                          minValue: 500,
                          maxValue: 100000,
                          step: 500,
                        );
                        if (result != null && context.mounted) {
                          context.read<ProfileCubit>().setStepsTarget(result);
                        }
                      }),
                  InfoBox(
                    label: 'Баллы кардиотренировок',
                    value: cardioPointsTarget.toString(),
                    onTap: () async {
                      int? result = await showValuePicker(
                        context: context,
                        title: 'Баллы кардиотренировок',
                        currentValue: cardioPointsTarget,
                        minValue: 5,
                        maxValue: 200,
                        step: 5,
                      );
                      if (result != null && context.mounted) {
                        context.read<ProfileCubit>().setCardioPointsTarget(result);
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              SectionLabelWithSwitch(text: 'Расписание режима сна', value: isSleepingModeActive),
              Divider(
                thickness: 1.5,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 15,
              ),
              SleepingModeBox(
                isActive: isSleepingModeActive,
                timeToSleep: timeToSleep,
                wakeUpTime: wakeUpTIme,
              ),
              const SizedBox(height: 30),
              const SectionLabel(text: 'Ваши данные'),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.5,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InfoBox(label: 'Пол', value: 'Мужской'),
                  InfoBox(label: 'День рождения', value: '4 февр. 1994 г.')
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [InfoBox(label: 'Вес', value: '73 кг'), InfoBox(label: 'Рост', value: '180 см')],
              ),
            ],
          ),
        ));
  }
}
