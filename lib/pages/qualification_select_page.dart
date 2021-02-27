// qualification_select_page.dart - Tako Lansbergen 2020/02/27
//
// Pagina voor selecteren kwalificaties
// overerft van StatefulWidget

import 'package:flutter/material.dart';

import 'package:diplomatik_app/models/qualification.dart';
import 'package:diplomatik_app/providers/qualification_provider.dart';

class QualificationSelectPage extends StatefulWidget {
  @override
  _QualificationSelectPageState createState() => _QualificationSelectPageState();
}

class _QualificationSelectPageState extends State<QualificationSelectPage> {
  Future<List<Qualification>> downloadData() async {
    var qualificationProvider = new QualificationProvider();
    var response = await qualificationProvider.getQualifications(context, true);
    return Future.value(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // header-balk met paginanaam
          title: Text("Selecteer om toe te voegen"),
        ),
        body: FutureBuilder<List<Qualification>>(
          future: downloadData(), // function where you call your api
          builder: (BuildContext context, AsyncSnapshot<List<Qualification>> snapshot) {
            // AsyncSnapshot<Your object type>
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('Laden...'));
            } else {
              if (snapshot.hasError)
                return Center(child: Text(snapshot.error.toString()));
              else
                return QualificationSelect(snapshot.data);
            }
          },
        ));
  }
}

class QualificationSelect extends StatefulWidget {
  final List<Qualification> _items;
  final _selected = Set<int>();

  QualificationSelect(this._items);

  @override
  _QualificationSelectState createState() => _QualificationSelectState();
}

class _QualificationSelectState extends State<QualificationSelect> {
  Future<void> linkQualifications() async {
    var qualificationProvider = new QualificationProvider();

    widget._selected.forEach((item) {
      qualificationProvider.addQualification(context, item);
    });

    Navigator.pop(context); // verwijder mijzelf
  }

  bool select(int i) {
    return widget._selected.contains(widget._items[i].id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    if (select(index)) {
                      widget._selected.remove(widget._items[index].id);
                    } else {
                      widget._selected.add(widget._items[index].id);
                    }
                  });
                },
                child: Row(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(select(index) ? Icons.radio_button_on : Icons.radio_button_off,
                          color: select(index) ? Colors.blue : Colors.blueGrey)),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: linkQualifications,
      ),
    );
  }
}