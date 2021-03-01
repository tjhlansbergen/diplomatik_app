// course_create_page.dart - Tako Lansbergen 2020/03/01
//
// Pagina voor aanmaken nieuw vak
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/providers/course_provider.dart';

class CourseCreatePage extends StatefulWidget {
  const CourseCreatePage();

  @override
  _CourseCreatePageState createState() => _CourseCreatePageState();
}

class _CourseCreatePageState extends State {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _code = TextEditingController();

  var _course = Course();

  // asynchrone methode voor aanroepen provider voor opslaan vak
  Future<void> _saveCourse() async {
    if (_formKey.currentState.validate()) {
      // haal veld-input op
      _formKey.currentState.save();

      // roep API aan via provider om vak aan te maken
      var courseProvider = new CourseProvider();
      courseProvider.createCourse(context, _course);

      // sluit pagina
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // header-balk met paginanaam
      appBar: AppBar(
        title: Text("Vul in om toe te voegen"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    // invoerveld naam
                    child: TextFormField(
                      controller: _name,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Naam:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        return null;
                      },
                      onSaved: (value) => _course.name = value,
                    )),
                Padding(
                    // invoerveld vakcode
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: _code,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Vakcode:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        return null;
                      },
                      onSaved: (value) => _course.code = value,
                    )),
              ],
            ),
          )),
      // accoordeer knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveCourse,
      ),
    );
  }
}
