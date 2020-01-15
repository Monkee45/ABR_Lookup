require "savon"
# The ABN for Energy Australia = 99 086 014 968
# This is based on new Branch work
# Just updating this one line

abn = 0

loop do
	print "\nEnter the ABN you are searching for ('q' to exit): "
	abn = gets.chomp
	puts " You are looking for: #{abn}\n"

	case abn
		when /^\d{11}$/			# regular expression looking for 11 digits from start of string to end of string
			break
		when 'q'
			break
	end

end

if abn == 0
	abn = '99086014968'
end

guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"

puts "This is the ABN we are looking for #{abn}"

client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

response = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

result = response.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
puts "\n\n"
puts result[:main_name][:organisation_name]
puts "Main Trading Name: #{result[:main_trading_name][:organisation_name]}"
puts "ABN Number: #{result[:abn][:identifier_value]}"
puts "Entity Status: #{result[:entity_status][:entity_status_code]}"
puts "ASIC Number: #{result[:asic_number]}"
puts "Entity Description: #{result[:entity_description]}"
