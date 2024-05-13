import 'package:benrica/src/domain/http/http_client.dart';
import 'package:benrica/src/domain/models/company_model.dart';
import 'package:benrica/src/domain/repositories/company_repository.dart';
import 'package:benrica/src/domain/stores/company_store.dart';
import 'package:benrica/src/domain/ultis/shared_preferences_helper.dart';
import 'package:benrica/src/ui/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompaniesPage extends StatefulWidget {
  final String? companyName;

  const CompaniesPage({super.key, this.companyName});

  @override
  _CompaniesPageState createState() => _CompaniesPageState();
}

class _CompaniesPageState extends State<CompaniesPage> {
  final TextEditingController _searchController = TextEditingController();
  final UnderlineInputBorder underlineInputBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );

  List<CompanyModel> _filteredCompanies = [];
  bool _isSearching = false;
  bool _isFindingCompany = true;

  final CompanyStore companies = CompanyStore(
    repository: CompanyRepository(
      client: HttpClientAdapter(),
    ),
  );

  @override
  void initState() {
    super.initState();
    companies.getCompany(context).then((_) {
      _filteredCompanies = companies.state.value;
      print(widget.companyName);
      if (widget.companyName != null && widget.companyName!.isNotEmpty) {
        findCompany(widget.companyName!);
      }
    });
    if (widget.companyName == null || widget.companyName!.isEmpty) {
      setState(() {
        _isFindingCompany = false;
      });
    }
  }

  void findCompany(String name) {
    String clearedName = name.replaceAll('_', ' ');
    bool foundCompany = false;
    for (var element in _filteredCompanies) {
      if (element.business_name == clearedName) {
        foundCompany = true;
        selectCompany(element);
      }
    }
    if (foundCompany) {
      setState(() {
        _isFindingCompany = false;
      });
    }
  }

  void selectCompany(CompanyModel company) async {
    try {
      setState(() {
        _isFindingCompany = false;
      });
      context.pushReplacement('/splash');
      await SharedPreferencesHelper.saveData('company', company.toJson());
      await SharedPreferencesHelper.saveData('id_business', company.id);
    } catch (e) {
      print(e);
    }
  }

  void _filterCompanies(String searchText) {
    print(searchText);
    if (searchText.isEmpty) {
      setState(() {
        _filteredCompanies = companies.state.value;
        _isSearching = false;
      });
      return;
    }

    List<CompanyModel> filteredList = [];
    companies.state.value.forEach((company) {
      if (company.business_name
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        filteredList.add(company);
      }
    });

    setState(() {
      _filteredCompanies = filteredList;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        body: _isFindingCompany
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    16.0,
                    16.0,
                    MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      const Image(
                        width: 200,
                        image: AssetImage('assets/logo/benrica_logo.png'),
                      ),
                      const SizedBox(height: 15),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Row(
                            children: [
                              const Icon(Icons.search),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _searchController,
                                  onChanged: _filterCompanies,
                                  decoration: InputDecoration(
                                    labelText: 'Pesquisar',
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    enabledBorder: underlineInputBorder,
                                    focusedBorder: underlineInputBorder,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isSearching == true
                                ? _buildCompanyList(_filteredCompanies)
                                : _buildAnimatedCompanyList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildCompanyList(List<CompanyModel> companies) {
    return companies.isNotEmpty
        ? ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(companies[index].business_name),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => selectCompany(companies[index]),
                  ),
                  const Divider(),
                ],
              );
            },
          )
        : const Center(
            child: Text(
              "Nenhuma empresa com esse nome",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _buildAnimatedCompanyList() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        companies.isLoading,
        companies.erro,
        companies.state,
      ]),
      builder: (context, child) {
        if (companies.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (companies.erro.value.isNotEmpty) {
          Future.delayed(Duration.zero, () {
            CustomSnackBar.show(
              context,
              'Erro inesperado. Tente novamente mais tarde!',
              success: false,
            );
          });
        }

        if (companies.state.value.isEmpty) {
          return const Center(
            child: Text(
              "Nenhuma empresa encontrada.",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification ||
                  scrollNotification is ScrollUpdateNotification) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: companies.state.value.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(companies.state.value[index].business_name),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => selectCompany(companies.state.value[index]),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
