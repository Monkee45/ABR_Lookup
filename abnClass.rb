require "savon"
# The ABN for Energy Australia = 99 086 014 968
# This is based on new Branch work
# Just updating this one line
class ABN
	attr_reader :value
	attr_reader :rec_count

	def initialize(input: $stdin, output: $stdout)
		@input = input
		@output = output
		@value = nil
		@rec_count = 0
	end

	def get_search_string
		@output.print "\nEnter the ABN or Name you are searching for: "
		loop do
			@value = @input.gets.chomp
			return true if not @value.empty? 
			@output.print "Invalid. Try again: Enter the ABN or Name you are searching for: "
		end
	end

	def submit_search_request
		guid = "890b3a4c-7267-4c8f-8c43-825a349a5e87"
		client = Savon.client(wsdl: "http://www.abn.business.gov.au/abrxmlsearch/ABRXMLSearch.asmx?WSDL")

		if @value =~ /^\d{11}$/
			response = client.call(:abr_search_by_abn, message: { authenticationGuid: guid, searchString: @value, includeHistoricalDetails: "N" })
			response.body[:abr_search_by_abn_response][:abr_payload_search_results][:response][:business_entity]
		else
			response = client.call(:abr_search_by_name_simple_protocol, message: { name: @value, authenticationGuid: guid })
			@rec_count = response.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list][:number_of_records]
			response.body[:abr_search_by_name_simple_protocol_response][:abr_payload_search_results][:response][:search_results_list][:search_results_record]

		end

	end

	def display_single_result (abn_result)
		abn_result.each do |key, value|
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
	end

	def display_multi_result (abn_result)
		abn_result.each do |entry|
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
	end

end
