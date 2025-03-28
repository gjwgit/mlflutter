import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectoryEntry {
  final String name;
  final String uri;
  final bool isDirectory;

  DirectoryEntry({
    required this.name,
    required this.uri,
    required this.isDirectory,
  });

  factory DirectoryEntry.fromJson(Map<String, dynamic> json) {
    return DirectoryEntry(
      name: json['name'],
      uri: json['uri'],
      isDirectory: json['isDirectory'] as bool,
    );
  }
}


class FileBrowser extends StatefulWidget {
  final String baseUri;
  const FileBrowser({Key? key, required this.baseUri}) : super(key: key);

  @override
  _FileBrowserState createState() => _FileBrowserState();
}



Future<List<DirectoryEntry>> fetchDirectoryEntries(String uri) async {
    // Simulate network delay.
  await Future.delayed(Duration(seconds: 1));

  // Return dummy data.
  return [
    DirectoryEntry(name: 'Documents', uri: '$uri/documents', isDirectory: true),
    DirectoryEntry(name: 'Photos', uri: '$uri/photos', isDirectory: true),
    DirectoryEntry(name: 'File1.txt', uri: '$uri/file1.txt', isDirectory: false),
    DirectoryEntry(name: 'File2.pdf', uri: '$uri/file2.pdf', isDirectory: false),
  ];
  // final response = await http.get(Uri.parse(uri));
  // if (response.statusCode == 200) {
  //   final List<dynamic> data = jsonDecode(response.body);
  //   return data.map((entry) => DirectoryEntry.fromJson(entry)).toList();
  // } else {
  //   throw Exception('Failed to load directory entries');
  // }
}


class _FileBrowserState extends State<FileBrowser> {
  late Future<List<DirectoryEntry>> futureEntries;

  @override
  void initState() {
    super.initState();
    futureEntries = fetchDirectoryEntries(widget.baseUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browsing: ${widget.baseUri}"),
      ),
      body: FutureBuilder<List<DirectoryEntry>>(
        future: futureEntries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data ?? [];
          // Optionally sort: directories first, then files.
          entries.sort((a, b) {
            if (a.isDirectory && !b.isDirectory) return -1;
            if (!a.isDirectory && b.isDirectory) return 1;
            return a.name.compareTo(b.name);
          });
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                leading: Icon(
                  entry.isDirectory ? Icons.folder : Icons.insert_drive_file,
                ),
                title: Text(entry.name),
                onTap: () {
                  if (entry.isDirectory) {
                    // Navigate to a new instance of the browser with the directory's URI.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FileBrowser(baseUri: entry.uri),
                      ),
                    );
                  } else {
                    // Handle file tap (e.g., open a preview or download).
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("File tapped: ${entry.name}")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
