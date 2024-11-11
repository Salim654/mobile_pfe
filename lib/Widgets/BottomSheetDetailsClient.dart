import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mobile_pfe/utils/Constants.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class BottomSheetDetailsClient extends StatelessWidget {
  final Map<String, dynamic> clientData;

  BottomSheetDetailsClient({required this.clientData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      child: Container(
        height: 330,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Details",
                style: TextStyle(
                  color: Constants.color3,
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildInfoRow('Name :  ', clientData['name']),
            const Divider(
              color: Constants.color1,
            ),
            buildInfoRow('Identification :  ', clientData['identification']),
            const Divider(
              color: Constants.color1,
            ),
            buildInfoRow('Email :  ', clientData['email']),
            const Divider(
              color: Constants.color1,
            ),
            buildInfoRow('Phone :  ', clientData['phone']),
            const Divider(
              color: Constants.color1,
            ),
            buildInfoRow('Address :  ', clientData['adresse']),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 100,
                    child: Button(
                      borderRadius: 10,
                      margin: EdgeInsets.all(8.0),
                      bgColor: Constants.color1,
                      onPressed: () {
                        Navigator.pop(context);
                        // some method calls
                      },
                      child: const Center(
                        child: Text(
                          "Ok",
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

  Widget buildInfoRow(String label, String data) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Constants.color4,
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500, // Medium
              fontFamily: 'Roboto',
              color: Constants.color4,
            ),
          ),
        ),
      ],
    );
  }
}
