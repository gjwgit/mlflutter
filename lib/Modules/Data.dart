import 'package:clubhouse/Modules/Member.dart';
import 'package:clubhouse/Modules/Room.dart';
import 'package:flutter/cupertino.dart';

const Color KClubhouseColor = Color(0xfff1efe4);

final List<Member> available = [
  Member(
    name: 'Do',
    profilePicture: 'assets/c1.jpg',
  ),
  Member(
    name: 'John',
    profilePicture: 'assets/c2.jpg',
  ),
  Member(
    name: 'Sara',
    profilePicture: 'assets/c4.jpeg',
  ),
  Member(
    name: 'Tyler',
    profilePicture: 'assets/c5.jpeg',
  ),
  Member(
    name: 'Rob',
    profilePicture: 'assets/c1.jpg',
  ),
  Member(
    name: 'Kal',
    profilePicture: 'assets/c5.jpeg',
  ),
  Member(
    name: 'Ade',
    profilePicture: 'assets/c4.jpeg',
  ),
  Member(
    name: 'Minh',
    profilePicture: 'assets/c2.jpg',
  ),
];

final List<Room> rooms = [
  Room(
    // Keyword/Category
    name: 'Computer Vision',
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
    name: 'Photographers',
    speakers: [
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
    audience: [
      Member(
        name: 'Rob',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'John',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Kal',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Ade',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Minh',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Do',
        profilePicture: 'assets/c1.jpg',
      ),
    ],
  ),
  Room(
    name: 'Personal Brand',
    speakers: [
      Member(
        name: 'Rob',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'John',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
    audience: [
      Member(
        name: 'Rob',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'John',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Kal',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Ade',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Minh',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Do',
        profilePicture: 'assets/c1.jpg',
      ),
    ],
  ),
  Room(
    name: 'Photographers',
    speakers: [
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
    audience: [
      Member(
        name: 'Rob',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'John',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Kal',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Ade',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Minh',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Do',
        profilePicture: 'assets/c1.jpg',
      ),
    ],
  ),
  Room(
    name: 'Photographers',
    speakers: [
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
    ],
    audience: [
      Member(
        name: 'Rob',
        profilePicture: 'assets/c1.jpg',
      ),
      Member(
        name: 'John',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Sara',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Tyler',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Kal',
        profilePicture: 'assets/c5.jpeg',
      ),
      Member(
        name: 'Ade',
        profilePicture: 'assets/c4.jpeg',
      ),
      Member(
        name: 'Minh',
        profilePicture: 'assets/c2.jpg',
      ),
      Member(
        name: 'Do',
        profilePicture: 'assets/c1.jpg',
      ),
    ],
  ),
];
