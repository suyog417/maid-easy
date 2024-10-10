import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maid_easy/api/database.dart';
import 'package:maid_easy/screens/bloc/create_job_bloc.dart';
import 'package:maid_easy/screens/list_maids.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateJob extends StatefulWidget {
  final String serviceId;
  const CreateJob({super.key, required this.serviceId});

  @override
  State<CreateJob> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJob> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  TimeOfDay _jobTime = TimeOfDay.now();
  final TextEditingController _noteController = TextEditingController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}_'
            // ignore: lines_longer_than_80_chars
            '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  bool forOneDay = true;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          context.read<CreateJobBloc>().close();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: kToolbarHeight,
                child: Text(
                  "Select date & time",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     Text('Selected date: $_selectedDate'),
              //     Text('Selected date count: $_dateCount'),
              //     Text('Selected range: $_range'),
              //     Text('Selected ranges count: $_rangeCount')
              //   ],
              // ),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("From-To"),
                      selected: forOneDay,
                      onSelected: (value) {
                        if (value) {
                          setState(() {
                            forOneDay = !forOneDay;
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text("One Day"),
                      selected: !forOneDay,
                      onSelected: (value) {
                        if (value) {
                          setState(() {
                            forOneDay = !forOneDay;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
              const Divider(),
              SfDateRangePicker(
                confirmText: "Save",
                onSelectionChanged: _onSelectionChanged,
                selectionMode: forOneDay
                    ? DateRangePickerSelectionMode.range
                    : DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
                backgroundColor: Colors.transparent,
                allowViewNavigation: false,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Select time"),
                trailing: Text(
                  _jobTime.format(context),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () async {
                  _jobTime = (await showTimePicker(context: context, initialTime: TimeOfDay.now())) ??
                      TimeOfDay.now();
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(hintText: "Note"),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<CreateJobBloc, CreateJobStates>(
            listener: (context, state) {
              print(state);
              if(state is JobCreatedSuccessfullyState){
                context.read<CreateJobBloc>().getRecommendations(state.id);
              }
              if(state is RecommsLoadedState){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => ListMaids(maids: state.data.data),));
              }
            },
            builder: (context, state) {
              if(state is JobCreationInProgress){
                return const Center(child: CircularProgressIndicator(),);
              }
              if(state is JobCreationInitialState){
                return FilledButton(
                    onPressed: () {
                      final data = {
                        "serviceId": widget.serviceId,
                        "serviceType": forOneDay ? "Range" : "One day",
                        "from": _range.split("_").first,
                        "to": _range.split("_").last,
                        "time": _jobTime.format(context).toString(),
                        "note": _noteController.text.trim()
                      };
                      // print(json.encode(data).toString());
                      context.read<CreateJobBloc>().createJob("6706c70316c30cafe86fc3cd", json.encode(data));
                    },
                    child: const Text("Create Job"));
              }
              return const Text("Something went wrong.");
            },
          ),
        ),
      ),
    );
  }
}
