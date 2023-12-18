import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_masterclass/pages/add_book_page.dart';
import 'package:crud_masterclass/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Yüksel Caner Mülazımoğlu\nKütüphane Yönetimi"),
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: [
          Container(margin: EdgeInsets.only(right: 15) ,child: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddBookPage(data: null,bookID: null,)));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            child: const Column(children: [
              Icon(Icons.book, color: Colors.purple),
              Text("Kitaplar", style: TextStyle(color: Colors.purple),)
            ]),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35),
            child: const Column(
                children: [Icon(Icons.shopping_cart), Text("Satın Al")]),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 35),
              child: const Column(
                  children: [Icon(Icons.settings), Text("Ayarlar")]))
        ]),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestoreService.readBookData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List bookList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = bookList[index];

                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String bookID = document.id;
                String yazarAdi = data['yazar'];
                String sayfa = data['sayfaSayisi'].toString();
                if (data['listedeYayinlanacak'] == true) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(118, 250, 200, 246),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                        title: Text(
                          data['kitapAdi'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text("Yazar: $yazarAdi, Sayfa Sayısı: $sayfa"),
                        trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddBookPage(data: data,bookID: bookID,)));
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    showAlertDialog(context, bookID);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete))
                            ])),
                  );
                }
                return Container();
              },
            );
          }
          return const Text("Eklenmiş kitap yok.");
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, String bookID) {
    Widget onayButton = ElevatedButton(
        onPressed: () {
          firestoreService.deleteBook(bookID);
          Navigator.of(context).pop();
        },
        child: const Text("Evet"));
    Widget redButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("Hayır"));

    AlertDialog alert = AlertDialog(
      title: const Text("Silmek istediğinize emin misiniz?"),
      actions: [onayButton, redButton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
