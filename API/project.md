# Project

## Create New Project

##### Done
#### Endpoint : POST api/project/new

#### Request Body (Success):

```json
{
  "info": "?",
  "linkVideo": "link",
  "materialName": "HTML Dasar",
  "price": 500,
  "picture": "file",
  "learningPath" : "Pemrograman Web"
}
```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```


## Update Project

##### Done
    #### Endpoint : PUT api/project/update/{ID}

#### Request Body (Success):

```json
{
  "info": "?",
  "linkVideo": "link",
  "materialName": "HTML Dasar",
  "price": 500,
  "picture": "file",
  "learningPath" : "Pemrograman Web"
}
```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

## Delete Project

##### Done 
#### Endpoint : DELETE api/project/delete/{ID}

#### Request Body (Success):

```json

```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```


## Get Project Pending

##### Done
#### Endpoint : GET api/project/pending/

#### Request Body (Success):

```json

```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "status" : "PENDING"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "status" : "PENDING"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```


## ACCEPTED Project

##### Done
## {ID} is id from project
#### Endpoint : PUT api/project/accepted/{ID}

#### Request Body (Success):

```json
{
  "reason" : "di isi jika di tolah dan null jika di terima",
  "email": "Email mentor"
}
```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

## Get All Project

##### Done
#### Endpoint : GET api/project/all

#### Request Body (Success):

```json

```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```


## Get All Project

##### Done
#### Endpoint : GET api/project/accepted

#### Request Body (Success):

```json

```


#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

## Get All Project Rejected

##### Done
#### Endpoint : GET /api/project/reject

#### Request Body (Success):

```json

```

#### Response Success

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    },
    {
      "id": "UUID",
      "materialName": "HTML Dasar",
      "student": 500,
      "price": 500,
      "picture": "file",
      "mentor" : "fulan"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```