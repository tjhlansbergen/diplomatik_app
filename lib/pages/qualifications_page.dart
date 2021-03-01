// qualifications_page.dart - Tako Lansbergen 2020/02/24
//
// Pagina voor tonen van de kwalificaties van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';
import 'package:diplomatik_app/pages/qualification_page.dart';
import 'package:diplomatik_app/pages/qualification_select_page.dart';
import 'package:diplomatik_app/pages/qualification_create_page.dart';

class QualificationsPage extends StatefulWidget {
  @override
  _QualificationsPageState createState() => _QualificationsPageState();
}

class _QualificationsPageState extends State<QualificationsPage> {
  // asynchrone methode voor aanroepen provider voor ophalen alle van kwalificaties gekoppeld aan klant
  Future<List<Qualification>> downloadData() async {
    var qualificationProvider = new QualificationProvider();
    var response = await qualificationProvider.getQualifications(context);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Kwalificaties"),
      ),
      body: FutureBuilder<List<Qualification>>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<List<Qualification>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // wacht terwijl data binnenkomt
            return Center(child: Text('Laden...'));
          } else {
            if (snapshot.hasError)
              // toon melding indien data niet gehaald kan worden
              return Center(child: Text(snapshot.error.toString()));
            else
              // toon de data zodra deze binnen is
              return qualificationList(context, snapshot.data);
          }
        },
      ),
      // toevoegen-knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showNewQualificationDialog,
      ),
    );
  }

  // dialoog-venster voor methode van toevoegen (handmatig/uit lijst)
  _showNewQualificationDialog() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context); // verwijder pop-up!
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QualificationSelectPage(true)))
                            .then((_) => setState(() => {}));
                      },
                      child: Text('Kies uit lijst', style: TextStyle(color: Colors.blue))),
                  Divider(),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context); // verwijder pop-up!
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QualificationCreatePage()))
                            .then((_) => setState(() => {}));
                      },
                      child: Text('Maak handmatig', style: TextStyle(color: Colors.blue))),
                ],
              ),
            ));
  }

  // widget voor tonen van klikbare lijst van kwalificaties
  Widget qualificationList(BuildContext context, List<Qualification> qualifications) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
              // klik-actie voor tonen individueel item
              onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => QualificationPage(qualifications[index].id)))
                  .then((_) => setState(() => {})),
              child: SizedBox(
                  child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qualifications[index].organization,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          qualifications[index].name,
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
        itemCount: qualifications.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    ));
  }
}
