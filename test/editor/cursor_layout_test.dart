import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('moving the caret at constant width keeps editor layout clean', (
    tester,
  ) async {
    final controller = QuillController.basic();
    final focusNode = FocusNode();
    final scrollController = ScrollController();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    addTearDown(scrollController.dispose);
    controller.document.insert(0, 'First line\nSecond line');
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates:
            FlutterQuillLocalizations.localizationsDelegates,
        home: QuillEditor(
          controller: controller,
          focusNode: focusNode,
          scrollController: scrollController,
          config: const QuillEditorConfig(),
        ),
      ),
    );
    focusNode.requestFocus();
    await tester.pump();
    final editor = tester.state<QuillRawEditorState>(
      find.byType(QuillRawEditor),
    );
    controller.updateSelection(
      const TextSelection.collapsed(offset: 12),
      ChangeSource.local,
    );
    await tester.pump(Duration.zero, EnginePhase.build);
    final needsLayout = editor.renderEditor.debugNeedsLayout;
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    expect(needsLayout, isFalse);
  });
}
