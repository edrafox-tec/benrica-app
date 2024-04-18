// ignore_for_file: use_build_context_synchronously

import 'package:benrica/components/custom_snack_bar.dart';
import 'package:benrica/components/schedule_modal_page.dart';
import 'package:benrica/http/http_client.dart';
import 'package:benrica/models/company_model.dart';
import 'package:benrica/models/service_model.dart';
import 'package:benrica/repositories/schedule_repository.dart';
import 'package:benrica/repositories/service_repository.dart';
import 'package:benrica/stores/schedule_store.dart';
import 'package:benrica/stores/service_store.dart';
import 'package:benrica/ultis/api_url.dart';
import 'package:benrica/ultis/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ApiUrl apiUrl = ApiUrl();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late BuildContext? contexts;
  CompanyModel? company;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    contexts = context;
    getData();
    schedules.getSchedule(context).then((_) {});
    services.getService(context).then((_) {});
  }

  Future<void> getData() async {
    final response = await SharedPreferencesHelper.getData(
      'company',
      (json) => CompanyModel.fromMap(json),
    );
    company = response;
  }

  final ServiceStore services = ServiceStore(
    repository: ServiceRepository(
      client: HttpClientAdapter(),
    ),
  );

  final ScheduleStore schedules = ScheduleStore(
    repository: ScheduleRepository(
      client: HttpClientAdapter(),
    ),
  );

  String getRealValue(String? value) {
    if (value == null) return '';
    return 'R\$${value.replaceAll('.', ',')}';
  }

  Future<void> openModalScheduleService(
      BuildContext context, ServiceModel service) async {
    final returnedData = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ScheduleModalPage(
          service: service,
          schedules: schedules.state.value,
          company: company!,
        ),
      ),
    );
    if (returnedData != null) {
      schedules.getSchedule(context).then((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Serviços',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge([
                  services.isLoading,
                  schedules.isLoading,
                  services.erro,
                  services.state,
                ]),
                builder: (context, child) {
                  if (services.isLoading.value || schedules.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (services.erro.value.isNotEmpty) {
                    Future.delayed(Duration.zero, () {
                      CustomSnackBar.show(
                        context,
                        'Erro inesperado. Tente novamente mais tarde!',
                        success: false,
                      );
                    });
                  }

                  if (services.state.value.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum item na lista",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: services.state.value.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              minVerticalPadding: 0,
                              contentPadding: const EdgeInsets.all(0),
                              title: SizedBox(
                                height: 135,
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Foto à esquerda
                                        const CircleAvatar(
                                          backgroundImage: AssetImage(
                                            'assets/logo/benrica_logo.png',
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                services.state.value[index]
                                                    .service_name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                services.state.value[index]
                                                    .service_time
                                                    .substring(
                                                        0,
                                                        services
                                                            .state
                                                            .value[index]
                                                            .service_time
                                                            .lastIndexOf(':')),
                                              ),
                                              Text(
                                                services.state.value[index]
                                                        .service_description ??
                                                    'Não informado',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              getRealValue(services.state
                                                  .value[index].service_value),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.arrow_forward),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () => openModalScheduleService(
                                context,
                                services.state.value[index],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
