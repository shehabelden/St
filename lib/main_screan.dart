import 'package:camera_platform_interface/src/types/camera_description.dart';
import 'package:flutter/material.dart';
import 'package:notefear/main.dart';

class MainScreen extends StatelessWidget {
  final CameraDescription camera;
  const MainScreen({Key? key, required  this.camera}) : super(key: key);
  @override
  Widget build(BuildContext context){
    List icon=[
      Icons.volume_down,
      Icons.camera_alt,
      Icons.accessibility_sharp,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0,
      ),
      body:ListView.builder(
          itemCount:3,
          physics:const NeverScrollableScrollPhysics(),
          itemBuilder: (c,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onPanStart: (p){
                  // Sounds.start(StaticVar().homeBadgeSound[index]);
                },
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                          camera: camera,
                        ) ,
                      )
                  );
                },
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade900,
                        width: .1,
                      ),
                    ),
                    child: Icon(
                      icon[index],
                      size: 120,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}