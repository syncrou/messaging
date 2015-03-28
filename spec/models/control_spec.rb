require 'yaml'

describe Control do
  it "lists all the available connections" do
    expect(Control.connections).to_not eq []
  end

end
