import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/data/dto/login_response_dto.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/utils/utils.dart';
import '../cubit/routes_cubit.dart';

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoutesCubit>(
        create: (_) => sl<RoutesCubit>(),
        child: BlocBuilder<RoutesCubit, RoutesState>(
          builder: (context, state){
            if(state.uiState == UIState.initial){
              dispatchGetRoutes(context);
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(state.uiState == UIState.loading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if(state.uiState == UIState.error){
              /*ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!))
              );*/
              return Center(
                child: TextButton(
                  onPressed: () => dispatchGetRoutes(context),
                  child: Text('Retry', style: TextStyle(color: AppColors.lightColorScheme.primary),
                ),
              )
              );
            } else if(state.uiState == UIState.success){
              if(state.routes!.isEmpty){
                return const Center(
                  child: Text('No routes found'),
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.routes!.length,
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  RouteDetailsPage(route: state.routes![index])
                              ),
                          );*/
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightColorScheme.secondary.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/route.png', height: 40, width: 40,),
                              const SizedBox(height: 5,),
                             // const Text('Test Route', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                              //const SizedBox(height: 3,),
                             // const Text('Route 1', style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),),
                              Text(state.routes![index].route ?? 'Unavailable', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                              const SizedBox(height: 3,),
                              Text(state.routes![index].routeCode ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal),),
                            ],
                          ),
                        ),
                      );
                    }
                ),
              );
            } else {
              return const Center(child: Text('An error occurred'),);
            }
          },
        )
    );
  }

  void dispatchGetRoutes(BuildContext context){
    final prefs = sl<SharedPreferences>();
    final userData = prefs.getString("userData");
    final user = LoginResponseDto.fromJson(jsonDecode(userData!));
    final collectorId = user.id;
    BlocProvider.of<RoutesCubit>(context).getCollectorRoutes(collectorId!);
  }
}
