require_relative 'abnClass'

begin
  myabn = ABN.new(97000098162,0)

  status = myabn.load_search

  abn_details = myabn.search_abr

  if (myabn.value =~ /^\d{11}$/) || (myabn.rec_count == '1')
    myabn.output_abn_search(abn_details)
  else
    myabn.output_name_search(abn_details)
end

rescue
  puts "Either there was rubbish entered or something went wrong"
end
