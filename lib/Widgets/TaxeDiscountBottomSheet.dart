import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';
import 'package:mobile_pfe/Services/ServiceTaxe.dart';
import 'package:mobile_pfe/Models/Taxe.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mobile_pfe/Views/ManageFacturePage.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class TaxeDiscountBottomSheet extends StatefulWidget {
  final Facture facture;

  TaxeDiscountBottomSheet({required this.facture});

  @override
  _TaxeDiscountBottomSheetState createState() =>
      _TaxeDiscountBottomSheetState();
}

class _TaxeDiscountBottomSheetState extends State<TaxeDiscountBottomSheet> {
  late TextEditingController discountController;
  List<Taxe> taxes = [];
  Taxe? selectedTaxe;
  bool isLoading = true;
  bool applyTax = true;
  bool applyDiscount = true;

  @override
  void initState() {
    super.initState();
    discountController =
        TextEditingController(text: widget.facture.discount.toString());
    _fetchTaxesForUser();
  }

  Future<void> _fetchTaxesForUser() async {
    try {
      List<Taxe> userTaxes = await ServiceTaxe.getTaxesForUser();
      List<Taxe> newTaxes =
          userTaxes.where((taxe) => taxe.application == 1).toList();
      setState(() {
        taxes = newTaxes;
        if (widget.facture.taxeId != null) {
          selectedTaxe =
              taxes.firstWhere((tax) => tax.id == widget.facture.taxeId);
          applyTax = true; // Set applyTax to true if taxeId is not null
        } else {
          applyTax = false; // Set applyTax to false if taxeId is null
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching taxes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Taxes and Discount',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Added font family
                      color: Constants.color3, // Text color
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch(
                        value: applyDiscount,
                        onChanged: (value) {
                          setState(() {
                            applyDiscount = value;
                            if (!applyDiscount) {
                              discountController.text =
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
                    controller: discountController,
                    decoration: InputDecoration(
                      labelText: 'Discount (%)',
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto', // Added font family
                        color: Constants.color4, // Text color
                      ),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    enabled: applyDiscount,
                  ),
                  const SizedBox(height: 16.0),
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
                  if (applyTax && taxes.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 8.0),
                        CustomDropdown<String>(
                          hintText: 'Select Taxe',
                          items: taxes.map((taxe) => taxe.shortName).toList(),
                          initialItem: selectedTaxe != null
                              ? selectedTaxe!.shortName
                              : taxes[0].shortName,
                          onChanged: (value) {
                            setState(() {
                              selectedTaxe = taxes.firstWhere(
                                  (taxe) => taxe.shortName == value);
                            });
                          },
                        ),
                      ],
                    ),
                  if (applyTax && taxes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No taxes available',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Roboto', // Added font family
                        ),
                      ),
                    ),
                  SizedBox(height: 15.0),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                        width: 100,
                        child: Button(
                          borderRadius: 8,
                          margin: const EdgeInsets.all(8.0),
                          bgColor: kWhite,
                          onPressed: () {
                            Navigator.pop(context); // Some method calls
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
                          try {
                            Facture? updatedFacture =
                                await ServiceFacture.editFacture(
                              id: widget.facture.id,
                              date: widget.facture.date,
                              dueDate: widget.facture.dueDate,
                              clientId: widget.facture.clientId,
                              discount: applyDiscount
                                  ? double.parse(discountController.text)
                                  : 0.0,
                              taxeId: applyTax && selectedTaxe != null
                                  ? selectedTaxe!.id
                                  : null,
                            );
                            if (updatedFacture != null) {
                              MotionToast.success(
                                width: 300,
                                height: 50,
                                title: Text("Updated Successfully"),
                                description: const Text(""),
                              ).show(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageFacturePage(
                                    facture: updatedFacture,
                                  ),
                                ),
                              );
                            } else {
                              throw Exception('Failed to update facture');
                            }
                          } catch (e) {
                            MotionToast.error(
                              width: 300,
                              height: 50,
                              title: Text("Updating Failed"),
                              description: const Text(""),
                            ).show(context);
                            // Handle error
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
                      ),
                    ),
                  ]),
                ],
              ),
      ),
    );
  }
}
