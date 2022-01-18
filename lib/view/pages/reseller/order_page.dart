import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:silkroute/constants/statusCodes.dart';
import 'package:silkroute/methods/helpers.dart';

import 'package:silkroute/methods/math.dart';
import 'package:silkroute/methods/payment_methods.dart';
import 'package:silkroute/methods/toast.dart';
import 'package:silkroute/model/services/OrderApi.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/flutter_dash.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class OrderPage extends StatefulWidget {
  const OrderPage({this.order});
  final dynamic order;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  dynamic orderDetails, bill, shiprocket;
  bool loading = true;

  dynamic price;
  int savings = 0, totalCost = 0;

  void loadPrice() {
    print("order: ${widget.order}");
    setState(() {
      shiprocket = widget.order['shiprocket'];
      shiprocket = [
        {
          "id": "ship_JKB7H65H99B",
          "weight": "5Kg",
          "returnDate": "12-13-13",
        }
      ];
      bill = widget.order['bill'];
      price = [
        {"title": "Total Value", "value": bill['totalValue']},
        {"title": "Discount", "value": bill['implicitDiscount']},
        {"title": "Coupon Discount", "value": bill['couponDiscount']},
        {"title": "Price After Discount", "value": bill['priceAfterDiscount']},
        {"title": "GST", "value": bill['gst']},
        {"title": "Logistics Cost", "value": bill['logistic']},
      ];

      totalCost = bill['totalCost'];

      savings = int.parse(
          (bill['totalValue'] - bill['priceAfterDiscount']).toString());
      loading = false;
    });
  }

  void loadOrder() {
    print("order: ${widget.order}");
    setState(() {
      orderDetails = widget.order;
    });
    loadPrice();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadOrder();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus.unfocus()},
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Navbar(),
        primary: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/1.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              //////////////////////////////
              ///                        ///
              ///         TopBar         ///
              ///                        ///
              //////////////////////////////

              TopBar(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: CustomScrollView(slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        loading
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF5B0D1B),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    // OrderPageTitle
                                    OrderPageTitle(orderDetails: orderDetails),
                                    // OrderStatus(orderDetails: {
                                    //   "status": widget.order["status"]
                                    // }),

                                    SizedBox(height: 10),

                                    OrderPriceDetails(
                                      invoiceNumber:
                                          orderDetails['invoiceNumber'],
                                      price: price,
                                      savings: savings,
                                      totalCost: totalCost,
                                    ),

                                    (shiprocket != null &&
                                            shiprocket.length > 0)
                                        ? PackageDetails(shiprocket: shiprocket)
                                        : SizedBox(height: 0),
                                    // CancelOrder(order: widget.order),
                                  ],
                                ),
                              ),
                      ]),
                    ),
                    SliverFillRemaining(
                        hasScrollBody: false, child: Container()),
                  ]),
                ),
              ),

              //////////////////////////////
              ///                        ///
              ///         Footer         ///
              ///                        ///
              //////////////////////////////
              Footer(),
            ],
          ),
        ),
        // bottomNavigationBar: Footer(),
      ),
    );
  }
}

class PackageDetails extends StatefulWidget {
  const PackageDetails({Key key, this.shiprocket}) : super(key: key);
  final dynamic shiprocket;

  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  dynamic shiprocket;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    shiprocket = widget.shiprocket;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "PACKAGES:",
              style: textStyle1(
                13,
                Color(0xFF811111),
                FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 5),
          (shiprocket == null || shiprocket.length == 0)
              ? Text(
                  "No Packages",
                  style: textStyle1(
                    13,
                    Colors.black54,
                    FontWeight.w500,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: shiprocket.length,
                  itemBuilder: (context, package_i) {
                    return PackageItem(shiprocket[package_i]);
                  },
                ),
        ],
      ),
    );
  }
}

class PackageItem extends StatefulWidget {
  const PackageItem(this.package, {Key key}) : super(key: key);
  final dynamic package;

