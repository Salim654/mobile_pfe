import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_awesome_bottom_sheet/flutter_awesome_bottom_sheet.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:mobile_pfe/Utils/settings.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/Models/Product.dart';
import 'package:mobile_pfe/Services/ServiceProduct.dart';
import 'package:mobile_pfe/Widgets/BottomSheetAddProduct.dart';
import 'package:mobile_pfe/Widgets/BottomSheetDetailsProduct.dart';
import 'package:mobile_pfe/Widgets/BottomSheetEditProduct.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final AwesomeBottomSheet _awesomeBottomSheet = AwesomeBottomSheet();
  late List<Product> products = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductsForUser();
  }

  void _fetchProductsForUser() async {
    try {
      List<Product> userProducts = await ServiceProduct.getProductsForUser();
      setState(() {
        products = userProducts;
      });
    } catch (e) {
      Constants.showSnackBar(context, 'Failed to load products', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && MediaQuery.of(context).size.width > 600) {
      return Settings.buildLayout(
        title: 'Products',
        body: _buildBody(),
      );
    } else {
      return Settings.buildMobileLayout(
        context: context,
        retour: 1,
        title: 'Products',
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
                builder: (context) => BottomSheetAddProduct(),
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
    if (products.isEmpty) {
      return Center(
        child: Image.asset('assets/images/nothing.jpg'),
      );
    } else {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: _buildProductCard(context, products[index]),
          );
        },
      );
    }
  }

  Widget _buildProductCard(BuildContext context, Product product) {
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
            key: ValueKey(product.id),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _detailsProduct(product),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.info,
                ),
                SlidableAction(
                  borderRadius: const BorderRadius.only(),
                  padding: const EdgeInsets.all(2.0),
                  onPressed: (context) => _editProduct(product),
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
                  onPressed: (context) => deleteBottom(product),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Constants.color5),
              title: Text(
                product.designation,
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

  void _editProduct(Product product) {
    Map<String, dynamic> productData = {
      'id': product.id,
      'reference': product.reference,
      'designation': product.designation,
      'category_id': product.categoryId,
      'brand_id': product.brandId,
      'price': product.price,
      'tva_id': product.tvaId,
    };
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetEditProduct(productData: productData),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await ServiceProduct.deleteProduct(product.id);
      MotionToast.success(
        width: 300,
        height: 50,
        title: Text("Product deleted successfully"),
        description: Text(""),
      ).show(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsPage(),
        ),
      );
    } catch (e) {
      MotionToast.error(
        width: 300,
        height: 50,
        title: Text("failed to  delete Product"),
        description: Text(""),
      ).show(context);
    }
  }

  void deleteBottom(Product product) {
    _awesomeBottomSheet.show(
      context: context,
      icon: Icons.delete,
      title: const Text(
        "Delete Product",
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      description: const Text(
        "Are you sure, You want to Delete Product...",
        style: TextStyle(fontFamily: 'Roboto'),
      ),
      color: CustomSheetColor(
        mainColor: Constants.color1,
        accentColor: Constants.color3,
        iconColor: Colors.white,
      ),
      positive: AwesomeSheetAction(
        onPressed: () {
          _deleteProduct(product);
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

  void _detailsProduct(Product product) {
    Map<String, dynamic> productData = {
      'id': product.id,
      'reference': product.reference,
      'designation': product.designation,
      'category_id': product.categoryId,
      'brand_id': product.brandId,
      'price': product.price,
      'tva_id': product.tvaId,
    };
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => BottomSheetDetailsProduct(idProduct: product.id),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
    );
  }
}
