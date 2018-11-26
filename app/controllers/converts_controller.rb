require_dependency 'libreconv'
require 'json'
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
    header = {'Content-Type' =>'application/json','Authorization' => 'OAuth '+params['sessionId']}
    id = params['AttachmentId']
    uri = URI.parse("https://sixt--salesdev--c.cs105.visual.force.com/services/data/v32.0/sobjects/Attachment/"+id+"/Body")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Get.new(uri.path, header)
    attachment = https.request(req)
    
    File.open("#{Rails.root}/public/#{params['Name']}", 'wb') { |f| f.write(attachment.body) } 
    connectsalesforce(params['ParentId'],params['Name'],params['sessionId'])
    render json: {convertDone: true}, status: :created, location: "Done"
  end
  def connectsalesforce(id,fname,sessionId)
    pdfname = fname.gsub 'xlsx', 'pdf'
    %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fname}")          

    header = {'Content-Type' =>'application/json','Authorization' => 'OAuth '+sessionId}
    data = {"ParentId" => id,"Description" => "Convert document","Name" => pdfname, "Body" => Base64::encode64(File.read("#{Rails.root}/public/file_conversion/#{pdfname}"))}
    uri = URI.parse("https://sixt--salesdev--c.cs105.visual.force.com/services/data/v32.0/sobjects/Attachment/")
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
