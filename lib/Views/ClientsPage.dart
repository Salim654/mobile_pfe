import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Client.dart';
import 'package:mobile_pfe/utils/settings.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:mobile_pfe/Services/ServiceClient.dart';
import 'package:mobile_pfe/Widgets/AddClientBottom.dart';
import 'package:mobile_pfe/Widgets/BottomSheetDetailsClient.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditClient.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class ClientsPage extends StatefulWidget {
  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();
  late List<Client> clients = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  // Fetching clients
  void _fetchClients() async {
    List<Client> fetchedClients =
        await ServiceClient.getClients(searchController.text);
    setState(() {
      clients = fetchedClients;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'Clients',
        body: _buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        retour: 1,
        context: context,
        title: 'Clients',
        body: _buildBody(),
      );
    }
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Constants.color1,
                borderRadius: BorderRadius.circular(8.0),
              ),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width - 20,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (text) {
                        _fetchClients(); // Filtering
                      },
                      decoration: const InputDecoration(
                        hintText: '    Search...',
                        hintStyle: TextStyle(
                          color: Constants.color1,
                          fontFamily: 'Roboto',
                        ),
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Constants.color1,
                        ),
                      ),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
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
                builder: (context) => AddClientBottom(),
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
    if (clients.isEmpty) {
      return Center(
        child: Image.asset('assets/images/nothing.jpg'),
      );
    } else {
      return ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _buildClientCard(context, clients[index]),
          );
        },
      );
    }
  }

  Widget _buildClientCard(BuildContext context, Client client) {
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
          width: MediaQuery.of(context).size.width -
              10, // Set width to screen width - 10 (5px margin on each side)
          height: 50,
          child: Slidable(
            key: ValueKey(client.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => detailsclient(client),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.info,
                ),
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _editClient(client),
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
                  onPressed: (context) => deleteBottom(client),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading:
                  const Icon(Icons.account_circle, color: Constants.color5),
              title: Text(
                client.name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  color: Constants.color5,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _editClient(Client client) {
    Map<String, dynamic> clientD = {
      'id': client.id,
      'name': client.name,
      'identification': client.identification,
      'email': client.email,
      'phone': client.phone,
      'adresse': client.address,
    };
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetEditClient(clientData: clientD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }

  Future<void> _deleteClient(Client client) async {
    try {
      await ServiceClient.deleteClient(client.id);
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text("Client Deleted successfully"),
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
        title: Text("Failed to  Delete Client"),
        description: Text(""),
      ).show(context);
    }
  }

  void deleteBottom(Client client) {
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: const Text(
        "Delete Client",
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Are you sure, You want to Delete Client...",
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          _deleteClient(client);
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

  void detailsclient(Client client) {
    Map<String, dynamic> clientData = {
      'id': client.id,
      'name': client.name,
      'identification': client.identification,
      'email': client.email,
      'phone': client.phone,
      'adresse': client.address,
    };
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetDetailsClient(clientData: clientData),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }
}
