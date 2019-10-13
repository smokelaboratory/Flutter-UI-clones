import 'package:flutter/material.dart';

import 'CartItemModel.dart';

void main() => runApp(ToyApp());

class ToyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToyCart(),
    );
  }
}

class ToyCart extends StatefulWidget {
  @override
  _ToyCartState createState() => _ToyCartState();
}

class _ToyCartState extends State<ToyCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            StackLayer(layerType: LayerType.LIST),
            StackLayer(layerType: LayerType.SUB_TOTAL),
            StackLayer(layerType: LayerType.CHECK_OUT),
            StackLayer(layerType: LayerType.TOOLBAR)
          ],
        ),
      ),
    );
  }
}

const double _sectionHeight = 80;
const double _arcSize = 30;
const double _padding = 32;

class StackLayer extends StatelessWidget {
  final LayerType layerType;
  List<CartItemModel> cartItemList;

  StackLayer({@required this.layerType}) {
    cartItemList = List<CartItemModel>();
    cartItemList.add(CartItemModel(
        "Shawn, The Sheep", "2", "\$ 180", "images/shawn.png", 0xffb0deff));
    cartItemList.add(
        CartItemModel("Bitzer", "1", "\$ 60", "images/bitzer.png", 0xffcdebe1));
    cartItemList.add(
        CartItemModel("Mr. X", "1", "\$ 50", "images/mr_x.png", 0xffdbe4ff));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ClipPath(
      clipper: LayerClipper(layerType),
      child: Container(
        width: size.width,
        height: size.height,
        color: Color(_getLayerColor(layerType)),
        child: Align(
            alignment: _getLayerChildAlignment(layerType),
            child: _getLayerChild(layerType)),
      ),
    );
  }

  Widget _getLayerChild(LayerType layerType) {
    switch (layerType) {
      case LayerType.TOOLBAR:
        return Container(
          height: _sectionHeight + _arcSize / 2,
          margin: const EdgeInsets.only(left: _padding, right: _padding),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 22,
                ),
                TextWidget(
                    text: "Shopping Cart",
                    textColor: Colors.black,
                    textSize: 22,
                    fontWeight: FontWeight.w700),
                Icon(
                  Icons.delete_outline,
                  color: Colors.black,
                  size: 22,
                )
              ],
            ),
          ),
        );
        break;
      case LayerType.CHECK_OUT:
        return SizedBox(
          height: _sectionHeight,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextWidget(
                    text: "Check Out",
                    textColor: Colors.white,
                    textSize: 18,
                    fontWeight: FontWeight.w600),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 17,
                )
              ],
            ),
          ),
        );
        break;
      case LayerType.SUB_TOTAL:
        return Container(
          height: _sectionHeight,
          margin: const EdgeInsets.only(
              bottom: 80, left: _padding, right: _padding),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                    text: "Subtotal",
                    textColor: Color(0xff64727e),
                    textSize: 15,
                    fontWeight: FontWeight.w600),
                TextWidget(
                    text: "\$ 290",
                    textColor: Colors.black,
                    textSize: 20,
                    fontWeight: FontWeight.w700),
              ],
            ),
          ),
        );
        break;
      default:
        return Container(
          padding: const EdgeInsets.only(
              left: _padding,
              right: _padding,
              top: _sectionHeight + _arcSize + 5,
              bottom: 2 * _sectionHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWidget(
                  text: "Your Toys",
                  textColor: Colors.black,
                  textSize: 27,
                  fontWeight: FontWeight.w700),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Color(0xff979fa7),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(text: 'You have '),
                    TextSpan(
                        text: cartItemList.length.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: ' items in your cart'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20, bottom: 15),
                  itemBuilder: (_, pos) {
                    return CartItem(
                        image: cartItemList[pos].image,
                        name: cartItemList[pos].name,
                        qty: cartItemList[pos].qty,
                        price: cartItemList[pos].price,
                        bgColor: cartItemList[pos].bgColor);
                  },
                  separatorBuilder: (_, __) {
                    return SizedBox(height: 20);
                  },
                  itemCount: cartItemList.length,
                  shrinkWrap: true,
                ),
              )
            ],
          ),
        );
        break;
    }
  }

  Alignment _getLayerChildAlignment(LayerType layerType) {
    switch (layerType) {
      case LayerType.TOOLBAR:
        return Alignment.topCenter;
        break;
      case LayerType.CHECK_OUT:
        return Alignment.bottomCenter;
        break;
      case LayerType.SUB_TOTAL:
        return Alignment.bottomCenter;
        break;
      default:
        return Alignment.topLeft;
        break;
    }
  }
}

