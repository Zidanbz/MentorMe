# Registration User

## Registration For User

#### Done
### Endpoint : POST /api/registration/user

#### Request Body (Success) :

```json
{
  "fullName": "fulan",
  "email": "fulan@gmail.com",
  "password": "fulan",
  "confirmPassword": "fulan"
}
```

#### Response Body (Success)

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

## Registration For admin

### Endpoint : POST /api/registration/admin

#### Request Body (Success) :

```json
{
  "fullName": "fulan",
  "email": "fulan@gmail.com",
  "password": "fulan",
  "confirmPassword": "fulan",
  "picture" : "file"
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": "Success Registration Admin",
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
