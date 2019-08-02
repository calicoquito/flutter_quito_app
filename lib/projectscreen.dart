// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'helperclasses/projectsbloc.dart';

// class Projects extends StatefulWidget{
//   @override
//   ProjectsState createState()=>ProjectsState();
// }
    
// class ProjectsState extends State<Projects>{
//   @override
//   Widget build(BuildContext context) {
//     final ProjectsBloc projectsBloc = Provider.of<ProjectsBloc>(context);
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(Icons.filter_none, size: 50.0, color: Colors.white,),
//           Container(
//             height: MediaQuery.of(context).size.height*0.4,
//             child: projectsBloc.length()==0 ? Center(
//               child:Text(
//                 'No Projects Available',
//                 style: TextStyle(
//                     fontSize: 25.0,
//                     color: Colors.orangeAccent
//                 )
//               )
//             ): ListView.builder(
//               itemCount: projectsBloc.length(),
//               itemBuilder: (context, index)=>Center(
//                 child:Text(
//                   projectsBloc.get(index).projectName,
//                   style: TextStyle(
//                       fontSize: 25.0,
//                       color: Colors.orangeAccent
//                   ),
//                 )
//               ),
//             )
//           )
//         ],
//       ),
//     );
//   }
// }
 
