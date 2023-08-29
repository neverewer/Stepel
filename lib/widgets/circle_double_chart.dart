import 'package:stepel/imports.dart';

class CircleDoubleChart extends StatelessWidget {
  const CircleDoubleChart(
      {super.key,
      required this.steps,
      required this.cardioPoints,
      required this.stepsTarget,
      required this.cardiPointsTarget,
      this.size,
      this.width,
      this.smallSize,
      required this.showLabel,
      required this.animationEnabled,
      this.stepsLabelFontSize,
      this.cardioLabelFontSize});
  final int steps;
  final int cardioPoints;
  final int cardiPointsTarget;
  final int stepsTarget;
  final double? size;
  final double? smallSize;
  final double? width;
  final bool showLabel;
  final bool animationEnabled;
  final double? stepsLabelFontSize;
  final double? cardioLabelFontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      SleekCircularSlider(
        appearance: CircularSliderAppearance(
            animationEnabled: animationEnabled,
            size: size ?? 180,
            startAngle: 270,
            angleRange: 360,
            customWidths: CustomSliderWidths(
              progressBarWidth: width ?? 10,
              trackWidth: width ?? 10,
            ),
            customColors: CustomSliderColors(
                trackColor: const Color.fromARGB(255, 2, 173, 102).withOpacity(0.2),
                progressBarColor: const Color.fromARGB(255, 2, 173, 102),
                shadowMaxOpacity: 0,
                dotColor: Colors.transparent)),
        min: 0,
        max: stepsTarget.toDouble(),
        initialValue: steps > stepsTarget ? stepsTarget.toDouble() : steps.toDouble(),
        innerWidget: (value) {
          return const SizedBox();
        },
      ),
      SleekCircularSlider(
        appearance: CircularSliderAppearance(
            animationEnabled: animationEnabled,
            size: smallSize ?? 140,
            startAngle: 270,
            angleRange: 360,
            customWidths: CustomSliderWidths(
              progressBarWidth: width ?? 10,
              trackWidth: width ?? 10,
            ),
            customColors: CustomSliderColors(
                trackColor: Colors.blue.withOpacity(0.2),
                progressBarColor: Colors.blue,
                shadowMaxOpacity: 0,
                dotColor: Colors.transparent)),
        min: 0,
        max: cardiPointsTarget.toDouble(),
        initialValue: cardioPoints > cardiPointsTarget ? cardiPointsTarget.toDouble() : cardioPoints.toDouble(),
        innerWidget: (value) {
          return const SizedBox();
        },
      ),
      Opacity(
          opacity: showLabel ? 1 : 0,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(steps.toString(),
                  style: TextStyle(
                      fontSize: stepsLabelFontSize ?? 32,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 2, 173, 102))),
              Text(cardioPoints.toString(),
                  style:
                      TextStyle(fontSize: cardioLabelFontSize ?? 28, fontWeight: FontWeight.w500, color: Colors.blue))
            ],
          )))
    ]);
  }
}
