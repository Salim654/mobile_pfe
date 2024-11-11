import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_pfe/services/ServiceTva.dart';
import 'package:mobile_pfe/views/TvaPage.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:buttons_flutter/buttons_flutter.dart';

class BottomSheetAddTva extends StatefulWidget {
  @override
  _BottomSheetAddTvaState createState() => _BottomSheetAddTvaState();
}

class _BottomSheetAddTvaState extends State<BottomSheetAddTva> {
  // Controller
  final TextEditingController valueController = TextEditingController();

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validator function for TVA value
  String? _validateValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    // Check if the value is numeric
    final double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'Value must be numeric';
    }
    return null;
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
                  "Add TVA",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              buildTextField('Value', valueController, _validateValue,
                  keyboardType: TextInputType.numberWithOptions(decimal: true)),
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
                      onPressed: _addTva,
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

  // Method to add a TVA
  void _addTva() async {
    if (_formKey.currentState!.validate()) {
      double value = double.parse(valueController.text);

      // Create a map of the form data
      Map<String, dynamic> tvaData = {
        'value': value,
      };

      try {
        // Add the TVA using the service
        await ServiceTva.addTva(tvaData);
        MotionToast.success(
          width: 300,
          height: 50,
          title: Text("TVA added successfully"),
          description: Text(""),
        ).show(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TvaPage(),
          ),
        );
      } catch (e) {
        print(e);
        MotionToast.error(
          width: 300,
          height: 50,
          title: Text("Adding TVA failed"),
          description: Text(""),
        ).show(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TvaPage(),
          ),
        );
      }
    }
  }
}
