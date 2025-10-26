import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/domain/models/collector_routes_model.dart';

class RouteDetailsPage extends StatelessWidget {
  final CollectorRoutesEntityResponse route;
  const RouteDetailsPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${route.route!} Farmers'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 50,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                 /* showDialog(context: context,
                      builder: (context){
                       return Container(
                         width: 300.0,
                         height: 200.0,
                         decoration: const BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(20.0)),
                         ),
                         child: Material(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               const Text('Select an operation'),
                               const SizedBox(height: 20,),
                               ListTile(
                                 leading: const Icon(Icons.view_agenda_outlined),
                                 title: const Text('View Previous Collections'),
                                 onTap: (){},
                               ),
                               ListTile(
                                 leading: const Icon(Icons.add_task),
                                 title: const Text('Record new Collection'),
                                 onTap: (){},
                               )
                             ],
                           ),
                         ),
                       );
                      }
                  );*/
                  showDialog(
                      context: context,
                      builder: (context){
                        return const AlertDialog(
                          title: Text('Select '),
                          content: Column(
                            children: [
                              /*ListTile(
                                leading: const Icon(Icons.view_agenda_outlined),
                                title: const Text('View Previous Collections'),
                                onTap: (){},
                              ),
                              ListTile(
                                leading: const Icon(Icons.add_task),
                                title: const Text('Record new Collection'),
                                onTap: (){},
                              )*/
                            ],
                          ),
                        );
                      }
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightColorScheme.primary.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.all(5),
                              child: Image.asset('assets/images/farmer.png' , height: 50, width: 50, /*color: Colors.black12*/)
                          ),
                          Container(
                             margin: const EdgeInsets.all(5),
                              child: Text('Farmer $index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),)),
                        ],
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Text('Farmer $index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                          const SizedBox(height: 5,),
                          Text('Farmer $index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

}
