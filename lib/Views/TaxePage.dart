import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:mobile_pfe/Widgets/BottomSheetAddTaxe.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditTaxe.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:mobile_pfe/Utils/settings.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Services/ServiceTaxe.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:buttons_flutter/buttons_flutter.dart';

import '../Models/Taxe.dart';

class TaxePage extends StatefulWidget {
  @override
  _TaxePageState createState() => _TaxePageState();
}

class _TaxePageState extends State<TaxePage> {
  late List<Taxe> taxes = [];
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();

  @override
  void initState() {
    super.initState();
    _fetchTaxesForUser();
  }

  void _fetchTaxesForUser() async {
    try {
      List<Taxe> userTaxes = await ServiceTaxe.getTaxesForUser();
      setState(() {
        taxes = userTaxes;
      });
    } catch (e) {
      Constants.showSnackBar(context, 'Failed to load taxes', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'Taxes',
        body: _buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        context: context,
        retour: 2,
        title: 'Taxes',
        body: _buildBody(),
      );
    }
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: _buildListView(),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.width * 0.05,
          child: FloatingActionButton(
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => BottomSheetAddTaxe(),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Constants.color1,
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (taxes.isEmpty) {
      return Center(
        child: Image.asset('assets/images/nothing.jpg'),
      );
    } else {
      return ListView.builder(
        itemCount: taxes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _buildTaxeCard(context, taxes[index]),
          );
        },
      );
    }
  }

  Widget _buildTaxeCard(BuildContext context, Taxe taxe) {
    double fontSize = 16.0;

    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Constants.color2.withOpacity(0.15),
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
          height: 100,
          child: Slidable(
            key: ValueKey(taxe.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _editTaxe(taxe),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => deleteBottom(taxe),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading:
                  const Icon(Icons.local_atm_outlined, color: Constants.color5),
              title: Text(
                taxe.shortName,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Constants.color5,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Value: ${taxe.valueType == 0 ? taxe.value.toString() + ' %' : taxe.value.toString()}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.color4,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    taxe.application == 0
                        ? 'Applied On Product'
                        : 'Not Applied On Product',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.color4,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editTaxe(Taxe taxe) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetEditTaxe(taxe: taxe),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }

  Future<void> _deleteTaxe(Taxe taxe) async {
    try {
      await ServiceTaxe.deleteTaxe(taxe.id);
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text("Taxe deleted successfully"),
        description: Text(""),
      ).show(context);
      _fetchTaxesForUser();
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("Failed to delete Taxe"),
        description: Text(""),
      ).show(context);
    }
  }

  void deleteBottom(Taxe taxe) {
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: const Text(
        "Delete Taxe",
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Are you sure, You want to Delete Taxe...",
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          _deleteTaxe(taxe);
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
