import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() {
    return _DiseaseDetectionScreen();
  }
}

class _DiseaseDetectionScreen extends State<DiseaseDetectionScreen> {
  String selectedCrop = 'Tomato';
  String newValuee = 'boo';

  final List<String> crops = [
    'Tomato',
    'Cucumber',
    'Eggplant',
    'Zucchini',
    'Potato',
    'Onion',
    'Watermelon',
    'Cantaloupe',
    'Grapes',
    'Pomegranate',
    'Fig',
    'Date Palm',
  ];

  @override
  void initState() {
    super.initState();
    selectedCrop = 'Tomato';
  }

  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                width: 320,
                child: Text(
                  'Please select the crop you want to check the take a picture of the leaf',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
              child: Row(
                children: [
                  Column(
                    children: [
                      DropdownButton(
                        value: selectedCrop,
                        onChanged: (newValue) {
                          setState(() {
                            if (newValue == null) {
                              return;
                            }
                            selectedCrop = newValue.toString();
                            newValuee = newValue.toString();
                          });
                        },
                        items: crops.map((crop) {
                          return DropdownMenuItem<String>(
                            value: crop,
                            child: Text(
                              crop,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          'Select one of the options',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        'Pick the crop',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _selectImage,
                        icon: const Icon(
                          Icons.upload_file_sharp,
                          color: Colors.grey,
                        ),
                        label: const Text(
                          'Upload Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton.icon(
                        onPressed: _takePicture,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                        label: const Text(
                          'Take Picture',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 38),
            // ElevatedButton.icon(
            //   onPressed: _selectImage,
            //   icon: const Icon(Icons.upload_file_sharp),
            //   label: const Text(
            //     'Upload Image',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // const SizedBox(height: 6),
            // ElevatedButton.icon(
            //   onPressed: _takePicture,
            //   icon: const Icon(Icons.camera_alt),
            //   label: const Text(
            //     'Take Picture',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            if (_selectedImage != null)
              Row(
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(50, 16, 96, 0),
                        child: Text(
                          'Your image:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Adjust spacing as needed
                      GestureDetector(
                        onTap: _takePicture,
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 140, // Set the desired width
                          height: 140, // Set the desired height
                        ),
                      ),
                      //const SizedBox(height: 20), // Adjust spacing as needed
                      // TextButton.icon(
                      //   onPressed: _takePicture,
                      //   icon: const Icon(Icons.camera_alt),
                      //   label: const Text(
                      //     'Retake Photo',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _removeImage,
                        label: const Text(
                          'Remove photo',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      FilledButton.icon(
                        onPressed: (){},
                        label: Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,10,0),
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                          ),
                        ),
                        icon: const Icon(Icons.check),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 117, 170, 114),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Disease detection AI has a 95% accuracy',
                        style: TextStyle(
                          color: Colors.grey,
                          //decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    //height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 145, 212)
                              .withOpacity(0.55),
                          const Color.fromARGB(255, 0, 145, 212)
                              .withOpacity(0.9),
                        ],
                      ), // Set the background color
                      borderRadius:
                          BorderRadius.circular(10), // Add rounded corners
                    ),
                    padding:
                        const EdgeInsets.all(16), // Add padding inside the box
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '//Dynamic title based on plant condition (Either eno its good or diseased)',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            //make Zaina or Hammad add
                            'You guys will add personalised text here based on the plant\'s condition',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'More content...\nYall are gay.\n\n\n\n\nAnd text here too.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}
