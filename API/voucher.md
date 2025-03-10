# Voucher

## Create New Voucher

#### Endpoint : POST /api/voucher/created

#### Request Body :

```json
{
  "name": "voucher apa",
  "piece": 75,
  "startTime": 2,
  "endTime": 9,
  "info": "voucher ini adalah ..."
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "ID": "a746dd73-1f1e-4e38-891a-b03e56a77e55",
      "name": "voucher apa",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-09T00:00:00.000Z",
      "dateEnd": "2024-12-18T00:00:00.000Z"
    },
    {
      "ID": "44813b82-9131-4bea-a7c0-0913f0c4e391",
      "name": "voucher apa",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-09T00:00:00.000Z",
      "dateEnd": "2024-12-18T00:00:00.000Z"
    },
    {
      "ID": "89432e61-d2c4-4339-9d51-65a5068b3362",
      "name": "Vocuer Data",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-10T00:00:00.000Z",
      "dateEnd": "2024-12-20T00:00:00.000Z"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```

## Get Voucher

#### Endpoint : GET /api/voucher/get

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
  "data": [
    {
      "ID": "a746dd73-1f1e-4e38-891a-b03e56a77e55",
      "name": "voucher apa",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-09T00:00:00.000Z",
      "dateEnd": "2024-12-18T00:00:00.000Z"
    },
    {
      "ID": "44813b82-9131-4bea-a7c0-0913f0c4e391",
      "name": "voucher apa",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-09T00:00:00.000Z",
      "dateEnd": "2024-12-18T00:00:00.000Z"
    },
    {
      "ID": "89432e61-d2c4-4339-9d51-65a5068b3362",
      "name": "Vocuer Data",
      "piece": 75,
      "info": "voucher ini adalah ...",
      "dateStart": "2024-12-10T00:00:00.000Z",
      "dateEnd": "2024-12-20T00:00:00.000Z"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```


## Delete Voucher

@ID is id from voucher
#### Endpoint : GET /api/voucher/delete/{ID}

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
  "data":[
    {
      "name": "voucher apa",
      "discount": 75,
      "dateStart": "datetime",
      "dateEnd": "datetime",
      "info": "voucher ini adalah ..."
    },
    {
      "name": "voucher apa",
      "discount": 75,
      "dateStart": "datetime",
      "dateEnd": "datetime",
      "info": "voucher ini adalah ..."
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```


## Update Voucher

@ID is id from voucher
#### Endpoint : GET /api/voucher/edit/{ID}

#### Request Body :

```json
{
  "name": "voucher apa",
  "piece": 75,
  "startTime": 2,
  "endTime": 1,
  "info": "voucher ini adalah ..."
}
```

#### Response Body (Success):

```json
{
  "code": 200,
  "error": null,
  "data":[
    {
      "name": "voucher apa",
      "discount": 75,
      "dateStart": "datetime",
      "dateEnd": "datetime",
      "info": "voucher ini adalah ..."
    },
    {
      "name": "voucher apa",
      "discount": 75,
      "dateStart": "datetime",
      "dateEnd": "datetime",
      "info": "voucher ini adalah ..."
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```

#### Response Body (Failed)

```json
{
  "code": "?",
  "error": "Message Error ?",
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year"
}
```