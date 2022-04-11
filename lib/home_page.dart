
// import 'dart:html';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


//  https://www.youtube.com/watch?v=6tfBflFUO7s


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String videoUrl = "https://file-examples.com/storage/fe1fca3bab62533d59c03ef/2017/04/file_example_MP4_480_1_5MG.mp4";
  String imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Sunflower_from_Silesia2.jpg/800px-Sunflower_from_Silesia2.jpg";
  String pdfUrl = "https://www.orimi.com/pdf-test.pdf";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
         child: RaisedButton(
           child: Text("download and open"),

             onPressed: (){
             // openFile(url: videoUrl, fileName:"video.mp4");
             openFile(url: imageUrl);
             // openFile(url: pdfUrl, fileName:"file.pdf");
             }),
       ),
    );

  }

  Future openFile({required String url , String? fileName}) async{

    final name = fileName ?? url.split("/").last;
    // to download file and open
     final file = await downloadFile(url , name);
     if(file == null) return;
     print("Path : ${file.path}") ;
     OpenFile.open(file.path);


     // to open fron storage
     // final file = await pickFile();
     // if(file == null) return;
     // print("Path : ${file.path}") ;
     // OpenFile.open(file.path);


  }

  // download file into private folder not visible to user
  Future<File?> downloadFile(String url, String name) async {
       final appStorage = await getApplicationDocumentsDirectory();
       final file  = File("${appStorage.path}/$name");

       try{
         final response = await Dio().get(
             url ,
             options: Options(
                 responseType: ResponseType.bytes,
                 followRedirects: false ,
                 receiveTimeout: 0
             ),

         );

         final raf = file.openSync(mode : FileMode.write);
         raf.writeFromSync(response.data);
         await raf.close();

         return file;
       }catch (e) {
         return null;
       }

  }


  Future<File?> pickFile()async{
    final result  = await FilePicker.platform.pickFiles();
    if(result == null) return null;

    return File(result.files.first.path!);
  }

}


