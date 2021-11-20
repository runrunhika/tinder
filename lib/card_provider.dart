import 'dart:math';

import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<String> _urlImage = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<String> get urlImages => _urlImage;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    // if (status != null) {
    // Fluttertoast.cancel();
    // Fluttertoast.showToast(
    // msg: status.toString().split('.').last.toUpperCase(), fontSize: 36);
    // }

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        disLike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
    }
    resetPosition();
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;
    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      final delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
  }

  void disLike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImage.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _urlImage.removeLast();
    resetPosition();
  }

  void resetUsers() {
    _urlImage = <String>[
      'https://storage.mantan-web.jp/images/2021/09/19/20210919dog00m200014000c/001_size6.jpg',
      'https://s.eximg.jp/exnews/feed/Grape/Grape_914544_7f78_1.jpg',
      'https://www.sponichi.co.jp/entertainment/news/2021/01/18/jpeg/20210118s00041000181000p_view.jpg',
      'https://eiga.k-img.com/images/buzz/80249/90381388c04c84c1/640.jpg?1566566551',
      'https://www.yomiuri.co.jp/media/2020/11/20201116-OYT1I50026-1.jpg?type=x-large',
      'https://livedoor.sp.blogimg.jp/yuitoki2914/imgs/8/f/8fb8e176.jpg',
      'https://img.popnroll.tv/uploads/news_image/image/67822/medium_sub4.jpg'
    ].reversed.toList();
    notifyListeners();
  }
}
