import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  /// FocusNode is a class that
  /// biar memudahkan dalam transisi ke form berikutnya
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode(); // _imageUrlFocusNode buat nge keep value inputan biar nggak ilang

  final _imageUrlController = TextEditingController();
  /// FormState allow us to interact with state behind
  /// Form widget
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null, 
    title: '', 
    description: '', 
    price: 0.0, 
    imageUrl: ''
  );
  // variable to handle for make form is empty if we want to add new product
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() { 
    // initiate listener
    // execute this whenever focus changed
    _imageUrlFocusNode.addListener(_updateImageUrl);
    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    /// this method also run before build is executed
    /// when we run this for the first time bcs didChangeDependencies
    /// will run multiple times, we set _isInit to false
    /// so that  in the future we dont reinitialize our form
    if (_isInit) {
      // extract id from receiving argument which sent by userproductitem
      final productId = ModalRoute.of(context)
                          .settings.arguments as String;
      
      /// didChangeDependencies will always run when we open the page
      /// so also when we add a new product
      /// because of that we need to detect when it comes for edit product or
      /// add new product
      if (productId != null) {
        // use provider to find the product information
        _editedProduct = Provider.of<ProductProvider>(
          context,
          listen: false
        ).findById(productId);

        // set form to be filled with product data
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          
          /// set imageurl to empty string or null because
          /// controller and initialvalue cant be used together
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }
  /// we have to dispose FocusNode object to remove them
  /// when we leave the screen. biar nggak memory leak
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();

    /// by default, listener will keep on memory although
    /// screen is closed. so we need to remove it when
    /// the screen is closed
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }
  
  void _updateImageUrl() {
    // when not focus on image form field
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') 
            && !_imageUrlController.text.startsWith('https')) || 
          (!_imageUrlController.text.endsWith('png') && 
            !_imageUrlController.text.endsWith('jpg') && 
              !_imageUrlController.text.endsWith('jpeg')) ) {
                return;
              }
      setState(() {
        
      });
    }
  }

  Future<void> _saveForm() async {
    // alternative validate form instead use argument validator:
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    /// this is a method how to save form input (?)
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    // update product
    if (_editedProduct.id != null) {
      try {
        await Provider.of<ProductProvider>(
          context,
          listen: false
        )
          .updateProduct(
            _editedProduct.id, 
            _editedProduct
          );
        // await make that code finished to executed before
        // move on to the next line
      }
        catch(error) {
          print(error);
        }
    }
      else {
        // Provider.of<ProductProvider>(
        //   context,
        //   listen: false
        // )
        //   .addProduct(_editedProduct)
        //     .catchError((error) {
        //       // catch error is reached when addProduct not succefully executed
              
        //       // adding return befor showDIalog for it can result
        //       // future function (?)
        //       return showDialog(
        //         context: context,
        //         // builder to build the dialog
        //         builder: (ctx) => AlertDialog(
        //           title: Text('An error occured!'),
        //           content: Text('Something went'),
        //           actions: <Widget>[
        //             FlatButton(
        //               onPressed: () {
        //                 // close the dialog
        //                 Navigator.of(ctx).pop();
        //               }, 
        //               child: Text('OK')
        //             )
        //           ],
        //         )
        //       );
        //     })
        //       .then((_) {
        //         setState(() { _isLoading = false; });
        //         // only leave page when done
        //         Navigator.of(context).pop();
        //       });
        
        /// ALTERNATIVE IF USING TRY CATCH
        try {
          await Provider.of<ProductProvider>(
            context,
            listen: false
          )
            .addProduct(_editedProduct);
        }
          catch(error) {
            await showDialog(
                context: context,
                // builder to build the dialog
                builder: (ctx) => AlertDialog(
                  title: Text('An error occured!'),
                  content: Text('Something went'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        // close the dialog
                        Navigator.of(ctx).pop();
                      }, 
                      child: Text('OK')
                    )
                  ],
                )
              );
          }
            // finally {
            //   /// finally only occurs in try catch
            //   /// this code always run no matter you fail or success
            //   setState(() { _isLoading = false; });
            //   // only leave page when done
            //   Navigator.of(context).pop();
            // }
      }
      setState(() { _isLoading = false; });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save), 
            onPressed: _saveForm
          )
        ],
      ),

      /// use Form widget to validate input automically
      body: _isLoading ? 
        Center(
          child: CircularProgressIndicator(),
        ) 
        : Padding(
          padding: const EdgeInsets.all(15.0),
          // kalo make Form(), gausah textcontroller u/ dapet input user (?)
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                /// TextFormField automically connected to Form widget
                /// TextFormField by default takes a much width that can it get
                
                /// NOTE:
                /// You cant use controller and initialValue together
                /// the solution is not to set value in _initValues, instead
                /// simply set to empty string or null then
                /// reach out controllername.text = _editedProduct.imageUrl <- example
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    labelText: 'Title'
                  ),
                  // textInputAction control what the bottom right in keybord will show
                  textInputAction: TextInputAction.next,
                  //validate form input
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Cannot be empty';
                    }
                    return null; // if not empty
                  },
                  /// onFieldSubmitted will executed when hit right bottom on keyboard
                  onFieldSubmitted: (_) {
                    /// FocusScope work bit like theme and MediaQuery
                    /// FocusScope.of(context) to connect to current page
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  // save form input
                  onSaved: (value) {
                    _editedProduct = Product(
                      /// set id and favoritestatus agar current id and
                      /// favoritestatus tidak hilang pas nge save product
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite, 
                      title: value, 
                      description: _editedProduct.description, 
                      price: _editedProduct.price, 
                      imageUrl: _editedProduct.imageUrl
                      );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(
                    labelText: 'Price'
                  ),
                  // textInputAction control what the bottom right in keybord will show
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  // validate input
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Cannot be empty';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price cannot be zero or below';
                    }
                    return null; // if not empty
                  },
                  /// onFieldSubmitted will executed when hit right bottom on keyboard
                  onFieldSubmitted: (_) {
                    /// FocusScope work bit like theme and MediaQuery
                    /// FocusScope.of(context) to connect to current page
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite, 
                      title: _editedProduct.title, 
                      description: _editedProduct.description, 
                      price: double.parse(value), 
                      imageUrl: _editedProduct.imageUrl
                      );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(
                    labelText: 'Description'
                  ),
                  // determine how long character / line of textfield
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  //validate form input
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Cannot be empty';
                    }
                    if (value.length < 10) {
                      return 'Should at least 10 character long';
                    }
                    return null; // if not empty
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: value, 
                      price: _editedProduct.price, 
                      imageUrl: _editedProduct.imageUrl
                      );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    // this container will show preview image
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 10,
                          color: Colors.grey
                        )
                      ),
                      child: _imageUrlController.text.isEmpty?
                              Text('Enter image URL') :
                                FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                    ),
                    /// TextFormField by defaultm takes a much width that can it get
                    /// so we wrap it into expanded widget biar bisa cukup sama preview image
                    /// di sebelahnya
                    // user will input url in this field
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Image URL'
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        //validate form input
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Cannot be empty';
                          }
                          if (!value.startsWith('http') && !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('png') && !value.endsWith('jpg') && !value.endsWith('jpeg')) {
                            return 'Please enter a valid image';
                          }
                          return null; // if not empty
                        },
                        // trigger _saveForm when we hit enter in keyboard
                        /// nggak langsung onFieldSubmitted : _saveForm
                        /// karena onFieldSubmitted hanya bisa ngehandle
                        /// function
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title, 
                            description: _editedProduct.description, 
                            price: _editedProduct.price, 
                            imageUrl: value
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        ),
    );
  }
}