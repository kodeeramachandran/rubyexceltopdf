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
    fileName = "ratesheet"

    #File.open("#{Rails.root}/public/#{fileName}.xlsx", 'wb') do |f|
      #f.write(Base64.decode64(params[:fileValue]))
    #end
    File.open("#{Rails.root}/public/#{fileName}.xlsx", 'wb') do |f|
      f.write(params[:fileValue])
    end

    %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fileName}.xlsx")

  

  outputfileBase64 = Base64.encode64(open("#{Rails.root}/public/file_conversion/#{fileName}.pdf").to_a.join);
  download_file_path = "#{Rails.root}/public/file_conversion/#{fileName}.pdf"
  
  render json: {download_file_path: outputfileBase64}, status: :created, location: "Done"
  end

end
