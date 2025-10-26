import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget implements PreferredSizeWidget {
  final String month;
  final Function()? pressed;

  const BottomBar({super.key, required this.month, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: pressed,
                    icon: const Icon(
                      Icons.calendar_month,
                      color: Colors.cyan,
                    )),
                const SizedBox(
                  width: 4,
                ),
                Text(month)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Widget bottom(String month) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.cyan,
                  )),
              const SizedBox(
                width: 4,
              ),
              Text(month)
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text("date"),
              SizedBox(
                width: 5,
              ),
              Text("Collected"),
              Text("Supply"),
              Text("+-Diff")
            ],
          ),
        )
      ],
    ),
  );
}
