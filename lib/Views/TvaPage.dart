import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:mobile_pfe/Widgets/BottomSheetAddTva.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditTva.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:mobile_pfe/Utils/settings.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Models/Tva.dart';
import 'package:mobile_pfe/Services/ServiceTva.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TvaPage extends StatefulWidget {
  @override
  _TvaPageState createState() => _TvaPageState();
}

class _TvaPageState extends State<TvaPage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();
  late List<Tva> tvas = [];

  @override
  void initState() {
    super.initState();
    _fetchTvasForUser();
  }

  void _fetchTvasForUser() async {
    try {
      List<Tva> userTvas = await ServiceTva.getTvasForUser();
      setState(() {
        tvas = userTvas;
      });
    } catch (e) {
      Constants.showSnackBar(context, 'Failed to load TVAs', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'TVAs',
        body: _buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        context: context,
        retour: 2,
        title: 'TVAs',
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
                builder: (context) => BottomSheetAddTva(),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: kWhite,
            ),
            backgroundColor: Constants.color1,
          ),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (tvas.isEmpty) {
      return Center(
        child: Image.asset('assets/images/nothing.jpg'),
      );
    } else {
      return ListView.builder(
        itemCount: tvas.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _buildTvaCard(context, tvas[index]),
          );
        },
      );
    }
  }

  Widget _buildTvaCard(BuildContext context, Tva tva) {
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
            key: ValueKey(tva.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _editTva(tva),
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
                  onPressed: (context) => deleteBottom(tva),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Constants.color5),
              title: Text(
                'TVA ID: ${tva.id}',
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
                    'Country: ${tva.country}',
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Text(
                    '${tva.value} %',
                    style: TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editTva(Tva tva) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetEditTva(tva: tva),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }

  Future<void> _deleteTva(Tva tva) async {
    try {
      await ServiceTva.deleteTva(tva.id);
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text("TVA deleted successfully"),
        description: Text(""),
      ).show(context);
      _fetchTvasForUser();
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("failed to delete tva"),
        description: Text(""),
      ).show(context);
    }
  }

  void deleteBottom(Tva tva) {
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: const Text(
        "Delete Tva",
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Are you sure, You want to Delete Tva...",
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          _deleteTva(tva);
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
