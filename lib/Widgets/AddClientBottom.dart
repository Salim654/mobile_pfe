import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Services/ServiceClient.dart';
import 'package:mobile_pfe/Views/ClientsPage.dart';
import 'package:mobile_pfe/utils/Constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class AddClientBottom extends StatefulWidget {
  @override
  _AddClientBottomState createState() => _AddClientBottomState();
}

class _AddClientBottomState extends State<AddClientBottom> {
  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController identificationController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Form key to track form state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validator functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  String? _validateIdentification(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an identification';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must be numeric';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
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
                  "Add Client",
                  style: TextStyle(
                    color: Constants.color3,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              buildTextField('Name', nameController, _validateName),
              buildTextField('Identification', identificationController,
                  _validateIdentification),
              buildTextField('Email', emailController, _validateEmail),
              buildTextField('Phone', phoneController, _validatePhone,
                  keyboardType: TextInputType.numberWithOptions(decimal: true)),
              buildTextField('Address', addressController, _validateAddress),
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
                            // Add button clicked
                            String name = nameController.text;
                            String identification =
                                identificationController.text;
                            String email = emailController.text;
                            String phone = phoneController.text;
                            String address = addressController.text;

                            Map<String, dynamic> clientData = {
                              'name': name,
                              'identification': identification,
                              'email': email,
                              'phone': phone,
                              'adresse': address,
                            };

                            try {
                              await ServiceClient.addClient(clientData);
                              MotionToast.success(
                                width: 300,
                                height: 50,
                                title: Text("Client added successfully"),
                                description: Text(""),
                              ).show(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClientsPage(),
                                ),
                              );
                            } catch (e) {
                              MotionToast.error(
                                width: 300,
                                height: 50,
                                title: Text("Failed to  add client"),
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
