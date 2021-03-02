// courses_page.dart - Tako Lansbergen 2020/03/01
//
// Pagina voor tonen van de vakken van de klant
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/providers/course_provider.dart';
import 'package:diplomatik_app/pages/course_page.dart';
import 'package:diplomatik_app/pages/course_create_page.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // asynchrone methode voor aanroepen provider voor ophalen alle van vakken gekoppeld aan klant
  Future<List<Course>> downloadData() async {
    var courseProvider = new CourseProvider();
    var response = await courseProvider.getCourses(context);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Vakken"),
      ),
      body: FutureBuilder<List<Course>>(
        future: downloadData(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // wacht terwijl data binnenkomt
            return Center(child: Text('Laden...'));
          } else {
            if (snapshot.hasError)
              // toon melding indien data niet gehaald kan worden
              return Center(child: Text(snapshot.error.toString()));
            else
              // toon de data zodra deze binnen is
              return courseList(context, snapshot.data);
          }
        },
      ),
      // toevoegen-knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseCreatePage()))
            .then((_) => setState(() => {})),
      ),
    );
  }

  // widget voor tonen van klikbare lijst van vakken
  Widget courseList(BuildContext context, List<Course> courses) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
              // klik-actie voor tonen individueel item
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoursePage(courses[index].id)))
                  .then((_) => setState(() => {})),
              child: SizedBox(
                  child: Container(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          courses[index].name,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          courses[index].code,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )),
              )));
        },
        itemCount: courses.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    ));
  }
}
