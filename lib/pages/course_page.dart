// course_page.dart - Tako Lansbergen 2020/03/01
//
// Pagina voor tonen van één vak van de klant

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/providers/course_provider.dart';
import 'package:diplomatik_app/pages/qualification_select_page.dart';

class CoursePage extends StatefulWidget {
  final int _id;

  const CoursePage(this._id);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  // asynchrone methode voor aanroepen provider voor ophalen vak
  Future<Course> downloadData() async {
    var courseProvider = new CourseProvider();
    var response = await courseProvider.getCourse(context, widget._id);
    return Future.value(response);
  }

  // asynchrone methode voor aanroepen provider voor verwijderen vak
  Future<void> removeCourse(int id) async {
    var courseProvider = new CourseProvider();
    await courseProvider.removeCourse(context, id);

    // sluit pagina
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Vak"),
      ),
      body: FutureBuilder<Course>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<Course> snapshot) {
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
                  CourseCard(snapshot.data),
                  FlatButton(
                      onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => QualificationSelectPage(false, course: snapshot.data)))
                          .then((_) => setState(() => {})),
                      child: Text('Vrijstellingen selecteren',
                          style: TextStyle(
                            color: Colors.green,
                          ))),
                  FlatButton(
                      onPressed: () => removeCourse(snapshot.data.id),
                      child: Text('Vak verwijderen',
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

// widget voor het tonen van één vak
class CourseCard extends StatelessWidget {
  final Course _course;
  const CourseCard(this._course);

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
                    Text(_course.name,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Vakcode:",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _course.code,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // onderstaande wordt alleen getoon áls er koppelingen zijn
                    SizedBox(
                      height: _course.qualifications.length > 0 ? 24.0 : 0,
                    ),
                    Text(
                      _course.qualifications.length > 0 ? "Wordt vrijgesteld door:" : "",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _course.qualifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              child: Text("\u2022 " + _course.qualifications[index].name));
                        }),
                  ],
                ))));
  }
}
