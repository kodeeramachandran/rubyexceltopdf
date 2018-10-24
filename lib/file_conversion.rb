##########################################################
# Ruby: ruby-2.5.1
##########################################################

require 'rubygems'
require 'libreconv'

class FileConversion

  def initialize(filepath)
    @doc_file = filepath
  end

  def convert
    Libreconv.convert(@doc_file, "#{Rails.root}/public/file_conversion/document.pdf")
    return "#{Rails.root}/public/file_conversion/document.pdf"
  end

end

# file_conversion = FileConversion.new('<xls file path>')
# file_conversion.convert
