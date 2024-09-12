import 'package:cloud_firestore/cloud_firestore.dart';

class firestoreservice {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  Future<void> addnote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  Stream<QuerySnapshot> getnotesstream() {
    final notesstream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesstream;
  }

  Future<void> updatenotes(String Docid, String updtext) {
    return notes.doc(Docid).update({
      'note': updtext,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deletenote(String Docid) {
    return notes.doc(Docid).delete();
  }
  //delete
  //update
}
