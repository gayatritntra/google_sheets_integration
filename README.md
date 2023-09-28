
## Explanation of how to use the google_sheet_service.rb
  
  - First Create the Service object

  ````yaml
    google_sheets_service = GoogleSheetsService.new('config/my-google-sheets-credentials.json')
  `````
  #### Add headers to google sheet
  
  - headers = ["First Name", "Last Name", "Email"]

  ``````yaml
    google_sheets_service.add_headers_to_spreadsheet(headers)
  ``````
  #### Add Data to google sheet

  - data = ["Mona", "Solanki", "mona.solanki@tntra.io"]

  ``````yaml
    google_sheets_service.send_data(data)
  ``````

  #### Update data of google sheet

  - old_dat = ["Mona", "Solanki", "mona.solanki@tntra.io"]

  - data_to_update = ["Mona", "Solanki", "mona@tntra.io"]

  ``````yaml
  google_sheets_service.update_data(data_to_update, old_data)
  ``````

  #### Delete data of google sheet

  - data_to_delete = ["Mona", "Solanki", "mona@tntra.io"]

  ``````yaml
  google_sheets_service.delete_data(data_to_delete)
  ``````

 





