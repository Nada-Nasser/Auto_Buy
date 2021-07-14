import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'expenses_tracker_bloc.dart';

class InvoicesScreen extends StatelessWidget {
  final List<Invoice> invoices;

  const InvoicesScreen({Key key, @required this.invoices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = _buildContent();

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: content.length,
        itemBuilder: (BuildContext context, int index) {
          return content[index];
        },
      ),
    );
  }

  List<Widget> _buildContent() {
    print("_buildContent INVOICES");
    List<Widget> w = [];
    for (int i = 0; i < invoices.length; i++) {
      w.add(OneInvoiceTile(invoice: invoices[i], index: i));
      w.add(SizedBox(
        height: 20,
      ));
    }
    return w;
  }

  factory InvoicesScreen.withSampleData(BuildContext context) {
    return InvoicesScreen(
      invoices: _fetchInvoices(context),
    );
  }

  static List<Invoice> _fetchInvoices(BuildContext context) {
    final bloc = Provider.of<ExpensesTrackerBloc>(context, listen: false);
    return bloc.invoices;
  }
}

class Invoice {
  final List<InvoiceEntry> entries;
  final double totalPrice;
  final DateTime dateTime;

  Invoice(this.totalPrice, this.dateTime, this.entries);
}

class InvoiceEntry {
  final String name;
  final double price;
  final int quantity;

  InvoiceEntry(this.name, this.price, this.quantity);
}

class OneInvoiceTile extends StatelessWidget {
  final Invoice invoice;
  final int index;

  const OneInvoiceTile({Key key, @required this.invoice, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecorationNoBorders(),
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
      // color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order ${index + 1}", style: TextStyle(fontSize: 18.0)),
                Text(
                    "${invoice.dateTime.day}/${invoice.dateTime.month}/${invoice.dateTime.year}",
                    style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Table(
            border: TableBorder.all(
              color: Colors.indigo,
              style: BorderStyle.solid,
              width: 2,
            ),
            children: _buildChildren(),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Price", style: TextStyle(fontSize: 18.0)),
                Text("${invoice.totalPrice} EGP",
                    style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildChildren() {
    List<TableRow> rows = [];

    TableRow r = TableRow(children: [
      Container(
        color: Colors.indigo[100],
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            'Products',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ]),
      ),
      Container(
        color: Colors.indigo[100],
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            'Quantities',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ]),
      ),
      Container(
        color: Colors.indigo[100],
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            'Price',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ]),
      ),
    ]);
    rows.add(r);

    for (int i = 0; i < invoice.entries.length; i++) {
      TableRow r = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${invoice.entries[i].name}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${invoice.entries[i].quantity}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${invoice.entries[i].price}',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ]);
      rows.add(r);
    }

    return rows;
  }

  BoxDecoration _boxDecorationNoBorders() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(1.0, 1.0), //(x,y)
          blurRadius: 2,
        ),
      ],
    );
  }
}

/*
*           order#1     - Date
* product_Name  -  quantity  -  price
* product_Name  -  quantity  -  price
* product_Name  -  quantity  -  price
*           Total Price      -   xxx
* ------------------------------------
* order#2
* product_Name  -  quantity  -  price
* product_Name  -  quantity  -  price
* product_Name  -  quantity  -  price
* Total Price = xxx
* ------------------------------------
* * */
