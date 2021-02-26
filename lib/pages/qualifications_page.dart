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
              return QualificationList(items: snapshot.data);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showNewQualificationDialog,
      ),
    );
  }

  _showNewQualificationDialog() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Kies uit lijst',
                          style: TextStyle(color: Colors.blue))),
                  Divider(),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Maak handmatig',
                          style: TextStyle(color: Colors.blue))),
                ],
              ),
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
