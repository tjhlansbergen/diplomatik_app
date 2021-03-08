// student_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor tonen van één student van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/models/student.dart';
import 'package:diplomatik_app/providers/student_provider.dart';
import 'package:diplomatik_app/pages/qualification_select_page.dart';

class StudentPage extends StatefulWidget {
  final int _id;

  const StudentPage(this._id);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  // asynchrone methode voor aanroepen provider voor ophalen student
  Future<Student> downloadData() async {
    var studentProvider = new StudentProvider();
    var response = await studentProvider.getStudent(context, widget._id);
    return Future.value(response);
  }

  // asynchrone methode voor aanroepen provider voor verwijderen student
  Future<void> removeStudent(int id) async {
    var studentProvider = new StudentProvider();
    await studentProvider.deleteStudent(context, id);

    // sluit pagina
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Student"),
      ),
      body: FutureBuilder<Student>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<Student> snapshot) {
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
                  StudentCard(snapshot.data),
                  FlatButton(
                      onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      QualificationSelectPage(SelectionContext.student, student: snapshot.data)))
                          .then((_) => setState(() => {})),
                      child: Text('Kwalificaties instellen',
                          style: TextStyle(
                            color: Colors.green,
                          ))),
                  FlatButton(
                      onPressed: () => removeStudent(snapshot.data.id),
                      child: Text('Student verwijderen',
                          style: TextStyle(
                            color: Colors.red,
                          ))),
                ],
              );
          }
        },
      ),
    );
  }
}

// widget voor het tonen van één student
class StudentCard extends StatelessWidget {
  final Student _student;
  const StudentCard(this._student);

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
                    Text(_student.name,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Studentnummer:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _student.studentNumber,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // onderstaande wordt alleen getoon áls er kwalificaties zijn
                    SizedBox(
                      height: _student.qualifications.length > 0 ? 24.0 : 0,
                    ),
                    Text(
                      _student.qualifications.length > 0 ? "Kwalificaties:" : "",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _student.qualifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Text("\u2022 " + _student.qualifications[index].name));
                        }),
                    // onderstaande wordt alleen getoon áls er vrijstellingen zijn
                    SizedBox(
                      height: _student.exemptions.length > 0 ? 24.0 : 0,
                    ),
                    Text(
                      _student.exemptions.length > 0 ? "Vrijstellingen:" : "",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _student.exemptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Text("\u2022 " + _student.exemptions[index].name));
                        }),
                  ],
                ))));
  }
}
