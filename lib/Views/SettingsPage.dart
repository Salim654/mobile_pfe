import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_pfe/Utils/DataActivitys.dart';
import 'package:mobile_pfe/Models/Activity.dart';
import 'package:mobile_pfe/Utils/settings.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Settings.buildLayout(
            title: 'Settings',
            body: _buildGridView(context),
          );
        } else {
          return Settings.buildMobileLayout(
            context: context,
            index: 2,
            title: 'Settings',
            body: _buildGridView(context),
          );
        }
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.5;
    final double itemWidth = size.width / 2;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: nbriteminonerow(constraints.maxWidth),
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: kIsWeb ? (itemWidth / itemHeight) : 1.0,
            ),
            itemCount: DataActivitys.settings.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  DataActivitys.onTapItem(
                      context, DataActivitys.settings[index].index);
                },
                child: _buildActivityCard(
                  context,
                  DataActivitys.settings[index],
                  constraints.maxWidth,
                ),
              );
            },
          );
        },
      ),
    );
  }

  int nbriteminonerow(double width) {
    if (width > 600) {
      return 4;
    } else {
      return 2;
    }
  }

  Widget _buildActivityCard(
      BuildContext context, Activity activity, double containerWidth) {
    double cardHeight = kIsWeb ? containerWidth * 0.05 : containerWidth * 0.1;
    double fontSize = kIsWeb ? 12.0 : 16.0;

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(activity.backImage),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              activity.imageUrl,
              height: cardHeight * 1.5,
            ),
            SizedBox(height: 8.0),
            Text(
              activity.text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
