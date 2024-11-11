import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_pfe/Models/Facture.dart';
import 'package:mobile_pfe/utils/settings.dart';
import 'package:mobile_pfe/Widgets/ClientBottomSheet.dart';
import 'package:mobile_pfe/Widgets/DatesBottomSheet.dart';
import 'package:mobile_pfe/Widgets/TaxeDiscountBottomSheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mobile_pfe/Views/ListProductsFacture.dart';

class ManageFacturePage extends StatelessWidget {
  final Facture facture;

  ManageFacturePage({required this.facture});

  String gettitle(int typefact) {
    switch (typefact) {
      case 1:
        return 'Manage Estimate';
      case 2:
        return 'Manage Purshase Order';
      default:
        return 'Manage Invoice';
    }
  }

  int getretourback(int typefact) {
    switch (typefact) {
      case 1:
        return 4;
      case 2:
        return 5;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Settings.buildLayout(
            title: gettitle(facture.type),
            body: _buildBody(context),
          );
        } else {
          return Settings.buildMobileLayout(
            context: context,
            retour: getretourback(facture.type),
            title: gettitle(facture.type),
            body: _buildBody(context),
          );
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Container(
            width: MediaQuery.of(context).size.width - 10,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                facture.reference,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        Expanded(
          child: ListView(
            children: [
              _buildMenuItem(
                icon: Icons.shopping_cart,
                text: 'Items',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListProductsFacture(
                        facture: facture,
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.person,
                text: 'Client',
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => ClientBottomSheet(facture: facture),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.date_range,
                text: 'Dates',
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => DatesBottomSheet(facture: facture),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                  );

                  // Handle Details tap
                },
              ),
              _buildMenuItem(
                icon: Icons.attach_money,
                text: 'Taxes and Discounts',
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        TaxeDiscountBottomSheet(facture: facture),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                  );

                  // Handle Taxes and Discounts tap
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.15),
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
          height: 60,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: Icon(icon),
                    title: Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
