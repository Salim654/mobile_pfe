import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Services/ServiceClient.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';
import 'package:mobile_pfe/Models/Client.dart';
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mobile_pfe/Views/ManageFacturePage.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class ClientBottomSheet extends StatefulWidget {
  final Facture facture;

  ClientBottomSheet({required this.facture});

  @override
  _ClientBottomSheetState createState() => _ClientBottomSheetState();
}

class _ClientBottomSheetState extends State<ClientBottomSheet> {
  List<Client> clients = [];
  Client? selectedClient;
  TextEditingController? textEditingController;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    try {
      List<Client> fetchedClients = await ServiceClient.getClients('');
      setState(() {
        clients = fetchedClients;
        if (widget.facture.clientId != null) {
          selectedClient = clients
              .firstWhere((client) => client.id == widget.facture.clientId);
        }
        textEditingController = TextEditingController(
          text: selectedClient?.name ?? '',
        );
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: clients.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Client',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Constants.color3,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomDropdown<String>(
                    hintText: 'Select Client',
                    items: clients.map((client) => client.name).toList(),
                    initialItem: selectedClient?.name ?? '',
                    onChanged: (value) {
                      setState(() {
                        selectedClient = clients
                            .firstWhere((client) => client.name == value);
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Button(
                            borderRadius: 10,
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
                                        discount: widget.facture.discount,
                                        date: widget.facture.date,
                                        dueDate: widget.facture.dueDate,
                                        clientId: selectedClient!.id,
                                        taxeId: widget.facture.taxeId);
                                if (updatedFacture != null) {
                                  MotionToast.success(
                                    width: 300,
                                    height: 50,
                                    title: Text("Updated Successfully"),
                                    description: Text(""),
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
                                  description: Text(""),
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
                          )),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
