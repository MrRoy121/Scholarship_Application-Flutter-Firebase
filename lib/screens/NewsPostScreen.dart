import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../models/article_model.dart';

class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Post App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsPostScreen(),
    );
  }
}

class NewsPostScreen extends StatefulWidget {
  @override
  _NewsPostScreenState createState() => _NewsPostScreenState();
}

class _NewsPostScreenState extends State<NewsPostScreen> {
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _readMoreUrlController = TextEditingController();
  final _applyUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedImagePath;
  DateTime? _publishDate;
  DateTime? _lastSubmitDate;
  MultiSelectController<String> listcontroller1 = MultiSelectController(), listcontroller2 = MultiSelectController();
  List<String> selectedCountries = [];
  List<String> selectedTypes = [];


  Future<void> _submitData() async {
    if (_titleController.text.isEmpty ||
        selectedCountries.isEmpty ||
        selectedTypes.isEmpty ||
        (_imageUrlController.text.isEmpty && _selectedImagePath == null) ||
        _publishDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title, Country, Type, Image (URL or File), Publish Date is Required!')),
      );
      return;
    }

    String? imageUrl;

    if (_selectedImagePath != null) {
      try {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance.ref().child('images/$fileName');

        UploadTask uploadTask = storageRef.putFile(File(_selectedImagePath!));
        TaskSnapshot snapshot = await uploadTask;

        imageUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image.')),
        );
        return;
      }
    } else {
      imageUrl = _imageUrlController.text;
    }

    final data = {
      'title': _titleController.text,
      'country': selectedCountries.map((item) {
        return Contries.indexOf(item).toString();
      }).toList(),
      'type': selectedTypes.map((item) {
        return (typess.indexOf(item) + 1).toString();
      }).toList(),
      'img_url': imageUrl,
      'read_more_url': _readMoreUrlController.text,
      'apply_url': _applyUrlController.text,
      'publishedDate': _publishDate,
      'lastApplyDate': _lastSubmitDate ?? DateTime.now(),
      'content': _descriptionController.text,
    };

    try {
      await FirebaseFirestore.instance.collection('news').add(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('News article posted successfully!')),
      );

      _titleController.clear();
      _imageUrlController.clear();
      _readMoreUrlController.clear();
      _applyUrlController.clear();
      _descriptionController.clear();
      listcontroller1.clearAll();
      listcontroller2.clearAll();
      setState(() {
        selectedCountries.clear();
        selectedTypes.clear();
        _publishDate = null;
        _lastSubmitDate = null;
        _selectedImagePath = null;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post news article.')),
      );
    }
  }


  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _selectedImagePath = selectedImage.path;
        _imageUrlController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post News Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _titleController,
                maxLines: 2,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Text('Country:', style: TextStyle(fontSize: 16)),
              MultiDropdown<String>(
                items: Contries.map((str) {
                  return DropdownItem(label: str, value: str);
                }).toList(),
                enabled: true,
                controller: listcontroller1,
                searchEnabled: true,
                chipDecoration: const ChipDecoration(
                  backgroundColor: Colors.yellow,
                  wrap: true,
                  runSpacing: 2,
                  spacing: 10,
                ),
                fieldDecoration: FieldDecoration(
                  hintText: 'Countries',
                  hintStyle: const TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(Icons.flag),
                  showClearIcon: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                    ),
                  ),
                ),
                dropdownDecoration: const DropdownDecoration(
                  marginTop: 2,
                  maxHeight: 500,
                  header: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Select countries from the list',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                  disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
                onSelectionChange: (selectedItems) {
                  setState(() {
                    selectedCountries = selectedItems;
                  });
                  debugPrint("OnSelectionChange: $selectedItems");
                },
              ),
              SizedBox(height: 16),
              Text('Type:', style: TextStyle(fontSize: 16)),
              MultiDropdown<String>(
                items: typess.map((str) {
                  return DropdownItem(label: str, value: str);
                }).toList(),
                enabled: true,
                controller: listcontroller2,
                searchEnabled: true,
                chipDecoration: const ChipDecoration(
                  backgroundColor: Colors.yellow,
                  wrap: true,
                  runSpacing: 2,
                  spacing: 10,
                ),
                fieldDecoration: FieldDecoration(
                  hintText: 'Types',
                  hintStyle: const TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(Icons.category),
                  showClearIcon: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                ),
                dropdownDecoration: const DropdownDecoration(
                  marginTop: 2,
                  maxHeight: 500,
                  header: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Select types from the list',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                  disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
                onSelectionChange: (selectedItems) {
                  setState(() {
                    selectedTypes = selectedItems;
                  });
                  debugPrint("OnSelectionChange: $selectedItems");
                },
              ),
              SizedBox(height: 16),
              Text('Image URL or Select Image:', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        hintText: 'Enter Image URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: _selectImage,
                  ),
                ],
              ),
              if (_selectedImagePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Selected Image: $_selectedImagePath'),
                ),
              SizedBox(height: 16),
              Text('Publish Date:', style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _publishDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _publishDate = pickedDate;
                    });
                  }
                },
                child: Text(_publishDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_publishDate!)),
              ),
              SizedBox(height: 16),
              Text('Last Submit Date:', style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _lastSubmitDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _lastSubmitDate = pickedDate;
                    });
                  }
                },
                child: Text(_lastSubmitDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_lastSubmitDate!)),
              ),
              SizedBox(height: 16),
              Text('Read More URL:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _readMoreUrlController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Text('Apply URL:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _applyUrlController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Text('Description:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _submitData,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
