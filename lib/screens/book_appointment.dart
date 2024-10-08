import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maid_easy/screens/appoinment_booked.dart';

class BookAppointment extends StatefulWidget {
  final List timeSlots;
  final List workingDays;
  const BookAppointment({super.key, required this.timeSlots, required this.workingDays});

  @override
  State<BookAppointment> createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  List selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateRangePickerWidget(
              initialStartDate: DateTime.now(),
              initialEndDate: DateTime.now().add(const Duration(days: 7)),
              onDateRangeChanged: (startDate, endDate) {
                print('Start Date: $startDate');
                print('End Date: $endDate');
              },
            ),
            Wrap(
              spacing: 6,
              children: List.generate(
                widget.timeSlots.length,
                (index) => ChoiceChip(
                    label: Text(widget.timeSlots.elementAtOrNull(index)),
                    selected: selected.contains(widget.timeSlots.elementAtOrNull(index)),
                  onSelected: (value) {
                    setState(() {
                      if(value){
                        selected.add(widget.timeSlots.elementAtOrNull(index));
                      } else {
                        selected.remove(widget.timeSlots.elementAtOrNull(index));
                      }
                    });
                  },
                ),
              ),
            ),
            FilledButton(onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => AppoinmentBooked(),));
            }, child: const AutoSizeText("Book Appointment"))
          ],
        ),
      ),
    );
  }
}

class DateRangePickerWidget extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final Function(DateTime, DateTime) onDateRangeChanged;

  const DateRangePickerWidget({
    Key? key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeChanged,
  }) : super(key: key);

  @override
  _DateRangePickerWidgetState createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  void _showDatePicker(BuildContext context, DateTime initialDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (_startDate == null || _endDate == null) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });

      widget.onDateRangeChanged(_startDate!, _endDate!);
    }
  }
  DateFormat formatter = DateFormat('yyyy-MM-dd'); // Replace with your desired pattern

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showDatePicker(context, _startDate!),
          child: const Text('Start Date'),
        ),
        const SizedBox(width: 10),
        Text(formatter.format(_startDate ?? DateTime.now())),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => _showDatePicker(context, _endDate!),
          child: const Text('End Date'),
        ),
        const SizedBox(width: 10),
        Text(formatter.format(_endDate ?? DateTime.now())),
      ],
    );
  }
}
