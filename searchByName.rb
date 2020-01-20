require "savon"
# Energy Australia = 99 086 014 968
print "Enter ABN: "
abn = gets.chomp

print "Enter Name: "
cname = gets.chomp
#cname = "abxyei39@455"
guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"
result1 = Array.new

# client_options = { :wsdl => "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL" }
client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

# searching by ABN number
puts "Searching by ABN Number"
abn_record = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: abn, includeHistoricalDetails: "N" })

# searching by a name or part of a name
puts "Searching by Company Name"
name_record = client.call(:abr_search_by_name_simple_protocol, message: { name: cname, authenticationGuid: guid })
puts name_record
abn_search_result = abn_record.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]

name_search_result = name_record.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list]

puts "ABN Search Result\n"
# puts abn_search_result
puts "\nName Search Result\n"
puts name_search_result[:number_of_records]
puts name_search_result[:exceeds_maximum]

# the returned has does not always have the same key values for name hence the need to "search"
# for one via main_name, business_name, etc.
  name_search_result[:search_results_record].each do |x|
    if x[:abn]
      print x[:abn][:identifier_value]
      print "\t"+x[:abn][:identifier_status]
      if x[:main_name]
        print "\t"+x[:main_name][:organisation_name]
        puts "\t"+x[:main_name][:score]
      else
        if x[:business_name]
          print "\t"+x[:business_name][:organisation_name]
          puts "\t"+x[:business_name][:score]
        else
          if x[:main_trading_name]
            print "\t"+x[:main_trading_name][:organisation_name]
            puts "\t"+x[:main_trading_name][:score]
          else
            print "\t"+x[:other_trading_name][:organisation_name]
            puts "\t"+x[:other_trading_name][:score]
          end
        end
      end
    else
     pp "What? No ABN"
    end
  end
# puts "Main Trading Name: #{result[:main_trading_name][:organisation_name]}"
# puts "ABN Number: #{result[:abn][:identifier_value]}"
# puts "Entity Status: #{result[:entity_status][:entity_status_code]}"
# puts "ASIC Number: #{result[:asic_number]}"
# puts "Entity Description: #{result[:entity_description]}"

# http://www.webservicex.net/uszip.asmx?WSDL
