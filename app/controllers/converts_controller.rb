require_dependency 'libreconv'
class ConvertsController < ApplicationController
 skip_before_action :verify_authenticity_token  
  # GET /converts
  # GET /converts.json
  def index
   render json: {status:"Success"}
  end

  # GET /converts/1
  # GET /converts/1.json
  def show
  end

  # GET /converts/new
  def new
   
  end

  # GET /converts/1/edit
  def edit
  end

  # POST /converts
  # POST /converts.json
  def create      
    path = File.join Rails.root, 'public'
    puts "-----------------"
    puts path
    File.open("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", 'wb') do |f|
      f.write(Base64.decode64(params[:file_convertor]["file"]))
    end

  # file_conversion = FileConversion.new(tempfile)
  # download_file_path = file_conversion.convert
  
  # File conversion process from xlsx to pdf
  Libreconv.convert("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf")   
  download_file_path = "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf"
  
  render json: {download_file_path: download_file_path}, status: :created, location: "Done"
  end

  # PATCH/PUT /converts/1
  # PATCH/PUT /converts/1.json
  def update
    
  end

  # DELETE /converts/1
  # DELETE /converts/1.json
  def destroy
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_convert
     
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def convert_params
     
    end
end
