import 'package:calendar_meeting_creator/ui/styles/app_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController subjectController = TextEditingController();

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
  }

  Column buildDatePicker(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter date',
          style: AppStyles.textCategoryTitle,
        ),
        Separators.smallSeparator,
        GestureDetector(
          onTap: () {
            selectDate(context);
          },
          child: Text(
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: AppStyles.textDateSelection,
          ),
        ),
      ],
    );
  }

  Column buildTimePicker(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter time',
          style: AppStyles.textCategoryTitle,
        ),
        Separators.smallSeparator,
        GestureDetector(
          onTap: () {
            selectTime(context);
          },
          child: Text(
            selectedTime.format(context),
            style: AppStyles.textDateSelection,
          ),
        ),
      ],
    );
  }

  Column buildSubjectField(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter subject',
          style: AppStyles.textCategoryTitle,
        ),
        Separators.smallSeparator,
        TextField(
          controller: subjectController,
          style: AppStyles.subjectHintText,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: '...',
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Meetings Creator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildSubjectField(context),
              Separators.largeSeparator,
              buildDatePicker(context),
              Separators.largeSeparator,
              buildTimePicker(context),
            ],
          ),
        ),
      ),
    );
  }
}
