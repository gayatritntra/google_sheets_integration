class DataEntriesController < ApplicationController
  def initialize
    super
  end

  def index
    @data_entries = DataEntry.all
  end

  def show
    @data_entry = DataEntry.find(params[:id])
  end

  def new
    @data_entry = DataEntry.new
  end


  def create
    @data_entry = DataEntry.new(data_entry_params)
    if @data_entry.save
      # Send the data to Google Sheets
      send_data_to_google_sheets(@data_entry)
      redirect_to new_data_entry_path, notice: 'Data was successfully sent to Google Sheet.'
    else
      render :new
    end
  end

  def send_data_to_google_sheets(data_entry)
    google_sheets_service = GoogleSheetsService.new('config/my-google-sheets-credentials.json')
    google_sheets_service.send_data(data_entry)
  end


  private

  def data_entry_params
    params.require(:data_entry).permit(:name, :value)
  end

end

