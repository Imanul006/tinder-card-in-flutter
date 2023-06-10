import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum CardStatus { next, previous, connect, block }

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = [];
  List<String> _urlImagesHistory = [];
  Size _screenSize = Size.zero;
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;

  List<String> get urlImages => _urlImages;
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

    final status = getStatus();

    if (status != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
        fontSize: 36,
      );
    }

    switch (status) {
      case CardStatus.next:
        next();
        break;
      case CardStatus.previous:
        previous();
        break;
      case CardStatus.connect:
        connect();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    final forceConnect = x.abs() < 20;

    const delta = 100;

    if (x >= delta) {
      return CardStatus.next;
    } else if (x <= -delta) {
      return CardStatus.previous;
    } else if (y <= -delta / 2 && forceConnect) {
      return CardStatus.connect;
    } else {
      return null;
    }
    
  }

  void next() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

    void previous() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _previousCard();

    notifyListeners();
  }

    void connect() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();

    notifyListeners();
  }

  Future _previousCard() async {
    if (_urlImages.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    if (_urlImagesHistory.isNotEmpty) {
      bringHistoryToLast();
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Already at top",
        fontSize: 36,
      );
    }
    
    resetPosition();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    sendLastToHistory();
    resetPosition();
  }

  void sendLastToHistory() {
    _urlImagesHistory.add(_urlImages.last);
    _urlImages.removeLast();
  }

  void bringHistoryToLast() {
    _urlImages.add(_urlImagesHistory.last);
    _urlImagesHistory.removeLast();
  }

  void resetUsers() {
    _urlImages = <String>[
      'https://picsum.photos/200',
      'https://picsum.photos/201',
      'https://picsum.photos/202',
      'https://picsum.photos/203',
      'https://picsum.photos/204',
      'https://picsum.photos/205',
      'https://picsum.photos/206',
      'https://picsum.photos/207',
      'https://picsum.photos/208',
      'https://picsum.photos/209',
      'https://picsum.photos/210',
      'https://picsum.photos/211',
      'https://picsum.photos/212',
      'https://picsum.photos/213',
      'https://picsum.photos/214',
      'https://picsum.photos/215',
    ].reversed.toList();

    notifyListeners();
  }
}
