import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Taxe.dart';
import 'package:mobile_pfe/services/ServiceTaxe.dart';
import 'package:mobile_pfe/views/TaxePage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetEditTaxe extends StatefulWidget {
  final Taxe taxe;

  BottomSheetEditTaxe({required this.taxe});

  @override
  _BottomSheetEditTaxeState createState() => _BottomSheetEditTaxeState();
}

class _BottomSheetEditTaxeState extends State<BottomSheetEditTaxe> {
  // Controllers for text fields
  late TextEditingController wordingController;
  late TextEditingController shortNameController;
  late TextEditingController valueController;

  late int _valueType; // 0 for 'Percentage', 1 for 'Fix'
  late int _application; // 0 for 'Applied on products', 1 otherwise

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the current values of the taxe
    wordingController = TextEditingController(text: widget.taxe.wording);
    shortNameController = TextEditingController(text: widget.taxe.shortName);
    valueController = TextEditingController(text: widget.taxe.value.toString());

    // Initialize radio buttons and checkbox selections
    _valueType = widget.taxe.valueType;
    _application = widget.taxe.application;
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
                  "Edit Taxe",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
                    // For Percentage
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
                            fontSize: 20,
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
                      onPressed: _saveTaxe,
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

  // Method to save the edited taxe
  void _saveTaxe() async {
    if (_formKey.currentState!.validate()) {
      double value = double.parse(valueController.text);

      // Create a map of the edited data
      Map<String, dynamic> taxeData = {
        'wording': wordingController.text,
        'short_name': shortNameController.text,
        'value': value,
        'value_type': _valueType,
        'application': _application,
      };

      try {
        // Call the service to edit the taxe
        await ServiceTaxe.editTaxe(widget.taxe.id, taxeData);
        MotionToast.success(
          width: 300,
          height: 50,
          title: Text("Taxe edited successfully"),
          description: Text(""),
        ).show(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TaxePage(),
          ),
        );
      } catch (e) {
        print(e);
        MotionToast.error(
          width: 300,
          height: 50,
          title: Text("Failed to edit Taxe"),
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
