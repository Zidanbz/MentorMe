# Top Up Coin

## Get Coin : GET /api/coin/get

#### Request Body :

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
    "coin": 500,
    "topUp": [
      {
        "amountCoin": 500,
        "price": 15000,
        "date": "datetime"
      },
      {
        "amountCoin": 500,
        "price": 15000,
        "date": "datetime"
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


## Do Top Up

#### Endpoint : POST /api/coin/topUp

#### Request Body
```json
{
  "amountCoin": 500
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