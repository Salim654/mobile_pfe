import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/Models/FactureProducts.dart';
import 'package:mobile_pfe/Models/Product.dart';
import 'package:mobile_pfe/Models/Taxe.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';
import 'package:mobile_pfe/Services/ServiceProduct.dart';
import 'package:mobile_pfe/Services/ServiceTaxe.dart';
import 'package:mobile_pfe/Views/ManageFacturePage.dart';
import 'package:mobile_pfe/utils/settings.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class ListProductsFacture extends StatefulWidget {
  final Facture facture;

  ListProductsFacture({required this.facture});

  @override
  _ListProductsFactureState createState() => _ListProductsFactureState();
}

String gettitle(int typefact) {
  switch (typefact) {
    case 1:
      return 'Estimate items';
    case 2:
      return 'Purshase Order items';
    default:
      return 'Invoice items';
  }
}

class _ListProductsFactureState extends State<ListProductsFacture> {
  late Future<List<FactureProduct>?> factureProductsFuture;
  List<Product> products = [];
  List<Taxe> taxes = [];
  bool noTaxe = false;

  @override
  void initState() {
    super.initState();
    factureProductsFuture =
        ServiceFacture.getFactureProducts(widget.facture.id);
    _fetchProductsForUser();
    _fetchTaxesForUser();
  }

  void _fetchProductsForUser() async {
    try {
      List<Product> userProducts = await ServiceProduct.getProductsForUser();
      setState(() {
        products = userProducts;
      });
    } catch (e) {
      Constants.showSnackBar(context, 'Failed to load products', Colors.red);
    }
  }

  void _fetchTaxesForUser() async {
    try {
      List<Taxe> userTaxes = await ServiceTaxe.getTaxesForUser();
      List<Taxe> newTaxes =
          userTaxes.where((taxe) => taxe.application == 0).toList();
      setState(() {
        taxes = newTaxes;
      });
    } catch (e) {
      Constants.showSnackBar(context, 'Failed to load taxes', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue,
          title: Text(
            gettitle(widget.facture.type),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto-Medium',
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageFacturePage(
                    facture: widget.facture,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductModalSheet();
        },
        child: Icon(
          Icons.add,
          color: kWhite,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: _buildListView(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListView() {
    return FutureBuilder<List<FactureProduct>?>(
      future: factureProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Image.asset('assets/images/noitems.PNG'),
          );
        } else {
          List<FactureProduct> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              FactureProduct product = products[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  height: 80,
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                onDismissed: (direction) {
                  deleteitem(widget.facture.id, product.productId);
                },
                child: GestureDetector(
                  onTap: () {
                    // Implement the action for tapping on a product
                  },
                  child: _buildProductCard(context, product),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildProductCard(BuildContext context, FactureProduct product) {
    double fontSize = 16.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          height: 80,
          child: ListTile(
            leading: const Icon(Icons.inventory),
            title: Text(
              product.productName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            subtitle: product.taxeId == null
                ? Text(
                    'Quantity: ${product.quantity}, Discount: ${product.discount} %, Unit Price: ${product.unitprice}')
                : Text(
                    'Quantity: ${product.quantity}, Discount: ${product.discount} %, Unit Price: ${product.unitprice} , Xe: ${product.taxeshorname} '),
          ),
        ),
      ),
    );
  }

  void _showAddProductModalSheet() {
    final _formKey = GlobalKey<FormState>();
    final _quantityController = TextEditingController();
    final _discountController = TextEditingController();
    Product? selectedProduct;
    Taxe? selectedTaxe;
    bool applyDiscount = true;
    bool applyTax = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(labelText: 'Quantity'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (products
                          .isNotEmpty) // Ensure products list is not empty
                        CustomDropdown<String>(
                          hintText: 'Select Product',
                          items: products
                              .map((product) => product.reference)
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProduct = products.firstWhere(
                                  (product) => product.reference == value);
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a product';
                            }
                            return null;
                          },
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(
                            value: applyDiscount,
                            onChanged: (value) {
                              setState(() {
                                applyDiscount = value;
                                if (!applyDiscount) {
                                  _discountController.text =
                                      '0'; // Set discount to 0
                                }
                              });
                            },
                          ),
                          const Text(
                            'Apply Discount',
                            style: TextStyle(
                              color: Constants.color3,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _discountController,
                        decoration: InputDecoration(labelText: 'Discount(%)'),
                        keyboardType: TextInputType.number,
                        enabled: applyDiscount,
                        validator: (value) {
                          if (applyDiscount &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter a discount';
                          }
                          if (applyDiscount &&
                              double.tryParse(value!) == null) {
                            return 'Please enter a valid number';
                          }
                          if (applyDiscount &&
                              double.tryParse(value!)! >= 100) {
                            return 'Number must be under 100';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Switch(
                            value: applyTax,
                            onChanged: (value) {
                              setState(() {
                                applyTax = value;
                                if (!applyTax) {
                                  selectedTaxe = null;
                                }
                              });
                            },
                          ),
                          const Text(
                            'Apply Tax',
                            style: TextStyle(
                              color: Constants.color3,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      if (applyTax &&
                          taxes.isNotEmpty) // Ensure taxes list is not empty
                        CustomDropdown<String>(
                          hintText: 'Select Tax',
                          items: taxes.map((taxe) => taxe.shortName).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTaxe = taxes
                                  .firstWhere((tax) => tax.shortName == value);
                            });
                          },
                          validator: (value) {
                            if (applyTax && value == null) {
                              return 'Please select a tax';
                            }
                            return null;
                          },
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Button(
                                borderRadius: 8,
                                margin: const EdgeInsets.all(8.0),
                                bgColor: kWhite,
                                onPressed: () {
                                  Navigator.pop(context);
                                  // some method calls
                                },
                                child: const Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Constants.color1,
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                              width: 100,
                              child: Button(
                                borderRadius: 10,
                                margin: EdgeInsets.all(8.0),
                                bgColor: Constants.color1,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    int quantity =
                                        int.parse(_quantityController.text);
                                    double discount = applyDiscount
                                        ? double.parse(_discountController.text)
                                        : 0.0;
                                    int productId = selectedProduct!.id;
                                    int? taxeId =
                                        applyTax ? selectedTaxe?.id : null;
                                    try {
                                      await ServiceFacture.addProductInvoice(
                                        factureId: widget.facture.id,
                                        quantity: quantity,
                                        discount: discount,
                                        productId: productId,
                                        taxeId: taxeId,
                                      );
                                      MotionToast.success(
                                        width: 300,
                                        height: 50,
                                        title: Text("Item Added Successfully"),
                                        description: Text(""),
                                      ).show(context);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ListProductsFacture(
                                            facture: widget.facture,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      MotionToast.error(
                                        width: 300,
                                        height: 50,
                                        title:
                                            Text("You Can't Add the Same Item"),
                                        description: Text(""),
                                      ).show(context);
                                    }
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      color: kWhite,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteitem(int factureid, int productid) async {
    try {
      await ServiceFacture.deleteItemFacture(
        factureid,
        productid,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListProductsFacture(
            facture: widget.facture,
          ),
        ),
      );
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("Something went wrong"),
        description: Text(""),
      ).show(context);
    }
  }
}
