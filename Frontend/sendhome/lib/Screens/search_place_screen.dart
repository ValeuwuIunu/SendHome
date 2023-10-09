import 'package:flutter/material.dart';
import 'package:sendhome/Assistants/request_assistant.dart';
import 'package:sendhome/global/map_key.dart';
import 'package:sendhome/models/predicted_place.dart';
import 'package:sendhome/widgets/place_prediction_tile.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({Key? key}): super(key:key);

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {

  List<Predictedplaces>placesPreditedList = [];
  findPlaceAutoCompleteSearch(String inputText) async{
    if(inputText.length > 1){
      String urlAutoCompleteSearch ="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:CO";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch =="Error Ocurred.Failesd No Response"){
        return;
      }

      if(responseAutoCompleteSearch["status"]=="OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredicitonsList = (placePredictions as List).map((jsonData) => Predictedplaces.fromJson(jsonData)).toList();

        setState(() {
          placesPreditedList =placePredicitonsList;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(47, 8, 73, 2.9),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.white),
          ),
          title: Text(
            "Buscar ubicación de entrega",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(47, 8, 73, 2.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),

              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 18.0,),

                        Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: TextField(
                                onChanged: (value) {
                                  findPlaceAutoCompleteSearch(value);
                                },
                                decoration: InputDecoration(
                                  hintText: "Ingresa la úbicación acá",
                                  fillColor: Colors.white54,
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 11,
                                    top: 8,
                                    bottom: 8
                                  )
                                ),
                                cursorColor: Colors.deepPurpleAccent,
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            //display place predictionresult
            (placesPreditedList.length>0)
            ?Expanded(
                child: ListView.separated(
                    itemCount: placesPreditedList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder:(context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPreditedList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context,int index){
                      return Divider(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                        thickness: 0,
                      );
                    },
                ),
            ) :Container(),
          ],
        ),
      ),
    );
  }
}
