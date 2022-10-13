import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intro/models/posts.dart';
import 'package:intro/utils/colors.dart';
import 'package:intro/utils/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List <Post>? posts;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from API
    getData();
  }

  getData () async {
    posts = await Service().getPost();
    if(posts != null){
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data from internet'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(child: CircularProgressIndicator(),),
        child: ListView.builder(
          itemCount: posts?.length,
            itemBuilder: (context, index){
          return Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey[300],
                  ),
                  child: Center(child: Text(posts![index].title[0].toUpperCase(), style: TextStyle(color: buttonColor, fontSize: 25),)),
                ),
                SizedBox(width: 16,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(posts![index].title,maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      Text(posts![index].body ?? '',maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
