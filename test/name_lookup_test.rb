require_relative "test_helper.rb"

describe Entity do
  let(:p) {Entity.new("David N.")}
  it "has a name" do
    p.name.must_equal "David N."
  end
  it "is certain by default" do
    p.certain?.must_equal true
  end
  it "allows uncertainty to be set" do
    p.certainty = false
    p.certain?.must_equal false
  end
  it "uses the name as a string" do
    p.to_s.must_equal "David N."
  end
  it "appends certainty to the name" do
    p.certainty = false
    p.to_s.must_equal "David N.?"
  end
  it "does not fail on nils" do
    n = Entity.new(nil)
    n.must_be_instance_of Entity
    n.name.must_be_nil
  end
  it "allows access to the raw name" do
    p.certainty = false
    p.name.must_equal "David N."
  end
  it "automatically determines certainty from strings" do
    p2 = Entity.new("Uncertain name?")
    p2.certain?.must_equal false
  end
  it "strips uncertainty from strings" do
    Entity::CertantyWords.each do |w|
      p2 = Entity.new("#{w} Uncertain name")
      p2.name.must_equal "Uncertain name"
    end
  end

end