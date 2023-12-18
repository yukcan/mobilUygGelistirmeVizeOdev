// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:crud_masterclass/services/firestore.dart';
import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  Map<String, dynamic>? data;
  String? bookID;
  AddBookPage({super.key, this.data, this.bookID});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  List<String> kategoriList = [
    "Roman",
    "Tarih",
    "Edebiyat",
    "Şiir",
    "Ansiklopedi"
  ];
  String? kategori;
  bool listeYayin = false;

  String kitapAdi = "", yayinEvi = "", yazar = "";
  String? sayfaSayisi, basimYili;

  final FirestoreService firestoreService = FirestoreService();

  Scaffold addBookWidget(String? bookName, String? publisher, String? author,
      String? category, String? numberOfPage, String? year, String? kitapID) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kitap Ekle"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextFormField(
                initialValue: bookName,
                onFieldSubmitted: (String value) {
                  setState(() {
                    kitapAdi = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Kitap Adı",
                ),
              ),
              TextFormField(
                initialValue: publisher,
                onFieldSubmitted: (String value) {
                  setState(() {
                    yayinEvi = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Yayınevi"),
              ),
              TextFormField(
                initialValue: author,
                onFieldSubmitted: (String value) {
                  setState(() {
                    yazar = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Yazarlar"),
              ),
              Container(
                height: 55,
                width: 400,
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Kategoriler"),
                    value: kategori,
                    items: kategoriList
                        .map((String k) => DropdownMenuItem(
                              value: k,
                              child: Text(k),
                            ))
                        .toList(),
                    onChanged: (String? secilenKategori) {
                      setState(() {
                        setState(() {
                          kategori = secilenKategori!;
                        });
                      });
                    }),
              ),
              TextFormField(
                initialValue: numberOfPage,
                onFieldSubmitted: (String value) {
                  setState(() {
                    sayfaSayisi = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Sayfa Sayısı"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: year,
                onFieldSubmitted: (String value) {
                  setState(() {
                    basimYili = value;
                  });
                },
                decoration: const InputDecoration(hintText: "Basım yılı"),
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                  title: const Text("Listede Yayınlanacak mı?"),
                  value: listeYayin,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) {
                        listeYayin = newValue;
                      }
                    });
                  }),
              Container(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kitapAdi == null ||
                          yayinEvi == null ||
                          yazar == null ||
                          kategori == null ||
                          sayfaSayisi == null ||
                          basimYili == null) {
                        showAlertDialog(context);
                      } else {
                        if (kitapID == null) {
                          firestoreService.addBook(
                              kitapAdi,
                              yayinEvi,
                              yazar,
                              kategori!,
                              int.parse(sayfaSayisi!),
                              int.parse(basimYili!),
                              listeYayin);
                          Navigator.pop(context);
                        } else {
                          firestoreService.updateBook(
                              kitapID,
                              kitapAdi,
                              yayinEvi,
                              yazar,
                              kategori!,
                              int.parse(sayfaSayisi!),
                              int.parse(basimYili!),
                              listeYayin);
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Kaydet"),
                  )),
            ],
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    Widget onayButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("Tamam"));

    AlertDialog alert = AlertDialog(
      title: const Text("Lütfen tüm seçenkleri eksiksiz doldurunuz."),
      actions: [onayButton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) {
      return addBookWidget(
          widget.data!['kitapAdi'],
          widget.data!['yayinEvi'],
          widget.data!['yazar'],
          widget.data!['kategori'],
          widget.data!['sayfaSayisi'].toString(),
          widget.data!['basimYili'].toString(),
          widget.bookID);
    }
    return addBookWidget(null, null, null, null, null, null, null);
  }
}
