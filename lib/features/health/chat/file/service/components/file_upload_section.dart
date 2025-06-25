/// File upload section component for the file service feature.
///
// Time-stamp: <Thursday 2025-06-26 08:10:18 +1000 Graham Williams>
///
/// Copyright (C) 2024-2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Ashley Tang

library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:solidpod/solidpod.dart';

import 'package:mlflutter/features/health/chat/file/service/providers/file_service_provider.dart';

/// A widget that handles file upload functionality and preview.
///
/// This component provides UI elements for selecting and uploading files,
/// including a file picker button and upload status indicators.

class FileUploadSection extends ConsumerStatefulWidget {
  const FileUploadSection({super.key});

  @override
  ConsumerState<FileUploadSection> createState() => _FileUploadSectionState();
}

class _FileUploadSectionState extends ConsumerState<FileUploadSection> {
  String? filePreview;
  bool showPreview = false;

  /// Handles file preview before upload to display its content or basic info.

  Future<List<String>> performDownload(List<String> remotePaths) async {
    if (remotePaths.isEmpty) return [];

    final List<String> localPaths = [];

    try {
      if (!context.mounted) return [];

      await getKeyFromUserIfRequired(
        context,
        const Text('Please enter your security key to download the files'),
      );

      if (!context.mounted) return [];

      final tempDir = await getTemporaryDirectory();

      for (final remotePath in remotePaths) {
        final fileName = remotePath.split('/').last.replaceAll('.enc.ttl', '');
        final localPath = '${tempDir.path}/mlflutter/$fileName';

        final fileContent = await readPod(
          'mlflutter/data/$remotePath',
          context,
          Text('Downloading $fileName'),
        );

        if (fileContent == SolidFunctionCallStatus.fail.toString() ||
            fileContent == SolidFunctionCallStatus.notLoggedIn.toString()) {
          throw Exception(
            'Download failed for $remotePath - check your connection and permissions',
          );
        }

        await saveDecryptedContent(fileContent, localPath);
        localPaths.add(localPath);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All files downloaded successfully'),
            backgroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showAlert(context, 'Download error: ${e.toString()}');
        debugPrint('Download error: $e');
      }
    }

    debugPrint(localPaths.toString());

    return localPaths;
  }

  Future<String> performEmbedding(List<String> files) async {
    await Future.delayed(Duration(seconds: 5));
    // Pretend embedding merges files into a single embedded string
    return 'embedded_${files.join('_')}';
  }

  Future<void> performUpload(String embeddedData) async {
    await Future.delayed(Duration(seconds: 5));
    // Pretend this uploads the embedded data
  }

  /// Handles file preview before upload to display its content or basic info.

  Future<void> handlePreview(String filePath) async {
    try {
      final file = File(filePath);
      String content;

      if (isTextFile(filePath)) {
        // For text files, show the first 500 characters.

        content = await file.readAsString();
        content =
            content.length > 500 ? '${content.substring(0, 500)}...' : content;
      } else {
        // For binary files, show their size and type.

        final bytes = await file.readAsBytes();
        content =
            'Binary file\nSize: ${(bytes.length / 1024).toStringAsFixed(2)} KB\nType: ${path.extension(filePath)}';
      }

      setState(() {
        filePreview = content;
        showPreview = true;
      });
    } catch (e) {
      debugPrint('Preview error: $e');
    }
  }

  /// Builds a preview card UI to show content or info of selected file.

