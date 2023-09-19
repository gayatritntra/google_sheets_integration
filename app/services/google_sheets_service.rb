class GoogleSheetsService
  def initialize(credentials_path)
    @credentials_path = credentials_path
  end

  def send_data(data_entry)
    authorize
    data = [data_entry.name, data_entry.value]
    spreadsheet_id = '18q-uDgOljTURm6S7yuIuNgxSUDuPx0KlARNfwzaCJwY'
    range = 'Sheet1'
    existing_data = get_existing_data(spreadsheet_id, range)
    next_row = existing_data ? existing_data.size + 1 : 1
    new_range = "#{range}!A#{next_row}"
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: [data])
    update_spreadsheet(spreadsheet_id, new_range, value_range)
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
