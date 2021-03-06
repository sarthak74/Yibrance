import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:silkroute/methods/helpers.dart';
import 'package:silkroute/methods/isauthenticated.dart';
import 'package:silkroute/model/services/ResellerProfileApi.dart';
import 'package:silkroute/view/widget/navbar.dart';
import 'package:silkroute/view/widget/profile_pic_picker.dart';
import 'package:silkroute/view/widget/subcategory_head.dart';
import 'package:silkroute/view/widget/text_field.dart';
import 'package:silkroute/view/widget/topbar.dart';
import 'package:silkroute/view/widget/footer.dart';
import 'package:getwidget/getwidget.dart';

import 'orders.dart';

TextStyle textStyle(num size, Color color) {
  return GoogleFonts.poppins(
    textStyle: TextStyle(
      color: color,
      fontSize: size.toDouble(),
      fontWeight: FontWeight.bold,
    ),
  );
}

class ResellerProfile extends StatefulWidget {
  @override
  _ResellerProfileState createState() => _ResellerProfileState();
}

class _ResellerProfileState extends State<ResellerProfile> {
  LocalStorage storage = LocalStorage('silkroute');

  @override
  void initState() {
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              Expanded(
                child: CustomScrollView(slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // PROFILE IMAGE
                      ProfileImageBar(),

                      SizedBox(height: 20),

                      // OPTIONS LIST
                      OptionsList(),

                      SizedBox(height: 20),

                      // PROFILE DETAIL CONTAINER
                      ProfileDetailContainer(),

                      // LOGOUT BUTTON
                      LogoutButton(),
                    ]),
                  ),
                  SliverFillRemaining(hasScrollBody: false, child: Container()),
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
      ),
    );
  }
}

class ProfileImageBar extends StatefulWidget {
  @override
  _ProfileImageBarState createState() => _ProfileImageBarState();
}

class _ProfileImageBarState extends State<ProfileImageBar> {
  LocalStorage storage = LocalStorage('silkroute');
  bool loading = true;
  String contact, name;

  loadVars() async {
    contact = await storage.getItem('contact');
    name = await storage.getItem('name');
    setState(() {
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
        ? Text("Loading...")
        : Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                top: MediaQuery.of(context).size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProfilePic(contact),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: textStyle1(15, Colors.black, FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class LogoutButton extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Methods().logout(context);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color(0xFF5B0D1B),
        ),
        child: Text(
          "Logout",
          style: textStyle(15, Colors.white),
        ),
      ),
    );
  }
}

class ProfileDetailContainer extends StatefulWidget {
  @override
  _ProfileDetailContainerState createState() => _ProfileDetailContainerState();
}

