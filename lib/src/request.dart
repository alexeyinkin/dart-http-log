import 'dart:convert';

import 'package:http/http.dart';

extension on Uri {
  String get pathWithQuery {
    String result = path;

    if (query.isNotEmpty) {
      result += '?$query';
    }

    return result;
  }
}

extension HttpLog on BaseRequest {
  String toRawHttpRequest() {
    final buffer = StringBuffer('${method} ${url.pathWithQuery} HTTP/1.1\r\n');

    buffer.write('Host: ${url.host}\r\n');

    for (final entry in headers.entries) {
      buffer.write('${entry.key}: ${entry.value}\r\n');
    }

    buffer.write('\r\n');

    if (this is Request) {
      buffer.write((this as Request).body);
    }

    return buffer.toString();
  }

  String toCurl({required BodyFormat bodyFormat}) {
    final buffer = StringBuffer(
      "curl \\\n"
      "  -X ${method.toUpperCase()} \\\n"
      "  '${url.toString()}'",
    );

    for (final entry in headers.entries) {
      buffer.write(" \\\n  -H '${entry.key}: ${entry.value}'");
    }

    if (this is Request) {
      switch (bodyFormat) {
        case BodyFormat.ascii:
          final body = (this as Request).body;
          if (body.isNotEmpty) {
            buffer
                .write(" \\\n  --data-ascii '${body.replaceAll("'", "\\'")}'");
          }
        case BodyFormat.binary:
          final bodyBytes = (this as Request).bodyBytes;
          if (bodyBytes.isNotEmpty) {
            final base64Body = base64Encode(bodyBytes);
            buffer.write(
              " \\\n  --data-binary '@<(echo ${base64Body} | base64 --decode)'",
            );
          }
      }
    }

    return buffer.toString();
  }
}

enum BodyFormat {
  ascii,
  binary,
}
