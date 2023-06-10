import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_card/kiuqi_card.dart';
import 'package:tinder_card/card_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: buildCards(),
        ),
      ),
    );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;
    return Stack(
      children: urlImages
          .map(
            (urlImage) => KiuqiCard(
              urlImage: urlImage,
              isFront: urlImages.last == urlImage,
            ),
          )
          .toList(),
    );
  }
}
