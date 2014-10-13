require_relative "test_helper.rb"
describe TimeSpan do
  let(:y) {Date.new(2014)}
  let(:m) {Date.new(2014,10)}
  let(:d) {Date.new(2014,10,17)}

  it "handles equality tests" do
    y.==(y).must_equal true
    y.  ==(m).wont_equal true
  end

  it "is nil by default" do
    t1 = TimeSpan.new
    t1.must_be_nil
  end

  it "is not nil if it has a beginning" do
    t1 = TimeSpan.new(y)
    t1.wont_be_nil
  end
  it "is not nil if it has a ending" do
    t1 = TimeSpan.new(nil,y)
    t1.wont_be_nil
  end

  it "initializes properly without dates" do
    t1 = TimeSpan.new
    t1.earliest.must_be_nil 
    t1.latest.must_be_nil
    t1.to_s.must_be_nil
    t1.defined?.must_equal false
    t1.same?.must_equal false
    t1.precise?.must_equal false
  end

  it "initializes with a single date" do
    t1 = TimeSpan.new(y)
    t1.earliest.must_equal y.earliest
    t1.latest.must_be_nil
    t1.defined?.must_equal true
    t1.same?.must_equal false
    t1.precise?.must_equal false
  end
  it "initializes with only an end date" do
    t1 = TimeSpan.new(nil,y)
    t1.earliest.must_be_nil
    t1.latest.must_equal y.latest
    t1.defined?.must_equal true
    t1.same?.must_equal false
    t1.precise?.must_equal false
  end
  it "initializes with two dates" do
    t1 = TimeSpan.new(y,m)
    t1.earliest.must_equal y.earliest
    t1.latest.must_equal m.latest
    t1.defined?.must_equal true
    t1.same?.must_equal false
    t1.precise?.must_equal false
  end

  it "initializes reorders dates" do
    t1 = TimeSpan.new(m,y)
    t1.earliest.must_equal y.earliest
    t1.latest.must_equal m.latest
  end

  it "provides access to raw dates" do
    t1 = TimeSpan.new(y,m)
    t1.earliest_raw.must_equal y
    t1.earliest_raw.precision.must_equal y.precision
    t1.latest_raw.must_equal m
    t1.latest_raw.precision.must_equal m.precision
  end

  it "initializes with two identical vague dates" do
    t1 = TimeSpan.new(y,y)
    t1.same?.must_equal true
    t1.precise?.must_equal false
  end

  it "initializes with two identical precise dates" do
    t1 = TimeSpan.new(d,d)
    t1.same?.must_equal true
    t1.precise?.must_equal true
  end

  it "reports well with a beginning date" do
    t1 = TimeSpan.new(y)
    t1.to_s.must_equal "after #{y.year}"
  end
  it "reports well with an uncertain beginning date" do
    y.certain = false
    t1 = TimeSpan.new(y)
    t1.to_s.must_equal "after 2014?"
  end
  
  it "reports well with a end date" do
    t1 = TimeSpan.new(nil,y)
    t1.to_s.must_equal "by #{y.year}"
    t2 = TimeSpan.new(nil,m)
    t2.to_s.must_equal "by October 2014"
    t2 = TimeSpan.new(nil,d)
    t2.to_s.must_equal "by October 17, 2014"
  end
  it "reports well with a precise date" do
    t1 = TimeSpan.new(d,d)
    t1.to_s.must_equal d.to_s(:long)
  end
  it "reports well with a precise uncertain date" do
    d.certain = false
    t1 = TimeSpan.new(d,d)
    t1.to_s.must_equal "October 17, 2014?"
  end
  it "reports well with a vague date" do
    t1 = TimeSpan.new(y,m)
    t1.to_s.must_equal "between 2014 and October 2014"
  end
  describe "Parsing" do
     it "can take a date as a beginning" do
      t = TimeSpan.parse Date.new(2014)
      t.must_be_instance_of TimeSpan
      t.earliest.must_equal Date.new(2014,1,1)
      t.latest.must_equal Date.new(2014,12,31)
    end
    it "can take a TimeSpan as a beginning" do
      t = TimeSpan.parse TimeSpan.new(Date.new(2013),Date.new(2014))
      t.must_be_instance_of TimeSpan
      t.earliest.must_equal Date.new(2013,1,1)
      t.latest.must_equal Date.new(2014,12,31)
    end
    it "can take a number as a beginning" do
      date_as_epoch = Date.new(2014,10,17).to_time.utc.to_i
      t = TimeSpan.parse date_as_epoch
      t.must_be_instance_of TimeSpan
      t.earliest.must_equal Date.new(2014,10,17)
    end
    it "can take a string as a beginning" do
      t = TimeSpan.parse "October 17, 2014"
      t.must_be_instance_of TimeSpan
      t.earliest.must_equal Date.new(2014,10,17)
    end
    it "throws invalid date if it does not recognize the string" do
      proc {t = TimeSpan.parse "Ice cream sandwiches"}.must_raise MuseumProvenance::DateError
    end
  end
end