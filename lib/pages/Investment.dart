import 'package:finance/model/InvestModel.dart';
import 'package:finance/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Investment extends StatefulWidget {
  @override
  _InvestmentState createState() => _InvestmentState();
}

class _InvestmentState extends State<Investment> {
  List<Widget> cards = [];

  @override
  void initState() {
    super.initState();
    context.read<InvestModel>().fetchDetail();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        height: double.infinity,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            children: [
              Text("Stock", style: TextStyle(color: mainColor, fontSize: 40)),
              SizedBox(
                height: 20,
              ),
              StockSearchBox(),
              SizedBox(
                height: 20,
              ),
              ...buildDetailCard(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildDetailCard(BuildContext context) {
    List details = context.watch<InvestModel>().favoriteDetail;
    cards.clear();
    for (int i = 0; i < details.length; i++) {
      if (details[i] == null) {
        cards.add(
          Container(
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  color: mainColor, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: CircularProgressIndicator(),
              )),
        );
      } else {
        cards.add(
          Container(
            width: MediaQuery.of(context).size.width - 40,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: mainColor, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(details[i]['exchangeShortName'], style: TextStyle(color: Colors.white),),
                    IconButton(
                      icon:
                      context.watch<InvestModel>().favoriteStocks.contains(details[i]['symbol']) ?
                      Icon(Icons.star,
                          color: Colors.white
                      ) :
                      Icon(Icons.star_border,
                          color: Colors.white
                      ),
                      onPressed: () => {context.read<InvestModel>().disFav(details[i]['symbol'])},
                    )
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          details[i]['symbol'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          details[i]['companyName'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            details[i]['price'].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 25,
                            width: 60,
                            decoration: BoxDecoration(
                              color: details[i]['changes'] <= 0 ?
                                  Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text(
                                details[i]['changes'].toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                ]),
              ],
            ),
          ),
        );
      }
    }
    return cards;
  }
}

class StockSearchBox extends StatefulWidget {
  @override
  _StockSearchBoxState createState() => _StockSearchBoxState();
}

class _StockSearchBoxState extends State<StockSearchBox> {
  String searchInput = '';

  final FocusNode _focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: majorInputBoxStyle,
      height: 60.0,
      child: CompositedTransformTarget(
        link: this._layerLink,
        child: TextFormField(
          focusNode: this._focusNode,
          style: TextStyle(
            color: mainColor,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Search...',
            prefixIcon: Icon(
              Icons.search,
              color: mainColor,
            ),
          ),
          onChanged: (text) => {context.read<InvestModel>().search(text)},
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      OutlineButton(
                        child: Text("Close"),
                        onPressed: () => {FocusScope.of(context).unfocus(),
                          context.read<InvestModel>().clearSearch()
                        },
                      ),
                      ...context.watch<InvestModel>().searchResults
                    ],
                  ),
                ),
              ),
            ));
  }
}
