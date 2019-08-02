import 'saver.dart';

/*
 * This is used to pass the user's
 * information down the widget tree as the user 
 * traverses the app
 */

class User{
  bool _isSignedIn = false;
  String _username = 'null';
  String _password = 'null';
  String _ploneToken = 'null';
  String _mattermostToken = 'null';
  String _userId= 'null';
  String _email = 'null';
  Map _projects = Map();
  Map _members = Map(); // Map<String, String>
  List _teams= List(); // List<Map<String, String>>

  static User _user = User._internal();

  factory User() => _user; 

  User._internal() {
    initialize();
  }

  void initialize() async{
    _email = await _fetchEmail();
    _username = await _fetchUsername();
    _password = await _fetchPassword();
    _ploneToken = await _fetchPloneToken();
    _mattermostToken = await _fetchMattermostToken();
    _userId = await _fetchUserId();
    _isSignedIn = await _fetchSignInStatus();
    _members = await _fetchMembers();
    _projects = await _fetchProjects();
    _teams = await _fetchTeams();
  }

  Future<String> _fetchUsername() async {
    final result = await Saver.getData(name: 'username');
    if(result==null){
      return _username;
    }
    else{
      _username = result;
       return _username;
    }
  }

  get username {
    return _username;
  }

  set username(String username) {
    _username = username;
    Saver.setData(name: 'username', data: username);
  }

  Future<String> _fetchEmail() async {
    final result = await Saver.getData(name: 'email');
    if(result==null){
      return _email;
    }
    else{
      _email = result;
       return _email;
    }
  }

  get email =>_email;

  set email(String email) {
    _email = email;
    Saver.setData(name: 'email', data: email);
  }

  Future<String> _fetchPassword() async {
    final result = await Saver.getData(name: 'password');
    if(result==null){
      return _password;
    }
    else{
      _password = result;
       return _password;
    }
  }

  get password => _password;

  set password(String password) {
    _password = password;
    Saver.setData(name: 'password', data: password);
  }

  Future<String> _fetchMattermostToken() async {
    final result = await Saver.getData(name: 'mattermostToken');
    if(result==null){
      return _mattermostToken;
    }
    else{
      _mattermostToken = result;
       return _mattermostToken;
    }
  }

  get mattermostToken => _mattermostToken;

  set mattermostToken(String mattermostToken) {
    _mattermostToken = mattermostToken;
    Saver.setData(name: 'mattermostToken', data: mattermostToken);
  }

  Future<String> _fetchPloneToken() async {
    final result = await Saver.getData(name: 'ploneToken');
    if(result==null){
      return _ploneToken;
    }
    else{
      _ploneToken = result;
       return _ploneToken;
    }
  }

  get ploneToken => _ploneToken;

  set ploneToken(String ploneToken) {
    _ploneToken = ploneToken;
    Saver.setData(name: 'ploneToken', data: ploneToken);
  }

  Future<String> _fetchUserId() async {
    final result = await Saver.getData(name: 'userId');
    if(result==null){
      return _userId;
    }
    else{
      _userId = result;
       return _userId;
    }
  }

  get userId => _userId;

  set userId(String userId) {
    _userId = userId;
    Saver.setData(name: 'userId', data: userId);
  }

  Future _fetchProjects() async {
   final result = await Saver.getData(name: 'projects');
    if(result==null){
      return _projects;
    }
    else{
      _projects = result;
       return _projects;
    }
  }

  get projects => _projects;

  set projects(Map projects) {
    _projects = projects;
    Saver.setData(name: 'projects', data: projects);
  }

  Future _fetchMembers() async {
    final result = await Saver.getData(name: 'members');
    if(result==null){
      return _members;
    }
    else{
      _members = result;
       return _members;
    }
  }

  get members => _members;

  set members(Map members) {
    _members = members;
    Saver.setData(name: 'members', data: members);
  }

  Future _fetchTeams() async {
    final result = await Saver.getData(name: 'teams');
    if(result==null){
      return _teams;
    }
    else{
      _teams = result;
       return _teams;
    }
  }

  get teams => _teams;

  set teams(List teams) {
    _teams = teams;
    Saver.setData(name: 'teams', data: teams);
  }

  Future<bool> _fetchSignInStatus() async{
    final result = await Saver.getSignInState();
    if(result==null){
      return _isSignedIn;
    }
    else{
      _isSignedIn = result;
      return result;
    }
  }

  bool get isSignedIn => _isSignedIn;

  Future<void> login() async{
    await Saver.setSignInState(true);
    _isSignedIn = true;
  }

  Future<void> logout() async{
    _isSignedIn = false;
    Saver.setData(name: 'username', data: 'null');
    Saver.setData(name: 'password', data: 'null');
    Saver.setData(name: 'email', data: 'null');
    Saver.setData(name: 'mattermostToken', data: 'null');
    Saver.setData(name: 'ploneToken', data: 'null');
    Saver.setData(name: 'teams', data: null);
    Saver.setData(name: 'projects', data: null);
    Saver.setData(name: 'members', data: null);
    Saver.setSignInState(false);
  }
}