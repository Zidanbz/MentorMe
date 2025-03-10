# Transaction

## Payment

@ID is id project
#### Endpoint : POST /api/payment/{ID}

#### Request Body :

@ID is id from voucher
```json
{
  "ID": "UUID"
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data":{
    "tokenPay" : "?",
    "redirectURL" : "?"
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

## Pra Payment

@ID is id project
#### Endpoint : GET /api/pay/{ID}

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
  "data":{
    "materialName" : "?",
    "syllabus" : "?",
    "price" : 50
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

## Change Coin For Mentor

#### Endpoint : POST /api/change/coin

#### Request Body :

```json
{
  "coin": 10,
  "accountNumber" : "miofsd"
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": "Success",
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

## Change Money For Mentor

#### Endpoint : POST /api/change/money

#### Request Body :

```json
{
  "money": 10,
  "accountNumber" : "miofsd"
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": "Success",
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

## Get Transaction Change Coin and MoneyMe For Mentor

#### Endpoint : GET /api/history/transaction/mentor

#### Request Body :

```json
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "coin": 25,
      "time": "second-minute-hours",
      "status": "PENDING",
      "totalMoney": 15000
    },
    {
      "coin": 15,
      "time": "second-minute-hours",
      "status": "SUCCESS",
      "totalMoney": 15000
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


