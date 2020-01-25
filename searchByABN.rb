require "savon"
# Energy Australia = 99 086 014 968
print "Enter ABN: "
abn = gets.chomp

guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"

# client_options = { :wsdl => "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL" }
client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")
# searching by ABN number
abn_record = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

# searching by a name or part of a name
abn_search_result = abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
# puts abn_search_result[:legal_name][:family_name]

abn_search_result.each do |key, value|
  case key
    when :abn
      print "#{value[:identifier_value]}"
    when :entity_status
      print "\t#{value[:entity_status_code]}".ljust(10)
      print "\t#{value[:effective_from].strftime("%e %b %Y")}"
    when :main_name
      print "\tEntity Name \t#{value[:organisation_name]}"
    when :business_name
      print "\tBusiness Name \t#{value[:organisation_name]}"
    when :main_trading_name
      print "\tTrading Name \t#{value[:organisation_name]}"
    when :other_trading_name
      print "\tOther Name \t#{value[:organisation_name]}"
    when :legal_name
      print "\tEntity Name \t#{value[:full_name]}"
    when :main_business_physical_address
      puts "\t#{value[:postcode]} #{value[:state_code]}"
    end
end
