import 'package:mlflutter/Modules/Member.dart';

class Room {
  String name;            // A keyword from the package meta data.
  String description;     // A descrioption of the keyword - WHERE DEFINED?
  List<Member> speakers;  // TO BE REMOVED - RANDOMLY SELECT 2 FOR HOME SCREEN
  List<Member> audience;  // A list of package names in this category.

  Room({
      this.name,
      this.description,
      this.speakers,
      this.audience,
  });
}
