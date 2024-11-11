import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:mobile_pfe/Models/Category.dart';
import 'package:mobile_pfe/utils/constants.dart';
import 'package:mobile_pfe/Models/Brand.dart';
import 'package:mobile_pfe/utils/settings.dart';
import 'package:mobile_pfe/Widgets/BottomSheetAddCategory.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditCategory.dart';
import 'package:mobile_pfe/Widgets/BottomSheetAddBrand.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditBrand.dart';
import 'package:mobile_pfe/Services/ServiceBrandCategory.dart';

class BrandCategoryPage extends StatefulWidget {
  final bool? isCategorySelected;

  BrandCategoryPage({this.isCategorySelected});
  @override
  _BrandCategoryPageState createState() => _BrandCategoryPageState();
}

class _BrandCategoryPageState extends State<BrandCategoryPage> {
  late List<Category> categories = [];
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();
  late List<Brand> brands = [];
  bool isCategorySelected = true;

  @override
  void initState() {
    super.initState();
    if (widget.isCategorySelected != null) {
      isCategorySelected = widget.isCategorySelected!;
    }
    _fetchData();
  }

  void _fetchData() async {
    if (isCategorySelected) {
      categories = await ServiceBrandCategory.fetchCategories();
    } else {
      brands = await ServiceBrandCategory.fetchBrands();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'Brand & Category',
        body: _buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        retour: 1,
        context: context,
        title: 'Brand & Category',
        body: _buildBody(),
      );
    }
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 15),
            SizedBox(
              width: 300.0,
              height: 60.0,
              child: Stack(
                children: [
                  Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  AnimatedAlign(
                    alignment: Alignment(isCategorySelected ? -1 : 1, 0),
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: 150.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Constants.color1,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategorySelected = true;
                        _fetchData();
                      });
                    },
                    child: Align(
                      alignment: Alignment(-1, 0),
                      child: Container(
                        width: 150.0,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: isCategorySelected
                                ? Colors.white
                                : Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCategorySelected = false;
                        _fetchData();
                      });
                    },
                    child: Align(
                      alignment: Alignment(1, 0),
                      child: Container(
                        width: 150.0,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          'Brands',
                          style: TextStyle(
                            color: isCategorySelected
                                ? Colors.black54
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 10),
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
                builder: (context) => isCategorySelected
                    ? BottomSheetAddCategory()
                    : BottomSheetAddBrand(),
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
    if ((isCategorySelected && categories.isEmpty) ||
        (!isCategorySelected && brands.isEmpty)) {
      return Center(
        child: Image.asset('assets/images/nothing.jpg'),
      );
    } else {
      return ListView.builder(
        itemCount: isCategorySelected ? categories.length : brands.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _buildEntityCard(
              context,
              isCategorySelected ? categories[index] : brands[index],
            ),
          );
        },
      );
    }
  }

  Widget _buildEntityCard(BuildContext context, dynamic entity) {
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
          height: 50,
          child: Slidable(
            key: ValueKey(entity.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _editEntity(entity),
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
                  onPressed: (context) => deleteBottom(entity),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(
                Icons.category,
                color: Constants.color5,
              ),
              title: Text(
                isCategorySelected ? entity.category : entity.name,
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

  void _editEntity(dynamic entity) {
    if (isCategorySelected) {
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetEditCategory(category: entity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
      );
    } else {
      showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetEditBrand(brand: entity),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
      );
    }
  }

  Future<void> _deleteEntity(dynamic entity) async {
    try {
      if (isCategorySelected) {
        await ServiceBrandCategory.deleteCategory(entity.id);
        categories.removeWhere((category) => category.id == entity.id);
      } else {
        await ServiceBrandCategory.deleteBrand(entity.id);
        brands.removeWhere((brand) => brand.id == entity.id);
      }
      setState(() {});
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text(" Deleted successfully"),
        description: Text(""),
      ).show(context);
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("Failed to delete"),
        description: Text(""),
      ).show(context);
    }
  }

  void deleteBottom(dynamic entity) {
    String tit = '';
    if (isCategorySelected) {
      tit = 'Delete Category';
    } else {
      tit = 'Delete Brand';
    }
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: Text(
        tit,
        style:
            const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: Text(
        "Are you sure, You want to $tit ...",
        style: const TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          _deleteEntity(entity);
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
