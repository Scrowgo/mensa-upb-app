import 'package:material_ui/material_ui.dart';
import 'package:mensa_app/ui/core/theme/theme.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// This file does not exist yet,
// it will be generated in the next step
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // The [directories] variable does not exist yet,
      // it will be generated in the next step
      directories: directories,
      addons: [
        ViewportAddon(Viewports.all),
        AlignmentAddon(initialAlignment: .center),
        BuilderAddon(
          name: 'ThemeDataScope',
          builder: ((context, child) {
            return Theme(data: AppTheme.dark, child: child);
          }),
        ),
      ],
    );
  }
}
