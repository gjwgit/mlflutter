import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p; // Import the path package
import 'package:open_file/open_file.dart';

class DirectoryBrowserScreen extends StatefulWidget {
  @override
  _DirectoryBrowserScreenState createState() => _DirectoryBrowserScreenState();
}

class _DirectoryBrowserScreenState extends State<DirectoryBrowserScreen> {
  Directory? rootDir;

  @override
  void initState() {
    super.initState();
    _initRootDirectory();
  }

  Future<void> _initRootDirectory() async {
    // Get the application's document directory and create a "files" subfolder.
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory root = Directory(p.join(appDocDir.path, 'files'));
    if (!await root.exists()) {
      await root.create(recursive: true);
      // Create sample structure: a subfolder and sample files.
      Directory subfolder = Directory(p.join(root.path, 'Subfolder'));
      await subfolder.create();
      File(p.join(root.path, 'sample.txt'))
          .writeAsStringSync("This is a sample file in the root directory.");
      File(p.join(subfolder.path, 'nested.txt'))
          .writeAsStringSync("This is a file inside a subfolder.");
    }
    setState(() {
      rootDir = root;
    });
  }

  Future<void> _uploadFile() async {
    // Pick a file from the local system.
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File pickedFile = File(result.files.single.path!);
      String fileName = p.basename(pickedFile.path);
      File destination = File(p.join(rootDir!.path, fileName));
      await pickedFile.copy(destination.path);
      setState(() {}); // Refresh the UI after upload.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded to ${destination.path}")),
      );
    }
  }

  Future<void> _refresh() async {
    setState(() {}); // Simply trigger a rebuild.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directory File Browser'),
        actions: [
          IconButton(icon: Icon(Icons.file_upload), onPressed: _uploadFile),
          IconButton(icon: Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: rootDir == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DirectoryItem(directory: rootDir!),
            ),
    );
  }
}

/// Widget to recursively display a directory’s content using an ExpansionTile.
class DirectoryItem extends StatefulWidget {
  final Directory directory;
  DirectoryItem({required this.directory});

  @override
  _DirectoryItemState createState() => _DirectoryItemState();
}

class _DirectoryItemState extends State<DirectoryItem> {
  late List<FileSystemEntity> children;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  void _loadChildren() {
    children = widget.directory.listSync();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        leading: Icon(Icons.folder),
        title: Text(p.basename(widget.directory.path)),
        children: children.map((entity) {
          if (entity is Directory) {
            return DirectoryItem(directory: entity);
          } else {
            return FileItem(file: entity as File);
          }
        }).toList(),
      ),
    );
  }
}

/// Widget representing an individual file with options for viewing, opening externally, and downloading.
class FileItem extends StatelessWidget {
  final File file;
  FileItem({required this.file});

  Future<void> _viewFileInternally(BuildContext context) async {
    try {
      String content = await file.readAsString();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FileViewerPage(file: file, content: content),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot view file internally")),
      );
    }
  }

  void _openFileExternally() {
    OpenFile.open(file.path);
  }

  Future<void> _downloadFile(BuildContext context) async {
    // Create a "downloads" folder in the app documents directory.
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory downloadsDir = Directory(p.join(appDocDir.path, 'downloads'));
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    String fileName = p.basename(file.path);
    File destination = File(p.join(downloadsDir.path, fileName));
    await file.copy(destination.path);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloaded to ${destination.path}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text(p.basename(file.path)),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'view') {
            _viewFileInternally(context);
          } else if (value == 'external') {
            _openFileExternally();
          } else if (value == 'download') {
            await _downloadFile(context);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'view',
            child: Text("View in App"),
          ),
          PopupMenuItem(
            value: 'external',
            child: Text("Open Externally"),
          ),
          PopupMenuItem(
            value: 'download',
            child: Text("Download"),
          ),
        ],
      ),
    );
  }
}

/// A screen to view file content internally.
class FileViewerPage extends StatelessWidget {
  final File file;
  final String content;
  FileViewerPage({required this.file, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(p.basename(file.path)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text(content)),
      ),
    );
  }
}