import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:sendhome/global/global.dart";
import "package:sendhome/splashScreen/splash_screen.dart";
import "package:smooth_star_rating_nsafe/smooth_star_rating.dart";

class RateDriverScreen extends StatefulWidget {
  String? assignedDriverId;

  RateDriverScreen({this.assignedDriverId});

  @override
  State<RateDriverScreen> createState() => _RateDriverScreenState();
}

class _RateDriverScreenState extends State<RateDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14)
      ),
      backgroundColor: Colors.transparent,
      child:Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
              borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22,),

            Text(
              "Califica tu experiencia",
              style: TextStyle(
                fontSize: 22,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),

            SizedBox(height: 20,),
            Divider(thickness: 2,color: Colors.deepPurpleAccent,),
            SizedBox(height: 20,),
            SmoothStarRating(
              rating: countRatingStars,
              allowHalfRating: false,
              starCount: 5,
              color: Colors.deepPurpleAccent,
              borderColor: Colors.grey,
              size: 46,
              onRatingChanged: (valueOfStarsChoosed){
                countRatingStars=valueOfStarsChoosed;

                if(countRatingStars ==1){
                  setState(() {
                    titleStarsRating="Muy mala";
                  });
                }
                if(countRatingStars ==2){
                  setState(() {
                    titleStarsRating="Mala";
                  });
                }
                if(countRatingStars ==3){
                  setState(() {
                    titleStarsRating="Buena";
                  });
                }
                if(countRatingStars ==4){
                  setState(() {
                    titleStarsRating="Muy buena";
                  });
                }
                if(countRatingStars ==5){
                  setState(() {
                    titleStarsRating="Excelente";
                  });
                }
              },
            ),

            SizedBox(height: 10,),
            Text(
              titleStarsRating,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color:Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              DatabaseReference rateDriverRef = FirebaseDatabase.instance.ref()
                  .child("drivers")
                  .child(widget.assignedDriverId!)
                  .child("raitings");

              rateDriverRef.once().then((snap){
                if(snap.snapshot.value == null){
                  rateDriverRef.set(countRatingStars.toString());

                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (c) => SplashScreen()));
                }
                else{
                  double pastRating = double.parse(snap.snapshot.value.toString());
                  double newAverageRatings = (pastRating+ countRatingStars)/2;
                  rateDriverRef.set(newAverageRatings.toString());

                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SplashScreen()));
                }
                Fluttertoast.showToast(msg: "Volviendo al inicio");
              });
            },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurpleAccent,
                padding: EdgeInsets.symmetric(horizontal: 70),
              ),
                child: Text("Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
