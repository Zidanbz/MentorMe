# Activity

## Get Activity 

##### ID is id for selected learning
#### Endpoint : GET /api/my/activity/{ID}

#### Request Body :

```json
{
}
```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Crabs",
    "materialName": "Pengenalan HTML",
    "picture" : "file",
    "train": [
      {
        "trainActivity": {
          "meeting": "Pertemuan 1",
          "materialNameSyllabus": "Belajar Dasar HTML, CSS, Javascript",
          "status": false,
          "IDActivity": "UUID"
        }
      },
      {
        "trainActivity": {
          "meeting": "Pertemuan 2",
          "materialNameSyllabus": "Menerapkan Program HTML, CSS, javascript",
          "status": false,
          "IDActivity": "UUID"
        }
      }
    ]
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :


```json
{
  "code": 400,
  "error": "Message error ?",
  "data": "",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```


## Upload Task

@ID is IDActivity
#### Endpoint : POST /api/my/activity/upload/{ID}

#### Request Body :

```json
{
  "task": "file",
  "criticism": "Berisi Kritik"
}
```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Crabs",
    "materialName": "Pengenalan HTML",
    "picture" : "file",
    "train": [
      {
        "trainActivity": {
          "meeting": "Pertemuan 1",
          "materialNameTrain": "Belajar Dasar HTML, CSS, Javascript",
          "status": true,
          "IDActivity": "UUID"
        }
      },
      {
        "trainActivity": {
          "meeting": "Pertemuan 2",
          "materialNameTrain": "Menerapkan Program HTML, CSS, javascript",
          "status": false,
          "IDActivity": "UUID"
        }
      }
    ]
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :


```json
{
  "code": 400,
  "error": "Message error ?",
  "data": "",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```


## Get Activity By MENTOR For Report

##### ID is id for selected learning
#### Endpoint : GET /api/activity/{ID}

#### Request Body :

```json
{
}
```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Crabs",
    "materialName": "Pengenalan HTML",
    "train": [
      {
        "trainActivity": {
          "meeting": "Pertemuan 1",
          "statusReport": false,
          "IDActivity": "UUID"
        }
      },
      {
        "trainActivity": {
          "meeting": "Pertemuan 2",
          "status": false,
          "IDActivity": "UUID"
        }
      }
    ]
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :


```json
{
  "code": 400,
  "error": "Message error ?",
  "data": "",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```


## report Content Activity By MENTOR For Report

##### ID is id for selected activity
#### Endpoint : PUT /api/report/{ID})

#### Request Body :

```json
{
  "activity": "?",
  "documentation": "file"
}
```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": "Success",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :


```json
{
  "code": 400,
  "error": "Message error ?",
  "data": "",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```