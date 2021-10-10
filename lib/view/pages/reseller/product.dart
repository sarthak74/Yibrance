import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:silkroute/methods/math.dart';
import 'package:silkroute/view/pages/reseller/order_page.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class ProductPage extends StatefulWidget {
  const ProductPage({this.id});

  final String id;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool loading = true;
  dynamic productDetails;

  void loadProductDetails() {
    setState(() {
      productDetails = {
        'id': "12",
        "title": "Kanjeevaram Silk Saree",
        "description":
            "This is a premium pure silk kanjeeevaram saree made with soft hands and electron-size perfection",
        "mrp": 20000,
        "sp": 5999,
        "wishlist": true,
        "discount": true,
        "totalSet": 12,
        "min": 5,
        "increment": 2,
        "discountValue": 70,
        "stockAvailability": 8,
        "resellerCrateAvailability": 13,
        "colors": [
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFF0F000),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFF0F000),
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
          Color(0xFFF0F000),
        ]
      };

      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProductDetails();
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
                            ? Text("Loading")
                            : SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    ProductImage(
                                        productDetails: productDetails),
                                    ProductDescription(product: productDetails),
                                    ProductCounter(product: productDetails),
                                    ProductAvailability(
                                        product: productDetails),
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

class ProductAvailability extends StatefulWidget {
  const ProductAvailability({this.product});
  final dynamic product;

  @override
  _ProductAvailabilityState createState() => _ProductAvailabilityState();
}

class _ProductAvailabilityState extends State<ProductAvailability> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ("Available in stock: " +
                    widget.product['stockAvailability'].toString())
                .toString(),
            style: textStyle(12, Colors.black),
          ),
          Text(
            ("Currently in crates of: " +
                    widget.product['resellerCrateAvailability'].toString() +
                    " Resellers")
                .toString(),
            style: textStyle(12, Colors.black),
          ),
        ],
      ),
    );
  }
}

class ProductCounter extends StatefulWidget {
  const ProductCounter({this.product});
  final dynamic product;

  @override
  _ProductCounterState createState() => _ProductCounterState();
}

class _ProductCounterState extends State<ProductCounter> {
  num counter, min, max, gap;
  bool loading = true;

  void inc() {
    if (counter + gap <= max) {
      setState(() {
        counter += gap;
      });
    }
  }

  void dec() {
    if (counter - gap >= min) {
      setState(() {
        counter -= gap;
      });
    }
  }

  void loadVars() {
    setState(() {
      counter = widget.product['min'];
      min = widget.product['min'];
      max = widget.product['totalSet'];
      gap = widget.product['increment'];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // COUNTER

          Row(
            children: <Widget>[
              GestureDetector(
                onTap: dec,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                  child: Text(
                    "-",
                    style: textStyle(
                      12,
                      Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black),
                ),
                padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Text(
                  loading ? "." : counter.toString(),
                  style: textStyle(
                    14,
                    Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: inc,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                  child: Text(
                    "+",
                    style: textStyle(
                      12,
                      Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //  COLORS
          SizedBox(height: 15),
          Align(
            alignment: Alignment.topLeft,
            child: loading
                ? Text("Loading")
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: counter,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 25,
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.5)),
                            color: widget.product['colors'][index],
                          ),
                        );
                      },
                    ),
                  ),
          ),
          SizedBox(height: 15),

          GestureDetector(
            onTap: null,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 15,
                  ),
                  SizedBox(width: 10),
                  Text("Add to Crate", style: textStyle(15, Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  const ProductDescription({this.product});
  final dynamic product;

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  @override
  Widget build(BuildContext context) {
    print("--> ${widget.product}");
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 10,
          MediaQuery.of(context).size.width * 0.05, 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.product['title'], style: textStyle(15, Colors.black)),
          Text(widget.product['description'],
              style: textStyle(12, Colors.grey)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.product['discount']
                  ? Row(
                      children: <Widget>[
                        Text(
                          ("₹" + widget.product['mrp'].toString()).toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFF5B0D1B),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          ("₹" + widget.product['sp'].toString()).toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFF5B0D1B),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          ("-" +
                                  widget.product['discountValue'].toString() +
                                  "%")
                              .toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Text(
                          ("₹" + widget.product['mrp'].toString()).toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Color(0xFF5B0D1B),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(5),
                child: Text(
                  ("Set of " + widget.product['totalSet'].toString())
                      .toString(),
                  style: textStyle(10, Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatefulWidget {
  const ProductImage({this.productDetails});
  final dynamic productDetails;

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool loading = true;
  int selected = 0;
  List images = [];
  String url = "assets/images/";

  Future<void> loadImages() async {
    setState(() {
      images = ["1.png", "1.png", "1.png", "1.png"];
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadImages().then((value) {
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
                vertical: 10),
            padding: EdgeInsets.all(10),
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 280,
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.18,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: (selected == index) ? 2 : 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  (selected == index)
                                      ? BoxShadow(
                                          color: Color(0xFFC6C2C2),
                                          offset: Offset(2.0, 3.0),
                                          blurRadius: 4.0,
                                        )
                                      : BoxShadow(
                                          color: Color(0xFFFFFFFF),
                                          offset: Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                        ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                      (url + images[index]).toString()),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          if (index < 3) SizedBox(height: 13)
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage((url + images[selected]).toString()),
                      fit: BoxFit.fill,
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.productDetails['wishlist'] =
                              !widget.productDetails['wishlist'];
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFF5B0D1B), width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(1, 3.0),
                              blurRadius: 4.0,
                            ),
                          ],
                          color: !widget.productDetails['wishlist']
                              ? Color(0xFFFFFFFF)
                              : Color(0xFFE1AC5D),
                        ),
                        child: Icon(
                          Icons.widgets,
                          size: 20,
                          color: widget.productDetails['wishlist']
                              ? Color(0xFFFFFFFF)
                              : Color(0xFFE1AC5D),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class AddToWishList extends StatefulWidget {
  AddToWishList({this.wishlist});
  final bool wishlist;
  @override
  _AddToWishListState createState() => _AddToWishListState();
}

class _AddToWishListState extends State<AddToWishList> {
  bool wishlist = false;
  @override
  Widget build(BuildContext context) {
    wishlist = widget.wishlist;
    return GestureDetector(
      onTap: () {
        setState(() {
          wishlist = !wishlist;
        });
      },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF5B0D1B), width: 3),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(1, 3.0),
              blurRadius: 4.0,
            ),
          ],
          color: !wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
        ),
        child: Icon(
          Icons.widgets,
          size: 20,
          color: wishlist ? Color(0xFFFFFFFF) : Color(0xFFE1AC5D),
        ),
      ),
    );
  }
}