import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {

  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,
      height: 40,
      width: 40,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
        rotation: true,
      ),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Cart Animation",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
          actions: [
            IconButton(
              icon: const Icon(Icons.cleaning_services),
              onPressed: () {
                _cartQuantityItems = 0;
                cartKey.currentState!.runClearCartAnimation();
              },
            ),
            const SizedBox(width: 16),
            AddToCartIcon(
              key: cartKey,
              icon: const Icon(Icons.shopping_cart),
              badgeOptions: const BadgeOptions(
                active: true,
                backgroundColor: Colors.red,
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: List.generate(
              15,
              (index) => AppListItem(
                onClick: listClick,
                index: index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
  }
}

class AppListItem extends StatelessWidget {

  final GlobalKey widgetKey = GlobalKey();
  final int index;
  final void Function(GlobalKey) onClick;

  AppListItem({super.key, required this.onClick, required this.index});
  @override
  Widget build(BuildContext context) {
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 60,
      height: 60,
      color: Colors.transparent,
      child: Image.network(
        "https://cdn.jsdelivr.net/gh/omerbyrk/add_to_cart_animation/example/assets/apple.png",
        width: 60,
        height: 60,
      ),
    );

    return ListTile(
      onTap: () => onClick(widgetKey),
      leading: mandatoryContainer,
      title: Text(
        "Apple Product Image ${index+1}",
      ),
    );
  }
}