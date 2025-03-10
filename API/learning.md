# Learning  User


## Get Learning By User

#### Endpoint : GET /api/my/learning

#### Request Body :

```json

```

#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "learning": {
        "ID" : "UUID",
        "IDProject": "UUID",
        "progress": true,
        "project": {
          "materialName": "Pengenalan HTML",
          "picture": "file",
          "student": 40
        }
      }
    },
    {
      "learning": {
        "ID" : "UUID",
        "IDProject": "UUID",
        "progress": false,
        "project": {
          "materialName": "Statistika",
          "picture": "file",
          "student": 40
        }
      }
    },
    {
      "learning": {
        "ID" : "UUID",
        "IDProject": "UUID",
        "progress": false,
        "project": {
          "materialName": "Web",
          "picture": "file",
          "student": 40
        }
      }
    },
    {
      "learning": {
        "ID" : "UUID",
        "progress": true,
        "project": {
          "materialName": "Java",
          "picture": "file",
          "student": 40
        }
      }
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (empty project):

```json
{
  "code": 200,
  "error": null,
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```


#### Response Body (Failed):

```json
{
  "code": 400,
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

## Get Project Buy By Customer

#### Endpoint : GET /api/project/buy

#### Request Body :

```json

```

#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "learning": {
        "ID": "UUID",
        "picture": "file",
        "materialName": "HTML",
        "name": "Ahmad",
        "lessonComplete": 2,
        "lessonNotComplete": 2
      }
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (empty project):

```json
{
  "code": 200,
  "error": null,
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```


#### Response Body (Failed):

```json
{
  "code": 400,
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```



