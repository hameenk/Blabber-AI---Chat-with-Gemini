import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(
    id: "0",
    firstName: "User",
  );
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 17, 58),
        centerTitle: true,
        title: const Text(
          "Blabber AI",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 38),
        ),
      ),
      body: _bludUI(),
    );
  }

  Widget _bludUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
            onPressed: _sendMediamessange,
            icon: const Icon(
              Icons.image,
            ))
      ]),
      currentUser: currentUser,
      onSend: _sendmessage,
      messages: messages,
    );
  }

  void _sendmessage(ChatMessage chatmessage) {
    setState(() {
      messages = [chatmessage, ...messages];
    });
    try {
      String question = chatmessage.text;
      List<Uint8List>? image;
      if (chatmessage.medias?.isNotEmpty ?? false) {
        image = [
          File(chatmessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: image,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediamessange() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (File != Null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "discrige this picture?",
          medias: [
            ChatMedia(
              url: file!.path,
              fileName: "",
              type: MediaType.image,
            )
          ]);
      _sendmessage(chatMessage);
    }
  }
}
