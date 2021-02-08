import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  var _isinit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _editetProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editetProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editetProduct.title,
          'description': _editetProduct.description,
          'price': _editetProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editetProduct.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.jpg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editetProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editetProduct.id, _editetProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editetProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went worng...'),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (val) {
                        _editetProduct = Product(
                          id: _editetProduct.id,
                          isFavorite: _editetProduct.isFavorite,
                          title: val,
                          description: _editetProduct.description,
                          price: _editetProduct.price,
                          imageUrl: _editetProduct.imageUrl,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (val) {
                        _editetProduct = Product(
                          id: _editetProduct.id,
                          isFavorite: _editetProduct.isFavorite,
                          title: _editetProduct.title,
                          description: _editetProduct.description,
                          price: double.parse(val),
                          imageUrl: _editetProduct.imageUrl,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(val) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.parse(val) <= 0) {
                          return 'Please enter a number greatest than zero';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (val) {
                        _editetProduct = Product(
                          id: _editetProduct.id,
                          isFavorite: _editetProduct.isFavorite,
                          title: _editetProduct.title,
                          description: val,
                          price: _editetProduct.price,
                          imageUrl: _editetProduct.imageUrl,
                        );
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (val.length < 10) {
                          return 'Should be at least 10 character long';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Theme.of(context).primaryColor)),
                          child: _imageUrlController.text.isEmpty
                              ? Text(
                                  'enter a url',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (val) {
                              _editetProduct = Product(
                                id: _editetProduct.id,
                                isFavorite: _editetProduct.isFavorite,
                                title: _editetProduct.title,
                                description: _editetProduct.description,
                                price: _editetProduct.price,
                                imageUrl: val,
                              );
                            },
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Please enter an imageUrl';
                              }
                              if (!val.startsWith('http') &&
                                  !val.startsWith('https')) {
                                return 'Please enter a valid Url';
                              }
                              if (!val.endsWith('.png') &&
                                  !val.endsWith('.jpeg') &&
                                  !val.endsWith('.jpg')) {
                                return 'Please enter a valid Url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
