import 'package:mlflutter/Modules/Member.dart';
import 'package:mlflutter/Modules/Room.dart';
import 'package:flutter/cupertino.dart';

const Color KClubhouseColor = Color(0xfff1efe4);

final List<Member> available = [
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
    name: 'cars',
    profilePicture: 'assets/cars.jpg',
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
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'easyocr',
    profilePicture: 'assets/c2.jpg',
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
    profilePicture: 'assets/c5.jpeg',
  ),
  Member(
    name: 'objects',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'ocsvm',
    profilePicture: 'assets/c5.jpeg',
  ),
  Member(
    name: 'opencv',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'pyiris',
    profilePicture: 'assets/c4.jpeg',
  ),
  Member(
    name: 'pyspeech',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'rain',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'webcam',
    profilePicture: 'assets/c2.jpg',
  ),
];

final List<Room> rooms = [
  Room(
    name: 'Classification',
    description: 'AI models that classify things.',
    speakers: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'cars',
        profilePicture: 'assets/cars.jpg',
      ),
    ],
    audience: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'cars',
        profilePicture: 'assets/cars.jpg',
      ),
      Member(
        name: 'iris',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'objects',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'ocsvm',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'pyiris',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'rain',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'sgnc',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
  ),
  Room(
    name: 'Computer Vision',
    description: 'AI models for seeing things.',
    // Randomly select 2 to display here.
    speakers: [
      Member(
        name: 'azcv',
        profilePicture: 'assets/azcv.png',
      ),
      Member(
        name: 'colorize',
        profilePicture: 'assets/colorize.jpg',
      ),
    ],
    // Display all of them in this category here.
    audience: [
      Member(
        name: 'azcv',
        profilePicture: 'assets/azcv.png',
      ),
      Member(
        name: 'cars',
        profilePicture: 'assets/cars.jpg',
      ),
      Member(
        name: 'colorize',
        profilePicture: 'assets/colorize.jpg',
      ),
      Member(
        name: 'cvbp',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'easyocr',
        profilePicture: 'assets/c2.jpg',
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
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'opencv',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'webcam',
        profilePicture: 'assets/c1.jpg',
      ),
    ],
  ),
  Room(
    name: 'Natural Language Processing',
    description: 'AI models that listen and talk.',
    speakers: [
      Member(
        name: 'azspeech',
        profilePicture: 'assets/azspeech.png',
      ),
      Member(
        name: 'deepspeech',
        profilePicture: 'assets/deepspeech.png',
      ),
    ],
    audience: [
      Member(
        name: 'azspeech',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'aztext',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'deepspeech',
        profilePicture: 'assets/deepspeech.png',
      ),
      Member(
        name: 'pyspeech',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
  ),
  Room(
    name: 'Prediction',
    description: 'AI models that predict things.',
    speakers: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'iris',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
    audience: [
      Member(
        name: 'audit',
        profilePicture: 'assets/audit.png',
      ),
      Member(
        name: 'rain',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'pyiris',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'movies',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'ocsvm',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
  ),
];
