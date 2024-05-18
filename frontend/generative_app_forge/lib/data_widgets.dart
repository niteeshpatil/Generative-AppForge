import 'package:flutter/material.dart';
import 'package:generative_app_forge/widget_builder.dart';

class PageBuilder {
  static Widget buildPageFromData(
      BuildContext context, Map<String, dynamic> pageData) {
    try {
      String type = pageData['type'];
      Map<String, dynamic> bodyData = pageData['body'] ?? {};
      Map<String, dynamic> appBarData = bodyData['appBar'] ?? {};
      String alignment = bodyData['alignment'] ?? 'left';
      double padding = bodyData['padding'] ?? 0;
      List<dynamic> elements = bodyData['elements'];

      return Scaffold(
        appBar: appBarData['display'] == true
            ? AppBar(
                title: Text(appBarData['title'] ?? ''),
                backgroundColor: appBarData['color'] != null
                    ? Color(int.parse(appBarData['color'].substring(1, 7),
                            radix: 16) +
                        0xFF000000)
                    : null,
              )
            : null,
        body: SingleChildScrollView(
          child: Column(
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
        ),
      );
    } catch (e) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text('$e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      });
      return Container();
    }
  }
}
