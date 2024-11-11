import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Brand.dart';
import 'package:mobile_pfe/Services/ServiceBrandCategory.dart';
import 'package:mobile_pfe/Views/BrandCategoryPage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetEditBrand extends StatefulWidget {
  final Brand brand;

  BottomSheetEditBrand({required this.brand});

  @override
  _BottomSheetEditBrandState createState() => _BottomSheetEditBrandState();
}

class _BottomSheetEditBrandState extends State<BottomSheetEditBrand> {
  // Controllers
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validators
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a description';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with existing values
    nameController = TextEditingController(text: widget.brand.name);
    descriptionController =
        TextEditingController(text: widget.brand.description);
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
                  "Edit Brand",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildTextField('Name', nameController, _validateName),
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
                          // Edit button clicked
                          String newName = nameController.text;
                          String newDescription = descriptionController.text;

                          Map<String, dynamic> updatedBrand = {
                            'id': widget.brand.id,
                            'userId': widget.brand.organization_id,
                            'name': newName,
                            'description': newDescription,
                          };

                          try {
                            await ServiceBrandCategory.updateBrand(
                                widget.brand.id, updatedBrand);
                            MotionToast.success(
                              width: 300,
                              height: 50,
                              title: Text("Brand updated successfully"),
                              description: Text(""),
                            ).show(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BrandCategoryPage(
                                  isCategorySelected: false,
                                ),
                              ),
                            );
                          } catch (e) {
                            MotionToast.error(
                              width: 300,
                              height: 50,
                              title: Text("Failed to update brand"),
                              description: Text(""),
                            ).show(context);
                          }
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Edit",
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
