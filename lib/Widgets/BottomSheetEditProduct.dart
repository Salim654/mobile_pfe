import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:mobile_pfe/Models/Category.dart';
import 'package:mobile_pfe/Models/Brand.dart';
import 'package:mobile_pfe/Models/Tva.dart';
import 'package:mobile_pfe/Services/ServiceBrandCategory.dart';
import 'package:mobile_pfe/Services/ServiceProduct.dart';
import 'package:mobile_pfe/Services/ServiceTva.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Views/ProductsPage.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetEditProduct extends StatefulWidget {
  final Map<String, dynamic> productData;

  BottomSheetEditProduct({required this.productData});

  @override
  _BottomSheetEditProductState createState() => _BottomSheetEditProductState();
}

class _BottomSheetEditProductState extends State<BottomSheetEditProduct> {
  // Controllers
  late TextEditingController referenceController;
  late TextEditingController designationController;
  late TextEditingController priceController;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Selected IDs
  int? selectedCategoryId;
  int? selectedBrandId;
  int? selectedTvaId;

  // Data lists
  List<Category> categories = [];
  List<Brand> brands = [];
  List<Tva> tvas = [];

  // Loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    referenceController =
        TextEditingController(text: widget.productData['reference']);
    designationController =
        TextEditingController(text: widget.productData['designation']);
    priceController =
        TextEditingController(text: widget.productData['price'].toString());

    _fetchData();
  }

  void _fetchData() async {
    try {
      categories = await ServiceBrandCategory.fetchCategories();
      brands = await ServiceBrandCategory.fetchBrands();
      tvas = await ServiceTva.getTvasForUser();

      // Initialize selected category, brand, and tva IDs
      selectedCategoryId =
          categories.isNotEmpty ? widget.productData['category_id'] : null;
      selectedBrandId =
          brands.isNotEmpty ? widget.productData['brand_id'] : null;
      selectedTvaId = tvas.isNotEmpty ? widget.productData['tva_id'] : null;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories, brands, and Tvas: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Validator functions
  String? _validateReference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a reference';
    }
    return null;
  }

  String? _validateDesignation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a designation';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a price';
    }
    // Check if the price is numeric
    final double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'Price must be numeric';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              "Edit Product",
              style: TextStyle(
                color: Constants.color3,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 10),
          isLoading
              ? Container(
                  height: 500,
                  child: Center(child: CircularProgressIndicator()))
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Reference Field
                      TextFormField(
                        controller: referenceController,
                        decoration: InputDecoration(labelText: 'Reference'),
                        validator: _validateReference,
                      ),
                      SizedBox(height: 10),
                      // Designation Field
                      TextFormField(
                        controller: designationController,
                        decoration: InputDecoration(labelText: 'Designation'),
                        validator: _validateDesignation,
                      ),
                      SizedBox(height: 10),
                      // Price Field
                      TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                        validator: _validatePrice,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 20),
                      // Custom Dropdowns
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          CustomDropdown<String>(
                            hintText: 'Select Category',
                            items: categories
                                .map((category) => category.category)
                                .toList(),
                            initialItem: selectedCategoryId != null
                                ? categories
                                    .firstWhere(
                                        (cat) => cat.id == selectedCategoryId)
                                    .category
                                : categories.isNotEmpty
                                    ? categories[0].category
                                    : 'Loading',
                            onChanged: (value) {
                              setState(() {
                                selectedCategoryId = categories
                                    .firstWhere((cat) => cat.category == value)
                                    .id;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Text('Brand',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          CustomDropdown<String>(
                            hintText: 'Select Brand',
                            items: brands.map((brand) => brand.name).toList(),
                            initialItem: selectedBrandId != null
                                ? brands
                                    .firstWhere(
                                        (br) => br.id == selectedBrandId)
                                    .name
                                : brands.isNotEmpty
                                    ? brands[0].name
                                    : 'Loading',
                            onChanged: (value) {
                              setState(() {
                                selectedBrandId = brands
                                    .firstWhere((br) => br.name == value)
                                    .id;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          Text('TVA',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          CustomDropdown<String>(
                            hintText: 'Select TVA',
                            items: tvas.map((tva) => '${tva.value} %').toList(),
                            initialItem: selectedTvaId != null
                                ? '${tvas.firstWhere((tva) => tva.id == selectedTvaId).value} %'
                                : tvas.isNotEmpty
                                    ? '${tvas[0].value} %'
                                    : 'Loading',
                            onChanged: (value) {
                              setState(() {
                                selectedTvaId = tvas
                                    .firstWhere(
                                        (tva) => '${tva.value} %' == value)
                                    .id;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 20),
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
                      // Validate the form
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed with updating the product
                        String reference = referenceController.text;
                        String designation = designationController.text;
                        double price = double.parse(priceController.text);

                        Map<String, dynamic> updatedProductData = {
                          'reference': reference,
                          'designation': designation,
                          'category_id': selectedCategoryId,
                          'brand_id': selectedBrandId,
                          'price': price,
                          'tva_id': selectedTvaId,
                        };

                        try {
                          // Call the service function to update the product
                          await ServiceProduct.editProduct(
                              widget.productData['id'], updatedProductData);
                          MotionToast.success(
                            width: 300,
                            height: 50,
                            title: Text("Product updated successfully"),
                            description: Text(""),
                          ).show(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsPage(),
                            ),
                          );
                        } catch (e) {
                          MotionToast.error(
                            width: 300,
                            height: 50,
                            title: Text("Failed to update Product"),
                            description: Text(""),
                          ).show(context);
                        }
                      }
                    },
                    child: const Center(
                      child: Text(
                        "Update",
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
    );
  }
}
