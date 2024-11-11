import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'file_handle_api.dart';

class PdfInvoiceApi {
  static Future<pw.Font> loadFont() async {
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final font = pw.Font.ttf(fontData);
    return font;
  }

  static Future<File> generate(PdfColor color, pw.Font fontFamily,
      Map<String, dynamic> factureDetails) async {
    final pdf = pw.Document();
    final iconImage =
        (await rootBundle.load('assets/images/icon.png')).buffer.asUint8List();
    final facture = factureDetails['facture'];
    final produits = factureDetails['produits'];
    final invoiceReference = facture['reference'];
    final organization = facture['organization'];

    final invoiceDate = facture['date'];
    final clientName = facture['client'];
    final clientad = facture['clientad'];
    final orgad = facture['organizationad'];
    final dueDate = facture['due_date'];
    final facturediscount = (facture['discount'] as num).toDouble();
    final facturetax = facture['taxe'];
    double facturetaxvalue = 0;
    int facturetaxvaluetype = 0;
    String nameTaxe = '';
    double totstaxefix = 0;

    if (facturetax != null) {
      facturetaxvalue = (facturetax['value'] as num).toDouble();
      facturetaxvaluetype = (facturetax['value_type'] as num).toInt();
      nameTaxe = facturetax['short_name'] as String;
    }

    double totaltva = 0;
    double fullpricehorstaxe = 0;
    double facturetotalDiscountamount = 0;
    double totshorstaxe = 0;
    double totsdiscount = 0;

    final tableHeaders = [
      'Description',
      'Quantity',
      'Unit Price',
      'Discount',
      'XE',
      'TVA',
      'Price HT',
      'Total'
    ];

    final tableData = produits.map((product) {
      final productData = product['product'];
      final quantity = (product['quantity'] as num).toDouble();
      final unitPrice = (productData['price'] as num).toDouble();
      final discount = (product['discount'] as num).toDouble();
      final unitTva = (productData['tva'] as num).toDouble();
      // Calculate product-level discount
      final discountAmount = (unitPrice * (discount / 100)) * quantity;
      final pricehorstaxe = unitPrice * quantity;
      final factureitemtax = product['taxe'];
      double factureitemtaxvalue = 0;
      int factureitemtaxvaluetype = 0;
      String nameitemTaxe = '';
      double tvaamount = 0;
      double total = 0;
      tvaamount =
          ((unitPrice - (unitPrice * (discount / 100))) * (unitTva / 100)) *
              quantity;

      String displayxe = '0.00';
      if (factureitemtax != null) {
        factureitemtaxvalue = (factureitemtax['value'] as num).toDouble();
        factureitemtaxvaluetype = (factureitemtax['value_type'] as num).toInt();

        if (factureitemtaxvaluetype == 0) {
          tvaamount += (pricehorstaxe + tvaamount - discountAmount) *
              (factureitemtaxvalue / 100);
          total = pricehorstaxe + tvaamount - discountAmount;
          displayxe = '$factureitemtaxvalue %';
        } else {
          tvaamount += (factureitemtaxvalue * (unitTva / 100) * quantity) +
              (factureitemtaxvalue * quantity);
          total = pricehorstaxe + tvaamount - discountAmount;
          totstaxefix += (factureitemtaxvalue * quantity) +
              (factureitemtaxvalue * (unitTva / 100) * quantity);
          displayxe = factureitemtaxvalue.toStringAsFixed(2);
        }
      } else {
        total = pricehorstaxe + tvaamount - discountAmount;
      }
      // Calculate totshorstaxe
      if (discount != 0) {
        double newhorsTaxe = pricehorstaxe - discountAmount;
        totshorstaxe += newhorsTaxe;
      } else {
        totshorstaxe += pricehorstaxe;
      }

      fullpricehorstaxe += pricehorstaxe;
      facturetotalDiscountamount += discountAmount;
      totaltva += tvaamount;

      return [
        productData['designation'] as String,
        quantity.toString(),
        unitPrice.toStringAsFixed(2),
        '${discount.toStringAsFixed(2)} %',
        displayxe,
        '${unitTva.toStringAsFixed(2)} %',
        (pricehorstaxe - discountAmount).toStringAsFixed(2),
        total.toStringAsFixed(3),
      ];
    }).toList();

    final totalBeforeDiscount =
        fullpricehorstaxe + totaltva - facturetotalDiscountamount;
    final factureDiscountAmount = totalBeforeDiscount * (facturediscount / 100);
    double totalAfterFactureDiscount = 0;
    totalAfterFactureDiscount = totalBeforeDiscount -
        factureDiscountAmount +
        (totstaxefix * facturediscount / 100);

    final newTotalTva = totaltva -
        (totaltva * facturediscount / 100) +
        (totstaxefix * facturediscount / 100);
    //print((totaltva * facturediscount / 100));

    double fulldiscou = 0;
    totsdiscount += factureDiscountAmount;
    if (facturediscount != 0) {
      fulldiscou =
          totshorstaxe * (facturediscount / 100) + facturetotalDiscountamount;
    } else {
      fulldiscou = facturetotalDiscountamount;
    }
    if (facturetax != null) {
      if (facturetaxvaluetype == 0) {
        totalAfterFactureDiscount +=
            totalAfterFactureDiscount * (facturetaxvalue / 100) -
                (newTotalTva * (facturetaxvalue / 100));
      } else {
        totalAfterFactureDiscount += facturetaxvalue;
      }
    }

    List<List<String>> tab5 = transformToListOfStringLists(tableData);
    final typfact = facture['type'] as int;
    String tit = '';
    String clname = clientName;
    String org = organization;
    String addclient = clientad;
    String addorg = orgad;

    if (typfact == 0) {
      tit = 'Invoice';
    } else if (typfact == 1) {
      tit = 'Estimate';
    } else {
      String aux = clname;
      clname = org;
      org = aux;
      aux = addclient;
      addclient = addorg;
      addorg = aux;
      tit = 'Purchase Order';
    }

    pdf.addPage(pw.MultiPage(
      build: (context) {
        return [
          pw.Row(
            children: [
              pw.Image(
                pw.MemoryImage(iconImage),
                height: 72,
                width: 72,
              ),
              pw.SizedBox(width: 1 * PdfPageFormat.mm),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    org,
                    style: pw.TextStyle(
                      fontSize: 25.0,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    addorg,
                    style: pw.TextStyle(
                      fontSize: 15.0,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    tit,
                    style: pw.TextStyle(
                      fontSize: 17.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    invoiceReference,
                    style: pw.TextStyle(
                      fontSize: 15.0,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    'Date: $invoiceDate',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    'Due Date: $dueDate',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Divider(),
          pw.Text(
            '$tit for : ',
            style: pw.TextStyle(
              fontSize: 14.0,
              color: color,
              font: fontFamily,
            ),
          ),
          pw.Text(
            clname,
            style: pw.TextStyle(
              fontSize: 12.0,
              color: color,
              font: fontFamily,
            ),
          ),
          pw.Text(
            'Adresse : $addclient',
            style: pw.TextStyle(
              fontSize: 10.0,
              color: color,
              font: fontFamily,
            ),
          ),
          pw.Divider(),
          pw.Text(
            '$tit Discount: $facturediscount %',
            style: pw.TextStyle(
              fontSize: 14.0,
              color: color,
              font: fontFamily,
            ),
          ),
          pw.Divider(),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Table.fromTextArray(
            headers: tableHeaders,
            data: tab5,
            border: null,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontFamily,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30.0,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
            },
            cellStyle: pw.TextStyle(
              font: fontFamily,
            ),
          ),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Full Total Hors Taxe: ${totshorstaxe.toStringAsFixed(3)}',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    'Total TVA: ${newTotalTva.toStringAsFixed(3)}',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  pw.Text(
                    'Total Discount: ${fulldiscou.toStringAsFixed(3)}',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                  (facturetax != null)
                      ? (facturetaxvaluetype == 0)
                          ? pw.Text(
                              '$nameTaxe: ${facturetaxvalue.toStringAsFixed(2)} %',
                              style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                color: color,
                                font: fontFamily,
                              ),
                            )
                          : pw.Text(
                              '$nameTaxe:  ${facturetaxvalue.toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                fontSize: 14.0,
                                fontWeight: pw.FontWeight.bold,
                                color: color,
                                font: fontFamily,
                              ),
                            )
                      : pw.Text(''),
                  pw.Text(
                    'Total: ${totalAfterFactureDiscount.toStringAsFixed(3)}',
                    style: pw.TextStyle(
                      fontSize: 14.0,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                      font: fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ];
      },
    ));

    return FileHandleApi.saveDocument(name: '$invoiceReference.pdf', pdf: pdf);
  }

  static List<List<String>> transformToListOfStringLists(List<dynamic> list) {
    List<List<String>> result = [];

    for (var item in list) {
      if (item is List) {
        bool allStrings = item.every((element) => element is String);

        if (allStrings) {
          result.add(List<String>.from(item));
        }
      }
    }

    return result;
  }
}
