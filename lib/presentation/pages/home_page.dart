import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_state.dart';
import '../bloc/home/picker_bloc.dart';
import '../bloc/home/picker_event.dart';
import '../bloc/home/picker_state.dart';
import '../widgets/item_gemini_message.dart';
import '../widgets/item_user_message.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc homeBloc;
  late PickerBloc pickerBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
    pickerBloc = context.read<PickerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: homeBloc.messages.isEmpty
                        ? Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  Image.asset('assets/images/gemini_icon.png'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: homeBloc.messages.length,
                            itemBuilder: (context, index) {
                              var message = homeBloc.messages[index];
                              if (message.isMine!) {
                                return itemOfUserMessage(message);
                              } else {
                                return itemOfGeminiMessage(message);
                              }
                            },
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<PickerBloc, PickerState>(
                        builder: (context, state) {
                          if (state is SelectedPhotoState) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      base64Decode(pickerBloc.pickedImage64!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white)),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        pickerBloc.add(ClearedPhotoEvent());
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: homeBloc.textController,
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              pickerBloc.add(SelectedPhotoEvent());
                            },
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              homeBloc.askToGemini(pickerBloc.pickedImage64);
                              pickerBloc.add(ClearedPhotoEvent());
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
