import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/widgets/profile_widgets/profile_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders long text without overflow at 300px', (tester) async {
    tester.view.physicalSize = const Size(300, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: ProfileInfoRow(
              label: 'Very Long Label Name for Academic Profile Information',
              value:
                  'really_long_student_email_address_that_causes_overflow@domain.example.com',
              icon: ImageManager.emailIcon,
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ProfileInfoRow), findsOneWidget);
  });

  testWidgets('triggers onEdit callback when tapped', (tester) async {
    var edited = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileInfoRow(
            label: 'Name',
            value: 'Student',
            icon: ImageManager.annotationTyping,
            onEdit: () => edited = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(IconButton));
    expect(edited, isTrue);
  });
}
