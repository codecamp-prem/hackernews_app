import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'src/blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'src/blocs/comments_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News from HackerNews',
          //home: NewsList(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings){
    if(settings.name == '/'){
      return MaterialPageRoute(
        builder: (context){

          final storiesBloc = StoriesProvider.of(context);

          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    }else{
      return MaterialPageRoute(
        builder: (context){
          final commentsBloc = CommentsProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', ''));

          commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }

  }
}
