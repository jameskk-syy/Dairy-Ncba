import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dairytenantapp/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/colors.dart';
import '../../../../core/cubits/connection_cubit.dart';
import '../../../../core/di/injector_container.dart';
import '../../../../core/network/network.dart';
import '../blocs/cubit/pending_collections_cubit.dart';
import '../blocs/cubit/sync_collections_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PendingCollectionsPage extends StatelessWidget {
  const PendingCollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<PendingCollectionsCubit>()..getPendingCollections(),
        ),
        BlocProvider(create: (context) => sl<SyncCollectionsCubit>()),
        BlocProvider(
          create: (context) => sl<ConnectionCubit>()..checkConnection(),
        ),
      ],
      child: Scaffold(
        //floatingActionButton: _buildFab1(context),
        /*appBar: AppBar(
          title: const Text('Pending Collections'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [

            BlocConsumer<SyncCollectionsCubit, SyncCollectionsState>(
              listener: (context, state) {
                if (state.uiState == UIState.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.exception!),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state.uiState == UIState.loading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    // Set to false to prevent dismissing
                    builder: (BuildContext context) {
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: Dialog(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(height: 16.0),
                                Text('Uploading...'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state.uiState == UIState.success) {
                  Navigator.pop(context);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.scale,
                      title: 'Success',
                      desc: state.message,
                      btnOkOnPress: () {
                        Navigator.pop(context);
                      },
                    ).show();
                  });
                  return const SizedBox.shrink();
                } else {
                  return IconButton(
                    onPressed: () async  {
                      final isConnected = await sl<NetworkInfo>().isConnected();
                      if( isConnected) {
                        BlocProvider.of<SyncCollectionsCubit>(context).syncCollections();
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.sync),
                  );
                }
              },
            )
          ],
        ),*/
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<PendingCollectionsCubit, PendingCollectionsState>(
      listener: (context, state) {
        if (state.uiState == UIState.error) {
          Fluttertoast.showToast(
            msg: state.exception ?? '',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state.uiState == UIState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.uiState == UIState.success) {
          if (state.collections!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No pending collections, Refresh to check again"),
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<PendingCollectionsCubit>(
                        context,
                      ).getPendingCollections();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<PendingCollectionsCubit>(
                  context,
                ).getPendingCollections();
              },
              child: ListView.builder(
                itemCount: state.collections!.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Render sync button as the first item
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(3.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          final isConnected =
                              await sl<NetworkInfo>().isConnected();
                          if (isConnected) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: Dialog(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(height: 16.0),
                                          Text('Uploading...'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            /*BlocListener<SyncCollectionsCubit,
                                SyncCollectionsState>(
                              listener: (context, state) {
                                if (state.uiState == UIState.error) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.exception!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else if (state.uiState == UIState.success) {
                                  Navigator.pop(context);
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.scale,
                                    title: 'Success',
                                    desc: state.message,
                                    btnOkOnPress: () {
                                      Navigator.pop(context);
                                    },
                                  ).show();
                                }
                              },
                              child: const SizedBox.shrink(),
                            );*/
                            BlocProvider.of<SyncCollectionsCubit>(
                              context,
                            ).syncCollections().then((value) {
                              Navigator.pop(context);
                              if (value) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.scale,
                                  title: 'Success',
                                  desc: 'Collections synced successfully',
                                  btnOkOnPress: () {},
                                ).show();
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.scale,
                                  title: 'Error',
                                  desc: 'Failed to sync collections',
                                  btnOkOnPress: () {},
                                ).show();
                              }
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No internet connection'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('Sync'),
                      ),
                    );
                  } else {
                    final collectionIndex = index - 1;
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.lightColorScheme.primary
                                .withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                              0,
                              1,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/milk_placeholder.png",
                                  height: 90,
                                  width: 50,
                                ),
                                Text(
                                  "${state.collections![collectionIndex].quantity} Ltrs",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.numbers,
                                      color: AppColors.lightColorScheme.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        "Farmer/No. ${state.collections![collectionIndex].farmerNumber}",
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sell_outlined,
                                      color: AppColors.lightColorScheme.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        state
                                            .collections![collectionIndex]
                                            .session,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: AppColors.lightColorScheme.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        state
                                            .collections![collectionIndex]
                                            .collectionDate
                                            .split('T')
                                            .first,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.network_cell_outlined,
                                      color: AppColors.lightColorScheme.error,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    const Expanded(
                                      child: Text(
                                        "Not sycned",
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          }
        } else {
          return const Center(child: Text('No pending collections'));
        }
      },
    );
  }
}
