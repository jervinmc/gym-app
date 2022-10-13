import 'dart:convert';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

List<LatLng> latlngSegment1 = [];

class MapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  bool isReady = false;
  LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
  LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);
  String category_select = '';
  final items = [
    'College of Agriculture, Food, Environment and Natural Resources',

    'College of Arts and Sciences',
    'College of Criminal Justice',
    'College of Economics, Management and Development Studies',
    'College of Education',
    'College of Engineering and Information Technology',
    'College of Nursing',
    'College of Sports, Physical Education and Recreation',
    'College of Veterinary Medicine and Biomedical Sciences',
    'Office of the Student Affairs and Services',
     'University Infirmary',
    'University Library',
    'University Marketing Center',
    'University Registrar',
    
  ];
  final Set<Polyline> _polyline = {};
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  // for my drawn routes on the map
  // Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  String googleAPIKey = "AIzaSyBF-Wtun3Oqsj5-z7v99Pq6lbtCJGicXpc";
  // for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  // the user's initial location and current location
  // as it moves
  LocationData? currentLocation;
  // a reference to the destination location
  LocationData? destinationLocation;
  // wrapper around the location API
  late Location location;
  CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      // tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(37.335685, -122.0605916));
  // if (currentLocation != null) {
  //   initialCameraPosition = CameraPosition(
  //       target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
  //       zoom: CAMERA_ZOOM,
  //       tilt: CAMERA_TILT,
  //       bearing: CAMERA_BEARING);
  // }

  @override
  void initState() {
    super.initState();

    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();
    //  _getPolyline();
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged().listen((LocationData cLoc) {
      latlngSegment1 = [];
      setState(() {});
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it

      currentLocation = cLoc;
      if (!isReady) {
        print("work");
        print(currentLocation!.longitude);
        initialCameraPosition = CameraPosition(
            zoom: CAMERA_ZOOM,
            // tilt: CAMERA_TILT,
            bearing: CAMERA_BEARING,
            target:
                LatLng(currentLocation!.latitude, currentLocation!.longitude));
        isReady = true;
        setState(() async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(
              CameraUpdate.newCameraPosition(initialCameraPosition));
        });
      }
      SOURCE_LOCATION =
          LatLng(currentLocation!.latitude, currentLocation!.longitude);

      latlngSegment1
          .add(LatLng(currentLocation!.latitude, currentLocation!.longitude));
      latlngSegment1
          .add(LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude));
      if (category_select != 'Change') {
        updatePinOnMap();
      }
    });
    setInitialLocation();
    // set custom marker pins
    //  setSourceAndDestinationIcons();
    // set the initial location
  }
// void setSourceAndDestinationIcons() async {
//    sourceIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 2.5),
//          'assets/images/driving_pin.png');

