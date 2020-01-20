require "savon"
# Energy Australia = 99 086 014 968
print "Enter ABN: "
abn = gets.chomp

guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"
result1 = Array.new

# client_options = { :wsdl => "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL" }
client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

# searching by ABN number
puts "Searching by ABN Number"
abn_record = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

# searching by a name or part of a name
abn_search_result = abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
# puts abn_search_result[:legal_name][:family_name]

puts "ABN Search Result\n"
puts abn_search_result.keys
puts abn_search_result
if abn_search_result.key?(:legal_name)
  puts abn_search_result[:legal_name].keys
  puts abn_search_result[:legal_name][:family_name]
  puts "has family name"
else
  puts "no family"
end

#if abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:exception]
#  @error_msg = abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:exception][:exception_description]
#  puts "THERE WAS AN ERROR"
#  puts @error_msg
#else
#  puts "NO ERROR FOUND"
#end
