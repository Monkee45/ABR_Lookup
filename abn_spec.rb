require_relative 'abnClass'

describe ABN do

  it "starts with a value of zero (0)" do
    companyX = ABN.new
    expect(companyX.value).to eq(0)
  end

  it "accepts a value to initialize its parameter" do
    companyX = ABN.new(50)
    expect(companyX.value).to eq(50)
  end


  it "sets the abn value if the user inputs an 11 digit number " do
    original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    companyX = ABN.new
    allow(companyX).to receive(:gets).and_return("97000098162\n")
    status = companyX.load_search
    expect(companyX.value).to eq("97000098162")
    $stdout = original_stdout
  end

  it "knows that its a 'name' search if an 11 digit number is not entered" do
    original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    companyX = ABN.new
    allow(companyX).to receive(:gets).and_return("222222\n", "q\n")
    status = companyX.load_search
#    expect(companyX.value).to eq(0)
    expect(companyX.search_type).to eq("Name")
    $stdout = original_stdout
  end

  it "web service returns an Hash" do
    original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    companyX = ABN.new
    allow(companyX).to receive(:gets).and_return("97000098162\n", "q\n")
    status = companyX.load_search
    abn_details = companyX.search_abr
    expect(abn_details).to be_a(Hash)
    $stdout = original_stdout
  end

end
