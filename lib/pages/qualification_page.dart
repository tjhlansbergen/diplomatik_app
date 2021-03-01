// qualification_page.dart - Tako Lansbergen 2020/02/27
//
// Pagina voor tonen van één kwalificatie van de klant

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';

class QualificationPage extends StatefulWidget {
  final int _id;

  const QualificationPage(this._id);

  @override
  _QualificationPageState createState() => _QualificationPageState();
}

class _QualificationPageState extends State<QualificationPage> {
  // asynchrone methode voor aanroepen provider voor ophalen kwalificatie
  Future<Qualification> downloadData() async {
    var qualificationProvider = new QualificationProvider();
    var response = await qualificationProvider.getQualification(context, widget._id);
    return Future.value(response);
  }

  // asynchrone methode voor aanroepen provider voor verwijderen kwalificatie
  Future<void> removeQualification(int id) async {
    var qualificationProvider = new QualificationProvider();
    await qualificationProvider.removeQualification(context, id);

    // sluit pagina
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Kwalificatie"),
      ),
      body: FutureBuilder<Qualification>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<Qualification> snapshot) {
          // wacht terwijl de data binnenkomt
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Laden...'));
          } else {
            // toon melding indien data niet gehaald kon worden
            if (snapshot.hasError)
              return Center(child: Text(snapshot.error.toString()));
            else
              return Column(
                children: [
                  // toon data en verwijder-knop zodra de data binnen is
                  QualificationCard(snapshot.data),
                  FlatButton(
                      onPressed: () => removeQualification(snapshot.data.id),
                      child: Text('Verwijder',
                          style: TextStyle(
                            color: Colors.red,
                          )))
                ],
              );
          }
        },
      ),
    );
  }
}

// widget voor het tonen van één kwalificatie
class QualificationCard extends StatelessWidget {
  final Qualification _qualification;
  const QualificationCard(this._qualification);

  // mapping type->type-id
  String _getType(int id) {
    switch (id) {
      case 1:
        return "Diploma";
      case 2:
        return "Certificaat";
      default:
        return "Onbekend";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  // toon details in kolom
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Naam:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(_qualification.name,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Opleider:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _qualification.organization,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Soort:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _getType(_qualification.qualificationTypeId),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // onderstaande wordt alleen getoon áls er vrijstellingen zijn
                    SizedBox(
                      height: _qualification.courses.length > 0 ? 24.0 : 0,
                    ),
                    Text(
                      _qualification.courses.length > 0 ? "Geeft vrijstelling voor:" : "",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _qualification.courses.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Text("\u2022 " + _qualification.courses[index].name));
                        }),
                  ],
                ))));
  }
}
