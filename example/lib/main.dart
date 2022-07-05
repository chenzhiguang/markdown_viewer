// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MarkdownViewer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const markdown = r'''
[foo\_bar](/url)
''';

    // TODO: Fix the colors for codes
    const code = TextStyle(fontFamily: 'monospace', fontSize: 12);

    return Scaffold(
      appBar: AppBar(title: const Text('MarkdownViewer Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: MarkdownViewer(
          markdown,
          onTapLink: (text, href, title) {
            print({text, href, title});
          },
          styleSheet: MarkdownStyle.fromTheme(
            Theme.of(context),
            // blockquoteDecoration: BoxDecoration(color: Colors.blue),
            //blockquotePadding: EdgeInsets.all(20),
            link: const TextStyle(color: Color(0xff2196f3)),
            blockquote: const TextStyle(color: Color(0xff666666)),
            inlineHtml: code.copyWith(),
          ),
        ),
      ),
    );
  }
}
