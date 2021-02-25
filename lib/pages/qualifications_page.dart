// qualifications_page.dart - Tako Lansbergen 2020/02/24
//
// Pagina voor tonen van de kwalificaties van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:diplomatik_app/providers/qualification_provider.dart';

class QualificationsPage extends StatefulWidget {
  @override
  _QualificationsPageState createState() => _QualificationsPageState();
}

class _QualificationsPageState extends State<QualificationsPage> {
  Future<String> downloadData() async {
    var qualificationProvider = context.read<QualificationProvider>();
    var response = await qualificationProvider.getQualifications(context);
    return Future.value(response.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // header-balk met paginanaam
          title: Text("Kwalificaties"),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FutureBuilder<String>(
              future: downloadData(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                // AsyncSnapshot<Your object type>
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Laden...'));
                } else {
                  if (snapshot.hasError)
                    return Center(child: Text(snapshot.error.toString()));
                  else
                    return Center(
                        child: new Text(
                            '${snapshot.data}')); // snapshot.data  :- get your object which is pass from your downloadData() function
                }
              },
            )));
  }
}
