/*
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: false,
            expandedHeight: 250.0,
            flexibleSpace: Container(
              padding: EdgeInsets.only(left: 20, top: 70, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Budget Left',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    '\$ 450',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Expanded(child: SizedBox(),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.playlist_add, color: Colors.white),
                        iconSize: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
 */