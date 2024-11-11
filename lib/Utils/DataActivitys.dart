import 'package:mobile_pfe/Models/Activity.dart';
import 'package:mobile_pfe/Views/ClientsPage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pfe/Views/BrandCategoryPage.dart';
import 'package:mobile_pfe/Views/EstimatesPage.dart';
import 'package:mobile_pfe/Views/ProductsPage.dart';
import 'package:mobile_pfe/Views/PurchaseOrdersPage.dart';
import 'package:mobile_pfe/Views/TvaPage.dart';
import 'package:mobile_pfe/Views/TaxePage.dart';
import 'package:mobile_pfe/Views/FacturesPage.dart';
import 'package:mobile_pfe/Views/SettingsPage.dart';
import 'package:mobile_pfe/Views/InvoicesPage.dart';

class DataActivitys {
  static List<Activity> activities = [
    Activity(
      index: 1,
      text: "Clients",
      backImage: "assets/images/box1.png",
      imageUrl: "assets/images/img1.png",
    ),
    Activity(
      index: 2,
      text: "Categories & Brands",
      backImage: "assets/images/box2.png",
      imageUrl: "assets/images/img2.png",
    ),
    Activity(
      index: 3,
      text: "Products",
      backImage: "assets/images/box3.png",
      imageUrl: "assets/images/img3.png",
    ),
    Activity(
      index: 4,
      text: "Documents",
      backImage: "assets/images/box4.png",
      imageUrl: "assets/images/img4.png",
    ),
    Activity(
      index: 5,
      text: "Settings",
      backImage: "assets/images/box1.png",
      imageUrl: "assets/images/img5.png",
    ),
  ];
  static List<Activity> factures = [
    Activity(
      index: 9,
      text: "Invoices",
      backImage: "assets/images/box1.png",
      imageUrl: "assets/images/img4.png",
    ),
    Activity(
      index: 10,
      text: "Purchase Orders",
      backImage: "assets/images/box2.png",
      imageUrl: "assets/images/img4.png",
    ),
    Activity(
      index: 11,
      text: "Estimates",
      backImage: "assets/images/box3.png",
      imageUrl: "assets/images/img4.png",
    ),
  ];
  static List<Activity> settings = [
    Activity(
      index: 8,
      text: "Profile",
      backImage: "assets/images/box1.png",
      imageUrl: "assets/images/img4.png",
    ),
    Activity(
      index: 6,
      text: "TVA",
      backImage: "assets/images/box2.png",
      imageUrl: "assets/images/img4.png",
    ),
    Activity(
      index: 7,
      text: "Taxes",
      backImage: "assets/images/box3.png",
      imageUrl: "assets/images/img4.png",
    ),
  ];
  static void onTapItem(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BrandCategoryPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductsPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FacturesPage()),
        );
        break;
      case 5:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
      case 6:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TvaPage()),
        );
        break;
      case 7:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaxePage()),
        );
        break;
      case 9:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InvoicesPage(),
          ),
        );
        break;
      case 10:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseOrdersPage(),
          ),
        );
        break;
      case 11:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EstimatesPage(),
          ),
        );
        break;
      default:
        //
        break;
    }
  }
}
