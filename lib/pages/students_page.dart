// students_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor tonen van de studenten van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/student.dart';
import 'package:diplomatik_app/providers/student_provider.dart';
import 'package:diplomatik_app/pages/student_page.dart';
import 'package:diplomatik_app/pages/student_create_page.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  // asynchrone methode voor aanroepen provider voor ophalen alle de data
  Future<List<Student>> downloadData() async {
    var studentProvider = new StudentProvider();
    var response = await studentProvider.getStudents(context);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Studenten"),
      ),
      body: FutureBuilder<List<Student>>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // wacht terwijl data binnenkomt
            return Center(child: Text('Laden...'));
          } else {
            if (snapshot.hasError)
              // toon melding indien data niet gehaald kan worden
              return Center(child: Text(snapshot.error.toString()));
            else
              // toon de data zodra deze binnen is
              return studentList(context, snapshot.data);
          }
        },
      ),
      // toevoegen-knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentCreatePage()))
            .then((_) => setState(() => {})),
      ),
    );
  }

  // widget voor tonen van klikbare lijst van studenten
  Widget studentList(BuildContext context, List<Student> students) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
              // klik-actie voor tonen individueel item
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentPage(students[index].id)))
                  .then((_) => setState(() => {})),
              child: SizedBox(
                  child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          students[index].name,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          students[index].studentNumber,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
              )));
        },
        itemCount: students.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    ));
  }
}
