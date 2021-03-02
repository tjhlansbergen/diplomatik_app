// student_create_page.dart - Tako Lansbergen 2020/03/02
//
// Pagina voor aanmaken nieuwe student
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/student.dart';
import 'package:diplomatik_app/providers/student_provider.dart';

class StudentCreatePage extends StatefulWidget {
  const StudentCreatePage();

  @override
  _StudentCreatePageState createState() => _StudentCreatePageState();
}

class _StudentCreatePageState extends State {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _number = TextEditingController();

  var _student = Student();

  // asynchrone methode voor aanroepen provider voor opslaan student
  Future<void> _saveStudent() async {
    if (_formKey.currentState.validate()) {
      // haal veld-input op
      _formKey.currentState.save();

      // roep API aan via provider om student aan te maken
      var studentProvider = new StudentProvider();
      studentProvider.createStudent(context, _student);

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
                      onSaved: (value) => _student.name = value,
                    )),
                Padding(
                    // invoerveld studentnummer
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: _number,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Studentnummer:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        return null;
                      },
                      onSaved: (value) => _student.studentNumber = value,
                    )),
              ],
            ),
          )),
      // accoordeer knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveStudent,
      ),
    );
  }
}
