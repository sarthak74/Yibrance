import 'package:flutter/material.dart';
import 'package:silkroute/view/pages/reseller/orders.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField(
      this.labelText, this.hintText, this.isPassword, this.onchanged,
      {this.initialValue, this.enabled});
  final String labelText, hintText, initialValue;
  final bool isPassword, enabled;
  final onchanged;
  CustomTextFieldState createState() => new CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        primaryColor: Colors.black87,
      ),
      child: new TextFormField(
        initialValue: widget.initialValue,
        obscureText: widget.isPassword,
        onChanged: widget.onchanged,
        enabled: widget.enabled,
        decoration: new InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          contentPadding: new EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10,
          ),
          labelText: widget.labelText,
          labelStyle: new TextStyle(
            color: (widget.enabled == null || widget.enabled == true)
                ? Colors.black54
                : Colors.grey,
          ),
          prefixStyle: new TextStyle(
            color: Colors.black,
          ),
          hintText: widget.hintText,
          hintStyle: textStyle1(13, Colors.black45, FontWeight.normal),
        ),
        style: textStyle1(
            13,
            (widget.enabled == null || widget.enabled == true)
                ? Colors.black
                : Colors.grey,
            FontWeight.normal),
      ),
    );
  }
}
