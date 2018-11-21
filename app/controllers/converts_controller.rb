require_dependency 'libreconv'
class ConvertsController < ApplicationController
 skip_before_action :verify_authenticity_token  
  # GET /converts
  # GET /converts.json
  def index
    render json: {msg: "Try with post"}, status: :created, location: "Done"
  end

  # POST /converts
  # POST /converts.json
  def create 
    client = Restforce.new(username: 'bsign@sixt.com.salesdev',
    password: 'Sixt@12348BSxw9A1OfRUTuL3oG0ytuvk',                      
    client_id: '3MVG9LzKxa43zqdKnLMTH95Ka9p68HnwyETiLPkAVoLfVnOZnmstL7HEf67R4EjdK60OygJUcST5rxgAFjD4K',
    client_secret: '8618267259260679484',
    host: 'test.salesforce.com',
    api_version: '41.0'
  )
    id = params['AttachmentId']

    attachment = client.query("select Id, Name, Body from Attachment Where Id ="+ "'"+id+"'").first
    File.open("#{Rails.root}/public/#{attachment.Name}", 'wb') { |f| f.write(attachment.Body) } 
    render json: {recived: true}, status: :created, location: "Done",action: connectsalesforce(params['ParentId'],attachment.Name,client)
  end
  def connectsalesforce(id,fname,client) 

    pdfname = fname.gsub 'xlsx', 'pdf'
    %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fname}")          
    client.create('Attachment', ParentId: id,
                          Description: 'Document test',
                          Name: 'convert pdf',
                          Body: Base64::encode64(File.read('#{Rails.root}/public/file_conversion/#{pdfname}')))    
   
  end
end
