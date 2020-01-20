require "savon"
# The ABN for Energy Australia = 99 086 014 968
# This is based on new Branch work
# Just updating this one line
class ABN
	attr_reader :value
	attr_reader :search_type

	def initialize(val=0, type="Number")
		@value = val
		@search_type = type
	end

	def load_search
			print "\nEnter the ABN you are searching for ('q' to exit): "
			@value = gets.chomp
			if @value =~ /^\d{11}$/
				@search_type = "Number"
			else
				@search_type = "Name"
			end
	end

	def search_abr
		guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"
		client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

		if @search_type == "Number"
			puts "Search By ABN"
			response = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: @value, includeHistoricalDetails: "N" })
			response.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
		else
			puts "Search by Name"
			response = client.call(:abr_search_by_name_simple_protocol, message: { name: @value, authenticationGuid: guid })
			response.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list]
		end

	end

	def output_abn_search (abn_result)
		if abn_result[:entity_type][:entity_type_code] == 'IND'
			print "Legal Name: "
			puts abn_result[:legal_name][:family_name]
		else
			puts "Registered Name: #{abn_result[:main_name][:organisation_name]}"
			puts "Main Trading Name: #{abn_result[:main_trading_name][:organisation_name]}"
			puts "ABN Number: #{abn_result[:abn][:identifier_value]}"
			puts "Entity Status: #{abn_result[:entity_status][:entity_status_code]}"
			puts "ASIC Number: #{abn_result[:asic_number]}"
			puts "Entity Description: #{abn_result[:entity_description]}"
		end
	end

	def output_name_search (abn_result)
		abn_result[:search_results_record].each do |x|
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
							if x[:other_trading_name]
              	print "\t"+x[:other_trading_name][:organisation_name]
              	puts "\t"+x[:other_trading_name][:score]
							else
								puts x[:legal_name][:full_name]
							end
            end
          end
        end
    	end
  	end
	end

end
