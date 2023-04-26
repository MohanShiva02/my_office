import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_office/PR/invoice/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
// import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';
import '../image_saving/user.dart';
import '../model/customer.dart';
import '../model/invoice.dart';
import '../model/supplier.dart';
import '../utils.dart';

double total = 0;

class PdfInvoiceApi {
  static Future<File> generate(
      Invoice invoice,
      // User user,
      Uint8List pic) async {
    final pdf = Document();
    var assetImage = pw.MemoryImage(
        (await rootBundle.load('assets/logo1.png')).buffer.asUint8List());

    final image = pw.MemoryImage(pic);

    // var asset qrImage = pw.MemoryImage(
    //     (await rootBundle.load('assets/qr_pic.jpg')).buffer.asUint8List());

    // var assetImage = pw.MemoryImage(File(user.imagePath).readAsBytesSync());

    pdf.addPage(
      MultiPage(
        header: (context) => builderLogo(assetImage, invoice.info, invoice),
        build: (context) => [
          // builderLogo(assetImage,invoice.info,invoice),
          buildHeader(invoice),
          SizedBox(height: 2.0 * PdfPageFormat.cm),
          // buildTitle(invoice),
          buildInvoice(invoice),
          Divider(color: const PdfColor.fromInt(0xffBEBEBE)),
          buildTotal(invoice),
          Text('Scan to Pay', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
          builderQR(image),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTermsAndConditions(invoice),
        ],
        footer: (context) => buildFooter(invoice),
      ),
    );

    return PdfApi.saveDocument(name: '${invoice.fileName}.pdf', pdf: pdf);
  }

  static Widget builderLogo(
          MemoryImage img, InvoiceInfo info, Invoice invoice) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: -30),
                height: 100, //150,
                width: 100, //150,
                child: pw.Image(img),
              ),
              Container(
                margin: const EdgeInsets.only(top: -20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      invoice.docType,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: PdfColors.red500,
                        fontSize: 20.0,
                      ),
                    ),
                    invoice.docType == "QUOTATION"
                        ? Text(
                            "#EST${invoice.cat}-${Utils.formatDummyDate(info.date)}${invoice.quotNo}",
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          )
                        : Text(
                            "#INV${invoice.cat}-${Utils.formatDummyDate(info.date)}${invoice.quotNo}",
                            style: const TextStyle(fontSize: 10),
                          ),
                    Text(
                      "Date :  ${Utils.formatDate(info.date)}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  static builderQR(pw.MemoryImage img) {
    // final qr = UPIPaymentQRCode(upiDetails: upiDetails,size: 100,);
    return Container(
      margin: const EdgeInsets.only(left: -7),
      height: 100, //150,
      width: 100, //150,
      child: pw.Image(img),
    );
  }

  static Widget buildHeader(Invoice invoice) => Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildSupplierAddress(invoice.supplier),
          SizedBox(width: 3.5 * PdfPageFormat.cm),
          buildCustomerAddress(invoice.customer),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bill To :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),),
                  SizedBox(width: 0.3 * PdfPageFormat.cm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: PdfColors.white,
                        width: 150,
                        child: Text(customer.name,
                          style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        color: PdfColors.white,
                        width: 150,
                        child: Text(
                          customer.street,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      Container(
                        color: PdfColors.white,
                        width: 150,
                        child: Text(
                          customer.address,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      Container(
                        color: PdfColors.white,
                        width: 150,
                        child: Text(
                          "Phone: ${customer.phone}",
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              customer.gst.toString().isNotEmpty ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GSTIN :',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),
                  SizedBox(width: 0.3 * PdfPageFormat.cm),
                  Text(customer.gst,
                    style: const TextStyle(fontSize: 10.0),
                  )
                ]
              ) : SizedBox(),
            ]
          ),
  );

  ///invoiceInfo
  // static Widget buildInvoiceInfo(InvoiceInfo info) {
  //
  //   final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
  //   final titles = <String>[
  //     'Invoice Number:',
  //     'Invoice Date:',
  //     'Payment Terms:',
  //     'Due Date:',
  //   ];
  //   final data = <String>[
  //     info.number,
  //     Utils.formatDate(info.date),
  //     paymentTerms,
  //     Utils.formatDate(info.dueDate),
  //   ];
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: List.generate(titles.length, (index) {
  //       final title = titles[index];
  //       final value = data[index];
  //
  //       return buildText(title: title, value: value, width: 200);
  //     }),
  //   );
  // }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Street : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),
                Text('1/1 RR Garden,Zamin Muthur,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),

                Text('Pollachi, Coimbatore,\nTamilnadu - 642-005,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),

                Text('+91 7708630275,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),

                Text('cs@onwords.in,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Website : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),

                Text('www.onwords.in,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GSTIN : ',style: TextStyle(fontSize: 10.0,fontWeight: FontWeight.bold),),

                Text('33BTUPN5784J1ZT,',
                    style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10)
                )
              ]
          ),




          ///
          // Text(supplier.street),
          // Text(supplier.address),
          // Text("Phone: ${supplier.phone}"),
          // Text("Email: ${supplier.email}"),
          // Text("Website: ${supplier.website}"),
          // SizedBox(height: 0.5 * PdfPageFormat.cm),
          // Text("GSTIN: ${supplier.gst}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
        ],
      );

  ///doctype
  // static Widget buildTitle(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       invoice.docType,
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //     SizedBox(height: 0.4 * PdfPageFormat.cm),
  //     // Text(invoice.info.description),
  //     // SizedBox(height: 0.8 * PdfPageFormat.cm),
  //   ],
  // );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Item & Description', 'Quantity', 'Unit Price', 'Total'];

    final data = invoice.items.map((item) {
      // final total = item.unitPrice * item.quantity * ( 1 + item.vat);
      final total = item.unitPrice * item.quantity * (1 + 0);
      return [
        item.description,
        // Utils.formatDate(item.date),
        '${item.quantity}',
        '${item.unitPrice}',
        // '${0} %',
        // '${item.vat} %',
        (total.toStringAsFixed(2)),
      ];
    }).toList();

    return Table.fromTextArray(
        headers: headers,
        data: data,
        cellStyle: const TextStyle(fontSize: 9),
        border: const TableBorder(
            // left: BorderSide(),
            // right: BorderSide(),
            // top: BorderSide(),
            // bottom: BorderSide(),
            // horizontalInside: BorderSide(),
            // verticalInside: BorderSide(),
            ),
        headerStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10, color: PdfColors.white),
        headerDecoration: const BoxDecoration(color: PdfColors.red700),
        cellHeight: 25,
        // headerAlignments: {
        //   0: Alignment.center,
        //   1: Alignment.center,
        //   2: Alignment.center,
        //   3: Alignment.center,
        //   4: Alignment.center,
        //   5: Alignment.center,
        // },
        columnWidths: {
          0: const FixedColumnWidth(230.0), // fixed to 100 width
          1: const FlexColumnWidth(50.0),
          2: const FixedColumnWidth(80.0), //fixed to 100 width
          3: const FixedColumnWidth(80.0), //fixed to 100 width
        },
        cellAlignments: {
          0: Alignment.centerLeft,
          1: Alignment.centerRight,
          2: Alignment.centerRight,
          3: Alignment.centerRight,
          4: Alignment.centerRight,
          5: Alignment.centerRight,
        },
        oddRowDecoration: const BoxDecoration(color: PdfColors.red50));
  }

  static Widget buildBankDetails(Invoice invoice) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Acc.Name: Onwords",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),
            Text(
              "Bank : HDFC",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),
            Text(
              "Acc.No: 5020-0065-403656",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),
            Text(
              "IFSC Code: HDFC0000787",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),
            Text(
              "UPI : onwordspay@ybl",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
            ),

            // Text("Acc.Name: ${invoice.accountName}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
            // Text("Acc.No: ${invoice.accountNumber}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
            // Text("IFSC Code: ${invoice.ifscCode}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
            // Text("Bank : ${invoice.bankName}", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15.0)),
          ]);

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    const vatPercent = 0.09;
    final vat = netTotal * vatPercent;
    final iVat = netTotal * vatPercent;
    final discount = invoice.discountAmount;
    // final labAndIns = invoice.labAndInstall;
    // final total = netTotal + vat + iVat + labAndIns;

    // final total = invoice.gstNeed ? netTotal + vat + iVat : netTotal;

    // final total = invoice.gstNeed?netTotal + vat + iVat + labAndIns: netTotal+ labAndIns;
    total = invoice.gstNeed
        ? netTotal + vat + iVat - discount
        : netTotal - discount;
    // val = invoice.gstNeed
    //     ? netTotal + vat + iVat - discount
    //     : netTotal - discount;
    final advanceAmt = invoice.advancePaid;
    final balanceAmt = total - advanceAmt;
    final discounts = invoice.discountAmount;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          buildBankDetails(invoice),
          Spacer(flex: 3),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildText(
                  title: 'Sub total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                invoice.gstNeed
                    ? buildText(
                        title: 'CGST ${vatPercent * 100} %',
                        value: Utils.formatPrice(vat),
                        unite: true,
                      )
                    : Text(""),
                invoice.gstNeed
                    ? buildText(
                        title: 'IGST ${vatPercent * 100} %',
                        value: Utils.formatPrice(vat),
                        unite: true,
                      )
                    : Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                // (invoice.docType == "INVOICE")||(invoice.labNeed)?buildText(
                //   title: 'LABOUR & INSTALLATION ',
                //   titleStyle: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.normal,
                //   ),
                //   value: Utils.formatPrice(labAndIns.toDouble()),
                //   unite: true,
                // )
                //     :Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                // buildText(
                //   title: 'Grand total',
                //   value: Utils.formatPrice(netTotal),
                //   unite: true,
                // ),
                // Divider(),
                discounts != 0
                    ? buildText(
                        title: 'Discount Amount ',
                        titleStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                        value: Utils.formatPrice(discount.toDouble()),
                        unite: true,
                      )
                    : Text(""),
                SizedBox(height: 1 * PdfPageFormat.mm),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: PdfColor.fromInt(0xffEBECF0),
                      borderRadius: BorderRadius.all(pw.Radius.circular(08))),
                  child: buildText(
                    title: 'Grand total ',
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    value: Utils.formatPrice(total),
                    unite: true,
                  ),
                ),

                SizedBox(height: 2 * PdfPageFormat.mm),

                advanceAmt != 0
                    ? buildText(
                        title: 'Advance Paid ',
                        titleStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                        value: Utils.formatPrice(advanceAmt.toDouble()),
                        unite: true,
                      )
                    : Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                advanceAmt != 0
                    ? buildText(
                        title: 'Balance Amount',
                        titleStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        value: Utils.formatPrice(balanceAmt.toDouble()),
                        unite: true,
                      )
                    : Text(""),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 2, color: PdfColors.grey500),
                // SizedBox(height: 0.5 * PdfPageFormat.mm),
                // Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // static Widget buildFooter(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.center,
  //   children: [
  //     SizedBox(height: 0.5 * PdfPageFormat.cm),
  //     invoice.docType == "QUOTATION"?
  //     ((invoice.gstNeed==true)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of Labour & Installation ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
  //     ((invoice.gstNeed==false)&&(invoice.labNeed == true))?Text ("*All Amount mentioned are exclusive of GST ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
  //     ((invoice.gstNeed==false)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of GST & Labour & Installation "):Text(""):Text(""),
  //     // invoice.docType == "QUOTATION"? invoice.gstNeed ?Text("*All Amount mentioned are exclusive of Labour & Installation ",
  //     //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text ("*All Amount mentioned are exclusive of GST, Labour & Installation ",
  //     //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text(""),
  //     Divider(),
  //     SizedBox(height: 2 * PdfPageFormat.mm),
  //     buildSimpleText(title: 'Address', value: "${invoice.supplier.street},${invoice.supplier.address}"),
  //     SizedBox(height: 1 * PdfPageFormat.mm),
  //     // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
  //   ],
  // );
  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          invoice.docType == "QUOTATION"
              ? ((invoice.gstNeed == false))
                  ? Text("*All Amount mentioned are exclusive of GST ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0))
                  : Text('')
              : Text(''),

          // ((invoice.gstNeed==true)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of Labour & Installation ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
          // ((invoice.gstNeed==false)&&(invoice.labNeed == true))?Text ("*All Amount mentioned are exclusive of GST ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):
          // ((invoice.gstNeed==false)&&(invoice.labNeed == false))?Text("*All Amount mentioned are exclusive of GST & Labour & Installation "):Text(""):Text(""),

          // invoice.docType == "QUOTATION"? invoice.gstNeed ?Text("*All Amount mentioned are exclusive of Labour & Installation ",
          //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text ("*All Amount mentioned are exclusive of GST, Labour & Installation ",
          //     style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)):Text(""),
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: '', value: "In Sync, with Smart World"),
          // buildSimpleText(title: 'Address', value: "${invoice.supplier.street},${invoice.supplier.address}"),
          SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: style),
          ),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static buildTermsAndConditions(
    Invoice invoice,
  ) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          invoice.cat == 'GA'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text("Terms & Conditions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(
                          "It is recommended by the Company to use INVERTER (UPS) of 1KVA for our control modules and the"
                          "Same shall be in Client's  Scope .",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "1. Site Preparation including fabricator,carpentry, welder, civil and Masonry work.\n"
                          "2. Provision for suitable Wiring, Electricity Supply with suitable plugs, socket etc.\n"
                          "3. Cable identification and Termination of the cables laid by Client's Contractor on the Distribution Board etc. Dedicated Earth Connection required.\n"
                          "4. Wire cost and material cost, other than motor and control box which comes within the package.\n"
                          "5. Company is not responsible for Defects caused due to non-installation of motion sensors.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text(
                          "*** Any additional work on behalf of client  will be quoted extra separately ***",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text("Warranty :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "Service and replacement warranty will be provided for the products up to 1 year from the date of installation.\n"
                          "The warranty will  cover the failures for the following reasons:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "a. Defects caused at the time of installation\n"
                          "b. Defects caused by manufacturer\n"
                          "c. Defects caused by Application / Programming error.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text(
                          "The warranty will not cover the failures caused due to the following reasons :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "a. Damage or defect caused by transportation, accident, misuse, lack of maintenance, improper usage or negligence on the part of Client\n"
                          "b. Wilful damage or negligence, normal wear and tear\n"
                          "c. Abuse or misuse of equipment/product\n"
                          "d. Damage or defect caused by  earthquake  or other similar natural disasters\n"
                          "e. Damage or defect caused by alteration, modification, conversion not authorised by Company in writing\n"
                          "f. Repairs carried out by personnel other than Company's authorised service personnel's\n"
                          "g. Defects or damages due to any other external means or causes are not covered under warranty",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text("Payment :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "There should not be any negotiation in final payment before handing over the Remote and other accessories.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text("DELIVERY PERIOD :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "1-2 weeks after receipt of commercially & technically clear order with advance of 50%",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text("Cancellation of Order :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "If the Order placed is cancelled by Client then the cancellation charges of 30% of the Order value shall be charged as  a Termination fee. ",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                      Text("Scope of Work :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text(
                          "1. Instruction and Supervision of conduit work at the initial level and there after completion of conduit work and wiring  work  final inspection will be done.\n"
                          "2. Once the contractor finishes the Electrical work and civil work, we will start Installation of Gate Automation Modules.\n"
                          "c. Abuse or misuse of equipment/product\n"
                          "d. Damage or defect caused by  earthquake  or other similar natural disasters\n"
                          "e. Damage or defect caused by alteration, modification, conversion not authorised by Company in writing\n"
                          "3. Programming of all the above mentioned components.\n"
                          "4. Delivery to the client and mobile application integration if needed.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 8)),
                    ])
              : invoice.cat == "SH"
                  ? Text('SMART HOME')
                  : Container(),
          Container(margin: EdgeInsets.only(top: 20,left: 80,right: 80),height: 0.5,color: PdfColors.black),
        ]);
  }
}
