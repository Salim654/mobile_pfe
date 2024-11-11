import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Category.dart';
import 'package:mobile_pfe/Services/ServiceBrandCategory.dart';
import 'package:mobile_pfe/Views/BrandCategoryPage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetEditCategory extends StatefulWidget {
  final Category category;

  BottomSheetEditCategory({required this.category});

  @override
  _BottomSheetEditCategoryState createState() =>
      _BottomSheetEditCategoryState();
}

class _BottomSheetEditCategoryState extends State<BottomSheetEditCategory> {
  // Controllers
  late TextEditingController categoryController;
  late TextEditingController referenceController;
  late TextEditingController descriptionController;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validators
  String? _validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a category';
    }
    return null;
  }

  String? _validateReference(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a reference';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing values
    categoryController = TextEditingController(text: widget.category.category);
    referenceController =
        TextEditingController(text: widget.category.reference);
    descriptionController =
        TextEditingController(text: widget.category.description);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Edit Category",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildTextField('Category', categoryController, _validateCategory),
              buildTextField(
                  'Reference', referenceController, _validateReference),
              buildTextField(
                  'Description', descriptionController, _validateDescription),
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
                          // Save button clicked
                          String category = categoryController.text;
                          String reference = referenceController.text;
                          String description = descriptionController.text;

                          Map<String, dynamic> updatedCategory = {
                            'id': widget.category.id,
                            'userId': widget.category.organization_id,
                            'category': category,
                            'reference': reference,
                            'description': description,
                          };

                          try {
                            // Call the service function to update the category
                            await ServiceBrandCategory.updateCategory(
                                widget.category.id, updatedCategory);
                            MotionToast.success(
                              width: 300,
                              height: 50,
                              title: Text("Category updated successfully"),
                              description: Text(""),
                            ).show(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrandCategoryPage(
                                  isCategorySelected: true,
                                ),
                              ),
                            );
                          } catch (e) {
                            MotionToast.error(
                              width: 300,
                              height: 50,
                              title: Text("Failed to update category"),
                              description: Text(""),
                            ).show(context);
                          }
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Save",
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
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      String? Function(String?) validator,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Roboto',
          color: Constants.color4,
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
