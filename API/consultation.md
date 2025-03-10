# Consultation

## Search Consultation

#### Endpoint : GET /api/consul/search

#### Request Body

```json
{
  "instansi": "?",
  "major": "Teknik Informasika",
  "subject": "Java",
  "references": "Pengenalan OOP",
  "description": "pencarian saya adalah ..."
}
```

#### Response Body (Success):

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

## History Consultation

#### Endpoint : GET /api/consul/history

#### Request Body 

```json
{
  
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": {
    "mentor": {
      "name": "Allan Dev",
      "picture": "file"
    },
    "coin": 15
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