# Learning Path

## Create Learning Path New

##### Done
#### Endpoint : POST /api/learn/new

#### Request Body

```json
{
  "categories": "name",
  "name": "Data Analyst",
  "picture": "file"
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "name": "Pemrograman Web",
      "students": 1000,
      "picture": "file"
    },
    {
      "id": "UUID",
      "name": "Pengolahan Data",
      "students": 1000,
      "picture": "file"
    },
    {
      "id": "UUID",
      "name": "Data Analyst",
      "students": 0,
      "picture": "file"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed)

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

## Get Project in Learning Path

@ID is id from learning path
#### Endpoint : GET /api/learn/{ID}

#### Request Body

```json
{
  
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "ID": "UUID",
      "materialName": "Pengenalan HTML",
      "fullName": "Aria Susanto",
      "picture": "file",
      "student": 50,
      "price": 15000
    },
    {
      "ID": "UUID",
      "materialName": "Javascript untuk Interaktivitas",
      "fullName": "Resky Pratama",
      "picture": "file",
      "student": 50,
      "price": 15000
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed)

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

## Search Learning Path

@ID is id from learning path
#### Endpoint : GET /api/learn/project/search/{ID}

#### Request Body

```json
{
  "search" : "name"
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "ID": "UUID",
      "materialName": "Pengenalan HTML",
      "fullName": "Aria Susanto",
      "picture": "file",
      "student": 50,
      "price": 15000
    },
    {
      "ID": "UUID",
      "materialName": "Javascript untuk Interaktivitas",
      "fullName": "Resky Pratama",
      "picture": "file",
      "student": 50,
      "price": 15000
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed)

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

## Learning Path Description

@ID is id from project
#### Endpoint : GET /api/learn/project/{ID}

#### Request Body

```json
{
  
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": {
    "ID": "UUID",
    "info": "HTML adalah ...",
    "picture": "file",
    "fullName": "Aria Santoso",
    "about": "Aria Santoso adalah ...",
    "linkVideo": "link video",
    "student" : 20
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed)

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


## Get Learning Path By Categories

@ID is id from project
#### Endpoint : GET /api/learn/project/categories/{ID}

#### Request Body

```json
{
  
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": {
    "ID": "UUID",
    "infoProject": "HTML adalah ...",
    "pictureProject": "file",
    "fullName": "Aria Santoso",
    "about": "Aria Santoso adalah ...",
    "linkVideo": "link video"
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed)

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

