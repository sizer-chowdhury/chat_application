import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  const CustomTextfield(
      {super.key,
        required this.hintText,
        required this.obscureText,
        required this.controller,
        this.validator,
        this.autovalidateMode,
        this.focusNode// Optional validator function
      });

  @override
  _MyTextfieldState createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<CustomTextfield> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        focusNode: widget.focusNode,
        autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
        obscureText: widget.obscureText ? _obscureText : false,
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14.0,
            fontStyle: FontStyle.italic,
          ),
        ),
        // Customizing error style
      ),
    );
  }
}
