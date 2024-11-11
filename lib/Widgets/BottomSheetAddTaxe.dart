import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/models/Taxe.dart';
import 'package:mobile_pfe/services/ServiceTaxe.dart';
import 'package:mobile_pfe/views/TaxePage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetAddTaxe extends StatefulWidget {
  @override
  _BottomSheetAddTaxeState createState() => _BottomSheetAddTaxeState();
}

class _BottomSheetAddTaxeState extends State<BottomSheetAddTaxe> {
  // Controllers for text fields
  final TextEditingController wordingController = TextEditingController();
  final TextEditingController shortNameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  // Variables for radio button and checkbox selections
  int _valueType = 0; // 0 for 'Percentage', 1 for 'Fix'
  int _application = 0; // 0 for 'Applied on products', 1 otherwise

  // Global key for form state
  final _formKey = GlobalKey<FormState>();

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
                  "Add Taxe",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              buildTextField('Wording', wordingController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Wording is required';
                }
                return null;
              }),
              buildTextField('Short Name', shortNameController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Short name is required';
                }
                return null;
              }),
              buildTextField('Value', valueController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Value is required';
                }
                try {
                  double parsedValue = double.parse(value);
                  if (_valueType == 0) {
                    // Percentage
                    if (parsedValue < 0 || parsedValue > 100) {
                      return 'For Percentage, Value must be between 0 and 100';
                    }
                  }
                } catch (e) {
                  return 'Value must be a number';
                }
                return null;
              }, keyboardType: TextInputType.number),
              SizedBox(height: 8),
              Text('Value Type', style: TextStyle(color: Constants.color4)),
              RadioListTile<int>(
                title: Text('Percentage',
                    style: TextStyle(color: Constants.color4)),
                value: 0,
                groupValue: _valueType,
                onChanged: (value) {
                  setState(() {
                    _valueType = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('Fix', style: TextStyle(color: Constants.color4)),
                value: 1,
                groupValue: _valueType,
                onChanged: (value) {
                  setState(() {
                    _valueType = value!;
                  });
                },
              ),
              SizedBox(height: 8),
              CheckboxListTile(
                title: Text('Applied on products',
                    style: TextStyle(color: Constants.color4)),
                value: _application == 0,
                onChanged: (value) {
                  setState(() {
                    _application = value! ? 0 : 1;
                  });
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
                      onPressed: _addTaxe,
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

  // Method to add a taxe
  void _addTaxe() async {
    if (_formKey.currentState!.validate()) {
      double value = double.parse(valueController.text);

      // Create a map of the form data
      Map<String, dynamic> taxeData = {
        'wording': wordingController.text,
        'short_name': shortNameController.text,
        'value': value,
        'value_type': _valueType,
        'application': _application,
      };

      try {
        // Add the tax using the service
        await ServiceTaxe.addTaxe(taxeData);
        MotionToast.success(
          width: 300,
          height: 50,
          title: Text("Taxe added successfully"),
          description: Text(""),
        ).show(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TaxePage(),
          ),
        );
      } catch (e) {
        MotionToast.error(
          width: 300,
          height: 50,
          title: Text("Failed to add Taxe"),
          description: Text(""),
        ).show(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TaxePage(),
          ),
        );
      }
    }
  }
}
