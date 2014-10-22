require_relative "test_helper.rb"

describe AcquisitionMethod do

  let(:m1) {AcquisitionMethod.new("name","prefix","suffix","definition",AcquisitionMethod::Prefix, ["alternate"])}
  let(:m2) {AcquisitionMethod.new("name","prefix","suffix","definition",AcquisitionMethod::Suffix, ["alternate", "other_alternate"])}

  it "has a class constant for prefix and suffix" do
    AcquisitionMethod::Prefix.must_be_instance_of Symbol
    AcquisitionMethod::Prefix.must_equal :prefix
    AcquisitionMethod::Suffix.must_be_instance_of Symbol
    AcquisitionMethod::Suffix.must_equal :suffix
  end

  it "can be initialized" do
    m1.name.must_equal "name"
    m1.prefix.must_equal "prefix"
    m1.suffix.must_equal "suffix"
    m1.definition.must_equal "definition"
    m1.forms.must_include "alternate"
  end

  it "is immutable" do
    lambda {m1.name = "new name"}.must_raise NoMethodError
    lambda {m1.prefix = "new prefix"}.must_raise NoMethodError
    lambda {m1.suffix = "new suffix"}.must_raise NoMethodError
    lambda {m1.definition = "new def"}.must_raise NoMethodError
    lambda {m1.synonyms = "new synonym"}.must_raise NoMethodError
  end

  it "lists forms" do
    m1.forms.must_be_kind_of Array
    m1.forms.count.must_equal 3
    m1.forms.must_include "alternate"
    m1.forms.must_include "suffix"
    m1.forms.must_include "prefix"
    m2.forms.count.must_equal 4
    m2.forms.must_include "suffix"
    m2.forms.must_include "alternate"
    m2.forms.must_include "prefix"
    m2.forms.must_include "other_alternate"
  end

  it "lists other forms" do
    m1.other_forms.must_be_kind_of Array
    m1.other_forms.count.must_equal 2
    m1.other_forms.must_include "alternate"
    m1.other_forms.must_include "suffix"
    m2.other_forms.count.must_equal 3
    m2.other_forms.must_include "alternate"
    m2.other_forms.must_include "prefix"
    m2.other_forms.must_include "other_alternate"
  end

  it "prints its name when cast to string" do
    m1.to_s.must_equal m1.name
  end

  it "attaches itself to a name" do
    m1.attach_to_name("Party").must_equal "#{m1.prefix} Party"
    m2.attach_to_name('Party').must_equal "Party #{m1.suffix}"
  end

  describe "Global Find" do
    it "does not find when there's nothing there" do
      method = AcquisitionMethod.find("David Newbury [1995,200].")
      method.must_be_nil

    end
    it "finds standard acquisition methods" do
      method = AcquisitionMethod.find("Sold to David Newbury [1995,200].")
      method.must_be_instance_of AcquisitionMethod
      method.must_equal AcquisitionMethod::SALE
    end
  end
  describe "Name Find" do
    it "does not find when there's nothing there" do
      method = AcquisitionMethod.find_by_name("Regurgitated")
      method.must_be_nil

    end
    it "finds standard acquisition methods" do
      method = AcquisitionMethod.find_by_name("Sale")
      method.must_be_instance_of AcquisitionMethod
      method.must_equal AcquisitionMethod::SALE
    end  end
end