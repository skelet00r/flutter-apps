import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'image-loader',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'image-loader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Key key = UniqueKey();
  NetworkImage networkImage;
  bool loaded = false;

  _MyHomePageState() {
    networkImage = new NetworkImage('https://picsum.photos/1024');
    key = UniqueKey();
    loaded = false;
  }

  void updateImage() {
    print('image update');
  }

  void getImagePalette(NetworkImage image) {
    image.evict();
  }

  void loadImage() {
    var image = new NetworkImage('https://picsum.photos/1024');
    debugPrint('loading image');
    setState(() {
      networkImage = image;
      key = UniqueKey();
      loaded = false;
    });
  }

  void resetImage(NetworkImage image) {
    print('evicting');
    image.evict().then<void>((bool success) {
      if (success) {
        debugPrint('removed image!');
        loadImage();
      } else {
        debugPrint('something went wrong');
      }
    });
  }

  void isLoaded() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Tap image to reload',
                style: Theme.of(context).textTheme.headline4),
            GestureDetector(
                onTap: () {
                  resetImage(networkImage);
                },
                child: Image(
                  image: networkImage,
                  key: key,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      debugPrint('load complete');
                      isLoaded();
                      return child;
                    }
                    debugPrint('loading image');
                    return CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
