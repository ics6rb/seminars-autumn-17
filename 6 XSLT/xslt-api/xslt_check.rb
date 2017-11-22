require 'nokogiri'

if $PROGRAM_NAME == __FILE__
  doc = Nokogiri::XML(File.read('response.xml'))
  xslt = Nokogiri::XSLT(File.read('transform.xslt'))
  puts xslt.transform(doc)
end
