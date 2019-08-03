class Jsons{

  static Map projectsjson = {
    "@type": "project",
    "title": "Project by api 9",
    "description": "Project for tessting purposes",
    "contributors": [],
    "start": "2019-06-12T17:20:00+00:00",
    "end": "2020-06-17T19:00:00+00:00",
    "whole_day": false,
    "open_end": false,
    "sync_uid": null,
    "contact_name": "",
    "contact_email": "",
    "contact_phone": "",
    "event_url": null,
    "location": "Office Quito",
    "recurrence": null,
    "image": {
      "filename": "test.jpg",
      "content-type": "image/jpeg",
      "data": "",
      "encoding": "base64"
    },
    "image_caption": "Image captions",
    "text": {
      "content-type": "text/html",
      "data":
          "<h1><em><strong>This event is just for test that starts at 12 today and goes on until I feel like it should stop</strong></em></h1>",
      "encoding": "utf-8"
    },
    "changeNote": null,
    "members":[]
  };

  static Map taskjson = {
    "@type": "task",
    "title": "Task upload by api",
    "description": "the task is to test the api",
    "task_detail": {
      "content-type": "text/html",
      "data": "<h2>Talk to some people to volunteer on the the project</h2>",
      "encoding": "utf-8"
    },
    "additional_files": null,
    "complete": false
  };



}