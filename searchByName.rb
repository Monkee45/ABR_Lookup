require "savon"
# Energy Australia = 99 086 014 968

puts "Enter the Name you are searching for: "
cname = gets.chomp
guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"

client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")
name_record = client.call(:abr_search_by_name_simple_protocol, message: { name: cname, authenticationGuid: guid })
name_search_result = name_record.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list][:search_results_record]
# pp name_search_result

# Display same/similar to https://abr.business.gov.au/ when doing a "name" search
# name_search_result is an array of hashes
# iterate through the array and then iterate through the hash key-value pairs
# Only pull out those keys/values that appear on the abr lookup site
# Business name key names seem to depend on the type of record
name_search_result.each do |entry|
  entry.each do |key, value|
    case key
      when :abn
        print "#{value[:identifier_value]}"
        print "\t#{value[:identifier_status]}".ljust(10)
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
end