  Widget _buildPreviewCard() {
    if (!showPreview || filePreview == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withAlpha(10),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.preview,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preview',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: MarkdownTooltip(
                    message: '''

                    **Close Preview:** Tap here to close the file preview panel.

                    ''',
                    child: const Icon(Icons.close, size: 20),
                  ),
                  onPressed: () => setState(() => showPreview = false),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Text(
                filePreview!,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileServiceProvider);
    // final isInBpDirectory =
    //     state.currentPath?.contains('blood_pressure') ?? false;
    // final isInVaccinationDirectory =
    //     state.currentPath?.contains('vaccination') ?? false;
    // final isInProfileDirectory =
    //     state.currentPath?.contains('profile') ?? false;
    // final showCsvButtons = isInBpDirectory || isInVaccinationDirectory;
    // final showProfileImportButton = isInProfileDirectory;
    final anyFilesSelected = state.selectedFiles?.isNotEmpty ?? false;
    final isButtonEnabled = !state.uploadInProgress && anyFilesSelected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title.

        const Text(
          'Upload Files',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Display preview card if enabled.

        _buildPreviewCard(),
        if (showPreview) const SizedBox(height: 16),

        // Show selected file info.

        if (state.uploadFile != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.file_present,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    path.basename(state.uploadFile!),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (state.uploadDone)
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              ],
            ),
          ),
        if (state.uploadFile != null) const SizedBox(height: 16),

        // Upload and CSV buttons row.

