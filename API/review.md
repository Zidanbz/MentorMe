# Review Mentor

## Create Review To Mentor

##### @ID is id project selected
#### Endpoint : POST /api/review/{ID}



#### Request Body

```json
{
  "qualityMentor": 5,
  "criticism": "Berisi Kritik"
}
```

#### Response Body (Success) :

```json
{
  "code": 200,
  "error": null,
  "data": {
    "fullName": "Crabs",
    "materialName": "Pengenalan HTML",
    "train": [
      {
        "trainActivity": {
          "meeting": "Pertemuan 1",
          "materialNameTrain": "Belajar Dasar HTML, CSS, Javascript",
          "status": true,
          "IDActivity": "UUID"
        }
      },
      {
        "trainActivity": {
          "meeting": "Pertemuan 2",
          "materialNameTrain": "Menerapkan Program HTML, CSS, javascript",
          "status": false,
          "IDActivity": "UUID"
        }
      }
    ]
  },
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```

#### Response Body (Failed) :


```json
{
  "code": 400,
  "error": "Message error ?",
  "data": "",
  "message": "httpStatusMessage",
  "time": "second-minute-jam data-month-year",
  "UUID": "5832532n9gwe80"
}
```