int _getLayerColor(LayerType layerType) {
  switch (layerType) {
    case LayerType.TOOLBAR:
      return 0xffdae9f7;
      break;
    case LayerType.CHECK_OUT:
      return 0xffff6138;
      break;
    case LayerType.SUB_TOTAL:
      return 0xffffffff;
      break;
    default:
      return 0xfff0f5fa;
      break;
  }
}

class TextWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final double textSize;
  final FontWeight fontWeight;

  TextWidget({this.text, this.textColor, this.textSize, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontFamily: "Khula",
            fontWeight: fontWeight));
  }
}

class LayerClipper extends CustomClipper<Path> {
  final LayerType layerType;

  LayerClipper(this.layerType);

  @override
  Path getClip(Size size) {
    return _getClipPath(layerType, size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

  Path _getClipPath(LayerType layerType, Size size) {
    switch (layerType) {
      case LayerType.TOOLBAR:
        return Path()
          ..lineTo(size.width, 0)
          ..lineTo(size.width, _sectionHeight)
          ..arcToPoint(
              Offset(size.width - _arcSize, _sectionHeight + _arcSize / 2),
              radius: Radius.circular(_arcSize))
          ..lineTo(_arcSize, _sectionHeight + _arcSize / 2)
          ..arcToPoint(Offset(0, _sectionHeight + _arcSize),
              radius: Radius.circular(_arcSize), clockwise: false);
        break;
      case LayerType.CHECK_OUT:
        var _startHeight = size.height - _sectionHeight;
        return Path()
          ..lineTo(0, _startHeight - _arcSize)
          ..arcToPoint(Offset(_arcSize, _startHeight),
              radius: Radius.circular(_arcSize), clockwise: false)
          ..lineTo(size.width - _arcSize, _startHeight)
          ..arcToPoint(Offset(size.width, _startHeight + _arcSize),
              radius: Radius.circular(_arcSize))
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height);
        break;
      case LayerType.SUB_TOTAL:
        var _startHeight = size.height - 2 * _sectionHeight;
        return Path()
          ..lineTo(0, _startHeight - _arcSize)
          ..arcToPoint(Offset(_arcSize, _startHeight),
              radius: Radius.circular(_arcSize), clockwise: false)
          ..lineTo(size.width - _arcSize, _startHeight)
          ..arcToPoint(Offset(size.width, _startHeight + _arcSize),
              radius: Radius.circular(_arcSize))
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height);
        break;
      default:
        return null;
        break;
    }
  }
}

class CartItem extends StatelessWidget {
  final String image, name, qty, price;
  final int bgColor;

  CartItem({this.image, this.name, this.qty, this.price, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Color(bgColor)),
          child: Image(image: AssetImage(image)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextWidget(
                      text: name,
                      textSize: 14,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextWidget(
                    text: price,
                    textSize: 15,
                    textColor: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CartButton(buttonType: ButtonType.MINUS),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 10,
                    child: Center(
                      child: TextWidget(
                        text: qty,
                        textSize: 12,
                        textColor: Color(0xff64727e),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CartButton(buttonType: ButtonType.PLUS)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class CartButton extends StatelessWidget {
  final ButtonType buttonType;

  CartButton({this.buttonType});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          buttonType == ButtonType.MINUS ? Icons.remove : Icons.add,
          size: 10,
        ),
      ),
    );
  }
}

enum ButtonType { PLUS, MINUS }
enum LayerType { TOOLBAR, LIST, SUB_TOTAL, CHECK_OUT }