//    destinationIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(devicePixelRatio: 2.5),
//          'assets/destination_map_marker.png');
// }
  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Color(0xffef5777),
        title: Text('Maps'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 350,
            width: 500,
            child: GoogleMap(
                scrollGesturesEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                markers: _markers,
                polylines: _polyline,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  // my map has completed being created;
                  // i'm ready to show the pins on the map
                  showPinsOnMap();
                }),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          // Container(
          //     width: 350,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(5),
          //         border: Border.all(color: Colors.black, width: 1)),
          //     padding: EdgeInsets.only(top: 10),
          //     child: DropdownButton<String>(
          //       hint: category_select=='' ? Text("Select Office/Department") : Text('${category_select}'),
          //       itemHeight: 60,
          //       isExpanded:true,
          //         items: items.map(buildMenuItem).toList(),
              
          //         onChanged: (category_select) => setState(() {
          //               this.category_select = category_select!;
          //               setState(() {
          //                 // 'University Marketing Center','University Registrar','University Library','College of Economics','College of Nursing','College of Veterenary Medicine'
          //                 if (category_select == 'University Library') {
          //                   DEST_LOCATION = LatLng(14.199478, 120.882407);
          //                 }
          //                 if (category_select == 'University Infirmary') {
          //                   DEST_LOCATION = LatLng(14.197527, 120.880091);
          //                 }
          //                 if (category_select ==
          //                     'University Marketing Center') {
          //                   DEST_LOCATION =
          //                       LatLng(14.196401713919988, 120.88167769261024);
          //                 } else if (category_select ==
          //                     'University Registrar') {
          //                   DEST_LOCATION =
          //                       LatLng(14.197609763546314, 120.88230296889176);
          //                 } else if (category_select == 'College of Nursing') {
          //                   DEST_LOCATION =
          //                       LatLng(14.20053001805633, 120.88188158007783);
          //                 } else if (category_select ==
          //                     'College of Economics, Management and Development Studies') {
          //                   DEST_LOCATION =
          //                       LatLng(14.199119762841994, 120.8829756737161);
          //                 } else if (category_select ==
          //                     'College of Veterinary Medicine and Biomedical Sciences') {
          //                   DEST_LOCATION =
          //                       LatLng(14.202642718597561, 120.88177354721309);
          //                 } else if (category_select ==
          //                     'Office of the Student Affairs and Services') {
          //                   DEST_LOCATION =
          //                       LatLng(14.197608345732224, 120.88237901810474);
          //                 } else if (category_select ==
          //                     'College of Engineering and Information Technology') {
          //                   DEST_LOCATION =
          //                       LatLng(14.199388596349173, 120.88071275263907);
          //                 } else if (category_select ==
          //                     'College of Sports, Physical Education and Recreation') {
          //                   DEST_LOCATION =
          //                       LatLng(14.197376030829396, 120.88244217546466);
          //                 } else if (category_select ==
          //                     'College of Education') {
          //                   DEST_LOCATION =
          //                       LatLng(14.198525547073766, 120.88043678519679);
          //                 } else if (category_select ==
          //                     'College of Arts and Sciences') {
          //                   DEST_LOCATION =
          //                       LatLng(14.199840525698145, 120.88208020886763);
          //                 } else if (category_select ==
          //                     'College of Criminal Justice') {
          //                   DEST_LOCATION =
          //                       LatLng(14.198207807665492, 120.87987131026155);
          //                 } else if (category_select ==
          //                     'College of Agriculture, Food, Environment and Natural Resources') {
          //                   DEST_LOCATION =
          //                       LatLng(14.199035268363202, 120.88261554521034);
          //                 }
          //               });

          //               initialCameraPosition = CameraPosition(
          //                   zoom: CAMERA_ZOOM,
          //                   // tilt: CAMERA_TILT,
          //                   bearing: CAMERA_BEARING,
          //                   target: DEST_LOCATION);
          //               setState(() async {
          //                 final GoogleMapController controller =
          //                     await _controller.future;
          //                 controller.animateCamera(
          //                     CameraUpdate.newCameraPosition(
          //                         initialCameraPosition));
          //               });
          //             }))),
                   Container(
            padding: EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child:Padding(
                padding: EdgeInsets.all(50),
                child:  Column(children: [
                  // Text('Nearest Landmark:'),
                  Padding(padding: EdgeInsets.only(top:10)),
                category_select=='College of Agriculture, Food, Environment and Natural Resources' ? Text('Beside University Library. \nIn front of College of Economics, Management and Development Studies (CEMDS)') :category_select=='College of Arts and Sciences' ? Text('Beside University Library. \nBehind College of Nursing') : category_select=='College of Criminal Justice' ? Text('College of Economics, Management and Development Studies') : category_select=='College of Criminal Justice' ? Text('Beside CvSU Research Building. \nIn front of College of Agriculture, Food, Environment and Natural Resources (CAFENR)') : category_select=='College of Education' ? Text('CvSU Gate 2. \nBeside Administration Building') : category_select=='College of Engineering and Information Technology' ? Text('CvSU Gate 2. \nIn front of Administration Building') : category_select=='College of Nursing' ? Text('Beside Hostel Tropicana. \nBehind College of Arts and Sciences (CAS)')  : category_select=='College of Nursing' ? Text('Beside Hostel Tropicana Behind College of Arts and Sciences (CAS)') : category_select=='College of Sports, Physical Education and Recreation' ? Text('CvSU Gymnasium. \nBeside Office of the Student Affairs and Services (OSAS) Building') : category_select=='College of Veterinary Medicine and Biomedical Sciences' ? Text('CvSU Saluysoy. \nIn front of Department of Animal Science Building') : category_select=='University Infirmary' ? Text('Beside College of Criminal Justice (CCJ) Building') : category_select=='University Library' ? Text('In front of College of Arts and Sciences (CAS) Building. \nBeside College of Agriculture, Food, Environment and Natural Resources (CAFENR)') : category_select=='University Marketing Center' ? Text('Beside CvSU Gate 1 University Mall (U-Mall)') : category_select=='University Registrar' ? Text('Beside CvSU Gymnasium In Office of the Student Affairs and Services (OSAS) Building') :  category_select=='College of Economics, Management and Development Studies' ? Text('Beside CvSU Research Building. \nIn front of College of Agriculture, Food, Environment and Natural Resources (CAFENR)') :  category_select=='Office of the Student Affairs and Services' ? Text('CvSU Oval.\nBeside CvSU Gymnasium')    : Text('')
              ],),
              )
            )
      ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   child: Card(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(15.0),
          //     ),
          //     elevation: 10,
          //     child: Container(
          //       padding: EdgeInsets.all(20),
          //         height: 370,
          //         child: ListView(children: [
          //           Padding(padding: EdgeInsets.only(bottom: 15)),
          //           category_select ==
          //                   'College of Economics, Management and Development Studies'
          //               ? Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text('Jemmalene O. Viado - College Secretary'),
          //                     Text('Thea Maries P. Perez - College Registrar'),
          //                     Text(
          //                         'Maria Corazon A. Buena - Chairperson, Department of Management'),
          //                     Text(
          //                         'Jenny Beb F. Ebo - Chairperson, Department of Management'),
          //                     Text(
          //                         'Sheryl S. Ersando - Chairperson, Department of Development Studies'),
          //                     Text(
          //                         'Dolores L. Aguilar - Chairperson, Department of Accountancy'),
          //                     Text(
          //                         'Mary Grace A. Ilagan - College Research Coordinator'),
          //                     Text(
          //                         'Danikka A. Cubillo - College Extension Coordinator'),
          //                     Text(
          //                         'Ma. Grasya M. Tibayan - Knowledge Management Unit Coordinator'),
          //                     Text(
          //                         'Princess M. Feliciano - R&E Coordinator, Department of Management'),
          //                     Text(
          //                         'Elizabeth E. Polinga - R&E Coordinator, Department of Economics'),
          //                     Text(
          //                         'Alberto M. Aguilar - R&E Coordinator, Department of Development Studies'),
          //                     Text(
          //                         'Maria Isolde R. Sustrina - R&E Coordinator, Department of Accountancy'),
          //                     Text('Mailah M. Ulep - College OJT Coordinator'),
          //                     Text(
          //                         'Tania Marie P. Melo - OJT Coordinator, Department of Management'),
          //                     Text(
          //                         'Reinalene Joy A. Casiano - OJT Coordinator, Department of Economics'),
          //                     Text(
          //                         'Richelle Joy A. Pasion - OJT Coordinator, Department of Development Studies'),
          //                   ],
          //                 )
          //               : category_select == 'University Marketing Center'
          //                   ? Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('No data.'),
          //                       ],
          //                     )
          //                   : category_select == 'University Registrar'
          //                       ? Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Text('Key Officials - No Info Yet'),
          //                             Text(''),
          //                             Text(''),
          //                             Text(''),
          //                           ],
          //                         )
          //                       : category_select == 'University Library'
          //                           ? Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(''),
          //                                 Text(
          //                                     'Head, University Library - Princess N. Roderno, RL'),
          //                                 Text(
          //                                     'College Librarian I - Nimphas E. Javier, RL'),
          //                                 Text(
          //                                     'College Librarian I - Veronica L. De Villa, RL'),
          //                                 Text(
          //                                     'Computer Operator I - Erwin C. Rupido'),
          //                                 Text(
          //                                     'Administrative Aide III - Kristine M. Mojica'),
          //                                 Text(
          //                                     'Administrative Aide III - Paloma A. Vida'),
          //                                 Text(
          //                                     'Administrative Aide III - Maharlika L. Villa'),
          //                                 Text(
          //                                     'Administrative Aide III - Ma. Cecilia C. Quiñones'),
          //                                 Text(
          //                                     'Administrative Aide III - Ana Rosel M. Rupido'),
          //                                 Text(
          //                                     'Administrative Aide III - Verna S. Barizo'),
          //                                 Text(
          //                                     'Administrative Aide III - Liecelle A. Floralde'),
          //                                 Text(
          //                                     'Administrative Aide III - Erlyn P. Dilidili'),
          //                                 Text(
          //                                     'Administrative Aide III - Keith Anne B. Vicedo'),
          //                                 Text(
          //                                     'Administrative Aide I - Jane G. Crisostomo'),
          //                               ],
          //                             )
          //                           : category_select ==
          //                                   'College of Veterinary Medicine and Biomedical Sciences'
          //                               ? Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Text(
          //                                         'Chair, Department of Basic Veterinary Sciences - DR. CHERRY R. ALVAREZ'),
          //                                     Text(
          //                                         'Chair, Department of Immunopathology and Microbiology - DR. ADRIAN MIKI C. MACALANDA'),
          //                                     Text(
          //                                         'Chair, Department of Clinical and Population Health - DR. EMMANUEL R. MAGO'),
          //                                     Text(
          //                                         'Chair, Department of Biomedical Sciences and Biotechnology - DR. MIKAELA ANGELICA VILLABLANCA'),
          //                                     Text(
          //                                         'Administrator, Veterinary Medical Center - DR. MIKAELA ANGELICA VILLABLANCA'),
          //                                     Text(
          //                                         'College Secretary - DR. MARIANO P. SISON'),
          //                                     Text(
          //                                         'College Registrar - DR. ADRIAN MIKI C. MACALANDA'),
          //                                     Text(
          //                                         'College Research and Development Coordinator - DR. ALVIN-WILLIAM A. ALVAREZ'),
          //                                     Text(
          //                                         'College Extension Coordinator - DR. EMMANUEL R. MAGO'),
          //                                     Text(
          //                                         'College Budget Officer/Inspector - DR. EMMANUEL R. MAGO'),
          //                                     Text(
          //                                         'College Job Placement Coordinator - DR. CHERRY R. ALVAREZ'),
          //                                     Text(
          //                                         'College GAD Program Coordinator - DR. CHERRY R. ALVAREZ'),
          //                                     Text(
          //                                         'College Guidance Coordinator - DR. DESIREE C. DEL MUNDO'),
          //                                     Text(
          //                                         'College QAAC - DR. NELSON J. MONTIALTO'),
          //                                     Text(
          //                                         'In-charge, Reading Room - DR. MARIANO P. SISON'),
          //                                     Text(
          //                                         'College MISO Officer - DR. EMMANUEL R. MAGO'),
          //                                     Text(
          //                                         'Chair, Department of Biomedical Sciences and Biotechnology - DR. MIKAELA ANGELICA VILLABLANCA'),
          //                                     Text(
          //                                         'College Property Custodian - DR. DESIREE C. DEL MUNDO'),
          //                                     Text(
          //                                         'Civil Security Officer - DR. NELSON J. MONTIALTO'),
          //                                     Text(
          //                                         'OJT Coordinator - DR. MELBOURNE R. TALACTAC'),
          //                                   ],
          //                                 )
          //                               : category_select ==
          //                                       'College of Nursing'
          //                                   ? Column(
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.start,
          //                                       children: [
          //                                         Text(
          //                                             'Chairperson, Department of Medical Technology Medical Laboratory Science (DMT/MLS) - College Secretary - Hazel Joyce L. Guiao, RMT, MSMLSc'),
          //                                         Text(
          //                                             'Principal, Department of Midwifery (DM) - Jane A. Rona, RN, RM, MAN'),
          //                                         Text(
          //                                             'College Secretary - Phaebi B. Romen, RN, MAN'),
          //                                         Text(
          //                                             'College Registrar - Joinito A. Ofracio, RN, MAN'),
          //                                         Text(
          //                                             'College Overall Clinical Coordinator / Jocelyn B. Dimayuga, RN, MAN'),
          //                                         Text(
          //                                             'College Research Coordinator - Rolando P. Antonio, RN, MANc'),
          //                                         Text(
          //                                             'College Extension Coordinator Sports and Cultural Development Coordinator - Sunny Rose M. Ferrera, RN, MAN'),
          //                                         Text(
          //                                             'Quality Assurance Coordinator - Nenita B. Panaligan, RN, MAN'),
          //                                         Text(
          //                                             'College Guidance Facilitator - Bernadette A. Sapinoso, PhD'),
          //                                         Text(
          //                                             'College Job Placement Coordinator - Lei Anne B. Rupido, RN, RM, MAN'),
          //                                         Text(
          //                                             'Student Organization Adviser - Louis Carlos O. Roderos, RN, MAN'),
          //                                         Text(
          //                                             'College Supply Officer/Canvasser - Charmaine V. Rosales, RMT, MSMLSc'),
          //                                         Text(
          //                                             'College Budget Officer/Cashier - Maribel L. Chua, RN, MAN'),
          //                                         Text(
          //                                             'Internship Coordinator (BSMT) Reading Room In-charge - Joinito A. Ofracio, RN, MAN'),
          //                                         Text(
          //                                             'College Property and Laboratory Custodian,Ivan Derek V. Wycoco, RN, MAN'),
          //                                         Text(
          //                                             'College MIS and Public Information Officer - Ria Marisse D. Matel, RMT, MSMLSc'),
          //                                         Text(
          //                                             'College Registrar - Joinito A. Ofracio, RN, MAN'),
          //                                       ],
          //                                     )
          //                                   : category_select ==
          //                                           'Office of the Student Affairs and Services'
          //                                       ? Column(
          //                                           crossAxisAlignment:
          //                                               CrossAxisAlignment
          //                                                   .start,
          //                                           children: [
          //                                             Text(
          //                                                 'Key Officials - No Info Yet'),
          //                                             Text(''),
          //                                             Text(''),
          //                                             Text(''),
          //                                           ],
          //                                         )
          //                                       : category_select ==
          //                                               'College of Engineering and Information Technology'
          //                                           ? Column(
          //                                               crossAxisAlignment:
          //                                                   CrossAxisAlignment
          //                                                       .start,
          //                                               children: [
          //                                                 Text(
          //                                                     'Chairperson, Department of Civil Engineering (DCE) - Engr. Roslyn P. Peña'),
          //                                                 Text(
          //                                                     'Chairperson, Department of Computer and Electronics Engineering (DCEE) - Dr. Willie C. Buclatin '),
          //                                                 Text(
          //                                                     'Chairperson, Department of Information Technology (DIT) - Prof. Marlon R. Pereña'),
          //                                                 Text(
          //                                                     'Chairperson, Department of Agriculture and Food Engineering (DAFE) - Engr. Al Owen Roy A. Ferrera'),
          //                                                 Text(
          //                                                     'College Secretary - Prof. Aileen A. Ardina'),
          //                                                 Text(
          //                                                     'College Budget Officer - Prof. Marivic G. Dizon'),
          //                                                 Text(
          //                                                     'College Registrar - Prof. Florence M. Banasihan'),
          //                                                 Text(
          //                                                     'College MIS/PIO Officer - Prof. Vanessa G. Coronado'),
          //                                                 Text(
          //                                                     'College Records Officer - Prof. Jake R. Ersando'),
          //                                                 Text(
          //                                                     'Coordinator, Research Services - Dr. Edwin R. Arboleda'),
          //                                                 Text(
          //                                                     'Coordinator, Graduate Programs - Prof. Charlotte B. Carandang'),
          //                                                 Text(
          //                                                     'Asst. Coordinator, Extension Services - Prof. Ria Clarisse L. Mojica'),
          //                                                 Text(
          //                                                     'Coordinator, R&E Monitoring and Evaluation Unit - Prof. Gladys G. Perey'),
          //                                                 Text(
          //                                                     'Coordinator for OJT - Prof. Efren R. Rocillo'),
          //                                                 Text(
          //                                                     'Coordinator, College Quality Assurance and Accreditation - Prof. Poinsettia A. Vida'),
          //                                                 Text(
          //                                                     'Asst. Coordinator, College Quality Assurance and Accreditation - Prof. Anabelle J. Almarez'),
          //                                                 Text(
          //                                                     'Coordinator, Knowledge Management Unit - Prof. Marlon F. Cruzate'),
          //                                                 Text(
          //                                                     'Coordinator, Gender and Development Program - Prof. Ma. Fatima B. Zuñiga'),
          //                                                 Text(
          //                                                     'Coordinator, Gender and Development Program (alternate) - Prof. Joy M. Peji'),
          //                                                 Text(
          //                                                     'Coordinator for Sports and Socio-Cultural Development - Prof. Garry M. Cahibaybayan'),
          //                                                 Text(
          //                                                     'College Guidance Counselor for BSABE, BSIT, BSCS, and BSOA - Dr. Jo Anne C. Nuestro'),
          //                                                 Text(
          //                                                     'College Guidance Counselor for BSCE, BS Arch, BSECE, BSEE, BSCpE, CTN, BSIE and BIT programs - Prof. Andy A. Dizon'),
          //                                                 Text(
          //                                                     'College Job Placement Officer - Prof. Simeon Daez'),
          //                                                 Text(
          //                                                     'College Property Custodian - Prof. Ezra Marie F. Ramos'),
          //                                                 Text(
          //                                                     'College Civil Security Officer - Prof. Ronald E. Araño'),
          //                                                 Text(
          //                                                     'College Canvasser In-charge, Electrical and Electronics Laboratory - Mr. Emerson C. Lascano'),
          //                                                 Text(
          //                                                     'In-charge, College Reading Room - Prof. Lilia O. Torres'),
          //                                                 Text(
          //                                                     'In-charge, Material Testing Laboratory - Engr. Larry E. Rocela'),
          //                                                 Text(
          //                                                     'In-charge, Industrial Automation Center - Engr. Ronald P. Peña'),
          //                                                 Text(
          //                                                     'In-charge, Simulation and Math Laboratory - Prof. Sheryl D. Fenol'),
          //                                                 Text(
          //                                                     'Manager, University Computer Center (UCC) - Prof. Emeline C. Guevarra '),
          //                                                 Text(
          //                                                     'University Web Master - Prof. Russel L. Villacarlos'),
          //                                                 Text(
          //                                                     'Assistant University Web Master - Prof. James Angelo V. Aves'),
          //                                                 Text(
          //                                                     'Head, UCC Laboratory and Software Section - Prof. Ace Amiel E. Malicsi'),
          //                                                 Text(
          //                                                     'Head, UCC Hardware and Maintenance Section - Prof. Bienvenido C. Sarmiento'),
          //                                                 Text(
          //                                                     'Head, e-Learning Team - Prof. Julie Ann C. Lontoc'),
          //                                               ],
          //                                             )
          //                                           : category_select ==
          //                                                   'College of Sports, Physical Education and Recreation'
          //                                               ? Column(
          //                                                   crossAxisAlignment:
          //                                                       CrossAxisAlignment
          //                                                           .start,
          //                                                   children: [
          //                                                     Text(
          //                                                         'Key Officials - No Info Yet'),
          //                                                     Text(''),
          //                                                     Text(''),
          //                                                     Text(''),
          //                                                   ],
          //                                                 )
          //                                               : category_select ==
          //                                                       'College of Education'
          //                                                   ? Column(
          //                                                       crossAxisAlignment:
          //                                                           CrossAxisAlignment
          //                                                               .start,
          //                                                       children: [
          //                                                         Text(
          //                                                             'Mr. Alfred A. Venzon - College Secretary'),
          //                                                         Text(
          //                                                             'Dr. Jennifer E. Barrientos - College Registrar'),
          //                                                         Text(
          //                                                             'Dr. Florencio R. Abanes - Chairperson, Teacher Education Department (TED)'),
          //                                                         Text(
          //                                                             'Dr. Pia Rhoda P. Lucero - Chairperson, Home Economics, Vocational and Technical Education Department (HEVTED)'),
          //                                                         Text(
          //                                                             'Mr. Rufriel S. Mesa - Principal, CvSU Science Laboratory School'),
          //                                                         Text(
          //                                                             'Prof. Julie S. Guevara - Administrator, CvSU Child Development Center'),
          //                                                         Text(
          //                                                             'Prof. Nancy C. Alaras - Coordinator, Quality Assurance and Accreditation'),
          //                                                         Text(
          //                                                             'Dr. Jake Raymund F. Fabregar - Coordinator, Research Services'),
          //                                                         Text(
          //                                                             'Ms. Lyneth B. Perez - Coordinator, Extension Services'),
          //                                                         Text(
          //                                                             'Ms. Richel P. Diokno - Coordinator, Gender and Development Program'),
          //                                                         Text(
          //                                                             'Ms. Gaea N. Estravila - Job Placement Officer'),
          //                                                         Text(
          //                                                             'Ms. Hydy May R. Rodrin - Coordinator, Sports and Socio-Cultural Development'),
          //                                                         Text(
          //                                                             'Dr. Reizel G. Viray - Budget Officer'),
          //                                                         Text(
          //                                                             'Mr. Jeffrey B. Aguila - College Canvasser and Civil Security Officer'),
          //                                                         Text(
          //                                                             'Mr. Ferdie S. Andulan - College Inspector and Property Custodian'),
          //                                                         Text(
          //                                                             'Ms. Rosal S. Concepcion - Coordinator, Instructional Materials Development and In-charge, Reading Room'),
          //                                                         Text(
          //                                                             'Prof. Jason R. Maniacop - College Guidance Coordinator'),
          //                                                         Text(
          //                                                             'Dr. Jovan B. Alitagtag - College Management and Information Systems Officer and College Public Information Officer'),
          //                                                       ],
          //                                                     )
          //                                                   : category_select ==
          //                                                           'College of Arts and Sciences'
          //                                                       ? Column(
          //                                                           crossAxisAlignment:
          //                                                               CrossAxisAlignment
          //                                                                   .start,
          //                                                           children: [
          //                                                             Text(
          //                                                                 'Dean - Dr. Bettina Joyce p. Ilagan'),
          //                                                             Text(
          //                                                                 'Department of Languages and Mass Communication - Ms. Rosa R. Hernandez'),
          //                                                             Text(
          //                                                                 'Department of Physical Sciences - Dr. Gemma S. Legaspi'),
          //                                                             Text(
          //                                                                 'Department of Biological Sciences - Prof. Dickson N. Dimero'),
          //                                                             Text(
          //                                                                 'Department of Social Sciences and Humanities - Prof. Gil D. Ramos'),
          //                                                             Text(
          //                                                                 'Secretary - Ms. Armi Grace Desingano'),
          //                                                             Text(
          //                                                                 'Registrar - Dr. Manny A. Romeroso'),
          //                                                             Text(
          //                                                                 'Research Coordinator - Prof. Michele T. Bono'),
          //                                                             Text(
          //                                                                 'Extension Coordinator - Ms. Veronica P. Penaflorida'),
          //                                                             Text(
          //                                                                 'Quality Assurance Coordinator - Dr. Agnes C. Francisco'),
          //                                                             Text(
          //                                                                 'Gender and Development Coordinator - Ms. Merlie C. Nahilat'),
          //                                                             Text(
          //                                                                 'Sports and Culture and the Arts Coordinator - Mr. Andrew J. Siducon'),
          //                                                             Text(
          //                                                                 'Guidance Counselor - Dr. Cecilia B. Banaag'),
          //                                                             Text(
          //                                                                 'Instructional Materials and Curriculum Review Committee Chair - Dr. Jocelyn L. Reyes'),
          //                                                             Text(
          //                                                                 'Job Placement Coordinator - Mr. Rene B. Betonio'),
          //                                                             Text(
          //                                                                 'Reading Room/ Accreditation Room In-Charge - Ms. Sherine M. Cruzate'),
          //                                                             Text(
          //                                                                 'Public Information Officer - Ms. Lisette D. Mendoza'),
          //                                                             Text(
          //                                                                 'Management Information System Officer - Ms. Catherine r. Mojica'),
          //                                                             Text(
          //                                                                 'BS Applied Math - Dr. Renelyn R. Cordial'),
          //                                                             Text(
          //                                                                 'BA Journalism - Ms. Racquel G. Agustin'),
          //                                                             Text(
          //                                                                 'BA English - Mr. Bernard S. Feranil'),
          //                                                             Text(
          //                                                                 'BA Political Science - Mr. Renato T. Agdalpen'),
          //                                                             Text(
          //                                                                 'BS Social Work - Ms. Merlie C. Nahilat'),
          //                                                             Text(
          //                                                                 'In-charge of the University Museum - Department of Social Sciences and Humanities'),
          //                                                             Text(
          //                                                                 'Budget Officer, Canvasser - Ms. Kathrine P. Viado'),
          //                                                             Text(
          //                                                                 'Property Custodian, Inspector - Mr. Denver R. Rodrin'),
          //                                                           ],
          //                                                         )
          //                                                       : category_select ==
          //                                                               'College of Criminal Justice'
          //                                                           ? Column(
          //                                                               crossAxisAlignment:
          //                                                                   CrossAxisAlignment.start,
          //                                                               children: [
          //                                                                 Text(
          //                                                                     'DR. FAMELA IZA C. MATIC - Dean/Quality Assurance Coordinator'),
          //                                                                 Text(
          //                                                                     'DR. SUSAN G. TAN - Chairperson, Industrial Security Administration/Extension Coordinator/GAD Coordinator'),
          //                                                                 Text(
          //                                                                     'DR. MARISSA C. LONTOC - Research Coordinator/College Guidance Coordinator/OSA Coordinator'),
          //                                                                 Text(
          //                                                                     'MS. FREDDA H. EBANADA - College Secretary and Planning/Budget Officer and Inspector/Faculty Representative'),
          //                                                                 Text(
          //                                                                     'MS. MARY ANN MAHILOM-LORENZO - College Public Information Officer/Competency Appraisal Coordinator/Job Placement Coordinator'),
          //                                                                 Text(
          //                                                                     'REV. DARIUS R. CAMPOS - On full study leave (PhD in Criminology)'),
          //                                                                 Text(
          //                                                                     'MR. MARCO VICTOR MENDOZA - College Registrar/Property Custodian / Laboratory Technician/Sports and Recreational Coordinator'),
          //                                                                 Text(
          //                                                                     'MR. MARK JOSEPH LLANTO - College Canvasser/In-Charge of Reading Room'),
          //                                                               ],
          //                                                             )
          //                                                           : category_select ==
          //                                                                   'College of Agriculture, Food, Environment and Natural Resources'
          //                                                               ? Column(
          //                                                                   crossAxisAlignment:
          //                                                                       CrossAxisAlignment.start,
          //                                                                   children: [
          //                                                                     Text('Dean - Dr. Analita dM. Magsino'),
          //                                                                     Text('Chairperson, Department of Animal Science	 - Dr. Cristina F. Olo'),
          //                                                                     Text('Chairperson, Department of Crop Science - Dr. Adelaida E. Sangalang'),
          //                                                                     Text('Chairperson, Department of Environmental Science - Ms. Amyel Dale L. Cero'),
          //                                                                     Text('Chairperson, Department of Agricultural Entrepreneurship - Mr. Edgardo A. Gonzales'),
          //                                                                     Text('Chairperson, Institute of Food Science and Technology - Mr. Jason D. Braga'),
          //                                                                     Text('Research & Knowledge Management Coordinator - Dr. Mariedel L. Autriz'),
          //                                                                     Text('Quality Assurance Coordinator - Dr. Cristina F. Olo'),
          //                                                                     Text('GAD Coordinator & Guidance Facilitator - Ms. Jo-an T. Ducducan'),
          //                                                                     Text('Registrar - Ms. Jo-an T. Ducducan'),
          //                                                                     Text('Extension Coordinator - Ms. Ma. Cecille N. Basa'),
          //                                                                     Text('Budget Officer - Dr. Adelaida E. Sangalang'),
          //                                                                     Text('On-The-Job Training Coordinator (Food Technology) - Mr. Jason D. Braga'),
          //                                                                     Text('Entrepreneurial Development Project Coordinator (Agricultural Entrepreneurship) - Mr. Edgardo A. Gonzales'),
          //                                                                     Text('MIS/Public Information Officer - Ms. Amyel Dale L. Cero'),
          //                                                                     Text('Instructional Materials Development Coordinator - Dr. Evelyn O. Singson'),
          //                                                                   ],
          //                                                                 )
          //                                                               : Text(
          //                                                                   '')
          //         ]))),
          // )
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation!.latitude, currentLocation!.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation!.latitude, destinationLocation!.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));

    setState(() {});
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    //  setPolylines();
  }

