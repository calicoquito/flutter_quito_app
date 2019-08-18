class Jsons{

  static Map projectsjson = {
    "@type": "project",
    "title": "Untitled",
    "description": "No description",
    "members": [],
    "start": "2019-06-12T17:20:00+00:00",
    "end": "2020-06-17T19:00:00+00:00",
    "whole_day": false,
    "open_end": false,
    "sync_uid": null,
    "contact_name": "",
    "contact_email": "",
    "contact_phone": "",
    "event_url": null,
    "location": "No location",
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
  };

  static Map taskjson = {
    "@type": "task",
    "title": "Untitled",
    "description": "No description",
    "task_detail": {
      "content-type": "text/html",
      "data": "<h2>Talk to some people to volunteer on the the project</h2>",
      "encoding": "utf-8"
    },
    "additional_files": null,
    "members": [],
    "details": "check this?",
    "complete": false
  };

}