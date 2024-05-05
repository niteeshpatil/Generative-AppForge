import 'package:flutter/material.dart';

class PageBuilder {
  static Widget buildPageFromData(Map<String, dynamic> pageData) {
    String type = pageData['type'];
    Map<String, dynamic> bodyData = pageData['body'];
    Map<String, dynamic> appBarData = bodyData['appBar'];
    String alignment = bodyData['alignment'] ?? 'left';
    double padding = bodyData['padding'] ?? 0;
    List<dynamic> elements = bodyData['elements'];

    return Scaffold(
      appBar: appBarData['display']
          ? AppBar(
              title: Text(appBarData['title']),
              backgroundColor: appBarData['color'] != null
                  ? Color(int.parse(appBarData['color'].substring(1, 7),
                          radix: 16) +
                      0xFF000000)
                  : null,
            )
          : null,
      body: Column(
        crossAxisAlignment: alignment == 'center'
            ? CrossAxisAlignment.center
            : alignment == 'right'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          ...elements.map((elementData) {
            return Padding(
              padding: EdgeInsets.all(padding),
              child: buildWidgetFromData(elementData),
            );
          }).toList(),
        ],
      ),
    );
  }

  static Widget buildWidgetFromData(dynamic elementData) {
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
                  ? Color(int.parse(
                      elementData['placeholderColor'].substring(1),
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
              elementData['color'] != null &&
                      elementData['color'].startsWith('#')
                  ? Color(int.parse(elementData['color'].substring(1),
                          radix: 16))
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
        return Image.network(
          elementData['url'],
          fit: BoxFit.cover,
        );
      default:
        return Container();
    }
  }
}
