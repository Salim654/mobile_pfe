import 'package:flutter/material.dart';
import 'package:mobile_pfe/Services/ServiceFacture.dart';

class ClasseViewInvoice extends StatelessWidget {
  final int idfact;

  ClasseViewInvoice({required this.idfact});

  Future<Map<String, dynamic>?> fetchInvoiceDetails() async {
    return await ServiceFacture.fetchFactureDetails(idfact);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchInvoiceDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Center(
              child: Text('Failed to load invoice details'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Invoice'),
            ),
            body: Center(
              child: Text('No invoice details available'),
            ),
          );
        }

        final factureDetails = snapshot.data!;
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

        final tableData = produits.map<TableRow>((product) {
          final productData = product['product'];
          final quantity = (product['quantity'] as num).toInt();
          final unitPrice = (productData['price'] as num).toDouble();
          final discount = (product['discount'] as num).toDouble();
          final unitTva = (productData['tva'] as num).toDouble();
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
            factureitemtaxvaluetype =
                (factureitemtax['value_type'] as num).toInt();

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

          print(total);

          //double
          //total = pricehorstaxe + tvaamount - discountAmount;

          totsdiscount += discountAmount;

          if (discount != 0) {
            double newhorsTaxe = pricehorstaxe - discountAmount;
            totshorstaxe += newhorsTaxe;
          } else {
            totshorstaxe += pricehorstaxe;
          }

          fullpricehorstaxe += pricehorstaxe;
          facturetotalDiscountamount += discountAmount;
          totaltva += tvaamount;

          return TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(productData['designation'],
                  style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(quantity.toString(), style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('${unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('${discount.toStringAsFixed(2)} %',
                  style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(displayxe, style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('${unitTva.toStringAsFixed(2)} %',
                  style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                  '${(pricehorstaxe - discountAmount).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 5)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('${total.toStringAsFixed(3)}',
                  style: TextStyle(fontSize: 5)),
            ),
          ]);
        }).toList();

        final totalBeforeDiscount =
            fullpricehorstaxe + totaltva - facturetotalDiscountamount;
        final factureDiscountAmount =
            totalBeforeDiscount * (facturediscount / 100);
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
          fulldiscou = totshorstaxe * (facturediscount / 100) +
              facturetotalDiscountamount;
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

        return Scaffold(
          appBar: AppBar(
            title: Text(invoiceReference),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/icon.png',
                        height: 48, width: 48),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(org,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        Text(addorg, style: TextStyle(fontSize: 8)),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tit,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold)),
                        Text(invoiceReference,
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.bold)),
                        Text('Due  $invoiceDate',
                            style: TextStyle(fontSize: 8)),
                        Text('Due Date: $dueDate',
                            style: TextStyle(fontSize: 8)),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Text(
                  '$tit for :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  clname,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  'Adresse : $addclient',
                  style: TextStyle(
                    fontSize: 10.0,
                  ),
                ),
                Divider(),
                Text('Invoice Discount: $facturediscount %',
                    style: TextStyle(fontSize: 8)),
                Divider(),
                SizedBox(height: 10),
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: tableHeaders
                          .map((header) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  header,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 5),
                                ),
                              ))
                          .toList(),
                    ),
                    ...tableData,
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            'Full Total Hors Taxe: ${totshorstaxe.toStringAsFixed(3)}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('Total TVA: ${newTotalTva.toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 9)),
                        Text('Total Discount: ${fulldiscou.toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 9)),
                        (facturetax != null)
                            ? (facturetaxvaluetype == 0)
                                ? Text(
                                    '$nameTaxe: ${facturetaxvalue.toStringAsFixed(2)} %',
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    '$nameTaxe:  ${facturetaxvalue.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                            : Text(''),
                        Text(
                            'Total: ${totalAfterFactureDiscount.toStringAsFixed(3)}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
