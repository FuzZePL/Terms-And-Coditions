import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/models/filter.dart';
import 'package:flutter/material.dart';

const String tableFavoriteItem = 'favoriteTable';

class FavoriteItemFileds {
  static final List<String> values = [
    idDatabase,
    id,
    name,
    description,
    pictures,
    filter,
    createdBy,
    idCreatedBy,
    school,
  ];

  static const String idDatabase = 'idDatabase';
  static const String id = 'id';
  static const String name = 'name';
  static const String description = 'description';
  static const String pictures = 'pictures';
  static const String filter = 'filter';
  static const String createdBy = 'createdBy';
  static const String idCreatedBy = 'idCreatedBy';
  static const String school = 'school';
}

class Note {
  final int? idDatabase;
  final String id;
  String name;
  final String description;
  dynamic pictures;
  final FilterOwn filter;
  final AppUser createdBy;
  final String idCreatedBy;
  final String school;
  List<dynamic>? listOfStringPictures;

  Note({
    this.idDatabase,
    required this.id,
    required this.name,
    required this.description,
    required this.pictures,
    required this.filter,
    required this.createdBy,
    required this.idCreatedBy,
    required this.school,
    this.listOfStringPictures,
  });

  Note copy({
    int? idDatabase,
    String? id,
    String? name,
    String? description,
    List<dynamic>? pictures,
    FilterOwn? filter,
    AppUser? createdBy,
    String? idCreatedBy,
    String? school,
  }) =>
      Note(
        idDatabase: idDatabase ?? this.idDatabase,
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        pictures: pictures ?? this.pictures,
        filter: filter ?? this.filter,
        createdBy: createdBy ?? this.createdBy,
        idCreatedBy: idCreatedBy ?? this.idCreatedBy,
        school: school ?? this.school,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
        idDatabase: json[FavoriteItemFileds.idDatabase] as int,
        id: json[FavoriteItemFileds.id] as String,
        name: json[FavoriteItemFileds.name] as String,
        description: json[FavoriteItemFileds.description] as String,
        pictures: json[FavoriteItemFileds.pictures] as dynamic,
        filter: json[FavoriteItemFileds.filter] as FilterOwn,
        createdBy: json[FavoriteItemFileds.createdBy] as AppUser,
        idCreatedBy: json[FavoriteItemFileds.idCreatedBy] as String,
        school: json[FavoriteItemFileds.school] as String,
      );

  Map<String, Object?> toJson() => {
        FavoriteItemFileds.idDatabase: idDatabase,
        FavoriteItemFileds.id: id,
        FavoriteItemFileds.name: name,
        FavoriteItemFileds.description: description,
        FavoriteItemFileds.pictures: pictures,
        FavoriteItemFileds.filter: filter,
        FavoriteItemFileds.createdBy: createdBy,
        FavoriteItemFileds.idCreatedBy: idCreatedBy,
        FavoriteItemFileds.school: school,
      };

  // convert pictures to map

  static Note fromMap(Map<String, dynamic> map) {
    FilterOwn filterOwn = FilterOwn(UniqueKey().toString(), map['listOfType'],
        false, map['level'], map['school']);
    return Note(
      id: map['id'],
      name: map['title'],
      description: map['description'],
      pictures: map['imageList'],
      filter: filterOwn,
      createdBy: AppUser.fromMapLimited(map['createdBy']),
      idCreatedBy: map['idCreatedBy'],
      school: map['school'],
    );
  }
}
