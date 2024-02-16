import 'package:dio/dio.dart';
import 'package:email_js_send_email/app_const.dart';
import 'package:email_js_send_email/dio_settings.dart';
import 'package:email_js_send_email/email_model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();
  final TextEditingController controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomTextField(hinText: 'Name', controller: controllerName),
                const SizedBox(height: 16),
                CustomTextField(hinText: 'Phone', controller: controllerPhone),
                const SizedBox(height: 16),
                CustomTextField(
                    maxLines: 6,
                    hinText: 'Info',
                    controller: controllerMessage),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: sendEmail,
        tooltip: 'Increment',
        child: const Icon(
          Icons.send,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> sendEmail() async {
    final Dio dio = DioSettings().dio;
    try {
      await dio.post('https://api.emailjs.com/api/v1.0/email/sen',
          data: EmailModel(
              templateId: AppsConst.templateId,
              serviceId: AppsConst.serviceId,
              userId: AppsConst.userId,
              accessToken: AppsConst.accessToken,
              templateParams: TemplateParams(
                fromName: controllerName.text,
                toName: controllerPhone.text,
                message: controllerMessage.text,
              )).toJson());
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('OK'),
            actions: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.close))
            ],
          ),
        );
      }
    } catch (e) {
      String errorText = e.toString();
      if (e is DioException) {
        errorText = e.response?.data;
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(errorText),
            actions: [
              IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: const Icon(Icons.close))
            ],
          ),
        );
      }
    }
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hinText,
      required this.controller,
      this.maxLines = 1});

  final String hinText;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 5,
            ),
          ),
          hintText: hinText,
          hintStyle:
              const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
    );
  }
}
