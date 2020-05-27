import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';

var selectedCampus = "";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Events Fetcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showEvents = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Press the below button to Fetch Events\n',style: TextStyle(fontWeight: FontWeight.bold),),
            Container(
              // color: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: Card(
                child: ListTile(
                          title: Text("G-Events"),
                          trailing: Icon(
                            Icons.event,
                            color: Colors.black,
                          ),
                          onTap: () async {
                              await selectCampus();
                              var campusCode;
                              print("Clicked");
                              if(showEvents){
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    content: ListTile(
                                      leading: CircularProgressIndicator(),
                                      title: Text("loading.."),
                                    ),
                                  ),
                                );
                                switch (selectedCampus) {
                                case "Visakhapatnam" : campusCode = "cam1";
                                  break;
                                case "Hyderabad" : campusCode = "cam2";
                                  break;
                                case "Bengaluru" : campusCode = "cam3";
                                  break;
                                default:
                              }
                              // Client client = Client();
                              try{
                              final response = await http.get("https://login.gitam.edu/Login.aspx");
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                var eventDates = [];
                                var eventTitles = [];
                                var eventLocation = [];
                                var contactNumber = [];
                                var contactPerson = [];
                                var eventLinks = [];
                                var document = parse(response.body);
                                List<dom.Element> links = document.querySelectorAll('div.event_block.$campusCode');
                                for (var i in links) {
                                  // print(i);
                                  for (var j in i.children) {
                                    eventLinks.add(j.attributes['href']);
                                    // print(j.children);
                                    for (var k in j.children) {
                                      // print(k.children);
                                      for (var l in k.children) {
                                        if (l.children.length > 1) {
                                          // print(l.children[2]);
                                          // print(l.text);
                                          var data = l.text.split(":");
                                          eventLocation.add(data[1].trim());
                                          contactNumber.add(data[2].trim());
                                          contactPerson.add(data[3].trim());
                                        }
                                        else if(l.children.length == 0){
                                          eventTitles.add(l.text);
                                          // print(l.text);
                                        }
                                        else{
                                          eventDates.add(l.text);
                                        }
                                      }
                                    }
                                  }
                                }
                                print("Event Dates are : \n $eventDates");
                                print("Event Titles are : \n $eventTitles");
                                print("Event Locations are : \n $eventLocation");
                                print("Contact Number are: \n $contactNumber");
                                print("Contact Persons are : \n $contactPerson");
                                print("Event Links are : \n $eventLinks");
                                Navigator.pop(context);
                                showGeneralDialog(
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    transitionBuilder: (context, a1, a2, widget) {
                                      return Transform.scale(
                                        scale: a1.value,
                                        child: Opacity(
                                          opacity: a1.value,
                                          child: Dialog(
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: ShapeDecoration(
                                                color: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(15.0))),
                                              ),
                                              height: MediaQuery.of(context).size.height * 0.75,
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 50.0),
                                                    child: ListWheelScrollView(
                                                      physics: ClampingScrollPhysics(),
                                                      diameterRatio: 1.8,
                                                      itemExtent: 150.0,
                                                      magnification: 1.0,
                                                      children: List.generate(eventDates.length, (index) => Container(
                                                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                                      decoration: ShapeDecoration(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        ),
                                                        color: Colors.lightGreen.shade700,
                                                        // color: Colors.orangeAccent.shade400,
                                                        ),
                                                        padding: EdgeInsets.only(top: 10.0,left: 10.0,right: 10.0),
                                                        width: double.infinity,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Align(alignment: Alignment.topRight,child: Text(eventDates[index],overflow: TextOverflow.ellipsis,)),
                                                            SizedBox(height: 10.0,),
                                                            Center(
                                                              child: Text(eventTitles[index],
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  shadows: [
                                                                    Shadow(
                                                                      color: Colors.black,
                                                                      blurRadius: 10.0,
                                                                    ),
                                                                  ],
                                                                  ),
                                                                ),
                                                              ),
                                                            SizedBox(height: 15.0,),
                                                            FittedBox(child: Text("🏛️ : " + eventLocation[index],style: TextStyle(wordSpacing: -2.0),)),
                                                            SizedBox(height: 5.0,),
                                                            FittedBox(child: Text("📞 : " + contactNumber[index])),
                                                            SizedBox(height: 5.0,),
                                                            FittedBox(child: Text("👤 : " + contactPerson[index])),
                                                          ],
                                                        ),
                                                      ))
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: ShapeDecoration(
                                                      color: Theme.of(context).primaryColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(15.0),
                                                          topLeft: Radius.circular(15.0)
                                                        ),
                                                      )
                                                    ),
                                                    alignment: Alignment.topCenter,
                                                    height: 50.0,
                                                    padding: EdgeInsets.only(top: 15.0),
                                                    child: Text("G-Events - $selectedCampus",style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),),
                                                  ),
                                                ],
                                              ),
                                              // child: Text("Hello World"),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    transitionDuration: Duration(milliseconds: 200),
                                    barrierDismissible: true,
                                    barrierLabel: '',
                                    context: context,
                                    pageBuilder: (context, animation1, animation2) {
                                      return Container();
                                    });
                              }
                              } catch(e){
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                    title: Center(child: Text("OOPS..!!")),
                                    content: Text("Something went wrong..Please try again later..!"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: (){
                                          Navigator.pop(context);
                                        } 
                                      ),
                                    ],
                                    )
                                );
                              }
                            }
                            setState(() {
                              showEvents = false;
                            });
                          print("ended");
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future selectCampus(){
    var campuses = ["Visakhapatnam","Hyderabad","Bengaluru"];
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            color: Colors.white,
          ),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: List.generate(
              campuses.length+1,
              (index) => index < 3 ? Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(height: MediaQuery.of(context).size.height * 0.06, child: Center(child: Text(campuses[index],style: TextStyle(color: Colors.lightGreen,fontSize: 20.0),))),
                    onTap: (){
                      setState((){
                        selectedCampus = campuses[index];
                        showEvents = true;
                        });
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1.0,),
                ],
              ) : ListTile(
                    title: Center(child: Text("Cancel",style: TextStyle(color: Colors.red,fontSize: 20.0),)),
                    onTap: (){
                      print(selectedCampus);
                      Navigator.pop(context);
                      setState(() {
                        showEvents = false;
                      });
                    },
                ),
            ),
          ),
        );
      },
    );
  }
  


}