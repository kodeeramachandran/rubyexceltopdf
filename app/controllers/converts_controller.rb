require_dependency 'libreconv'
class ConvertsController < ApplicationController
 skip_before_action :verify_authenticity_token  
  # GET /converts
  # GET /converts.json
  def index
    connectsalesforce()
   render json: {msg: "Yor are tring this servoice with get method please try with post",status:"Success"}
  end

  # POST /converts
  # POST /converts.json
  def create      
    path = File.join Rails.root, 'public'
    fileName = params['File Name'];

    File.open("#{Rails.root}/public/#{fileName}.xlsx", 'wb') do |f|
      f.write(Base64.decode64(params['Xlsx Body']))
    end 

  
  #download_file_path = "#{Rails.root}/public/file_conversion/#{fileName}.pdf"
  
  connectsalesforce(params['ParentId'],fileName);
  render json: {recived: true}, status: :created, location: "Done"
  end
  def connectsalesforce(id,fname)
   
    puts "--------"
    %x("#{Rails.root}/public/office/program/swriter" --headless --convert-to pdf --outdir  "#{Rails.root}/public/file_conversion/" "#{Rails.root}/public/#{fileName}.xlsx")

    #outputfileBase64 = Base64.encode64(open("#{Rails.root}/public/file_conversion/#{fileName}.pdf").to_a.join);
    #outputfileBase64 = open("#{Rails.root}/public/file_conversion/#{fileName}.pdf").read;

    client = Restforce.new(oauth_token: '00D1w0000008aNu!AQcAQB9mzTN4EmJm8i8RZel7Vs3XC4wOJXWLHHcUfAisN2V8.eZoisKZAjUtH0EbucTfUxoTJjPQ5WfKkrDNlXVenkVzflM5',
                       instance_url: 'https://sixt--salesdev.cs105.my.salesforce.com',
                       "token_type" => "Bearer",
                       api_version: '41.0')
    puts client.inspect
    client.create('Attachment', ParentId: id,
                          Description: 'Document test',
                          Name: 'convert pdf',
                          Body: Base64::encode64(File.read('#{Rails.root}/public/file_conversion/#{fname}.pdf'))
   
  end
end
