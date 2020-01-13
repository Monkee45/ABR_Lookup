require "savon"
# Energy Australia = 99 086 014 968

abn='99086014968'
cname = "True life calling"
guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"
result1 = Array.new

# client_options = { :wsdl => "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL" }
client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

# searching by ABN number
abn_record = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

# searching by a name or part of a name
name_record = client.call(:abr_search_by_name_simple_protocol, message: { name: cname, authenticationGuid: guid })

abn_search_result = abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]

name_search_result = name_record.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list]

puts "ABN Search Result\n"
puts abn_record
puts "\n\n\n\n\n\n\n\n\n\n\n Name Search Result\n"
# pp name_search_result

# puts response
# puts result[:main_name][:organisation_name]
# puts "Main Trading Name: #{result[:main_trading_name][:organisation_name]}"
# puts "ABN Number: #{result[:abn][:identifier_value]}"
# puts "Entity Status: #{result[:entity_status][:entity_status_code]}"
# puts "ASIC Number: #{result[:asic_number]}"
# puts "Entity Description: #{result[:entity_description]}"

# http://www.webservicex.net/uszip.asmx?WSDL
