require_dependency 'libreconv'
require 'json'
require 'openssl'
require 'net/https'

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
    header = {'Content-Type' =>'application/json','Authorization' => 'OAuth '+params['SessionId']}
    id = params['AttachmentId']
    baseURL = params['Url']
    uri = URI.parse(baseURL+"/services/data/v44.0/sobjects/Attachment/"+id+"/Body")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, header)
    attachment = https.request(req)
    
    File.open("#{Rails.root}/public/#{params['Name']}", 'wb') { |f| f.write(attachment.body) } 
    convertandCreateAttachment(params['ParentId'],params['Name'],params['SessionId'],baseURL)
    render json: {convertDone: true}, status: :created, location: "Done"
  end
  
  def convertandCreateAttachment(id,fname,sessionId, baseURL)
    pdfname = fname.gsub 'xlsx', 'pdf'
    %x("#{Rails.root}/public/office/program/swriter" --headless --invisible --nocrashreport --nodefault --nologo --nofirststartwizard --norestore --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fname}")          

    %x("pdftk #{Rails.root}/public/file_conversion/#{pdfname} cat 1 3-end output #{Rails.root}/public/file_conversion/#{'r'+pdfname}")

    header = {'Content-Type' =>'application/json','Authorization' => 'OAuth '+sessionId}
    data = {"ParentId" => id,"Description" => "Convert document","Name" => pdfname, "Body" => Base64::encode64(File.read("#{Rails.root}/public/file_conversion/#{'r'+pdfname}"))}
    uri = URI.parse(baseURL+"/services/data/v44.0/sobjects/Attachment/")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, header)
    req.body = data.to_json
    res = https.request(req)
    puts res
    File.delete("#{Rails.root}/public/file_conversion/#{pdfname}") if File.exist?("#{Rails.root}/public/file_conversion/#{pdfname}") 
    File.delete("#{Rails.root}/public/#{fname}") if File.exist?("#{Rails.root}/public/#{fname}")  
   
  end
end
