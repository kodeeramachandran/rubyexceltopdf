require_dependency 'libreconv'
class ConvertsController < ApplicationController
 skip_before_action :verify_authenticity_token  
  # GET /converts
  # GET /converts.json
  def index
   render json: {msg: "Yor are tring this servoice with get method please try with post",status:"Success"}
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
  #Libreconv.convert("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf","#{Rails.root}/public/office/program/soffice")   
  
  %x("#{Rails.root}/public/office/program/uno -f pdf"  "#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx")

  

  outputfileBase64 = Base64.encode64(open("#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf").to_a.join);
  download_file_path = "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf"
  
  render json: {download_file_path: outputfileBase64}, status: :created, location: "Done"
  end

end
