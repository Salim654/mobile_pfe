import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:mobile_pfe/Models/Client.dart';
import 'package:mobile_pfe/Models/Product.dart';
import 'package:mobile_pfe/Models/Taxe.dart';
import 'package:mobile_pfe/Services/ServiceClient.dart';
import 'package:mobile_pfe/Services/ServiceTaxe.dart';
import 'package:mobile_pfe/Utils/settings.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';
import 'package:mobile_pfe/Views/ClasseViewInvoice.dart';
import 'package:mobile_pfe/Views/file_handle_api.dart';
import 'package:mobile_pfe/Views/pdf_invoice_api.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_pfe/Views/ManageFacturePage.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class EstimatesPage extends StatefulWidget {
  @override
  _EstimatesPageState createState() => _EstimatesPageState();
}

class _EstimatesPageState extends State<EstimatesPage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();
  late List<Facture> estimates = [];
  bool isLoading = true;
  List<Client> clients = [];
  List<Taxe> taxes = [];
  bool noTaxe = false;

  @override
  void initState() {
    super.initState();
    fetchEstimates();
    _fetchTaxesForUser();
    _fetchClients();
  }

  void _fetchClients() async {
    List<Client> fetchedClients = await ServiceClient.getClients('');
    setState(() {
      clients = fetchedClients;
    });
  }

  void _fetchTaxesForUser() async {
    try {
      List<Taxe> userTaxes = await ServiceTaxe.getTaxesForUser();
      setState(() {
        taxes = userTaxes;
      });
    } catch (e) {}
  }

  void fetchEstimates() async {
    try {
      List<Facture>? userEstimates = await ServiceFacture.getEstimates();
      setState(() {
        estimates = userEstimates ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'Estimates',
        body: buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        context: context,
        retour: 0,
        title: 'Estimates',
        body: buildBody(),
      );
    }
  }

  Widget buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 15),
            Expanded(
              child: buildListView(),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          child: FloatingActionButton(
            onPressed: () {
              showAddEstimateModalSheet();
            },
            child: Icon(
              Icons.add,
              color: kWhite,
            ),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget buildListView() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (estimates.isEmpty) {
      return Center(
        child: Image.asset('assets/images/noestimates.PNG'),
      );
    } else {
      return ListView.builder(
        itemCount: estimates.length,
        itemBuilder: (context, index) {
          return buildFactureCard(context, estimates[index]);
        },
      );
    }
  }

  Widget buildFactureCard(BuildContext context, Facture facture) {
    double fontSize = 16.0;

    return Slidable(
      key: ValueKey(facture.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
            padding: const EdgeInsets.all(2.0),
            onPressed: (context) => manageFacture(facture),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.settings,
          ),
          SlidableAction(
            padding: const EdgeInsets.all(2.0),
            onPressed: (context) => deleteBottom(facture.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
          SlidableAction(
            padding: const EdgeInsets.all(2.0),
            onPressed: (context) => generateInvoice2(facture.id),
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            icon: Icons.visibility,
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            padding: const EdgeInsets.all(2.0),
            onPressed: (context) => generateInvoice(facture.id),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.picture_as_pdf,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 10,
            height: 80,
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(
                facture.reference,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${facture.date}'),
                  Text('Due Date: ${facture.dueDate}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteFacture(int idfacture) async {
    try {
      await ServiceFacture.deleteFacture(idfacture);
      fetchEstimates();
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text("Estimates deleted successfully"),
        description: Text(""),
      ).show(context);
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("failed to delete Estimates"),
        description: Text(""),
      ).show(context);
    }
  }

  void generateInvoice(int idfact) async {
    Map<String, dynamic>? factureDetails =
        await ServiceFacture.fetchFactureDetails(idfact);
    final font = await PdfInvoiceApi.loadFont();
    final pdfFile =
        await PdfInvoiceApi.generate(PdfColors.black, font, factureDetails!);
    FileHandleApi.openFile(pdfFile);
  }

  void generateInvoice2(int idfact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClasseViewInvoice(idfact: idfact!),
      ),
    );
  }

  void manageFacture(Facture facture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageFacturePage(facture: facture),
      ),
    );
  }

  void showAddEstimateModalSheet() {
    final _formKey = GlobalKey<FormState>();
    Client? selectedClient;
    DateTime? selectedDate;
    DateTime? selectedDueDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: selectedDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!)
                                      : '',
                                ),
                                decoration: InputDecoration(labelText: 'Date'),
                                onTap: () async {
                                  final DateTime? picked =
                                      await DatePicker.showSimpleDatePicker(
                                    context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                    dateFormat: "dd-MMMM-yyyy",
                                    locale: DateTimePickerLocale.en_us,
                                    looping: true,
                                  );
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    setState(() {
                                      selectedDate = picked;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                  text: selectedDueDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(selectedDueDate!)
                                      : '',
                                ),
                                decoration:
                                    InputDecoration(labelText: 'Due Date'),
                                onTap: () async {
                                  final DateTime? picked =
                                      await DatePicker.showSimpleDatePicker(
                                    context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                    dateFormat: "dd-MMMM-yyyy",
                                    locale: DateTimePickerLocale.en_us,
                                    looping: true,
                                  );
                                  if (picked != null &&
                                      picked != selectedDueDate) {
                                    setState(() {
                                      selectedDueDate = picked;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a due date';
                                  } else if (selectedDate != null &&
                                      selectedDueDate != null &&
                                      selectedDueDate!
                                          .isBefore(selectedDate!)) {
                                    return 'Due date must be after the selected date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomDropdown<String>(
                        hintText: 'Select Client',
                        items: clients.map((client) => client.name).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClient = clients
                                .firstWhere((client) => client.name == value);
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a client';
                          }
                          return null;
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    Facture? newfact =
                                        await ServiceFacture.addInvoice(
                                      clientId: selectedClient!.id,
                                      date: DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!),
                                      dueDate: DateFormat('yyyy-MM-dd')
                                          .format(selectedDueDate!),
                                      discount: 0,
                                      taxeId: null,
                                      type: 1,
                                    );

                                    if (newfact != null) {
                                      MotionToast.success(
                                        width: 300,
                                        height: 50,
                                        title: Text("Added successfully"),
                                        description: Text(""),
                                      ).show(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ManageFacturePage(
                                                  facture: newfact),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    MotionToast.error(
                                      width: 300,
                                      height: 50,
                                      title: Text("failed to Add"),
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
                                    fontSize: 14,
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
          },
        );
      },
    );
  }

  void deleteBottom(int idfacture) {
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: const Text(
        "Delete Estimate",
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Are you sure, You want to Delete Estimate...",
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          deleteFacture(idfacture);
          Navigator.of(context).pop();
        },
        title: 'Delete',
      ),
      negative: AwesomeSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        title: 'Cancel',
      ),
    );
  }
}
