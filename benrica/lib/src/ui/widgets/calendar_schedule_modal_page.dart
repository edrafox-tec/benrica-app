// ignore_for_file: use_build_context_synchronously

import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/models/login_model.dart';
import 'package:benrica/src/domain/models/schedule_model.dart';
import 'package:benrica/src/domain/models/service_model.dart';
import 'package:benrica/src/domain/models/user_model.dart';
import 'package:benrica/src/domain/repositories/schedule_repository.dart';
import 'package:benrica/src/domain/stores/schedule_store.dart';
import 'package:benrica/src/domain/ultis/shared_preferences_helper.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScheduleModalPage extends StatefulWidget {
  final ServiceModel service;
  final List<ScheduleModel> schedules;
  final CompanyModel company;

  CalendarScheduleModalPage({
    required this.service,
    required this.schedules,
    required this.company,
  });

  @override
  State<CalendarScheduleModalPage> createState() =>
      _CalendarScheduleModalPageState();
}

class _CalendarScheduleModalPageState extends State<CalendarScheduleModalPage> {
  DateTime now = DateTime.now();
  bool isLoading = false;
  double startHour = 0.0;
  double endHour = 0.0;
  int timeInterval = 15;
  final ScheduleStore newSchedule = ScheduleStore(
    repository: ScheduleRepository(
      client: HttpClientAdapter(),
    ),
  );

  @override
  void initState() {
    super.initState();
    int initialHour = int.parse(widget.company.initial_time!.split(':')[0]);
    int initialMinute = int.parse(widget.company.initial_time!.split(':')[1]);
    int finalHour = int.parse(widget.company.final_time!.split(':')[0]);
    int finalMinute = int.parse(widget.company.final_time!.split(':')[1]);

    if (initialMinute >= 30) {
      startHour = initialHour + 0.5;
    } else {
      startHour = initialHour + 0.0;
    }

    if (finalMinute >= 30) {
      endHour = finalHour + 0.5;
    } else {
      endHour = finalHour + 0.0;
    }
  }

  Future<UserResponseInterface?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final loginResponseJson = prefs.getString('loginResponse');

