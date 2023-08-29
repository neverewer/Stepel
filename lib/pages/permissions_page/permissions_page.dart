import 'package:stepel/imports.dart';

@RoutePage()
class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.only(top: 80, right: 20, left: 20, bottom: 10),
            child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ScreenIcon(),
                  SizedBox(height: 20),
                  Title(),
                  SizedBox(height: 20),
                  SubTitle(),
                ],
              ),
              ButtonsRow()
            ])));
  }
}

class ScreenIcon extends StatelessWidget {
  const ScreenIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.directions_run,
      size: 50,
      color: Colors.blue.shade800,
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Отслеживать мою активность',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Stepel может отслеживать в фоновом режиме показатели ходьбы. Это означает, что вы будете получать информацию о числе шагов, пройденном расстоянии и расходе калорий для данного вида активности. \n\nStepel может отслеживать в фоновом режиме показатели ходьбы. Это означает, что вы будете получать информацию о числе шагов, пройденном расстоянии и расходе калорий для данного вида активности. \n\nЕсли вы не хотите давать разрешение, приложение не сможет отслеживать вашу активность и будет бесполезным.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, height: 1.5),
    );
  }
}

class ButtonsRow extends StatelessWidget {
  const ButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
      RejectButton(),
      ConfirmButton(),
    ]);
  }
}

class RejectButton extends StatelessWidget {
  const RejectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => SystemNavigator.pop(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        overlayColor: MaterialStateProperty.all<Color>(Colors.blue.shade200),
        elevation: MaterialStateProperty.all<double?>(0),
      ),
      child: Text(
        'Нет, спасибо',
        style: TextStyle(color: Colors.blue.shade800),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var permissionsGranted = await PermissionsService.checkPermissions();
        LocalStorageService.instance.setPermissionsGranted(permissionsGranted);
        if (permissionsGranted && context.mounted) {
          context.router.replaceNamed('/main');
        }
      },
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800)),
      child: const Text('Включить'),
    );
  }
}
