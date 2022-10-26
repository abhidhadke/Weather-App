import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:wheather/worker/worker.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    late Map data = {};

    try{  data = data.isNotEmpty? data: ModalRoute.of(context)?.settings.arguments as Map;  }
    catch(e){  data = data;  }

    late String bgimage;
    bool isDayTime = data['icon'][2].startsWith('d');
    String rain = isDayTime ? 'rain_day.png' : 'rain_night.png';
    String haze = isDayTime ? 'haze_day.png' : 'haze_night.png';
    String clear = isDayTime ? 'clear_day.png' : 'clear_night.png';
    String cloud = isDayTime ? 'cloud_day.png' : 'cloud_night.png';
    String mist = isDayTime ? 'mist_day.png' : 'mist_night.png';
    String snow = isDayTime ? 'snow_day.png' : 'snow_night.png';

    if (data['id'] == 800){
      bgimage = clear;
    }
    else if (200 <= data['id'] && data['id'] <= 350){
      bgimage = rain;
    }
    else if (800 < data['id'] && data['id'] < 805){
      bgimage = cloud;
    }
    else if ((700 < data['id'] && data['id'] < 712) || (725 < data['id'] && data['id'] < 790)){
      bgimage = mist;
    }
    else if (data['id'] == 721){
      bgimage = haze;
    }
    else if (600 <= data['id'] && data['id'] < 630){
      bgimage = snow;
    }
    else {
      bgimage = clear;
    }


    //set weather icon
    String icon = data['icon'];
    //set aqi
    late String aqi;
    if (data['aqi'] == 1){
      aqi = 'Very Good';
    }
    else if (data['aqi'] == 2){
      aqi = 'Good';
    }
    else if (data['aqi'] == 3){
      aqi = 'Moderate';
    }
    else if (data['aqi'] == 4){
      aqi = 'Poor';
    }
    else{
      aqi = 'Very Poor';
    }

    void getCity (String loc) async {


      Worker instance1 = Worker(location: loc);
      await instance1.getData();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        'location': instance1.location,
        'temp': instance1.temp,
        'type': instance1.tempType,
        'humidity': instance1.humidity,
        'speed': instance1.airSpeed,
        'aqi': instance1.aqi,
        'icon': instance1.icon,
        'country': instance1.country,
        'time' : instance1.datetime,
        'description' : instance1.tempDescp,
        'city' : instance1.city,
        'state' : instance1.state,
        'id' : instance1.id
      });
      Loader.hide();
    }

    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: 'Error fetching data!!  Try again!',
        contentType: ContentType.failure,
      ),
    );

    @override
    void dispose() {
      Loader.hide();
      debugPrint("Called dispose");
      super.dispose();
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Image.asset('assets/$bgimage',fit: BoxFit.fill,height: double.infinity,width: double.infinity,),
            Container(decoration: const BoxDecoration(color: Colors.black38),),

            SafeArea(
              child: SearchBarAnimation(
                textEditingController: TextEditingController(
                ),
                isOriginalAnimation: false,
                enableKeyboardFocus: true,
                trailingWidget: const Icon(Icons.search, color: Colors.white,),
                secondaryButtonWidget: const Icon(Icons.close_rounded),
                buttonWidget: const Icon(Icons.search_rounded),
                hintText: 'Search Cities',
                hintTextColour: Colors.white60,
                searchBoxColour: Colors.transparent.withOpacity(0.4),
                buttonColour: Colors.transparent.withOpacity(0.5),
                textInputType: TextInputType.text,
                enteredTextStyle: const TextStyle(color: Colors.white),

                onFieldSubmitted: (String value){
                  setState(() {
                    debugPrint(value);
                    getCity(value);
                    Loader.show(context,
                        isSafeAreaOverlay: false,
                        isBottomBarOverlay: false,
                        overlayFromBottom: 80,
                        overlayColor: Colors.black26,
                        progressIndicator: const CircularProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                        themeData: Theme.of(context)
                            .copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green))
                    );
                    Future.delayed(const Duration(seconds: 10), () {
                      Loader.hide();
                      debugPrint("Loader is being shown after hide ${Loader.isShown}");
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  });
                },

              ),
            ),

            Stack(
            children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                const SizedBox(height: 120,),
                                Text(
                                data['city'] + ', ' + data['state'] + ', ' + data['country'],
                                style: GoogleFonts.lato(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                                ),
                                  Text(
                                    data['time'],
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                              ]
                   ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data['temp'].toStringAsFixed(1) + ' °',
                                        style: GoogleFonts.lato(
                                            fontSize: 60,
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(
                                      'C',
                                        style: GoogleFonts.openSans(
                                            fontSize: 45,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.network('https://openweathermap.org/img/wn/$icon@2x.png', width: 60, height: 60,),
                                      const SizedBox(width: 10,),
                                      Text(
                                        data['type'] + ', ' + data['description'],
                                        style: GoogleFonts.lato(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                        ),
                                      )
                                  ],
                                  )
                                    ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              margin : const EdgeInsets.symmetric(vertical: 40),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white30,

                                )
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Wind',
                                      style: GoogleFonts.lato(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      (data['speed']*3.6).toStringAsFixed(1),
                                      style: GoogleFonts.lato(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      'km/hr',
                                      style: GoogleFonts.lato(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'AQI',
                                      style: GoogleFonts.lato(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      data['aqi'].toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                    aqi,
                                    style: GoogleFonts.lato(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Humidity',
                                      style: GoogleFonts.lato(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      data['humidity'].toString(),
                                      style: GoogleFonts.lato(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                    Text(
                                      '%',
                                      style: GoogleFonts.lato(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),

                  ),



            ],
          )],
        ),
        
    );
  }
}

