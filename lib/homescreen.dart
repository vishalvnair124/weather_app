import 'package:geolocator/geolocator.dart';
import 'constants.dart' as k;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoded = false;
  num temp = 0;
  num pressure = 0;
  num humidity = 0;
  num cover = 0;
  String cityname = "";

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff4158D0), Color(0xffC850C0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: Visibility(
          visible: isLoded,
          replacement: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.09,
                padding: const EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: TextFormField(
                    onFieldSubmitted: (String s) {
                      cityname = s;
                      getCityWeather(cityname);
                      isLoded = false;
                      controller.clear();
                    },
                    controller: controller,
                    cursorColor: Colors.white.withOpacity(0.3),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.7)),
                    decoration: InputDecoration(
                      hintText: 'Search city',
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      size: 40,
                      color: Colors.red,
                    ),
                    Text(
                      cityname,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Image(
                          image: const AssetImage('images/thermometer.png'),
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          'Temperature  : ${temp.toStringAsFixed(1)}℃',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Image(
                          image: const AssetImage('images/barometer.png'),
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          'Pressure         : $pressure hPa',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Image(
                          image: const AssetImage('images/humidity.png'),
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          'Humidity         : $humidity ',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.10,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      offset: const Offset(1, 2),
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      15,
                    ),
                  ),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Image(
                          image: const AssetImage('images/cloud cover.png'),
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          'Cloud cover    : $cover ',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void getCurrentLocation() async {
    var p = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true);
    getCurrentCityWeather(p);
  }

  void getCurrentCityWeather(Position p) async {
    var client = http.Client();
    var uri =
        '${k.domain}lat=${p.latitude}&lon=${p.longitude}&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = jsonDecode(data);
      updateUI(decodeData);
      setState(() {
        isLoded = true;
      });
    } else {
      getCurrentLocation();
    }
  }

  void getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var data = response.body;
      print(data);
      var decodeData = jsonDecode(data);
      updateUI(decodeData);
      setState(() {
        isLoded = true;
      });
    }
  }

  void updateUI(var decodedData) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        humidity = 0;
        cover = 0;
        pressure = 0;

        cityname = "Not available";
      } else {
        temp = decodedData['main']['temp'] - 273;
        humidity = decodedData['main']['humidity'];
        cover = decodedData['clouds']['all'];
        pressure = decodedData['main']['pressure'];
        cityname = decodedData['name'];
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
