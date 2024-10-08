import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maid_easy/screens/book_appointment.dart';

class AppointmentInfo extends StatelessWidget {
  final String fullName;
  final String phone;
  final List prefferedWork;
  final List prefferedLocation;
  final List workingDay;
  final List timeSLots;
  final int charges;
  final String tag;

  const AppointmentInfo({super.key, required this.tag, required this.fullName, required this.phone, required this.prefferedWork, required this.prefferedLocation, required this.workingDay, required this.timeSLots, required this.charges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText("Appointment"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                  tag: tag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      "https://plus.unsplash.com/premium_photo-1681483534373-2d9250d3e1e9?q=80&w=2016&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      height: MediaQuery.sizeOf(context).height * 0.2,
                    ),
                  )),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     AutoSizeText(fullName,style: Theme.of(context).textTheme.titleLarge,),
                    Wrap(
                      children: List.generate(prefferedWork.length, (index) => AutoSizeText(prefferedWork.elementAtOrNull(index)),),
                    ),
                    InkWell(
                      onTap: () => Clipboard.setData( ClipboardData(text: phone)),
                      child: OverflowBar(
                        children: [
                          const Icon(Icons.phone,),
                          AutoSizeText(phone)
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          AutoSizeText("Experience", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(
            height: 8,
          ),
          const AutoSizeText(
              '''I am an experienced dentist with over 10 years of practice. I am specialized in general dentistry and I will offer a range of services.'''),
          const SizedBox(
            height: 8,
          ),
          AutoSizeText("Reviews", style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton(onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => BookAppointment(
            timeSlots: timeSLots,
            workingDays: workingDay,
          ),));
        }, child: const AutoSizeText("Book Appointment")),
      ),
    );
  }
}
