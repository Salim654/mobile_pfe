import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Services/ServiceClient.dart';
import 'package:mobile_pfe/Views/ClientsPage.dart';
import 'package:mobile_pfe/utils/Constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetEditClient extends StatefulWidget {
  final Map<String, dynamic> clientData;

  BottomSheetEditClient({required this.clientData});

  @override
  _BottomSheetEditClientState createState() => _BottomSheetEditClientState();
}

class _BottomSheetEditClientState extends State<BottomSheetEditClient> {
  late TextEditingController nameController;
  late TextEditingController identificationController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.clientData['name']);
    identificationController =
        TextEditingController(text: widget.clientData['identification']);
    emailController = TextEditingController(text: widget.clientData['email']);
    phoneController = TextEditingController(text: widget.clientData['phone']);
    addressController =
        TextEditingController(text: widget.clientData['adresse']);
  }

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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Edit Client",
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
              buildTextField('Identification', identificationController,
                  _validateIdentification),
              buildTextField('Email', emailController, _validateEmail),
              buildTextField('Phone', phoneController, _validatePhone,
                  keyboardType: TextInputType.numberWithOptions(decimal: true)),
              buildTextField('Address', addressController, _validateAddress),
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
                            String name = nameController.text;
                            String identification =
                                identificationController.text;
                            String email = emailController.text;
                            String phone = phoneController.text;
                            String address = addressController.text;

                            Map<String, dynamic> updatedClientData = {
                              'name': name,
                              'identification': identification,
                              'email': email,
                              'phone': phone,
                              'adresse': address,
                            };

                            try {
                              await ServiceClient.editClient(
                                  widget.clientData['id'], updatedClientData);
                              MotionToast.success(
                                width: 300,
                                height: 50,
                                title: Text("Client updated successfully"),
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
                                title: Text("Failed to update Client"),
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
