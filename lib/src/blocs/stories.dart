import 'dart:async';
import 'package:hackernewsapp/src/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
//import '../models/item_model.dart';
import '../models/resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int,Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>();

  // Getter to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int,Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to Sinks
  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc(){
    _itemFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache(){
    return _repository.clearCache();
  }

  dispose(){
    _topIds.close();
    _itemsOutput.close();
    _itemFetcher.close();
  }

  _itemsTransformer(){
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, _){
          cache[id] = _repository.fetchItem(id);
          return cache;
        },
        <int, Future<ItemModel>>{},
    );
  }
}