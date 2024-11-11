import 'package:flutter/material.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Views/EstimatesPage.dart';
import 'package:mobile_pfe/Views/PurchaseOrdersPage.dart';
import 'package:mobile_pfe/utils/DataActivitys.dart';
import 'package:mobile_pfe/Models/Activity.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'package:mobile_pfe/Widgets/SideMenu.dart';
import 'package:mobile_pfe/Views/ClientsPage.dart';
import 'package:mobile_pfe/Views/FacturesPage.dart';
import 'package:mobile_pfe/Views/SettingsPage.dart';
import 'package:mobile_pfe/Views/HomePage.dart';
import 'package:mobile_pfe/Views/InvoicesPage.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class Settings {
  static Widget buildLayout({required String title, required Widget body}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Adjust the threshold as needed
          return buildMobileLayout(title: title, body: body);
        } else {
          return Scaffold(
            body: Row(
              children: [
                Container(
                  width: 250,
                  child: SideMenu(activities: DataActivitys.activities),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Roboto-Medium',
                        ),
                      ),
                    ),
                    body: body,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  static Widget buildMobileLayout({
    required String title,
    required Widget body,
    int? index,
    int? retour,
    BuildContext? context,
  }) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Set the preferred height
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          leading: retour != null
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    switch (retour) {
                      case 0:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(
                              builder: (context) => FacturesPage()),
                        );
                        break;
                      case 1:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                        break;
                      case 2:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()),
                        );
                        break;
                      case 3:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(
                              builder: (context) => InvoicesPage()),
                        );
                        break;
                      case 4:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(
                              builder: (context) => EstimatesPage()),
                        );
                        break;
                      case 5:
                        Navigator.pushReplacement(
                          context!,
                          MaterialPageRoute(
                              builder: (context) => PurchaseOrdersPage()),
                        );
                        break;

                      default:
                        //
                        break;
                    }
                  },
                )
              : null,
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              color: kWhite,
              fontWeight: FontWeight.bold, // Medium
              fontSize: 20,
            ),
          ),
          backgroundColor: Constants.color1,
        ),
      ),
      drawer: SideMenu(activities: DataActivitys.activities),
      body: body,
      bottomNavigationBar: index != null
          ? MoltenBottomNavigationBar(
              barColor: Constants.color1,
              selectedIndex: index,
              onTabChange: (clickedIndex) {
                // Handle tab change
                switch (clickedIndex) {
                  case 0:
                    Navigator.pushReplacement(
                      context!,
                      MaterialPageRoute(builder: (context) => FacturesPage()),
                    );
                    break;
                  case 1:
                    Navigator.pushReplacement(
                      context!,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    break;
                  case 2:
                    Navigator.pushReplacement(
                      context!,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                    break;

                  default:
                    //
                    break;
                }
              },
              tabs: [
                MoltenTab(
                  icon: Icon(Icons.note),
                  unselectedColor: Colors.white,
                ),
                MoltenTab(
                  icon: Icon(Icons.home),
                  unselectedColor: Colors.white,
                ),
                MoltenTab(
                  icon: Icon(Icons.settings),
                  unselectedColor: Colors.white,
                ),
              ],
            )
          : null,
    );
  }
}
