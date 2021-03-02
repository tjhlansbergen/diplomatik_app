// qualification_select_page.dart - Tako Lansbergen 2020/02/27
//
// Pagina voor selecteren kwalificaties
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/common/constants.dart';
import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/models/course.dart';
import 'package:diplomatik_app/models/student.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';
import 'package:diplomatik_app/providers/course_provider.dart';
import 'package:diplomatik_app/providers/student_provider.dart';

class QualificationSelectPage extends StatefulWidget {
  final SelectionContext selectionContext;
  final Course course;
  final Student student;

  const QualificationSelectPage(this.selectionContext, {this.course, this.student});

  @override
  _QualificationSelectPageState createState() => _QualificationSelectPageState();
}

class _QualificationSelectPageState extends State<QualificationSelectPage> {
  // asynchrone methode voor aanroepen provider voor ophalen kwalificaties, die NIET al aan de klant gekoppeld zijn
  Future<List<Qualification>> downloadData() async {
    var qualificationProvider = new QualificationProvider();
    var response =
        await qualificationProvider.getQualifications(context, widget.selectionContext == SelectionContext.customer);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // header-balk met paginanaam
        appBar: AppBar(
          title: Text(widget.selectionContext == SelectionContext.customer
              ? "Selecteer om toe te voegen"
              : "Selecteer om in te stellen"),
        ),
        body: FutureBuilder<List<Qualification>>(
          future: downloadData(),
          builder: (BuildContext context, AsyncSnapshot<List<Qualification>> snapshot) {
            // wacht op de data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Laden...'));
            } else {
              // toon melding als data niet gehaald kan worden
              if (snapshot.hasError)
                return Center(child: Text(snapshot.error.toString()));
              else
                // toont data als deze binnen is
                return QualificationSelect(snapshot.data, widget.selectionContext, widget.course, widget.student);
            }
          },
        ));
  }
}

// widget voor het tonen van selecteerbare lijst kwalificaties
class QualificationSelect extends StatefulWidget {
  final List<Qualification> _items;
  final SelectionContext _selectionContext;
  final Course _course;
  final Student _student;

  final _selected = Set<int>(); // lijst met (unieke) kwalificatie-id's

  QualificationSelect(this._items, this._selectionContext, this._course, this._student) {
    if (_selectionContext == SelectionContext.course) {
      _course.qualifications.forEach((qualification) {
        _selected.add(qualification.id);
      });
    } else if (_selectionContext == SelectionContext.student) {
      _student.qualifications.forEach((qualification) {
        _selected.add(qualification.id);
      });
    }
  }

  @override
  _QualificationSelectState createState() => _QualificationSelectState();
}

class _QualificationSelectState extends State<QualificationSelect> {
  // asynchrone methode voor aanroepen provider voor koppelen van kwalificaties
  Future<void> linkCustomer() async {
    switch (widget._selectionContext) {
      // kwalificaties koppelen aan de klant van de ingelogde gebruiker
      case SelectionContext.customer:
        var qualificationProvider = new QualificationProvider();
        // voor iedere geselecteerde kwalificatie...
        widget._selected.forEach((item) {
          qualificationProvider.addQualification(context, item);
        });
        break;

      // kwalificaties koppelen aan het meegestuurde vak
      case SelectionContext.course:
        var courseProvider = new CourseProvider();
        courseProvider.updateCourse(context, widget._course.id, widget._selected);
        break;

      case SelectionContext.student:
        var studentProvider = new StudentProvider();
        studentProvider.updateStudent(context, widget._student.id, widget._selected);
        break;
    }

    // sluit pagina
    Navigator.pop(context);
  }

  bool isSelected(int i) {
    return widget._selected.contains(widget._items[i].id);
  }

  IconData getIconData(int i) {
    if (widget._selectionContext == SelectionContext.customer) {
      return isSelected(i) ? Icons.check_box_outlined : Icons.check_box_outline_blank;
    } else {
      return isSelected(i) ? Icons.radio_button_on : Icons.radio_button_off;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        // selecteerbare lijst kwalificaties
        child: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected(index)) {
                      widget._selected.remove(widget._items[index].id);
                    } else {
                      widget._selected.add(widget._items[index].id);
                    }
                  });
                },
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      // selectie knop
                      child: Icon(getIconData(index), color: isSelected(index) ? Colors.blue : Colors.blueGrey)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget._items[index].organization,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget._items[index].name,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )),
                ]));
          },
          itemCount: widget._items.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        ),
      ),
      // accordeer-knop
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: linkCustomer,
      ),
    );
  }
}
