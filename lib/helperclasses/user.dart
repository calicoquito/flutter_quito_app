import 'saver.dart';

/*
 * This singleton is used to pass the user's
 * information down the widget tree as the user 
 * traverses the app
 */


class User{
  bool _isSignedIn = false;
  String _username = 'null';
  String _password = 'null';
  String _ploneToken = 'null'; // used to authorize all plone requests
  String _mattermostToken = 'null'; // used to authorize all mattermot requests
  String _userId= 'null'; // the user's mattermost id
  String _email = 'null';
  String _serverId = 'null'; // the mattermost server id
  String _sessionId = 'null'; // the current logged-in session id
  
  // all the projects the user is involved in and indexed by their project name
  // This project name is the same as the mattermost channel name for which the project corresponsed to
  // this is the plone data
  Map _projects = Map();
  
  // All the members in the same team as the user
  Map _members = Map(); // Map<String, String>

  // a list of all the mattermost team the user is included in. 
  // This should most of the times be 1
  List _teams= List(); // List<Map<String, String>>

  // all the channels/projects the user is included in and indexed by their channel id
  // instead of the channel name/project name
  Map _channels = Map(); // Map<String, dynamic>

  // all the projects the user is involved in and indexed by their project name
  // This project name is the same as the mattermost channel name for which the project corresponsed to
  // this is the mattermost data

  Map _channelsByName = Map();


  static final User _user = User._internal();


  factory User() => _user;

  User._internal() {
    initialize();
  }

  void initialize(){
    _fetchEmail();
    _fetchUsername();
    _fetchPassword();
    _fetchPloneToken();
    _fetchMattermostToken();
    _fetchUserId();
    _fetchServerId();
    _fetchSessionId();
    _fetchSignInStatus();
    _fetchMembers();
    _fetchProjects();
    _fetchTeams();
    _fetchChannels();
    _fetchChannelsByName();
  }

  // Saver is the class that is used to manage storing  and retreiving 
  // data to and from local storage using SharedPreferences
  // See saver.dart as lib/helperclasses/saver.dart for more.

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

  Future<void> _fetchServerId() async{
    final result = await Saver.getData(name: 'serverId');
    if(result==null){
      return _serverId;
    }
    else{
      _serverId = result;
       return _serverId;
    }
  }

  get serverId => _serverId;

  set serverId(String serverId){
    _serverId = serverId;
    Saver.setData(name:'serverId', data: serverId);
  }

  
  Future<void> _fetchSessionId() async{
    final result = await Saver.getData(name: 'sessionId');
    if(result==null){
      return _sessionId;
    }
    else{
      _sessionId = result;
       return _sessionId;
    }
  }

  get sessionId => _sessionId;

  set sessionId(String sessionId){
    _sessionId = sessionId;
    Saver.setData(name:'sessionId', data: sessionId);
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

  get teams{ 
    return _teams;
  }

  set teams(List teams) {
    _teams = teams;
    Saver.setData(name: 'teams', data: teams);
  }

  Future _fetchChannels() async {
    final result = await Saver.getData(name: 'channels');
    if(result==null){
      return channels;
    }
    else{
      _channels = result;
       return _channels;
    }
  }

  get channels{ 
    return _channels;
  }

  set channels(Map channels) {
    _channels = channels;
    Saver.setData(name: 'channels', data: channels);
  }

  Future _fetchChannelsByName() async {
    final result = await Saver.getData(name: 'channelsByName');
    if(result==null){
      return channelsByName;
    }
    else{
      _channelsByName = result;
       return _channelsByName;
    }
  }

  get channelsByName{ 
    return _channelsByName;
  }

  set channelsByName(Map channelsByName) {
    _channelsByName = channelsByName;
    Saver.setData(name: 'channelsByName', data: channelsByName);
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
  //sets all the fields to null to remove the data from local storage
  Future<void> logout() async{
    _isSignedIn = false;
    Saver.setData(name: 'username', data: null);
    Saver.setData(name: 'password', data: null);
    Saver.setData(name: 'email', data: null);
    Saver.setData(name: 'mattermostToken', data: null);
    Saver.setData(name: 'ploneToken', data: null);
    Saver.setData(name: 'userId', data: null);
    Saver.setData(name: 'serverId', data: null);
    Saver.setData(name: 'teams', data: null);
    Saver.setData(name: 'projects', data: null);
    Saver.setData(name: 'members', data: null);
    Saver.setData(name: 'channels', data: null);
    Saver.setData(name:'channelsByName', data: null);
    Saver.setSignInState(false);
  }
}
