import 'package:http/http.dart';
import 'package:http_log/http_log.dart';

Future<void> main() async {
  final client = LoggingClient(
    Client(),
    storeLastRequest: true,
  );

  final response = await client.post(
    Uri.parse('http://httpbin.org/status/404'),
    headers: {
      'X-My-Header': 'Value',
    },
    body: 'Body',
  );

  if (response.statusCode >= 400) {
    print('Request failed:');
    print(client.lastRequest!.toRawHttpRequest());
    print(client.lastRequest!.toCurl(bodyFormat: BodyFormat.ascii));
  }
}
