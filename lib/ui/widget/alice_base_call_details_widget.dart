import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_alice/helper/alice_conversion_helper.dart';
import 'package:flutter_alice/ui/utils/alice_parser.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

abstract class AliceBaseCallDetailsWidgetState<T extends StatefulWidget> extends State<T> {
  final JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  Widget getListRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(name, style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(padding: EdgeInsets.only(left: 5)),
        Flexible(
            fit: FlexFit.loose,
            child: MarkdownBody(
              data: '`$value`',
              selectable: true,
            )
            // SelectableText(
            //   value,
            // ),
            ),
        Padding(
          padding: EdgeInsets.only(bottom: 18),
        )
      ],
    );
  }

  String formatBytes(int bytes) => AliceConversionHelper.formatBytes(bytes);

  String formatDuration(int duration) => AliceConversionHelper.formatTime(duration);

  String? formatBody(dynamic body, String? contentType) => AliceParser.formatBody(body, contentType);

  String? getContentType(Map<String, dynamic>? headers) => AliceParser.getContentType(headers);
}
