import 'package:flutter/material.dart';
import 'package:sendhome/splashScreen/splash_screen.dart';

class PayFareAmountDialog extends StatefulWidget {


  double? fareAmount;
  
  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color:Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Text("Fare Amount".toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:Colors.white,
              fontSize: 16,
            ),
            ),
            SizedBox(height: 10,),
            Divider(thickness: 1,color: Colors.grey[300],),
            SizedBox(height: 10,),
            
            Text(
              "\$ "+widget.fareAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:Colors.white,
                fontSize: 50
              ),
            ),

            SizedBox(height: 10,),

            Padding(
                padding: EdgeInsets.all(10),
              child:Text(
                "This is the total trip fare amount.Please pay it to the driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ),

            SizedBox(height: 10,),

            Padding(
                padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                onPressed: (){
                  Future.delayed(Duration(milliseconds: 10000),(){
                    Navigator.pop(context,"Cash Paid");
                    Navigator.push(context,MaterialPageRoute(builder: (c)=> SplashScreen()));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Pay Cash",
                      style: TextStyle(
                        fontSize: 20,
                        color:Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "\$ " +widget.fareAmount.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color:Colors.deepPurpleAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10,)
          ],
        ),
      ),

    );
  }
}
