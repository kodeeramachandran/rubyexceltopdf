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
    puts "-------------------"
    fname = "ratesheet"
    #File.open("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", 'wb') do |f|
      #f.write(Base64.decode64(params[:file_convertor][:file]))
    #end
    puts request
    puts "-------------------"
    #File.open("#{Rails.root}/public/#{fname.xlsx}", 'wb') do |f|
     # f.write(request.body)
    #end
  # file_conversion = FileConversion.new(tempfile)
  # download_file_path = file_conversion.convert
  
  # File conversion process from xlsx to pdf
  #Libreconv.convert("#{Rails.root}/public/#{params[:file_convertor][:filename]}.xlsx", "#{Rails.root}/public/file_conversion/#{params[:file_convertor][:filename]}.pdf","#{Rails.root}/public/office/program/soffice")   
  
 
  
  render json: {download_file_path:params}, status: :created, location: "Done"
  end

end
