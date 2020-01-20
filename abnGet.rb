require_relative 'abnClass'

begin
  myabn = ABN.new(97000098162,"Number")
  puts myabn.search_type

  status = myabn.load_search

  abn_details = myabn.search_abr
  puts "After search_abr:  #{myabn.search_type}"

  if myabn.search_type == 'Number'
    myabn.output_abn_search(abn_details)
  else
    myabn.output_name_search(abn_details)
end

rescue
  puts "Either there was rubbish entered or something went wrong"
end
