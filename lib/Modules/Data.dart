import 'package:mlflutter/Modules/Member.dart';
import 'package:mlflutter/Modules/Room.dart';
import 'package:flutter/cupertino.dart';

const Color KClubhouseColor = Color(0xfff1efe4);

final List<Member> packages = [
  Member(
    name: 'audit',
    profilePicture: 'assets/audit.png',
  ),
  Member(
    name: 'azcv',
    profilePicture: 'assets/azcv.png',
  ),
  Member(
    name: 'azspeech',
    profilePicture: 'assets/azspeech.png',
  ),
  Member(
    name: 'aztext',
    profilePicture: 'assets/aztext.png',
  ),
  Member(
    name: 'cars',
    profilePicture: 'assets/cars.png',
  ),
  Member(
    name: 'colorize',
    profilePicture: 'assets/colorize.jpg',
  ),
  Member(
    name: 'deepspeech',
    profilePicture: 'assets/deepspeech.png',
  ),
  Member(
    name: 'cvbp',
    profilePicture: 'assets/cvbp.jpg',
  ),
  Member(
    name: 'easyocr',
    profilePicture: 'assets/easyocr.png',
  ),
  Member(
    name: 'facedetect',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'facematch',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'movies',
    profilePicture: 'assets/movies.png',
  ),
  Member(
    name: 'objects',
    profilePicture: 'assets/objects.png',
  ),
  Member(
    name: 'ocsvm',
    profilePicture: 'assets/ocsvm.png',
  ),
  Member(
    name: 'opencv',
    profilePicture: 'assets/opencv.png',
  ),
  Member(
    name: 'pyiris',
    profilePicture: 'assets/iris.png',
  ),
  Member(
    name: 'pyspeech',
    profilePicture: 'assets/pyspeech.png',
  ),
  Member(
    name: 'rain',
    profilePicture: 'assets/rain.png',
  ),
  Member(
    name: 'webcam',
    profilePicture: 'assets/webcam.png',
  ),
];

final List<Room> rooms = [
  Room(
    name: 'Classification',
    description: 'AI models that classify things.',
    audience: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'cars',
        profilePicture: 'assets/cars.png',
      ),
      Member(
        name: 'iris',
        profilePicture: 'assets/iris.png',
      ),
      Member(
        name: 'objects',
        profilePicture: 'assets/objects.png',
      ),
      Member(
        name: 'ocsvm',
        profilePicture: 'assets/ocsvm.png',
      ),
      Member(
        name: 'pyiris',
        profilePicture: 'assets/iris.png',
      ),
      Member(
        name: 'rain',
        profilePicture: 'assets/rain.png',
      ),
      Member(
        name: 'sgnc',
        profilePicture: 'assets/sgnc.png',
      ),
    ],
  ),
  Room(
    name: 'Computer Vision',
    description: 'AI models for seeing things.',
    audience: [
      Member(
        name: 'azcv',
        profilePicture: 'assets/azcv.png',
      ),
      Member(
        name: 'cars',
        profilePicture: 'assets/cars.png',
      ),
      Member(
        name: 'colorize',
        profilePicture: 'assets/colorize.jpg',
      ),
      Member(
        name: 'cvbp',
        profilePicture: 'assets/cvbp.jpg',
      ),
      Member(
        name: 'easyocr',
        profilePicture: 'assets/easyocr.png',
      ),
      Member(
        name: 'facedetect',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'facematch',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'objects',
        profilePicture: 'assets/objects.png',
      ),
      Member(
        name: 'opencv',
        profilePicture: 'assets/opencv.png',
      ),
      Member(
        name: 'webcam',
        profilePicture: 'assets/webcam.png',
      ),
    ],
  ),
  Room(
    name: 'Natural Language Processing',
    description: 'AI models that listen and talk.',
    audience: [
      Member(
        name: 'azspeech',
        profilePicture: 'assets/azspeech.png',
      ),
      Member(
        name: 'aztext',
        profilePicture: 'assets/aztext.png',
      ),
      Member(
        name: 'deepspeech',
        profilePicture: 'assets/deepspeech.png',
      ),
      Member(
        name: 'pyspeech',
        profilePicture: 'assets/pyspeech.png',
      ),
    ],
  ),
  Room(
    name: 'Prediction',
    description: 'AI models that predict things.',
    audience: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'rain',
        profilePicture: 'assets/rain.png',
      ),
      Member(
        name: 'pyiris',
        profilePicture: 'assets/iris.png',
      ),
      Member(
        name: 'movies',
        profilePicture: 'assets/movies.png',
      ),
      Member(
        name: 'ocsvm',
        profilePicture: 'assets/ocsvm.png',
      ),
    ],
  ),
];
