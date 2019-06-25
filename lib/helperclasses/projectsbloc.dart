import 'package:flutter/cupertino.dart';

/*
 * This class implements a ChangeNotifier to provide 
 * functionality so users may create projects which 
 * will be shared and accessible throughout the app
 */

class ProjectsBloc extends ChangeNotifier{
  List<Project> _projects = List();
  
  void addProject(Project project){
    _projects.add(project);
    notifyListeners();
  }
  Project get(index){
    return _projects.length==0 ? null : _projects[index];
  }
  int length(){
    return _projects.length;
  }
}

class Project{
  String _projectName;

  Project(String name){
    _projectName=name;
  }

  String get projectName => this._projectName;

  set projectName(String projectName) {
    this._projectName = projectName;
  }
  List _options;

  List get options => this._options;

  set options(List options) {
    this._options = options;
  }
}