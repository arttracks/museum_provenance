require_relative "test_helper.rb"
describe Party do
  let(:p) {Party.new("Roberta")}
  it "accepts a birth year" do
    p.birth = Date.new(1990)
    p.birth.must_equal Date.new(1990)
  end
  it "accepts a birth year" do
    p.death = Date.new(1990)
    p.death.must_equal Date.new(1990)
  end
  it "generates proper strings for birth and death" do
    p.birth = Date.new(1980)
    p.death = Date.new(1990)
    p.name_with_birth_death.must_equal "Roberta [1980-1990]"
  end
  it "generates proper strings without birth and death" do
    p.name_with_birth_death.must_equal "Roberta"
  end
  it "generates proper strings with death" do
    p.death = Date.new(1990)
    p.name_with_birth_death.must_equal "Roberta [-1990]"
  end
  it "generates proper strings with birth" do
    p.birth = Date.new(1980)
    p.name_with_birth_death.must_equal "Roberta [1980-]"
  end

end