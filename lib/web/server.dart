import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/models/filter.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/note.dart';
import '../screens/login/auth_screen.dart';

class Server {
  static Future<void> logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  static bool isLogged() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return true;
    }
    return false;
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> authUser(String email, String password, String username,
      String school, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential authResult;

    authResult = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String url =
        'https://firebasestorage.googleapis.com/v0/b/donotnote-d6d2b.appspot.com/o/user_icon-icons.png?alt=media&token=9d11af13-d68c-4997-b0d2-c0f6c4d27048';

    FirebaseMessaging fbm = FirebaseMessaging.instance;
    String? token = await fbm.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set({
      'username': username,
      'email': email,
      'image': url,
      'school': school,
      'token': token,
      'pkt': 0,
    });
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<List<Note>> getSuggestedNotes(AppUser user) async {
    final List<Note> noteList = [];
    final QuerySnapshot<Map<String, dynamic>> notes = await FirebaseFirestore
        .instance
        .collection('notesPublish')
        .limit(10)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in notes.docs) {
      noteList.add(Note.fromMap(i.data()));
    }
    /*  for (int i = 0; i < noteList.length; i++) {
      noteList[i].pictures =
          await downloadImageToVariable(noteList[i].pictures);
    } */
    return noteList;
  }

  static Future<AppUser> getUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    AppUser toReturn = AppUser(
      userData.id,
      userData['email'],
      userData['username'],
      userData['school'],
      userData['image'],
      userData['token'],
      userData['pkt'],
    );
    return toReturn;
  }

  static Future<List<Note>> getUserNotes(AppUser user) async {
    List<Note> userNote = [];

    final QuerySnapshot<Map<String, dynamic>> userNotes =
        await FirebaseFirestore.instance
            .collection('notesPublish')
            .where('idCreatedBy', isEqualTo: user.id)
            .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> i in userNotes.docs) {
      userNote.add(Note.fromMap(i.data()));
    }
    for (int i = 0; i < userNote.length; i++) {
      userNote[i].listOfStringPictures = userNote[i].pictures;
    }
    return userNote;
  }

  static Future<void> deleteItemsFromDatabase(Note note) async {
    List<dynamic>? pictures = note.listOfStringPictures;

    await deleteNote(note);

    if (pictures != null) {
      for (String val in pictures) {
        await FirebaseStorage.instance.refFromURL(val).delete();
      }
    }
  }

  static Future<List<Note>> getFavourite(List<String> listId) async {
    if (listId.isEmpty) {
      return [];
    }
    List<Note> noteList = [];
    final QuerySnapshot<Map<String, dynamic>> notes = await FirebaseFirestore
        .instance
        .collection('notesPublish')
        .where('id', whereIn: listId)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> i in notes.docs) {
      Note note = Note.fromMap(i.data());
      noteList.insert(0, note);
    }
    return noteList;
  }

  static Future<void> editNote(Note note, List<String> indexList) async {
    await FirebaseFirestore.instance
        .collection('notesPublish')
        .doc(note.id)
        .update({
      'title': note.name,
      'description': note.description,
      'imageList': note.pictures,
      'level': note.filter.level,
      'listOfType': note.filter.listOfType,
      'createdBy': note.createdBy.toJsonLimited(),
      'school': note.school,
      'indexList': indexList,
    });
  }

  static Future<void> createNote(Note note, List<String> indexList) async {
    await FirebaseFirestore.instance
        .collection('notesPublish')
        .doc(note.id)
        .set({
      'id': note.id,
      'title': note.name,
      'description': note.description,
      'imageList': note.pictures,
      'level': note.filter.level,
      'listOfType': note.filter.listOfType,
      'createdBy': note.createdBy.toJsonLimited(),
      'school': note.school,
      'indexList': indexList,
      'idCreatedBy': note.createdBy.id,
    });
  }

  static Future<void> editUser(AppUser newUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(newUser.id)
        .update({
      'email': newUser.email,
      'username': newUser.username,
      'image': newUser.image,
      'school': newUser.school,
    });
  }

  static Future<String> putNoteImage(
      String userId, String dateTime, int i, File imageList) async {
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('note_image')
        .child('$userId$dateTime$i.jpg');
    await ref.putFile(imageList);
    return await ref.getDownloadURL();
  }

  static Future<void> deleteImageFromDatabase(String id) async {
    await FirebaseStorage.instance.refFromURL(id).delete();
  }

  static Future<void> deleteUserAccount(
      String email, String password, BuildContext ctx) async {
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('notesPublish')
          .where('createdBy', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      user.delete();
    }).onError((error, stackTrace) {
      ConstantFunctions.showSnackBar(
        ctx,
        KColors.kErrorColor,
        KColors.kWhiteColor,
        error.toString(),
      );
    });
  }

  static Future<void> reportNote(Note note) async {
    await FirebaseFirestore.instance.collection('reports').doc(note.id).set({
      'id': note.id,
    });
  }

  static Future<void> login(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<List<Uint8List>> downloadImageToVariable(
      List<dynamic> image) async {
    final List<Uint8List> list = [];
    for (String element in image) {
      final http.Response temp = await http.get(Uri.parse(element));
      if (temp.statusCode == 200) {
        list.add(temp.bodyBytes);
      }
    }
    return list;
  }

  static Future<List<Note>> getReportedNote() async {
    List<Note> reportList = [];
    final QuerySnapshot<Map<String, dynamic>> userNotes =
        await FirebaseFirestore.instance.collection('reports').get();
    for (var i in userNotes.docs) {
      reportList.add(Note.fromMap(i.data()));
    }
    return reportList;
  }

  static Future<void> deleteNote(Note note) async {
    await FirebaseFirestore.instance
        .collection('notesPublish')
        .doc(note.id)
        .delete();
  }

  static Future<void> onDeleteReport(Note note) async {
    List<String> pictures = List<String>.from(note.pictures);

    await deleteNote(note);

    for (String val in pictures) {
      await FirebaseStorage.instance.refFromURL(val).delete();
    }
  }

  static Future<void> onDismissReport(Note note) async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(note.id)
        .delete();
  }

  static Future<List<Note>> onSearch(
      String query1, FilterOwn generalFilter) async {
    if (query1.contains('*~~@(*%&%#')) {
      final QuerySnapshot<Map<String, dynamic>> note = await FirebaseFirestore
          .instance
          .collection('notesPublish')
          .where('id', isEqualTo: query1)
          .get();
      return [Note.fromMap(note.docs[0].data())];
    }
    final String query = query1.toLowerCase();
    final List<Note> noteList = [];
    final QuerySnapshot<Map<String, dynamic>> notes;
    // TODO add better search
    if (generalFilter.listOfType.isNotEmpty) {
      if (generalFilter.onlyFromYourSchool) {
        notes = await FirebaseFirestore.instance
            .collection('notesPublish')
            .where('listOfType', whereIn: generalFilter.listOfType)
            .where('level', isEqualTo: generalFilter.level)
            .where('school', isEqualTo: generalFilter.school)
            .where('indexList', arrayContains: query)
            .limit(20)
            .get();
      } else {
        notes = await FirebaseFirestore.instance
            .collection('notesPublish')
            .where('listOfType', whereIn: generalFilter.listOfType)
            .where('level', isEqualTo: generalFilter.level)
            .where('indexList', arrayContains: query)
            .limit(20)
            .get();
      }
    } else {
      if (generalFilter.level.isEmpty) {
        notes = await FirebaseFirestore.instance
            .collection('notesPublish')
            .where('indexList', arrayContains: query)
            .limit(20)
            .get();
      } else {
        notes = await FirebaseFirestore.instance
            .collection('notesPublish')
            .where('level', isEqualTo: generalFilter.level)
            .where('indexList', arrayContains: query)
            .limit(20)
            .get();
      }
    }

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in notes.docs) {
      Note temp = Note.fromMap(i.data());
      noteList.add(temp);
    }

    return noteList;
  }

  static Future<void> signOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      AuthScreen.routeName,
    );
  }
}
