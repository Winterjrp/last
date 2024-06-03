import 'package:flutter/material.dart';
import 'package:last/constants/color.dart';

typedef CallbackFunction = void Function();

class AdminHomeCard extends StatefulWidget {
  final String headerText;
  final IconData icon;
  final int amount;
  final CallbackFunction callback;
  const AdminHomeCard(
      {Key? key,
      required this.headerText,
      required this.icon,
      required this.amount,
      required this.callback})
      : super(key: key);

  @override
  State<AdminHomeCard> createState() => _AdminHomeCardState();
}

class _AdminHomeCardState extends State<AdminHomeCard> {
  late bool _isHovered;

  @override
  void initState() {
    super.initState();
    _isHovered = false;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.scale(
        scale: _isHovered ? 1.05 : 1,
        child: SizedBox(
          height: 185,
          width: 200,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                backgroundColor: specialBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                widget.callback();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.headerText,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Icon(
                        widget.icon,
                        size: 70,
                        color: darkYellow,
                      ),
                    ),
                    Text(
                      widget.amount.toString(),
                      style: const TextStyle(
                        fontSize: 25,
                        color: darkFlesh,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
