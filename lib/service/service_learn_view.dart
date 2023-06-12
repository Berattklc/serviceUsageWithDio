import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:service_dio_usage/service/post_model.dart';
import 'package:service_dio_usage/service/post_service.dart';

class ServiceLearn extends StatefulWidget {
  const ServiceLearn({super.key});

  @override
  State<ServiceLearn> createState() => _ServiceLearnState();
}

class _ServiceLearnState extends State<ServiceLearn> {
  //sadece bu sayfa kullanacak ise private yapmamız gerekiyor
  List<PostModel>? _items;
  bool _isLoading = false;
  late final Dio _dio;
  final _baseUrl = "https://jsonplaceholder.typicode.com/";

  //Test edilebilir kod başladı
  late final IPostService _postService;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
    _postService = PostService();
    fetchPostItemsAdvance();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  //Dataları çekiyoruz
  Future<void> fetchPostItems() async {
    _changeLoading();

    final response =
        await Dio().get("https://jsonplaceholder.typicode.com/posts");

    if (response.statusCode == HttpStatus.ok) {
      //işlem başarılımı
      final _datas = response.data;
      if (_datas is List) {
        setState(() {
          _items = _datas.map((e) => PostModel.fromJson(e)).toList();
        });
      }
    }
    _changeLoading();
  }

  // Future<void> fetchPostItemsAdvance() async {
  //   _changeLoading();

  //   final response = await _dio.get("posts");

  //   if (response.statusCode == HttpStatus.ok) {
  //     //işlem başarılımı
  //     final _datas = response.data;
  //     if (_datas is List) {
  //       setState(() {
  //         _items = _datas.map((e) => PostModel.fromJson(e)).toList();
  //       });
  //     }
  //   }
  //   _changeLoading();
  // }

  Future<void> fetchPostItemsAdvance() async {
    _changeLoading();

    _items = await _postService.fetchPostItemsAdvance();

    _changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text("Hello"),
        actions: [
          _isLoading ? CircularProgressIndicator.adaptive() : SizedBox.shrink()
        ],
      ),
      body: _items == null
          ? Placeholder()
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _items?.length ?? 0,
              itemBuilder: (context, index) {
                return _PostCard(model: _items?[index]);
              },
            ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    Key? key,
    required PostModel? model,
  })  : _model = model,
        super(key: key);

  final PostModel? _model;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black45,
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text(_model?.title ?? ""),
        subtitle: Text(_model?.body ?? ""),
      ),
    );
  }
}
