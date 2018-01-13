require_relative "test_helper.rb"

describe AcquisitionMethod do
  
  let(:opts1) {
    {
      id:                 :acquisition,
      title:              "name", 
      prefix:             "prefix", 
      suffix:             "suffix",
      description:        "definition",
      explanation:        "This is the default method for acquisitions and is the base type for all acquisitions.It should be used if there are no additional details available.  If there is not an explicit acquisition method mentioned, this will be assumed.",
      preferred_form:     AcquisitionMethod::Prefix, 
      synonyms:           ["alternate"],
    } 
  }
  let(:opts2) {
    {
      id:                 :acquisition,
      title:              "name", 
      prefix:             "prefix", 
      suffix:             "suffix",
      description:        "definition",
      explanation:        "This is the default method for acquisitions and is the base type for all acquisitions.It should be used if there are no additional details available.  If there is not an explicit acquisition method mentioned, this will be assumed.",
      preferred_form:     AcquisitionMethod::Suffix, 
      synonyms:           ["alternate", "other_alternate"],
    } 
  }
 
  let(:m1) {AcquisitionMethod.new opts1}
  let(:m2) {AcquisitionMethod.new opts2}

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
    it "uses the default when there's nothing there" do
      method = AcquisitionMethod.find("David Newbury [1995,200].")
      method.must_equal AcquisitionMethod.find_by_id(:acquisition)
    end

    it "finds standard acquisition methods" do
      method = AcquisitionMethod.find("Purchased by David Newbury [1995,200].")
      method.must_be_instance_of AcquisitionMethod
      method.must_equal AcquisitionMethod.find_by_id(:sale)
    end
  end
  describe "Name Find" do
    it "does not find when there's nothing there" do
      method = AcquisitionMethod.find_by_name("Regurgitated")
      method.must_be_nil

    end
    it "finds standard acquisition methods" do
      method = AcquisitionMethod.find_by_name("On Loan")
      method.must_be_instance_of AcquisitionMethod
      method.must_equal AcquisitionMethod.find_by_id(:on_loan)
    end
  end
end