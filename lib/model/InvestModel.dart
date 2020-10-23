import 'dart:math';

import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InvestModel with ChangeNotifier, DiagnosticableTreeMixin {
  List<ListTile> _searchResults = [];
  List get searchResults => _searchResults;

  Set<String> _favoriteStocks = new Set();
  Set<String> get favoriteStocks => _favoriteStocks;


  List _favoriteDetail = [];
  List get favoriteDetail => _favoriteDetail;

  InvestModel() {
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteStocks.addAll(prefs.getStringList('stocks'));
    fetchDetail();
  }


  Future<void> fav(String symbol) async {
    favoriteStocks.add(symbol);
    fetchDetail(stockSymbol: symbol);

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('stocks', favoriteStocks.toList());
  }

  Future<void> disFav(String symbol) async {
    favoriteStocks.remove(symbol);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('stocks', favoriteStocks.toList());
  }

  Future<void> fetchDetail({String stockSymbol}) async {
    if (stockSymbol == null) {
      if (favoriteStocks.length != favoriteDetail.length || favoriteDetail.length == 0) {
        _favoriteDetail.clear();
        for (String symbol in _favoriteStocks) {
          final response = await http
              .get("https://financialmodelingprep.com/api/v3/profile/$symbol?apikey=7904f239e16172e05637e67ca5b2cf46");

          if (response.statusCode == 200) {
            _favoriteDetail.add(jsonDecode(response.body)[0]);
          }
        }
        notifyListeners();
      }
    } else {
      final response = await http
          .get("https://financialmodelingprep.com/api/v3/profile/$stockSymbol?apikey=7904f239e16172e05637e67ca5b2cf46");

      if (response.statusCode == 200) {
        _favoriteDetail.add(jsonDecode(response.body)[0]);
        notifyListeners();
      }
    }

  }

  Future<void> search(String keyword) async {
    final response = await http.get(
        "https://financialmodelingprep.com/api/v3/search?query=$keyword&limit=5&exchange=NASDAQ&apikey=demo");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      _searchResults.clear();
      for (int i = 0; i < data.length; i++) {
        _searchResults.add(ListTile(
          title: Text(data[i]['name']),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => {
              fav(data[i]['symbol']),
            },
          ),
        ));
      }
      notifyListeners();
    }
  }

  void clearSearch() {
    searchResults.clear();
  }
}
