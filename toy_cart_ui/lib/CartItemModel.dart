class CartItemModel {
  String _name, _qty, _price, _image;
  int _bgColor;

  CartItemModel(this._name, this._qty, this._price, this._image, this._bgColor);

  get bgColor => _bgColor;

  get image => _image;

  get price => _price;

  get qty => _qty;

  String get name => _name;

}
