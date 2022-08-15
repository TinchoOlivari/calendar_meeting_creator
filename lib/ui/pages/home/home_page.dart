import 'package:calendar_meeting_creator/ui/styles/app_styles.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController subjectController = TextEditingController();
  DeviceCalendarPlugin deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> _retrieveCalendars() async {
    try {
      var permissionsGranted = await deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return;
        }
      }

      final calendarResult = await deviceCalendarPlugin
          .retrieveCalendars()
          .then((value) => value.data);

      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select an e-mail account to schedule the event',
                    style: AppStyles.modalBottomTitle,
                  ),
                ),
                const Divider(height: 4),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: calendarResult?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      if (!calendarResult![index].isReadOnly!) {
                        return ListTile(
                          title: Text(calendarResult[index].name!),
                          onTap: () async {
                            final bool result = await createEvent(
                                calendarResult[index].id!,
                                subjectController.text,
                                _selectedDate,
                                _selectedDate);
                            if (result) {
                              Navigator.of(context).pop();
                            } else {
                              print('NO se creo el evento');
                            }
                          },
                        );
                      }
                      return Container();
                    }),
              ],
            );
          });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createEvent(
      String calendarId, String title, DateTime start, DateTime end) async {
    Event event = Event(
      calendarId,
      title: title,
      start: TZDateTime.from(start, getLocation('America/Argentina/Cordoba')),
      end: TZDateTime.from(end, getLocation('America/Argentina/Cordoba')),
    );

    var createEventResult =
        await deviceCalendarPlugin.createOrUpdateEvent(event);

    return createEventResult!.isSuccess;
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
    );

    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  selectTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (selected != null && selected != TimeOfDay.fromDateTime(_selectedDate)) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          selected.hour,
          selected.minute,
        );
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
            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
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
            "${_selectedDate.hour} : ${_selectedDate.minute}",
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

  FloatingActionButton buildSaveButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _retrieveCalendars();
      },
      child: const Icon(Icons.save),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar Event Creator'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: <Widget>[
                buildSubjectField(context),
                Separators.largeSeparator,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildDatePicker(context),
                    buildTimePicker(context),
                  ],
                ),
                Separators.largeSeparator,
                buildSaveButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
