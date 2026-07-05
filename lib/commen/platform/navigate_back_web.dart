import 'dart:js_interop';

@JS('window.history.back')
external void _goBack();

void navigateBack() => _goBack();
