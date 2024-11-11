import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buttons_flutter/buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobile_pfe/Models/ProductD.dart';
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:mobile_pfe/services/ServiceProduct.dart';
import 'package:pretty_animated_buttons/configs/pkg_colors.dart';

class BottomSheetDetailsProduct extends StatelessWidget {
  final int idProduct;

  BottomSheetDetailsProduct({required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductD>(
      future: ServiceProduct.detailsProduct(idProduct),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: 370, child: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError || snapshot.data == null) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                'Failed to load product details.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          ProductD product = snapshot.data!;
          return ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16.0)),
            child: Container(
              height: 370,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: Constants.color3,
                        fontFamily: 'Roboto',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow('Reference :  ', product.reference),
                  const Divider(
                    color: Constants.color1,
                  ),
                  _buildDetailRow('Designation :  ', product.designation),
                  const Divider(
                    color: Constants.color1,
                  ),
                  _buildDetailRow(
                      'Category :  ', product.categoryId.toString()),
                  const Divider(
                    color: Constants.color1,
                  ),
                  _buildDetailRow('Brand :  ', product.brandId.toString()),
                  const Divider(
                    color: Constants.color1,
                  ),
                  _buildDetailRow('Price :  ', '${product.price}'),
                  const Divider(
                    color: Constants.color1,
                  ),
                  _buildDetailRow('TVA :  ', '${product.tvaId} %'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Button(
                            borderRadius: 10,
                            margin: EdgeInsets.all(8.0),
                            bgColor: Constants.color1,
                            onPressed: () {
                              Navigator.pop(context);
                              // some method calls
                            },
                            child: const Center(
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                  color: kWhite,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDetailRow(String label, String data) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: Constants.color4,
          ),
        ),
        Expanded(
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500, // Medium
              fontFamily: 'Roboto',
              color: Constants.color4,
            ),
          ),
        ),
      ],
    );
  }
}
