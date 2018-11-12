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
    fname = "ratesheet";
    #File.open("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", 'wb') do |f|
      #f.write(Base64.decode64(params[:file_convertor][:file]))
    #end
    fileurl= "https://sixt--salesdev--c.cs105.content.force.com/sfc/dist/version/download/?oid=00D1w0000008aNu&ids=0681w0000008gdZ&d=%2Fa%2F1w0000008PL5%2FKejr7MEITHSTV8mPTJGo0CIqkAU9VmP3CFHIFGURLJc&asPdf=false"
  # file_conversion = FileConversion.new(tempfile)
  # download_file_path = file_conversion.convert
  
  # File conversion process from xlsx to pdf
  #Libreconv.convert("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf","#{Rails.root}/public/office/program/soffice")   
  
  #%x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fname}.xlsx")  
  %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{fileurl}" "#{Rails.root}/public/#{fname}.xlsx")  

  #outputfileBase64 = Base64.encode64(open("#{Rails.root}/public/file_conversion/#{fname}.pdf").to_a.join);
  file = File.open("#{Rails.root}/public/file_conversion/#{fname}.pdf", "rb")
  outputfileBase64 = file.read
  download_file_path = "#{Rails.root}/public/file_conversion/#{fname}.pdf"
  
  render json: {download_file_path: outputfileBase64}, status: :created, location: "Done"
  end

end
