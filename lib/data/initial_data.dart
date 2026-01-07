// Initial data for the rental management app
const String initialDataJson = '''
{
  "rooms": [
    {
      "roomNumber": "03",
      "tenant": {
        "name": "Vicheka",
        "phone": "0812345678",
        "joinDate": "2025-01-01"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2025-01-01",
          "endDate": "2025-01-31",
          "isPaid": false,
          "paymentStatus": "Unpaid"
        }
      ]
    },
    {
      "roomNumber": "10",
      "tenant": {
        "name": "Vicheka",
        "phone": "0823456789",
        "joinDate": "2024-12-15"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2024-12-15",
          "endDate": "2025-01-15",
          "isPaid": false,
          "paymentStatus": "Unpaid"
        }
      ]
    },
    {
      "roomNumber": "6",
      "tenant": {
        "name": "Lebron",
        "phone": "0834567890",
        "joinDate": "2024-11-01"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2025-01-01",
          "endDate": "2025-01-31",
          "isPaid": true,
          "paymentStatus": "Paid"
        }
      ]
    },
    {
      "roomNumber": "2",
      "tenant": {
        "name": "James",
        "phone": "0845678901",
        "joinDate": "2024-10-01"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2025-02-01",
          "endDate": "2025-02-28",
          "isPaid": false,
          "paymentStatus": "Upcoming"
        }
      ]
    },
    {
      "roomNumber": "5",
      "tenant": null,
      "receipts": []
    },
    {
      "roomNumber": "7",
      "tenant": null,
      "receipts": []
    },
    {
      "roomNumber": "1",
      "tenant": {
        "name": "Michael",
        "phone": "0856789012",
        "joinDate": "2024-09-01"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2025-01-01",
          "endDate": "2025-01-31",
          "isPaid": true,
          "paymentStatus": "Paid"
        }
      ]
    },
    {
      "roomNumber": "4",
      "tenant": {
        "name": "Sarah",
        "phone": "0867890123",
        "joinDate": "2024-12-01"
      },
      "receipts": [
        {
          "roomCost": 100,
          "waterCost": 10,
          "electricityCost": 10,
          "durDate": "2025-01-01",
          "endDate": "2025-01-31",
          "isPaid": false,
          "paymentStatus": "Unpaid"
        }
      ]
    },
    {
      "roomNumber": "8",
      "tenant": null,
      "receipts": []
    },
    {
      "roomNumber": "9",
      "tenant": null,
      "receipts": []
    }
  ]
}
''';
