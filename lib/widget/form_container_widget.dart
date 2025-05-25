import 'package:fyp/main.dart';
import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final bool obscureText;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextInputAction? textInputAction;
  // final TextInputType? inputType;
  final TextInputType? keyboardType;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final Color? textColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? suffixIconColor;
  final Color? focusedBorderColor;
  final double borderRadius;

  const FormContainerWidget({
    super.key,
    this.controller,
    this.isPasswordField= false,
    this.textInputAction,
    this.obscureText= false,
    this.fieldKey,
    this.hintText,
    this.helperText,
    this.labelText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.textColor,
    this.hintColor,
    this.fillColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.focusedBorderColor,
    this.borderRadius = 15.0,
  });

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default colors if not provided
    final textColor = widget.textColor ?? (isDark ? Colors.white : Colors.black87);
    final hintColor = widget.hintColor ?? (isDark ? Colors.white70 : Colors.grey[600]);
    final fillColor = widget.fillColor ?? (isDark ? Colors.black26 : Colors.grey[100]);
    final suffixIconColor = widget.suffixIconColor ?? (isDark ? Colors.grey : Colors.blue);
    final focusedBorderColor = widget.focusedBorderColor ?? theme.buttonColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: TextFormField(
        style: TextStyle(color: textColor),
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField == true ? obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: hintColor,fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 2,
            ),
          ),
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: obscureText ? suffixIconColor : focusedBorderColor,
            ),
          )
              : null,
        ),
      ),
    );
  }
}


















