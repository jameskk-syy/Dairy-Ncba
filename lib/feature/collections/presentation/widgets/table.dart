import 'package:flutter/material.dart';

Widget table(
    String date, String collected, String supply, String diff, Color color) {
  return Container(
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
        color: Colors.white),
    child: Row(
      children: [
        Text(date),
        Text(collected),
        Text(supply),
        Text(
          diff,
          style: TextStyle(color: color),
        )
      ],
    ),
  );
}

Widget dataTable(List<DataRow> rows, BuildContext context) {
  TextStyle textStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 17);
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: SingleChildScrollView(
      child: DataTable(
        columnSpacing: MediaQuery.of(context).size.width/20,
        columns: [
          DataColumn(label: Text("Date", style: textStyle,)),
          DataColumn(label: Text("Collected", style: textStyle,)),
          DataColumn(label: Text("Supply", style: textStyle,)),
          DataColumn(label: Text("Diff", style: textStyle,))
        ], 
        rows: rows),
    ),
  );
}
