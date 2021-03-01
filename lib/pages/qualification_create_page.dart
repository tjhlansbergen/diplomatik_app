// qualification_create_page.dart - Tako Lansbergen 2020/02/27
//
// Pagina voor aanmaken nieuwe kwalificatie
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';

class QualificationCreatePage extends StatefulWidget {
  const QualificationCreatePage();

  @override
  _QualificationCreatePageState createState() => _QualificationCreatePageState();
}

class _QualificationCreatePageState extends State {
  final _formKey = GlobalKey<FormState>();
  List<bool> _isSelected = [true, false];

  final _name = TextEditingController();
  final _organisation = TextEditingController();

  var _qualification = Qualification();

  // asynchrone methode voor aanroepen provider voor opslaan kwalificatie
  Future<void> _saveQualification() async {
    if (_formKey.currentState.validate()) {
      // haal veld-input op
      _formKey.currentState.save();

      // bepaal kwalificatie type-id
      _qualification.qualificationTypeId = _isSelected[0] ? 1 : 2;

      // roep API aan via provider om kwalifcatie aan te maken
      var qualificationProvider = new QualificationProvider();
      qualificationProvider.createQualification(context, _qualification);

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
                      onSaved: (value) => _qualification.name = value,
                    )),
                Padding(
                    // invoerveld organisatie-naam
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: TextFormField(
                      controller: _organisation,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Onderwijsinstelling:'),
                      validator: (value) {
                        if (value.isEmpty) return 'Verplicht veld';
                        return null;
                      },
                      onSaved: (value) => _qualification.organization = value,
                    )),
                Padding(
                  // toggle soort
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: ToggleButtons(
                      children: <Widget>[
                        Text('    Diploma    '),
                        Text('  Certificaat  '),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              _isSelected[buttonIndex] = true;
                            } else {
                              _isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: _isSelected,
                    ),
                  ),
                ),
              ],
            ),
          )),
      // accoordeer knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: _saveQualification,
      ),
    );
  }
}
