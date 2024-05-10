A logger for HTTP requests.

This is currently a work in progress.
Only a single use case is now supported: storing the last request.
It can be used to debug failed requests like this:

```dart
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
```

Output:

```
Request failed:
POST /status/404 HTTP/1.1
Host: httpbin.org
X-My-Header: Value
content-type: text/plain; charset=utf-8

Body
curl \
  -X POST \
  'http://httpbin.org/status/404' \
  -H 'X-My-Header: Value' \
  -H 'content-type: text/plain; charset=utf-8' \
  --data-ascii 'Body'
```
