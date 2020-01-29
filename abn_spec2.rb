require 'stringio'
require_relative 'abnClass' 

describe ABN do

	context 'with input equal to an 11-digit number' do
		it 'asks for input only once' do
		output = ask_for_abn_input("97000098162")
 		expect(output).to eq "\nEnter the ABN or Name you are searching for: "
		end
	end
 
	context 'with no input' do
		it 'asks repeatedly, until an entry is provided' do
			output = ask_for_abn_input('','Time')
 		expect(output).to eq "\nEnter the ABN or Name you are searching for: Invalid. Try again: Enter the ABN or Name you are searching for: "
		end
	end
 
	context 'with entry of anything other than an 11 digit number' do
		it "knows that its a 'name' search if an 11 digit number is not entered" do
			companyX = ABN.new
			output = ask_for_abn_input('222222')
			expect(companyX.rec_count).not_to be '0'
		 end
	end 

 
  def ask_for_abn_input(*input_string)
    input = StringIO.new(input_string.join("\n") + "\n")
    output = StringIO.new
     example = ABN.new(input: input, output: output)
    expect(example.get_search_string).to be true
    output.string
  end
end