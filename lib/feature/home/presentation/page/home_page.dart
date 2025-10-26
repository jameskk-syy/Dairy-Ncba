import 'dart:convert';
import 'package:dairytenantapp/feature/auth/presentation/pages/login_page.dart';
import 'package:dairytenantapp/feature/home/presentation/page/recent_collections_page.dart';
import 'package:dairytenantapp/feature/home/presentation/page/recent_sales_page.dart';
import 'package:dairytenantapp/feature/home/presentation/widgets/subtotals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../../../collections/presentation/pages/add_collection_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../cubit/home_cubit.dart';
import '../widgets/header_widget.dart';
import '../widgets/home_stats_widget.dart';
import '../widgets/monthly_stats.dart';
import '../widgets/routes_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();

  Color left = AppColors.lightColorScheme.onPrimary;

  Color right = AppColors.lightColorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final roles = user.roles!.map((e) => e.name).toList();
    final role = roles[0];
    final collectorId = user.id;
    final userName = user.username;
    final  cooperativeName  =user.tenantName;
    final date = getTodaysDate();

    return BlocProvider(
      create:
          (context) =>
              sl<HomeCubit>()
                ..getTotalFarmers(collectorId)
                ..getTotalCollections(collectorId, date)
                ..getTotalLitres(collectorId, date)
                ..getTotalSubCollections(date)
                ..getSubCollectorsTotals(date)
                ..getMonthlyTotals(DateTime.now().toLocal().month, collectorId)
                ..getCollectorRoutes(collectorId),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cooperativeName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${getGreetingsMessage()}, $userName",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          height: 2,
                          width: 30,
                          color: Colors.black,
                          child: const Center(child: Text("Menu")),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: const Icon(Icons.account_circle_sharp),
                            title: const Text('Profile'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 5,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                            onTap: () async {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.account_circle_sharp, size: 30),
            ),
          ],
        ),
        body: _buildBody(context, role!, collectorId!),
        floatingActionButton: _buildFab(context),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddCollectionPage(visible: true),
          ),
        );
      },
      child: const Icon(Icons.add, color: AppColors.black),
    );
  }

  Widget _buildBody(BuildContext context, String role, int collectorID) {
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const CollectionsQuickStatsWidget(),
            const SizedBox(height: 5),
            role == "MILK_COLLECTOR"
                ? const SubCollectorTotals()
                : const SizedBox(),
            role == "MILK_COLLECTOR" || role == "TRANSPORTER"
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('My Routes', style: TextStyle(fontSize: 17)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {},
                        child: const Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ),
                  ],
                )
                : const SizedBox(),
            const SizedBox(height: 5),
            role == 'MILK_COLLECTOR' || role == "TRANSPORTER"
                ? const RoutesWidget()
                : Container(),
            const SizedBox(height: 5),
            role == "MILK_COLLECTOR" || role == "TRANSPORTER"
                ? Container(
                  height: 45,
                  width: 300,
                  decoration: BoxDecoration(
                    color: AppColors.lightColorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Monthly Totals',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
                : HeaderWidget(
                  context: context,
                  pageController: pageController,
                  onSalesPressed: _onSalesPressed,
                  onColectionsPressed: _onCollectionsPressed,
                  left: left,
                  right: right,
                ),
            role == "MILK_COLLECTOR" || role == "TRANSPORTER"
                ? const MonthlyStats()
                : Expanded(
                  flex: 2,
                  child: PageView(
                    controller: pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (i == 0) {
                        setState(() {
                          right = AppColors.lightColorScheme.secondary;
                          left = AppColors.lightColorScheme.onPrimary;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = AppColors.lightColorScheme.onPrimary;
                          left = AppColors.lightColorScheme.secondary;
                        });
                      }
                    },
                    children: <Widget>[
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const RecentCollectionsPage(),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const RecentSalesPage(),
                      ),
                    ],
                  ),
                ),

            /*Expanded(
              flex: 2,
              child: PageView(
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                onPageChanged: (int i) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (i == 0) {
                    setState(() {
                      right = AppColors.lightColorScheme.secondary;
                      left = AppColors.lightColorScheme.onPrimary;
                    });
                  } else if (i == 1) {
                    setState(() {
                      right = AppColors.lightColorScheme.onPrimary;
                      left = AppColors.lightColorScheme.secondary;
                    });
                  }
                },
                children: <Widget>[
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: const RecentCollectionsPage(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.expand(),
                    child: const RecentSalesPage(),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  void _onCollectionsPressed() {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }

  void _onSalesPressed() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
    );
  }
}
