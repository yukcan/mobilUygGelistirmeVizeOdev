import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference kitaplar =
      FirebaseFirestore.instance.collection('kitaplar');

  Future<void> addBook(String kitapAdi, String yayinEvi, String yazar,
      String kategori, int sayfaSayisi, int basimYili, bool listeYayin) {
    return kitaplar.add({
      'kitapAdi': kitapAdi,
      'yayinEvi': yayinEvi,
      'yazar': yazar,
      'kategori': kategori,
      'sayfaSayisi': sayfaSayisi,
      'basimYili': basimYili,
      'listedeYayinlanacak': listeYayin
    });
  }

  Future<QuerySnapshot> readBookData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('kitaplar').get();
    return querySnapshot;
  }

  Future<void> updateBook(String bookID,String kitapAdi, String yayinEvi, String yazar,
      String kategori, int sayfaSayisi, int basimYili, bool listeYayin){
    return kitaplar.doc(bookID).update({
      'kitapAdi': kitapAdi,
      'yayinEvi': yayinEvi,
      'yazar': yazar,
      'kategori': kategori,
      'sayfaSayisi': sayfaSayisi,
      'basimYili': basimYili,
      'listedeYayinlanacak': listeYayin
    });
  }

  Future<void> deleteBook(String bookID){
    return kitaplar.doc(bookID).delete();
  }
}
