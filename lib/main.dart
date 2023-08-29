import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grid_tabb_app/repository/repository.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/data_bloc.dart';
import 'bloc/data_event.dart';
import 'bloc/data_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => DataBloc(DataRepository()),
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.add(FetchDataEvent());
    return Scaffold(
      appBar: AppBar(title: Text('Images')),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoadingState) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is DataLoadedState) {
            return SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 3,
                children: List.generate(
                  state.data.length,
                  (index) {
                    double reducedHeight = (state.data[index].height! / 3).toDouble();
                    double reducedWidth = (state.data[index].width! / 2).toDouble();
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CatDetailView(id: state.data[index].id!),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: state.data[index].url!,
                        height: reducedHeight,
                        width: reducedWidth,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        placeholder: (context, url) => ShimmerBox(
                          height: reducedHeight,
                          width: reducedWidth,
                          borderRadius: 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is DataErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}

class CatDetailView extends StatelessWidget {
  final String id;

  CatDetailView({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cat Details")),
      body: Center(child: Text("ID: $id")),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Alignment alignment;

  const ShimmerBox({
    Key? key,
    required this.height,
    required this.width,
    required this.borderRadius,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color lightGray = Color(0xffe0e0e0);
    final Color shimmerBaseColor = lightGray.withOpacity(0.5);
    final Color shimmerHighlightColor = lightGray.withOpacity(0.2);

    return Align(
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        child: Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            decoration: BoxDecoration(
              color: shimmerBaseColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}
