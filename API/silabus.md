# syllabus

## Create syllabus

##### @ID is the id of the selected project
#### Endpoint : POST /api/syllabus/new/{ID}

#### Request Body :

```json
{
  "meeting": "Pertemuan ke- ?",
  "materialNameTrainee": "?",
  "description": "?",
  "task": "?"
}
```


#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "meeting": "Pertemuan Ke Berapa",
      "materialNameTrainee": "Nama Materi Trainee",
      "description" : "?",
      "task" : "?"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :

```json
{
  "code": 403,
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

## Get syllabus By project

##### @ID is the id of selected project
#### Endpoint : GET /api/my/syllabus/{ID}

#### Request Body :

```json
{
  "materialNameTrainee": "?",
  "description": "?",
  "task": "?"
}
```


#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "meeting": "Pertemuan Ke Berapa",
      "materialNameTrainee": "Nama Materi Trainee",
      "task" : "?"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :

```json
{
  "code": 403,
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```