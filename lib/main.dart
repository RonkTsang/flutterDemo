// Flutter code sample for AboutListTile

// This sample shows two ways to open [AboutDialog]. The first one
// uses an [AboutListTile], and the second uses the [showAboutDialog] function.

import 'package:flutter/material.dart';

//import 'package:english_words/english_words.dart';
import 'package:english_words/english_words.dart';
// Dart 函数语法
void main() => runApp(App());

/// This Widget is the main application widget.
/// Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.
class App extends StatelessWidget {

  // 理解为 渲染函数
  @override
  Widget build (BuildContext ctx) {
    Color c = const Color.fromRGBO(211, 44, 245, 1.0);
    nouns.take(50).forEach(print);
    return new MaterialApp(
      home: RandomWord(),
      debugShowCheckedModeBanner: true,
      color: c,
        theme: ThemeData.dark(),
    );
  }
}

/// Stateful widgets 持有的状态可能在widget生命周期中发生变化.
/// 实现一个 stateful widget 至少需要两个类:
///  - 一个 StatefulWidget类。
///  - 一个 State类。 StatefulWidget类本身是不变的，但是 State类在 widget 生命周期中始终存在.
class RandomWord extends StatefulWidget {
  @override
  State<StatefulWidget> createState () => RandomWordState();
}

class RandomWordState extends State<RandomWord> {
  final _wordList = <WordPair>[];

  final _biggerFont = new TextStyle(
      fontSize: 18.0,
      color: Color.fromRGBO(167, 50, 70, 1)
  );

  final _loveSet = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
//    final wp = new WordPair.random();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
//              print('yep you press me');
              _routeToFavorite();
            },
          ),
          IconButton(
            icon: Icon(Icons.album),
            onPressed: () {
              print('Hello');
            },
          ),
        ],
//        actionsIconTheme: IconThemeData(
//          color: Colors.deepPurple[400],
//
//        ),
      ),
      body: _buildList()
    );
  }

  void _routeToFavorite () {
    Navigator.of(context).push(
        _genFavoritePage()
    );
  }

  Route _genFavoritePage () {
    return MaterialPageRoute(
        builder: (contxt) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('收藏 ❤️'),
              ),
            body: _genFavoriteList(),
          );
        }
    );
  }

  Widget _genFavoriteList () {
    return FavoriteList(_loveSet, () {
      setState((){});
    });
  }

  ListView _buildList() {
    return new ListView.builder(
        itemCount: 20,
        itemBuilder: (context, i) {
          if (i >= _wordList.length) {
            _wordList.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_wordList[i], i);
        }
    );
  }

  Widget _buildRow(WordPair pair, int index) {
    final isLove = _loveSet.contains(pair);

    return Column(
      children: <Widget>[
        Divider(),
        ListTile(
          title: Text(pair.asPascalCase, style: _biggerFont),
          subtitle: Text('index: ${index.toString()}'),
          trailing: Icon(
            isLove ? Icons.favorite : Icons.favorite_border,
            color: isLove ? Colors.deepOrangeAccent : Colors.black26,
            size: 25,
          ),
          onTap: () {
            setState(() {
              if (_loveSet.contains(pair)) {
                _loveSet.remove(pair);
              } else {
                _loveSet.add(pair);
              }
            });
          },
        )
      ],
    );
  }
}

class FavoriteList extends StatefulWidget {
  Set loveSet;
  Function onDelete;
  FavoriteList (this.loveSet, [this.onDelete]): super();
  @override
  State<StatefulWidget> createState() {
    return FavoriteListState(loveSet, onDelete);
  }
}

class FavoriteListState extends State<FavoriteList> {
  Set loveSet;
  Function onDelete;
  FavoriteListState (this.loveSet, this.onDelete): super();

  @override
  Widget build(BuildContext context) {
    final rows = loveSet.map((e) => (
        ListTile(
          title: Text(e.asPascalCase),
          onLongPress: () {
            print('长按: ');
            print(e);
            UIUtil.confirm(
                context: context,
                text: '确定删除吗？',
                onSucc: () {
                  final word = e;
                  if (loveSet.contains(word)) {
                    setState(() {
                      loveSet.remove((word));
                    });
                    if (onDelete is Function) {
                      onDelete();
                    }
                  }
                  print('取消收藏');
                },
                onCancel: () {
                  print('取消收藏');
                }
            );
          },
        )
    ));

    final divideList = ListTile.divideTiles(
        context: context,
        tiles: rows
    ).toList();

    return ListView(
      children: divideList,
    );
  }
}

class UIUtil {
  static confirm ({
    @required
    BuildContext context,

    @required
    String text,

    Function onSucc,

    Function onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 18),
                  child: Text(text, style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            if (onSucc is Function) {
                              onSucc();
                            }
                            // 关闭 Dialog
                            Navigator.pop(context);
                          },
                          child: Text('确定')),
                    ),
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            if (onCancel is Function) {
                              onCancel();
                            }
                            // 关闭 Dialog
                            Navigator.pop(context);
                          },
                          child: Text('取消')),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}