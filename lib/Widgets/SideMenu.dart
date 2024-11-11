import 'package:flutter/material.dart';
import 'package:mobile_pfe/Models/Activity.dart';
import 'package:mobile_pfe/Services/ServiceLogin.dart';
import 'package:mobile_pfe/Views/LoginPage.dart';
import 'package:mobile_pfe/Views/HomePage.dart';
import 'package:mobile_pfe/Utils/DataActivitys.dart';

class SideMenu extends StatelessWidget {
  final List<Activity> activities;

  SideMenu({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Image.asset(
            'assets/images/menuimg.png',
            width: 100,
            height: 100,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    activities[index].imageUrl,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(activities[index].text),
                  onTap: () {
                    // Item tap
                    DataActivitys.onTapItem(context, activities[index].index);
                  },
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              try {
                await ServiceLogin.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                print('Logout failed: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
