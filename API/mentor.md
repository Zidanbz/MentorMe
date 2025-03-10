# Mentor

## Create Mentor

#### Endpoint : POST /api/registration/mentor

#### Request Body :

```json
{
  "fullName": "fulan",
  "email": "fulan@gmail.com",
  "password": "fulan",
  "confirmPassword": "fulan",
  "cv": "file",
  "ktp": "file",
  "picture": "file",
  "portfolio" : "link",
  "ability" : "?"
}
```


#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": null,
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :

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

## GET Mentor PENDING

#### Endpoint : GET /api/mentor/pending

#### Request Body :

```json

```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "fullName": "fulan",
      "email": "fulan@gmail.com",
      "cv": "file",
      "ktp": "file",
      "picture": "file",
      "portfolio" : "link",
      "ability" : "?",
      "status" : "PENDING"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```
#### Response Body (Failed) :

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
## ACCEPTED Mentor

##### {ID} is id from mentor
#### Endpoint : PUT /api/accepted/{ID}

#### Request Body :

```json
{
  "reason" : "di isi jika di tolah dan null jika di terima",
  "email" : "email from mentor"
}
```
#### Response Body (Success) :

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
#### Response Body (Failed) :

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

## GET Mentor Reject

#### Endpoint : GET /api/user/reject

#### Request Body :

```json

```
#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": [
    {
      "fullName": "fulan",
      "email": "fulan@gmail.com",
      "cv": "file",
      "ktp": "file",
      "picture": "file",
      "portfolio" : "link",
      "ability" : "?",
      "status" : "PENDING"
    }
  ],
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```
#### Response Body (Failed) :

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

## Update Mentor

#### Endpoint : PUT /api/profile/mentor/update

#### Request Body :

```json
{
  "fullName": "fulan",
  "cv": "file",
  "ktp": "file",
  "picture": "file",
  "portfolio" : "link",
  "ability" : "?"
}
```


#### Response Body (Success) :

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

#### Response Body (Failed) :

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