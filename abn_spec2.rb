require_relative 'abnClass'

describe ABN do

  it "sets the abn value if the user inputs an 11 digit number " do
    companyX = ABN.new
#   allow_any_instance_of(companyX).to receive(:gets).and_return("97000098162\n")
    allow(companyX).to receive(:gets).and_return("97000098162\n")
    status = companyX.load_search
    expect(companyX.value).to eq("97000098162")

  end

end
