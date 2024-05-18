import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buildWidgetFromData(dynamic elementData) {
  String elementType = elementData['type'];
  switch (elementType) {
    case 'text':
      return TextFormField(
        decoration: InputDecoration(
          labelText: elementData['label'],
          hintText: elementData['placeholder'],
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(
            color: elementData['placeholderColor'] != null
                ? Color(int.parse(elementData['placeholderColor'].substring(1),
                    radix: 16))
                : null,
          ),
        ),
        onChanged: (value) {
          // Your onChanged logic here
        },
        obscureText: elementData['isPassword'] ?? false,
      );
    case 'button':
      return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            elementData['color'] != null && elementData['color'].startsWith('#')
                ? Color(int.parse(elementData['color'].substring(1), radix: 16))
                    .withOpacity(1.0)
                : Colors.transparent,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(elementData['label']),
        ),
      );
    case 'image':
      String imageUrl = elementData['url'];
      if (imageUrl.endsWith('.svg')) {
        return Container(
          width: 120, // Set the width as needed
          height: 120, // Set the height as needed
          child: SvgPicture.network(
            imageUrl,
            fit: BoxFit.scaleDown,
          ),
        );
      } else {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
        );
      }
    default:
      return Container();
  }
}
