# Login User

## Login For User

##### Done
### Endpoint : POST api/login/user

#### Request Body (Success):

```json
{
  "email" : "fulan@gmail.com",
  "password" : "fulan"
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": {
    "categories": [
      {
        "id": "UUID",
        "name": "Desain"
      },
      {
        "id": "UUID",
        "name": "Bisnis"
      },
      {
        "id": "UUID",
        "name": "IT & Perangkat Lunak"
      }
    ],
    "learningPath": [
      {
        "id": "UUID",
        "name": "Pemrograman Web",
        "students": 1000
      },
      {
        "id": "UUID",
        "name": "Pengolahan Data",
        "students": 1000
      },
      {
        "id": "UUID",
        "name": "Pengenalan Desain",
        "students": 1000
      }
    ],
    "token": "5mfo90asf"  
  },
  "message": "httpStatusMessage",
  "time": "2024-11-29T13:45:00Z",
  "UUID": "1nig9wejwoin"
}
```

```json
{
  "code": 401,
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "1nig9wejwoin"
}
```