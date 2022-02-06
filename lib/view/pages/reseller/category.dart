import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/category_tile.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:silkroute/view/widget/horizontal_list_view.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/topbar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({this.categories, this.category});

  final dynamic category, categories;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  dynamic category = [];
  bool loading = true;

  void loadSubcategories() {
    setState(() {
      category = widget.category;
      print("catg: $category\n${widget.categories}");
      loading = false;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSubcategories();
    });
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
                child: loading
                    ? Text("Loading")
                    : CustomScrollView(slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate([
                            //////////////////////////////
                            ///                        ///
                            ///     Category Head      ///
                            ///                        ///
                            //////////////////////////////
                            HorizontalListView("CATEGORIES", widget.categories),
                            //CategoryHead(title: widget.category),

                            //////////////////////////////
                            ///                        ///
                            ///         Lists          ///
                            ///                        ///
                            //////////////////////////////

                            SizedBox(height: 10),

                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                child: loading
                                    ? Text("Loading Loading")
                                    : (category['subCat'].length == 0 ||
                                            (category['subCat'] ?? []) == [])
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Items",
                                              style: textStyle1(
                                                  13,
                                                  Colors.black54,
                                                  FontWeight.w500),
                                            ),
                                          )
                                        : GridView.count(
                                            crossAxisCount: 2,
                                            children: List.generate(
                                              (category['subCat'].length == 0 ||
                                                      (category['subCat'] ??
                                                              []) ==
                                                          [])
                                                  ? 0
                                                  : category['subCat'].length,
                                              (index) {
                                                return CategoryTile(
                                                  category: category["title"],
                                                  subCat: category['subCat']
                                                      [index],
                                                );
                                              },
                                            ),
                                          ),
                              ),
                            ),
                          ]),
                        ),
                        SliverFillRemaining(
                            hasScrollBody: false, child: Container()),
                      ]),
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
