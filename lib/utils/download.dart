import 'dart:convert';
import 'dart:html';

void download(
  List<int> bytes, {
  required String downloadName,
}) {
  final _base64 = base64Encode(bytes);
  final anchor = AnchorElement(href: 'data:application/json;base64,$_base64')
    ..target = 'blank';

  anchor.download = downloadName;
  document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}
