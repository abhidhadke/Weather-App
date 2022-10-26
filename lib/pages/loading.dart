import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wheather/worker/worker.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {



  void SetData () async {
    try {
      Worker instance = Worker(location: "Pune");
      await instance.getData();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': instance.location,
        'temp': instance.temp,
        'type': instance.tempType,
        'humidity': instance.humidity,
        'speed': instance.airSpeed,
        'aqi': instance.aqi,
        'icon': instance.icon,
        'country': instance.country,
        'time' : instance.datetime,
        'description' : instance.tempDescp,
        'city' : instance.city,
        'state' : instance.state,
        'id' : instance.id
      });


    }
    catch(e){
      SetData();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SetData();

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white70,
          size: 105.0,
        ),
      )
    );
  }
}
