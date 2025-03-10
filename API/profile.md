# Profile 

## History Transaction

#### Endpoint : GET /api/profile/history

#### Request Body :

```json
{
  
}
```

#### Response Body (Success) :

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": {
    "customers": {
      "ID": "UUID",
      "job": "Mahasiswa",
      "status": "Premium"
    },
    "history": [
      {
        "status": "success",
        "price": 150000,
        "project": {
          "ID": "UUID",
          "materialName": "Pengenalan HTML"
        },
        "LearingPath": {
          "ID": "UUID",
          "name": "Pemrograman Web"
        }
      },
      {
        "status": "Failed",
        "price": 200000,
        "project": {
          "ID": "UUID",
          "materialName": "CSS Untuk Styling"
        },
        "LearingPath": {
          "ID": "UUID",
          "name": "Pemrograman Web"
        }
      }
    ]
  },
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

## Get Profile

#### Endpoint : GET /api/profile/get

#### Request Body :

```json

```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Sulaiman",
    "picture" : "file",
    "phone" : "0822xxxx",
    "email" : "sulaimankeren@gmail.com",
    "status" : "FREE/PREMIUM",
    "job": "?"
  },
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


## Edit Profile

#### Endpoint : POST /api/profile/edit


#### Request Body :

```json
{
  "picture": "file",
  "fullName" : "Sulaiman Keren",
  "phone" : "0822xxx"
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Sulaiman",
    "picture" : "file",
    "phone" : "0822xxxx",
    "email" : "sulaimankeren@gmail.com"
  },
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