  @override
  _PackageItemState createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool exp) {
            setState(() {
              isExpanded = !exp;
            });
          },
          expandedHeaderPadding: EdgeInsets.all(0),
          animationDuration: Duration(milliseconds: 500),
          children: [
            ExpansionPanel(
              backgroundColor: Colors.grey[200],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Shipment Id: ",
                            style: textStyle1(
                              10,
                              Colors.black87,
                              FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.package['id'],
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          Text(
                            "Weight: ",
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.package['weight'],
                            style: textStyle1(
                              10,
                              Colors.black54,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("timeline"),
                        Row(
                          children: <Widget>[
                            Text(
                              "Return before: ",
                              style: textStyle1(
                                10,
                                Colors.black54,
                                FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.package['returnDate'],
                              style: textStyle1(
                                10,
                                Colors.black54,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            color: Color(0xFF811111),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Details",
                                style: textStyle1(
                                  10,
                                  Colors.white,
                                  FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.right_chevron,
                                size: 15,
                                color: Colors.white,
                              ),
                              Icon(
                                CupertinoIcons.right_chevron,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPriceDetails extends StatefulWidget {
  OrderPriceDetails(
      {this.price, this.savings, this.totalCost, this.invoiceNumber});
  final dynamic price;
  final num savings, totalCost;
  final String invoiceNumber;
  @override
  _OrderPriceDetailsState createState() => _OrderPriceDetailsState();
}

class _OrderPriceDetailsState extends State<OrderPriceDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Id: ${widget.invoiceNumber}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "View Invoice",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.transparent,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: Colors.grey[700],
                        shadows: [
                          Shadow(color: Colors.grey[700], offset: Offset(0, -2))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          OrderPriceDetailsList(
              price: widget.price,
              savings: widget.savings,
              totalCost: widget.totalCost),
        ],
      ),
    );
  }
}

class OrderPriceDetailsList extends StatefulWidget {
  OrderPriceDetailsList({this.price, this.savings, this.totalCost});
  final dynamic price;
  final num savings;
  final num totalCost;
  @override
  _OrderPriceDetailsListState createState() => _OrderPriceDetailsListState();
}

class _OrderPriceDetailsListState extends State<OrderPriceDetailsList> {
  dynamic price;
  int savings = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    price = widget.price;
    savings = widget.savings;
    return Column(
      children: <Widget>[
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 6,
          padding: EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return PriceRow(
              title: price[index]['title'],
              value: ("₹" + (price[index]['value']).toString()).toString(),
            );
          },
        ),
        Dash(
          length: MediaQuery.of(context).size.width * 0.8,
          dashColor: Colors.grey[700],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: PriceRow(
            title: "Total Cost",
            value: "₹" + widget.totalCost.toString(),
          ),
        ),
        Dash(
          length: MediaQuery.of(context).size.width * 0.8,
          dashColor: Colors.grey[700],
        ),
        SizedBox(height: 10),
        (savings > 0)
            ? Text(
                ("You saved ₹" + savings.toString() + " on this order")
                    .toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Text(""),
      ],
    );
  }
}

class PriceRow extends StatefulWidget {
  const PriceRow({this.title, this.value});
  final String title, value;
  @override
  _PriceRowState createState() => _PriceRowState();
}

class _PriceRowState extends State<PriceRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          widget.title,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          widget.value,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color(0xFF5B0D1B),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatefulWidget {
  StarRating({this.orderDetails});
  final dynamic orderDetails;

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: 15,
      ),
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SmoothStarRating(
            starCount: 5,
            rating: double.parse(widget.orderDetails['rating'].toString()),
            color: Colors.orange,
            borderColor: Colors.black,
          ),
        ],
      ),
    );
  }
}

class OrderStatus extends StatefulWidget {
  const OrderStatus({this.itemDetails});
  final dynamic itemDetails;

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool isProfileExpanded = false, loading = true, cancelled = false;
  int index = 0;
  List<Icon> icons = [];

