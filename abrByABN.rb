require "savon"
# Energy Australia = 99 086 014 968

abn='99086014968'
guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"

puts "This is the ABN we are looking for #{abn}"

# client_options = { :wsdl => "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL" }

client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

# response = client.call(:abr_search_by_abn, :includeHistoricalDetails => "N")

response = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

result = response.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
# puts response
puts result[:main_name][:organisation_name]
puts "Main Trading Name: #{result[:main_trading_name][:organisation_name]}"
puts "ABN Number: #{result[:abn][:identifier_value]}"
puts "Entity Status: #{result[:entity_status][:entity_status_code]}"
puts "ASIC Number: #{result[:asic_number]}"
puts "Entity Description: #{result[:entity_description]}"

# http://www.webservicex.net/uszip.asmx?WSDL
