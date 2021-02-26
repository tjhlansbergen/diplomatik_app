// qualifications_page.dart - Tako Lansbergen 2020/02/24
//
// Pagina voor tonen van de kwalificaties van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';

class QualificationsPage extends StatefulWidget {
  @override
  _QualificationsPageState createState() => _QualificationsPageState();
}

class _QualificationsPageState extends State<QualificationsPage> {
  Future<List<Qualification>> downloadData() async {
    var qualificationProvider = new QualificationProvider();
    var response = await qualificationProvider.getQualifications(context);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // header-balk met paginanaam
          title: Text("Kwalificaties"),
        ),
        body: FutureBuilder<List<Qualification>>(
          future: downloadData(), // function where you call your api
          builder: (BuildContext context,
              AsyncSnapshot<List<Qualification>> snapshot) {
            // AsyncSnapshot<Your object type>
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Laden...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text(snapshot.error.toString()));
              else
                return Center(
                    child: QualificationList(
                        items: snapshot
                            .data)); // snapshot.data  :- get your object which is pass from your downloadData() function
            }
          },
        ));
  }
}

class QualificationList extends StatelessWidget {
  final List<Qualification> items;
  const QualificationList({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
              onTap: _buttonDummy,
              child: SizedBox(
                  child: Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index].organization,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          items[index].name,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
              )));
        },
        itemCount: items.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    ));
  }

  void _buttonDummy() {
    //
  }
}