  dynamic itemDetails;
  var statuses = [
    "Order Placed",
    "Dispatched",
    "Out for Delivery",
    "Delivered"
  ];
  void loadVars() {
    setState(() {
      itemDetails = widget.itemDetails;
      if (itemDetails['customerStatus'] == "Return Requested") {
        cancelled = true;
      } else {
        index = statuses.indexOf(itemDetails['customerStatus']);
        for (int i = 0; i < index; i++) {
          icons.add(Icon(Icons.check));
        }
        icons.add(Icon(Icons.radio_button_checked, color: Colors.white));
        for (int i = index + 1; i < 4; i++) {
          icons.add(Icon(Icons.radio_button_checked));
        }
      }

      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadVars();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFF5B0D1B),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            decoration: BoxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    isProfileExpanded = cancelled ? false : !isExpanded;
                  });
                },
                expandedHeaderPadding: EdgeInsets.all(0),
                animationDuration: Duration(milliseconds: 500),
                children: [
                  ExpansionPanel(
                    backgroundColor: Colors.grey[200],
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.radio_button_checked,
                                size: 20, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              cancelled
                                  ? "Cancelled"
                                  : itemDetails['customerStatus'],
                              style: textStyle(15, Colors.grey[700]),
                            ),
                          ],
                        ),
                      );
                    },
                    body: ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 70,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            height: 170,
                            child: IconStepper(
                              enableNextPreviousButtons: false,
                              enableStepTapping: false,
                              stepColor: Colors.grey[400],
                              direction: Axis.vertical,
                              activeStepBorderColor: Colors.green,
                              activeStepBorderWidth: 1,
                              activeStepBorderPadding: 2.0,
                              lineLength: 20,
                              activeStep: index,
                              lineDotRadius: 2,
                              activeStepColor: Colors.green,
                              stepPadding: 0.0,
                              lineColor: Colors.grey[400],
                              stepRadius: 10,
                              icons: icons,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            height: 170,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 12),
                                Text("Order Placed",
                                    style: textStyle(12, Colors.black54)),
                                SizedBox(height: 25),
                                Text("Dispatched",
                                    style: textStyle(12, Colors.black54)),
                                SizedBox(height: 23),
                                Text("Out for Delivery",
                                    style: textStyle(12, Colors.black54)),
                                SizedBox(height: 23),
                                Text("Delivered",
                                    style: textStyle(12, Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isExpanded: isProfileExpanded,
                  ),
                ],
              ),
            ),
          );
  }
}

class OrderPageTitle extends StatefulWidget {
  OrderPageTitle({this.orderDetails});
  final dynamic orderDetails;
  @override
  _OrderPageTitleState createState() => _OrderPageTitleState();
}

class _OrderPageTitleState extends State<OrderPageTitle> {
  dynamic orderDetails, moreColor = true, loading = true, showReturn = false;
  List<bool> selected = [];
  int count = 0;
  void loadVars() {
    setState(() {
      orderDetails = widget.orderDetails;
      for (var x in orderDetails['items']) {
        selected.add(false);
      }
      loading = false;
    });
  }

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
    super.initState();
  }

  TextStyle infoStyle = textStyle1(
    10,
    Colors.black87,
    FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: Color(0xFF5B0D1B),
                  ),
                ),
              ],
            ),
          )
        : Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderDetails['items'].length,
                itemBuilder: (BuildContext context, int item_i) {
                  // if(orderDetails['items'][i]['returnPeriod'])
                  // implement add period to delivery return

                  return InkWell(
                    onLongPress: () {
                      if (count > 0) {
                        return;
                      }
                      setState(() {
                        selected[item_i] =
                            (selected[item_i] == true) ? false : true;
                        if (selected[item_i])
                          count++;
                        else
                          count--;
                      });
                    },
                    onTap: () {
                      if (count == 0) {
                        return;
                      }
                      setState(() {
                        selected[item_i] =
                            (selected[item_i] == true) ? false : true;
                        if (selected[item_i])
                          count++;
                        else
                          count--;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 8),
                      decoration: BoxDecoration(
                        color: (selected.length > item_i && selected[item_i])
                            ? Colors.grey[400]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      constraints: BoxConstraints(maxHeight: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              "assets/images/unnamed.png",
                              fit: BoxFit.contain,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    orderDetails["items"][item_i]['title'],
                                    style: textStyle1(
                                      12,
                                      Colors.black,
                                      FontWeight.w700,
                                    ),
                                  ),
                                  Container(
                                    height: 22,
                                    child: ListView.builder(
                                      itemCount: orderDetails["items"][item_i]
                                              ['colors']
                                          .length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int color_i) {
                                        return Container(
                                          margin: EdgeInsets.only(right: 5),
                                          height: 20,
                                          width: 20,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              "assets/images/unnamed.png",
                                              fit: BoxFit.contain,
                                              width: 20,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Text(
                                    "${orderDetails["items"][item_i]["mrp"]}",
                                    style: textStyle1(
                                        11, Color(0xFF811111), FontWeight.w700),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text("Status: ", style: infoStyle),
                                      Text(
                                        orderDetails["items"][item_i]
                                            ["customerStatus"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: infoStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Quantity: ${orderDetails['items'][item_i]['quantity']}",
                                  style: infoStyle,
                                ),
                                GestureDetector(
                                  child: Text(
                                    "Rating & Review",
                                    style: infoStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              (count > 0)
                  ? GestureDetector(
                      onTap: () async {
                        await Helpers()
                            .showRequestReturn(context, orderDetails, selected);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF811111),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Request Return",
                          style: textStyle1(
                            12,
                            Colors.white,
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(height: 0),
              SizedBox(height: 5),
            ],
          );
  }
}
