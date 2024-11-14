import 'package:flutter/material.dart';
class UserTile extends StatelessWidget {

  final String text;
  final void Function()? onTap;

  const UserTile({super.key,
  required this.text,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            Icon(Icons.person),
             SizedBox(width: 20,),
             Text(text)
          ],
        ),
      ),
    );
  }
}
