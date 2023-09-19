require 'google/apis/sheets_v4'
require 'googleauth'

# Define the path to your JSON credentials file
credentials_path = Rails.root.join('config', 'my-google-sheets-credentials.json')

# Authorize using the service account credentials
authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(credentials_path),
  scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
)

# Fetch the access token
authorizer.fetch_access_token!

# Initialize the Google Sheets API client
google_sheets_service = Google::Apis::SheetsV4::SheetsService.new
google_sheets_service.authorization = authorizer
