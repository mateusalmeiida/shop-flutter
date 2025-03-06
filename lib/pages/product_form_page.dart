import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _imageUrlFocus = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlControler.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocus.removeListener(_updateImage);
    _imageUrlFocus.dispose();
  }

  void _updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<ProductList>(context, listen: false)
          .saveProduct(_formData);
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Ocorreu um erro!'),
              content: Text('Não foi possível salvar o produto'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 5),
                children: [
                  TextFormField(
                    initialValue: _formData['name']?.toString(),
                    decoration: InputDecoration(labelText: 'Nome'),
                    textInputAction: TextInputAction.next,
                    onSaved: (name) {
                      _formData['name'] = name ?? '';
                    },
                    validator: (_name) {
                      final name = _name ?? '';

                      if (name.trim().isEmpty) {
                        return 'O nome é obrigatório';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _formData['price']?.toString(),
                    decoration: InputDecoration(labelText: 'Preço'),
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onSaved: (price) {
                      _formData['price'] = double.parse(price ?? '0');
                    },
                    validator: (_price) {
                      final priceString = _price ?? '-1';
                      final price = double.tryParse(priceString) ?? -1;

                      if (price <= 0) {
                        return 'Informe um preço válido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _formData['description']?.toString(),
                    decoration: InputDecoration(labelText: 'Descrição'),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    onSaved: (description) {
                      _formData['description'] = description ?? '';
                    },
                    validator: (_description) {
                      final description = _description ?? '';

                      if (description.trim().length < 15) {
                        return 'A descrição precisa ter pelo menos 15 caracteres';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _imageUrlFocus,
                          controller: _imageUrlControler,
                          decoration:
                              InputDecoration(labelText: 'URL da Imagem'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.url,
                          onSaved: (url) {
                            _formData['url'] = url ?? '';
                          },
                          validator: (_url) {
                            final url = _url ?? '';
                            if (!isValidImageUrl(url)) {
                              return 'URL Inválida';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _submitForm();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1)),
                        alignment: Alignment.center,
                        child: _imageUrlControler.text.isEmpty
                            ? Text('Informe a URL')
                            : FittedBox(
                                fit: BoxFit.cover,
                                child: Image.network(_imageUrlControler.text),
                              ),
                      )
                    ],
                  ),
                ],
              )),
    );
  }
}
