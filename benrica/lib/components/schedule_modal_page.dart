import 'package:benrica/components/calendar_schedule_modal_page.dart';
import 'package:benrica/models/company_model.dart';
import 'package:benrica/models/schedule_model.dart';
import 'package:benrica/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScheduleModalPage extends StatelessWidget {
  final ServiceModel service;
  final List<ScheduleModel> schedules;
  final CompanyModel company;

  ScheduleModalPage({
    required this.service,
    required this.schedules,
    required this.company,
  });

  String getRealValue(String? value) {
    if (value == null) return '';
    return 'R\$${value.replaceAll('.', ',')}';
  }

  Future<void> openModalScheduleCalendar(
    BuildContext context,
    ServiceModel service,
    List<ScheduleModel> schedules,
  ) async {
    try {
      final returnedData = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => CalendarScheduleModalPage(
            service: service,
            schedules: schedules,
            company: company,
          ),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (returnedData != null && context.mounted) {
        context.pop(true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Informações do serviço',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 30.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Serviço: ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                service.service_name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Text(
                                'Tempo: ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                service.service_time,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              const Text(
                                'Valor: ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                getRealValue(service.service_value),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descrição: ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  service.service_description ??
                                      'Não informado',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 60.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFFD9D9D9)),
                    ),
                    onPressed: () =>
                        openModalScheduleCalendar(context, service, schedules),
                    child: const Text(
                      'CONTINUAR',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
