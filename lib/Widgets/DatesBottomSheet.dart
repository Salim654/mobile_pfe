import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:mobile_pfe/Views/ManageFacturePage.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart'; // Import the page to navigate to

class DatesBottomSheet extends StatefulWidget {
  final Facture facture;

  DatesBottomSheet({required this.facture});

  @override
  _DatesBottomSheetState createState() => _DatesBottomSheetState();
}

class _DatesBottomSheetState extends State<DatesBottomSheet> {
  late DateTime selectedDate;
  late DateTime selectedDueDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.parse(widget.facture.date);
    selectedDueDate = DateTime.parse(widget.facture.dueDate);
  }

  void _pickDate(BuildContext context, bool isDueDate) async {
    DateTime? pickedDate = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: isDueDate ? selectedDueDate : selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      dateFormat: "yyyy-MM-dd",
      locale: DateTimePickerLocale.en_us,
      looping: true,
    );

    if (pickedDate != null) {
      setState(() {
        if (isDueDate) {
          selectedDueDate = pickedDate;
        } else {
          selectedDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Dates',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto', // Added font family
                color: Constants.color3, // Text color
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date:',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Constants.color4,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                        color: Constants.color4,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Constants.color1,
                      ),
                      onPressed: () => _pickDate(context, false),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due Date:',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Constants.color4,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${selectedDueDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Roboto',
                        color: Constants.color4,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Constants.color1,
                      ),
                      onPressed: () => _pickDate(context, true),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
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
                    // Check if due date is greater than selected date
                    if (selectedDueDate.isAfter(selectedDate)) {
                      try {
                        Facture? updatedFacture =
                            await ServiceFacture.editFacture(
                          id: widget.facture.id,
                          discount: widget.facture.discount,
                          date: selectedDate.toIso8601String(),
                          dueDate: selectedDueDate.toIso8601String(),
                          clientId: widget.facture.clientId,
                          taxeId: widget.facture.taxeId,
                        );
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
                    } else {
                      // Show error message if due date is not greater than selected date
                      MotionToast.error(
                        width: 300,
                        height: 50,
                        title:
                            Text("Due date must be greater than selected date"),
                        description: Text(""),
                      ).show(context);
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
