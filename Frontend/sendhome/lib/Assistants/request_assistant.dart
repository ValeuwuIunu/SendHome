import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class RequestAssistant{



  static Future<dynamic> receiveRequest(String url)async{
    http.Response httpResponse = await http.get(Uri.parse(url));

    try{
      if(httpResponse.statusCode ==200){
        String responseData = httpResponse.body;
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;

      }
      else{
        return"Error Ocurred.Failesd No Response";
      }
    }catch(exp){
      return "Error Ocurred. Failed. No Response";
    }
  }
}