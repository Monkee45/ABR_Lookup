require_relative 'abnClass'

begin
  myabn = ABN.new

  status = myabn.get_search_string

  abn_details = myabn.submit_search_request

  if (myabn.value =~ /^\d{11}$/) || (myabn.rec_count == '1')
    myabn.display_single_result(abn_details)
  else
    myabn.display_multi_result(abn_details)
  end

rescue Errno::ETIMEDOUT
	puts "Network timed out connecting to ABR"
rescue
  puts "Either there was rubbish entered or something went wrong"
end