// void setPolylines() async {
// List<PointLatLng> result = polylinePoints.decodePolyline("_p~iF~ps|U_ulLnnqC_mqNvxq`@");
// print(result);
//   //  List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(googleAPIKey,currentLocation.latitude,currentLocation.longitude,destinationLocation.latitude,destinationLocation.longitude);
//    if(result.isNotEmpty){
//       result.forEach((PointLatLng point){
//          polylineCoordinates.add(
//             LatLng(point.latitude,point.longitude)
//          );
//       });
//      setState(() {
//       _polylines.add(Polyline(
//         width: 5, // set the width of the polylines
//         polylineId: PolylineId("poly"),
//         color: Color.fromARGB(255, 40, 122, 198),
//         points: polylineCoordinates
//         ));
//     });
//   }
// }
  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
    );
// final GoogleMapController controller = await _controller.future;
// controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    _polyline.add(Polyline(
      polylineId: PolylineId('line1'),
      visible: true,
      //latlng is List<LatLng>
      points: latlngSegment1,
      width: 6,
      color: Colors.blue,
    ));
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation!.latitude, currentLocation!.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == "sourcePin");
      _markers.add(Marker(
        markerId: MarkerId("sourcePin"),
        position: pinPosition, // updated position
        //  icon: sourceIcon
      ));
    });
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
        PointLatLng(
            destinationLocation!.latitude, destinationLocation!.longitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // _addPolyLine();
  }

  // _addPolyLine() {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //       polylineId: id, color: Colors.red, points: polylineCoordinates);
  //   polylines[id] = polyline;
  //   setState(() {});
  // }
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Container(
          padding: EdgeInsets.all(10),
          child: Text(item, style: TextStyle(fontSize: 15))));
}