        Row(
          children: [
            // Main upload button.

            Expanded(
              child: MarkdownTooltip(
                message: '''

                **Upload**: Tap here to upload a file to your Solid Health Pod.

                ''',
                child: ElevatedButton.icon(
                  onPressed: state.uploadInProgress
                      ? null
                      : () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null && result.files.isNotEmpty) {
                            final file = result.files.first;
                            if (file.path != null) {
                              if (file.extension?.toLowerCase() == 'none') {
                                // await convertPDFToJsonUpload(File(file.path!));
                              } else {
                                ref
                                    .read(fileServiceProvider.notifier)
                                    .setUploadFile(file.path);
                                await handlePreview(file.path!);
                                if (!context.mounted) return;
                                await ref
                                    .read(fileServiceProvider.notifier)
                                    .handleUpload(context);
                              }
                            }
                          }
                        },
                  icon: Icon(
                    Icons.file_upload,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label: const Text('Upload File to POD'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            // Main upload button.

            Expanded(
              child: MarkdownTooltip(
                message: '''

        **Embed**: Tap here to select a file and generate its context embeddings.

        ''',
                child: ElevatedButton.icon(
                  onPressed: isButtonEnabled
                      ? () async {
                          List<String> selectedFiles =
                              state.selectedFiles ?? [];

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              int step = 0;
                              bool isConfirmed = false;
                              bool isCancelled = false;
                              String? errorMessage; // New: To hold error state

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  Future<void> runSteps() async {
                                    try {
                                      setState(() => step = 1);
                                      List<String> downloadedFiles =
                                          await performDownload(selectedFiles);
                                      if (isCancelled) return;

                                      setState(() => step = 2);
                                      String embeddedResult =
                                          await performEmbedding(
                                        downloadedFiles,
                                      );
                                      if (isCancelled) return;

                                      setState(() => step = 3);
                                      await performUpload(embeddedResult);

                                      if (isCancelled) return;

                                      Navigator.of(context)
                                          .pop(); // Done, close dialog
                                    } catch (e) {
                                      setState(() {
                                        errorMessage =
                                            'An error occurred at step $step: $e';
                                      });
                                    }
                                  }

                                  if (isConfirmed && step == 0) {
                                    runSteps();
                                  }

                                  return AlertDialog(
                                    title: Text('Embed Context'),
                                    content: isConfirmed
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (errorMessage != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 8.0,
                                                  ),
                                                  child: Text(
                                                    errorMessage!,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ListTile(
                                                leading: step == 0
                                                    ? Icon(
                                                        Icons.download_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 1
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Downloading files...',
                                                ),
                                              ),
                                              ListTile(
                                                leading: step < 2
                                                    ? Icon(
                                                        Icons.memory_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 2
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Running embedding...',
                                                ),
                                              ),
                                              ListTile(
                                                leading: step < 3
                                                    ? Icon(
                                                        Icons.upload_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 3
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Uploading embedding...',
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Selected Files:'),
                                              ...selectedFiles.map(
                                                (file) => ListTile(
                                                  title: Text(file),
                                                  leading: Icon(
                                                    Icons.insert_drive_file,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    actions: [
                                      if (!isConfirmed)
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel'),
                                        ),
                                      if (!isConfirmed)
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() => isConfirmed = true);
                                          },
                                          child: Text('Confirm'),
                                        ),
                                      if (isConfirmed && step < 3)
                                        TextButton(
                                          onPressed: () {
                                            isCancelled = true;
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      : null,
                  icon: Icon(
                    Icons.memory,
                    color: isButtonEnabled
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).disabledColor,
                  ),
                  label: const Text('Embed Context'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isButtonEnabled
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.12),
                    foregroundColor: isButtonEnabled
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            // Main upload button.

            Expanded(
              child: MarkdownTooltip(
                message: '''

        **Download Context**: Tap here to download your health data context embeddings to use used in chat.

        ''',
                child: ElevatedButton.icon(
                  onPressed: isButtonEnabled
                      ? () async {
                          List<String> selectedFiles =
                              state.selectedFiles ?? [];

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              int step = 0;
                              bool isConfirmed = false;
                              bool isCancelled = false;
                              String? errorMessage; // New: To hold error state

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  Future<void> runSteps() async {
                                    try {
                                      setState(() => step = 1);
                                      List<String> downloadedFiles =
                                          await performDownload(selectedFiles);
                                      if (isCancelled) return;

                                      setState(() => step = 2);
                                      String embeddedResult =
                                          await performEmbedding(
                                        downloadedFiles,
                                      );
                                      if (isCancelled) return;

                                      setState(() => step = 3);
                                      await performUpload(embeddedResult);

                                      if (isCancelled) return;

                                      Navigator.of(context)
                                          .pop(); // Done, close dialog
                                    } catch (e) {
                                      setState(() {
                                        errorMessage =
                                            'An error occurred at step $step: $e';
                                      });
                                    }
                                  }

                                  if (isConfirmed && step == 0) {
                                    runSteps();
                                  }

                                  return AlertDialog(
                                    title: Text('Download Context'),
                                    content: isConfirmed
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (errorMessage != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom: 8.0,
                                                  ),
                                                  child: Text(
                                                    errorMessage!,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ListTile(
                                                leading: step == 0
                                                    ? Icon(
                                                        Icons.download_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 1
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Downloading files...',
                                                ),
                                              ),
                                              ListTile(
                                                leading: step < 2
                                                    ? Icon(
                                                        Icons.memory_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 2
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Running embedding...',
                                                ),
                                              ),
                                              ListTile(
                                                leading: step < 3
                                                    ? Icon(
                                                        Icons.upload_outlined,
                                                        color: Colors.grey,
                                                      )
                                                    : step == 3
                                                        ? CircularProgressIndicator()
                                                        : Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                title: Text(
                                                  'Uploading embedding...',
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Selected Files:'),
                                              ...selectedFiles.map(
                                                (file) => ListTile(
                                                  title: Text(file),
                                                  leading: Icon(
                                                    Icons.insert_drive_file,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    actions: [
                                      if (!isConfirmed)
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel'),
                                        ),
                                      if (!isConfirmed)
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() => isConfirmed = true);
                                          },
                                          child: Text('Confirm'),
                                        ),
                                      if (isConfirmed && step < 3)
                                        TextButton(
                                          onPressed: () {
                                            isCancelled = true;
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }
                      : null,
                  icon: Icon(
                    Icons.download,
                    color: isButtonEnabled
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).disabledColor,
                  ),
                  label: const Text('Download Context'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: isButtonEnabled
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context)
                            .disabledColor
                            .withValues(alpha: 0.12),
                    foregroundColor: isButtonEnabled
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Preview button.

        if (state.uploadFile != null) ...[
          const SizedBox(height: 12),
          MarkdownTooltip(
            message: '''

            **Preview File**: Tap here to preview the recently uploaded file.

            ''',
            child: TextButton.icon(
              onPressed: state.uploadInProgress
                  ? null
                  : () => handlePreview(state.uploadFile!),
              icon: const Icon(Icons.preview),
              label: const Text('Preview File'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }
}
