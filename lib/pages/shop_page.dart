import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Shop"),
        actions: [
          IconButton(
            splashRadius: 1,
            icon: const Icon(Icons.collections_bookmark_outlined),
            onPressed: () {},
          ),
          IconButton(
            splashRadius: 1,
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                border: outlineBorder,
                focusedBorder: outlineBorder,
                enabledBorder: outlineBorder,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: "Search shops",
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShopFilterButtons(text: "Shops"),
                ShopFilterButtons(text: "Videos"),
                ShopFilterButtons(text: "Editor's picks"),
                ShopFilterButtons(text: "Collections"),
                ShopFilterButtons(text: "Guides"),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 100,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            itemBuilder: (context, index) => Container(color: Colors.grey),
          )
        ],
      ),
    );
  }
}

class ShopFilterButtons extends StatelessWidget {
  const ShopFilterButtons({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
        onPressed: () {},
      ),
    );
  }
}
