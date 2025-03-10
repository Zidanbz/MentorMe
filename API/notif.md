# Notification

## Create Notification 

#### Endpoint : POST /api/notif/new

#### Request Body

```json
{
  "title": "Bisnis",
  "message" : "message"
}
```

#### Response Body (Success)

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


## Get All Notification

#### Endpoint : GET /api/get/all

#### Request Body

```json

```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": [
    {
      "ID": "UUID",
      "title": "nama pesan",
      "message": "pesan"
    }
  ],
  "data": "Success",
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