import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/enum/state.dart';
import 'package:story_app/data/model/request_add_story.dart';
import 'package:story_app/provider/story_add.dart';
import 'package:story_app/routes/page_manager.dart';
import 'package:story_app/util/helper.dart';
import 'package:story_app/widget/safe_area.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onSuccessAddStory;

  const AddStoryPage({super.key, required this.onSuccessAddStory});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaScaffold(
      appBar: AppBar(title: const Text("Add Story")),
      body: ChangeNotifierProvider<AddStoryProvider>(
        create: (context) => AddStoryProvider(ApiService()),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    child: InkWell(
                      onTap: () => _selectImage(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_selectedImage != null)
                            Opacity(
                              opacity: 0.8,
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                  child: Image.file(_selectedImage!)),
                            ),
                          Text(
                            "Select Image",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Plase enter description!';
                      }
                      return null;
                    },
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Consumer<AddStoryProvider>(
                    builder: (context, provider, _) {
                      switch (provider.state) {
                        case ResultState.hasData:
                          print(provider.message);
                          afterBuildWidgetCallback(() {
                            context.read<PageManager>().returnData(true);
                            widget.onSuccessAddStory();
                          });
                          break;
                        case ResultState.error:
                        case ResultState.noData:
                          print(provider.message);
                          break;
                        default:
                          break;
                      }

                      return ElevatedButton(
                        onPressed: () => _onUploadPressed(provider),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text("Upload")],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _onUploadPressed(AddStoryProvider provider) {
    if (_formKey.currentState?.validate() == true && _selectedImage != null) {
      AddStoryRequest request = AddStoryRequest(
          description: _descriptionController.text, photo: _selectedImage!);
      provider.addStory(request);
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }
}
