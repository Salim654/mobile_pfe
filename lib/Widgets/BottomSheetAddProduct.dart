import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:mobile_pfe/Models/Category.dart';
import 'package:mobile_pfe/Models/Brand.dart';
import 'package:mobile_pfe/Models/Tva.dart';
import 'package:mobile_pfe/Services/ServiceBrandCategory.dart';
import 'package:mobile_pfe/Services/ServiceProduct.dart';
import 'package:mobile_pfe/Services/ServiceTva.dart';
import 'package:mobile_pfe/Views/ProductsPage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetAddProduct extends StatefulWidget {
  @override
  _BottomSheetAddProductState createState() => _BottomSheetAddProductState();
}

class _BottomSheetAddProductState extends State<BottomSheetAddProduct> {
  // Controllers
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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
    _fetchData();
  }

  // Fetch data
  void _fetchData() async {
    try {
      categories = await ServiceBrandCategory.fetchCategories();
      brands = await ServiceBrandCategory.fetchBrands();
      tvas = await ServiceTva.getTvasForUser();
      selectedCategoryId = categories.isNotEmpty ? categories[0].id : null;
      selectedBrandId = brands.isNotEmpty ? brands[0].id : null;
      selectedTvaId = tvas.isNotEmpty ? tvas[0].id : null;
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

  // Validators
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
              "Add Product",
              style: TextStyle(
                color: Constants.color3,
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
                      ), // Price Field
                      SizedBox(height: 20),
                      // Custom Dropdowns
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (categories.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                CustomDropdown<String>(
                                  hintText: 'Select Category',
                                  items: categories
                                      .map((category) => category.category)
                                      .toList(),
                                  initialItem: categories.isNotEmpty
                                      ? categories[0].category
                                      : 'No categories available',
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategoryId = categories
                                          .firstWhere(
                                              (cat) => cat.category == value)
                                          .id;
                                    });
                                  },
                                ),
                              ],
                            ),
                          if (brands.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('Brand',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                CustomDropdown<String>(
                                  hintText: 'Select Brand',
                                  items: brands
                                      .map((brand) => brand.name)
                                      .toList(),
                                  initialItem: brands.isNotEmpty
                                      ? brands[0].name
                                      : 'No brands available',
                                  onChanged: (value) {
                                    setState(() {
                                      selectedBrandId = brands
                                          .firstWhere((br) => br.name == value)
                                          .id;
                                    });
                                  },
                                ),
                              ],
                            ),
                          if (tvas.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text('TVA',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                CustomDropdown<String>(
                                  hintText: 'Select TVA',
                                  items: tvas
                                      .map((tva) => '${tva.value} %')
                                      .toList(),
                                  initialItem: tvas.isNotEmpty
                                      ? '${tvas[0].value} %'
                                      : 'No TVAs available',
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTvaId = tvas
                                          .firstWhere((tva) =>
                                              '${tva.value} %' == value)
                                          .id;
                                    });
                                  },
                                ),
                              ],
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
                  borderRadius: 10,
                  margin: EdgeInsets.all(8.0),
                  bgColor: kWhite,
                  onPressed: () {
                    Navigator.pop(context);
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
                ),
              ),
              SizedBox(
                width: 100,
                child: Button(
                  borderRadius: 10,
                  margin: EdgeInsets.all(8.0),
                  bgColor: Constants.color1,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Add button clicked
                      String reference = referenceController.text;
                      String designation = designationController.text;
                      double price = double.parse(priceController.text);

                      Map<String, dynamic> productData = {
                        'reference': reference,
                        'designation': designation,
                        'category_id': selectedCategoryId,
                        'brand_id': selectedBrandId,
                        'price': price,
                        'tva_id': selectedTvaId,
                      };

                      try {
                        await ServiceProduct.addProduct(productData);
                        MotionToast.success(
                          width: 300,
                          height: 50,
                          title: Text("Product added successfully"),
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
                          title: Text("Failed to  add Product"),
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