    if (loginResponseJson == null) {
      return UserResponseInterface(
        id: 0,
        id_businesses: 0,
        user_name: '',
        email: '',
        phone_number: '',
        access_level: 0,
        reset_pass: null,
        deleted_at: null,
        created_at: null,
        updated_at: null,
        status: null,
        error: null,
        errors: null,
        message: null,
      );
    } else {
      var loginResponse = await SharedPreferencesHelper.getData(
        'loginResponse',
        (json) => LoginModel.fromMap(json),
      );

      return loginResponse?.user ?? null;
    }
  }

  Future<void> doSchedule(
      ServiceModel service, DateTime date, contextDialog) async {
    UserResponseInterface? user = await getUser();

    dynamic body = {
      'id_user': user?.id ?? 0,
      'scheduling_date_time': date.toString(),
      'id_service': service.id,
      'scheduling_advance_value': '0.00',
      'scheduling_status': 1,
      'scheduling_add_time': '00:00:00',
    };

    newSchedule.addSchedule(body, context).then((_) {
      print(newSchedule.state.value.isNotEmpty);
      print(newSchedule.state.value);

      if (newSchedule.state.value.isNotEmpty) {
        GoRouter.of(contextDialog).pop();
        context.pop(true);
        CustomSnackBar.show(
          context,
          'Agendamento realizado com sucesso!',
          success: true,
        );
      } else {
        CustomSnackBar.show(
          context,
          'Houve um erro na solicitação.',
          success: false,
        );
        context.pop();
      }
    });
  }

  Future<void> showMyDialog(DateTime? date) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final f = DateFormat('dd/MM/yyy HH:mm');
        String convertedData = f.format(date!);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Confirmação de agendamento'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Serviço: ${widget.service.service_name}'),
                    Text('Data: $convertedData'),
                    const SizedBox(height: 16.00),
                    const Text('Gostaria de confirmar o agendamento?'),
                  ],
                ),
              ),
              actions: <Widget>[
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Confirmar',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              doSchedule(widget.service, date, context);
                            },
                          ),
                        ],
                      ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Appointment> events = [];
    DateTime initialSelectedDate = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );

    if (initialSelectedDate.minute < 15) {
      initialSelectedDate = DateTime(
        initialSelectedDate.year,
        initialSelectedDate.month,
        initialSelectedDate.day,
        initialSelectedDate.hour,
        15,
      );
    } else if (initialSelectedDate.minute < 30) {
      initialSelectedDate = DateTime(
        initialSelectedDate.year,
        initialSelectedDate.month,
        initialSelectedDate.day,
        initialSelectedDate.hour,
        30,
      );
    } else if (initialSelectedDate.minute < 45) {
      initialSelectedDate = DateTime(
        initialSelectedDate.year,
        initialSelectedDate.month,
        initialSelectedDate.day,
        initialSelectedDate.hour,
        45,
      );
    } else {
      initialSelectedDate = DateTime(
        initialSelectedDate.year,
        initialSelectedDate.month,
        initialSelectedDate.day,
        initialSelectedDate.hour + 1,
        0,
      );
    }

    List<TimeRegion> getTimeRegions() {
      List<TimeRegion> regions = <TimeRegion>[];
      DateTime now = DateTime.now();

      if (now.minute < 15) {
        regions.add(TimeRegion(
          startTime: DateTime(now.year, now.month, now.day, now.hour, 0),
          endTime: DateTime(now.year, now.month, now.day, now.hour, 15),
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: '',
        ));
      } else if (now.minute < 30) {
        regions.add(TimeRegion(
          startTime: DateTime(now.year, now.month, now.day, now.hour, 15),
          endTime: DateTime(now.year, now.month, now.day, now.hour, 30),
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: '',
        ));
      } else if (now.minute < 45) {
        regions.add(TimeRegion(
          startTime: DateTime(now.year, now.month, now.day, now.hour, 30),
          endTime: DateTime(now.year, now.month, now.day, now.hour, 45),
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: '',
        ));
      } else {
        regions.add(TimeRegion(
          startTime: DateTime(now.year, now.month, now.day, now.hour, 45),
          endTime: DateTime(now.year, now.month, now.day, now.hour + 1, 0),
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: '',
        ));
      }

      for (int index = 0; index < widget.schedules.length; index++) {
        DateTime schedulingDateTime = DateTime.parse(
          widget.schedules[index].scheduling_date_time.replaceAll("Z", ""),
        );
        DateTime schedulingDateTimeFinal = DateTime.parse(
          widget.schedules[index].scheduling_time_total.replaceAll("Z", ""),
        );
        regions.add(TimeRegion(
          startTime: schedulingDateTime,
          endTime: schedulingDateTimeFinal,
          enablePointerInteraction: false,
          color: Colors.grey.withOpacity(0.2),
          text: '',
        ));
      }
      return regions;
    }

    return Scaffold(
      appBar: AppBar(),
      body: SfCalendar(
        onTap: (calendarTapDetails) => showMyDialog(calendarTapDetails.date),
        view: CalendarView.week,
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: startHour,
          endHour: endHour,
          timeInterval: Duration(minutes: timeInterval),
          timeFormat: 'HH:mm',
        ),
        specialRegions: getTimeRegions(),
        showNavigationArrow: true,
        firstDayOfWeek: DateTime.now().weekday,
        dataSource: MeetingDataSource(events),
        minDate: DateTime(now.year, now.month, now.day, now.hour, now.minute),
        maxDate: DateTime(now.year, now.month, now.day, now.hour, now.minute)
            .add(const Duration(days: 25)),
        initialDisplayDate: initialSelectedDate,
        initialSelectedDate: initialSelectedDate,
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
