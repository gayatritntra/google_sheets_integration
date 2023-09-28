class GoogleSheetsService
  def initialize(credentials_path)
    @credentials_path = credentials_path
    @spreadsheet_id = '18q-uDgOljTURm6S7yuIuNgxSUDuPx0KlARNfwzaCJwY'
    @range = 'Sheet1'
  end

  def add_headers_to_spreadsheet(headers)
    authorize
    response = @google_sheets_service.get_spreadsheet_values(@spreadsheet_id, "#{@range}!A1:Z1")
    if response.values.present?
      num_existing_headers = response.values.first.length
      new_header_column = ('A'.ord + num_existing_headers).chr
      new_header = headers
      initialize_header = Google::Apis::SheetsV4::ValueRange.new(values: [new_header])
      new_header_range = "#{@range}!#{new_header_column}1"

      update_spreadsheet(@spreadsheet_id, new_header_range, initialize_header)
    else
      range = "#{@range}!A1"
      new_headers = Google::Apis::SheetsV4::ValueRange.new(values: [headers])
      update_spreadsheet(@spreadsheet_id, range, new_headers)
    end
  end

  def send_data(data_entry)
    authorize
    existing_data = get_existing_data(@spreadsheet_id, @range)
    next_row = existing_data ? existing_data.size + 1 : 1
    new_range = "#{@range}!A#{next_row}"
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: [data_entry])
    update_spreadsheet(@spreadsheet_id, new_range, value_range)
  end

  def delete_data(data_entry)
    authorize
    sheet = @google_sheets_service.get_spreadsheet(@spreadsheet_id)
    existing_data = get_existing_data(@spreadsheet_id, @range)
    data_to_delete = existing_data.select { |arr| arr == data_entry }.first

    return nil unless data_to_delete.present?

    row_index = 0

    existing_data.each_with_index do |arr, index|
      next if arr != data_to_delete

      row_index = index + 1
    end

    sheet_id = sheet.sheets.find { |s| s.properties.title == @range }.properties.sheet_id
    request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new
    request.requests = [
      {
        delete_dimension: {
          range: {
            sheet_id: sheet_id, # Use the sheet ID, not the name
            dimension: 'ROWS',
            start_index: row_index - 1,
            end_index: row_index # Deletes a single row
          }
        }
      }
    ]
    @google_sheets_service.batch_update_spreadsheet(@spreadsheet_id, request)
  end

  def update_data(data_to_update, existing_data)
    authorize
    sheet_existing_data = get_existing_data(@spreadsheet_id, @range)
    sheet_updated_data = []
    sheet_existing_data.each do |data|
      if data == existing_data
        sheet_updated_data << data_to_update
      else
        sheet_updated_data << data
      end
    end

    value_range = Google::Apis::SheetsV4::ValueRange.new(values: sheet_updated_data)
    update_spreadsheet(@spreadsheet_id, @range, value_range)
  end

  private

  def authorize
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(@credentials_path),
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    )
    authorizer.fetch_access_token!
    @google_sheets_service = Google::Apis::SheetsV4::SheetsService.new
    @google_sheets_service.authorization = authorizer
  end

  def get_existing_data(spreadsheet_id, range)
    @google_sheets_service.get_spreadsheet_values(spreadsheet_id, range)&.values
  end

  def update_spreadsheet(spreadsheet_id, range, value_range)
    @google_sheets_service.update_spreadsheet_value(spreadsheet_id, range, value_range, value_input_option: 'RAW')
  end
end