class _ProfileDetailContainerState extends State<ProfileDetailContainer> {
  bool isProfileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isProfileExpanded = !isExpanded;
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
                      Icon(Icons.person, size: 20, color: Colors.black54),
                      SizedBox(width: 10),
                      Text(
                        "Profile Details",
                        style: textStyle(15, Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
              body: ListTile(
                title: ProfileDetailsList(),
              ),
              isExpanded: isProfileExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailsList extends StatefulWidget {
  @override
  _ProfileDetailsListState createState() => _ProfileDetailsListState();
}

class _ProfileDetailsListState extends State<ProfileDetailsList> {
  dynamic personDetail = {}, loading = true;
  LocalStorage storage = LocalStorage('silkroute');
  List fields = [
    ['name', true],
    ['contact', false],
    ['anotherNumber', true]
  ];
  // List alts = ['Name', 'Contact', 'Email', 'Alternate Number'];

  void loadPerson() async {
    personDetail = await storage.getItem('user');
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPerson();
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text("Loading")
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: fields.length,
            itemBuilder: (BuildContext context, int i) {
              return PersonalDetailRow(
                title: fields[i][0],
                editable: fields[i][1],
              );
            });
  }
}

class PersonalDetailRow extends StatefulWidget {
  PersonalDetailRow({this.title, this.editable});
  final String title;
  final bool editable;

  @override
  _PersonalDetailRowState createState() => _PersonalDetailRowState();
}

class _PersonalDetailRowState extends State<PersonalDetailRow> {
  LocalStorage storage = LocalStorage('silkroute');
  bool _enabled = false, isContact = false, loading = true;
  TextEditingController _controller = TextEditingController();
  dynamic user;
  dynamic title, data;
  List fields = ['Name', 'Contact', 'Alternate Number'];
  List alts = ['name', 'contact', 'anotherNumber'];

  void save() async {
    if (_enabled == false) {
      return;
    }

    data = _controller.text;

    user[widget.title] = data;
    await storage.deleteItem('user');
    await storage.setItem('user', user);
    setState(() {
      _controller.text = "";
      _enabled = false;
    });
    var body = {title: data, 'contact': user['contact']};

    await ResellerProfileApi().setProfile(body);
  }

  void loadVars() async {
    user = await storage.getItem('user');
    setState(() {
      title = fields[alts.indexOf(widget.title)];
      data = user[widget.title];

      _controller.text = data;
      print("${widget.title} $data");
      isContact = ('contact' == widget.title ? true : false);
      loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVars();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            height: 23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Color(0xFF5B0D1B),
                  ),
                ),
              ],
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              (widget.editable)
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.black87,
                        ),
                        child: new TextField(
                          maxLines: null,
                          controller: _controller,
                          enabled: _enabled,
                          onChanged: null,
                          style:
                              textStyle1(13, Colors.black87, FontWeight.w500),
                          decoration: new InputDecoration(
                            labelStyle:
                                textStyle1(13, Colors.black54, FontWeight.w500),
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle:
                                textStyle1(13, Colors.black54, FontWeight.w500),
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.black54,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.black87,
                                width: 3,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.black54,
                                width: 3,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.black54,
                                width: 3,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            contentPadding: new EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            prefixStyle: new TextStyle(
                              color: Colors.black,
                            ),
                            labelText: title,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black54),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          data.toString(),
                          style:
                              textStyle1(13, Colors.black54, FontWeight.w500),
                        ),
                      ),
                    ),
              (widget.editable)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!_enabled) {
                            _enabled = true;
                          } else {
                            save();
                          }
                        });
                      },
                      child: Icon(_enabled ? Icons.save : Icons.edit, size: 18),
                    )
                  : SizedBox(width: 10),
              (_enabled && widget.editable)
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_enabled) {
                            _enabled = false;
                          }
                        });
                      },
                      child: Icon(Icons.cancel, size: 18),
                    )
                  : Text(""),
            ],
          );
  }
}

class OptionsList extends StatefulWidget {
  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  bool loading = true;
  dynamic user;
  String pickupAdd, businessAdd;

  void loadVars() async {
    user = await Methods().getUser();

    setState(() {
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
        ? Text("Loading...")
        : Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.grey[200],
            ),
            child: Column(
              children: <Widget>[
                OptionRow(
                  prefixIcon: Icons.receipt,
                  title: "Coupons",
                  suffixIcon: Icons.arrow_forward,
                  function: () async {
                    await Helpers().showCoupons(context);
                  },
                ),
                OptionRow(
                  prefixIcon: CupertinoIcons.location,
                  title: "Address",
                  suffixIcon: Icons.arrow_forward,
                  function: () async {
                    await Helpers()
                        .showBusinessAddressDialog(context, businessAdd);
                  },
                ),
                OptionRow(
                  prefixIcon: Icons.card_membership,
                  title: "Saved Cards",
                  suffixIcon: Icons.edit,
                ),
                OptionRow(
                  prefixIcon: Icons.receipt,
                  title: "GSTIN",
                  suffixIcon: Icons.arrow_forward,
                  function: () async {
                    await Helpers().showGstinDialog(context, user["gst"]);
                  },
                ),
              ],
            ),
          );
  }
}

class OptionRow extends StatefulWidget {
  const OptionRow(
      {this.prefixIcon, this.title, this.suffixIcon, this.function});
  final IconData prefixIcon, suffixIcon;
  final String title;
  final Function function;
  @override
  _OptionRowState createState() => _OptionRowState();
}

class _OptionRowState extends State<OptionRow> {
  TextStyle textStyle(num size, Color color) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color,
        fontSize: size.toDouble(),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(widget.prefixIcon, size: 18, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: textStyle(15, Colors.black54),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            widget.suffixIcon,
            size: 18,
            color: Color(0xFF811111),
          ),
          onPressed: widget.function,
        ),
      ],
    );
  }
}
