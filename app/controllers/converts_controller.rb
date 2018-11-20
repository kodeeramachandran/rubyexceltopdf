require_dependency 'libreconv'
class ConvertsController < ApplicationController
 skip_before_action :verify_authenticity_token  
  # GET /converts
  # GET /converts.json
  def index
    connectsalesforce('123','ggg');
   render json: {msg: "Yor are tring this servoice with get method please try with post",status:"Success"}
  end

  # POST /converts
  # POST /converts.json
  def create      
    path = File.join Rails.root, 'public'
    fileName = params['File Name'];

    File.open("#{Rails.root}/public/#{fileName}.xlsx", 'wb') do |f|
     f.write(params['Xlsx Body'])
    end 

  
  #download_file_path = "#{Rails.root}/public/file_conversion/#{fileName}.pdf"
  
  connectsalesforce(params['ParentId'],fileName);
  render json: {recived: true}, status: :created, location: "Done"
  end
  def connectsalesforce(id,fname)   

    %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fname}.xlsx")

    #outputfileBase64 = Base64.encode64(open("#{Rails.root}/public/file_conversion/#{fileName}.pdf").to_a.join);
    #outputfileBase64 = open("#{Rails.root}/public/file_conversion/#{fileName}.pdf").read;
    client = Restforce.new(username: 'bsign@sixt.com.salesdev',
                       password: 'Sixt@12348BSxw9A1OfRUTuL3oG0ytuvk',                      
                       client_id: '3MVG9LzKxa43zqdKnLMTH95Ka9p68HnwyETiLPkAVoLfVnOZnmstL7HEf67R4EjdK60OygJUcST5rxgAFjD4K',
                       client_secret: '8618267259260679484',
                       host: 'test.salesforce.com',
                       api_version: '41.0')
    
    response =  client.authenticate!
       
    client.create('Attachment', ParentId: id,
                          Description: 'Document test',
                          Name: 'convert pdf',
                          Body: Base64::encode64(File.read('#{Rails.root}/public/file_conversion/#{fname}.pdf')))
   
  end
end
