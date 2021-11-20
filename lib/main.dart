import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_app_sample/card_provider.dart';
import 'package:tinder_app_sample/tinder_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.pink,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    primary: Colors.white,
                    shape: CircleBorder(),
                    minimumSize: Size.square(80)))),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red.shade200, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildLogo(),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(child: buildCards()),
                    const SizedBox(
                      height: 16,
                    ),
                    buildButtons()
                  ],
                )),
          )),
    );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return urlImages.isEmpty
        ? Center(
            child: Text("None"),
          )
        : Row(
            //均等
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.red, Colors.white, isDislike),
                  backgroundColor:
                      getColor(Colors.white, Colors.red, isDislike),
                  side: getBorder(Colors.red, Colors.white, isDislike),
                ),
                child: Icon(Icons.clear, color: Colors.red, size: 40),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);

                  provider.disLike();
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.blue, Colors.white, isSuperLike),
                  backgroundColor:
                      getColor(Colors.white, Colors.blue, isSuperLike),
                  side: getBorder(Colors.blue, Colors.white, isSuperLike),
                ),
                child: Icon(Icons.star, color: Colors.blue, size: 40),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);

                  provider.superLike();
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: getColor(Colors.teal, Colors.white, isLike),
                  backgroundColor: getColor(Colors.white, Colors.teal, isLike),
                  side: getBorder(Colors.teal, Colors.white, isLike),
                ),
                child: Icon(Icons.favorite, color: Colors.teal, size: 40),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);

                  provider.like();
                },
              ),
            ],
          );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };
    return MaterialStateProperty.resolveWith(getBorder);
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;

    return urlImages.isEmpty
        ? Center(
            child: ElevatedButton(
              child: Text("Restart"),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.resetUsers();
              },
            ),
          )
        : Stack(
            children: urlImages
                .map((urlImage) => TinderCard(
                    urlImage: urlImage, isFront: urlImages.last == urlImage))
                .toList(),
          );
  }

  Widget buildLogo() {
    return Row(
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          color: Colors.white,
          size: 36,
        ),
        const SizedBox(
          height: 16,
        ),
        Text("Tinder",
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold))
      ],
    );
  }
}
