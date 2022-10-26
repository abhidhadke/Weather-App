import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';



class Worker{

  late double lat; //latitude of the location
  late double lon; //longitude of the location
  late String location; // Required location
  late double temp; //temperature of the location
  late int humidity; // humidity of the location
  late double airSpeed; // Air Speed of the location
  late String tempType; // Current Weather type
  late int aqi; // Air quality Index
  late String icon; // Icon of the current weather
  late String country; // name of the country
  late String datetime;
  late String tempDescp;
  late int timezone;
  late String city;
  late String state;
  late int id;
  String api = '7db29e6828110cfbb21f51b52d838653'; // Api for OpenWeatherApi



  Future <void> getData() async {
    try {

      //getting location
      var LocUrl = Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$location&limit=1&appid=$api');
      var LocRes = await http.get(LocUrl);
      List Cords = jsonDecode(LocRes.body);
      Map cordsData = Cords[0];
      lat = cordsData['lat'];
      lon = cordsData['lon'];
      country = cordsData['country'];
      city = cordsData['name'];
      state = cordsData['state'];

      // getting data
      var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$api&units=metric');
      var aqiUrl = Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$api');
      var response = await http.get(url);
      var aqiRes = await http.get(aqiUrl);

      // parsing the data
      Map data = jsonDecode(response.body);
      timezone = data['timezone'];


      //getting temp,humidity
      Map mainData = data['main'];
      temp = mainData['temp'];
      humidity = mainData['humidity'];


      // getting temp description, icon
      List Weather = data['weather'];
      Map weatherData = Weather[0];
      tempType = weatherData['main'];
      tempDescp = weatherData['description'];
      icon = weatherData['icon'];
      id = weatherData['id'];

      // getting wind speed
      Map speed = data['wind'];
      airSpeed = speed['speed'];

      // getting aqi of air
      Map Aqi = jsonDecode(aqiRes.body);
      List AqiData = Aqi['list'];
      Map AqiData1 = AqiData[0];
      Map main = AqiData1['main'];
      aqi = main['aqi'];

      DateTime dtime = DateTime.now().add(Duration(seconds: timezone - DateTime.now().timeZoneOffset.inSeconds));
      datetime = DateFormat.jm().format(dtime) + ' - ' + DateFormat('EEEE, d MMM yyyy').format(dtime);

    }
    catch(e){
      //call again if any error found
      getData();
    }
  }


  Worker({required this.location});

}

