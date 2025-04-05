# Chat

## Start Chat to First Time

### Endpoint: POST /api/chat

#### Request body

```json
{
  "email": "fulan@gmail.com"
}
```

#### Response Body (Success)

```json
{
  "code": 200,
  "error": null,
  "data": 5032,
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

## Get History Chat

### Endpoint: GET /api/chat

#### Request body

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
      "idRoom": 29412
    },
    {
      "idRoom": 40212
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

