require_relative "test_helper.rb"

describe Timeline do

  let(:t) {Timeline.new}
  let(:p1) {Period.new("P1")}
  let(:p2) {Period.new("P2")}
  let(:p3) {Period.new("P3")}
  let(:p4) {Period.new("P4")}

  it "begins empty" do
    t.earliest.must_be_nil
    t.latest.must_be_nil
    t.count.must_equal 0
  end

  it "returns nil for bad access" do
    t.first.must_be_nil
    t.last.must_be_nil
    t[0].must_be_nil
  end

  it "handles insertion" do
    t.insert(p1)
    t.earliest.must_equal p1
    t.latest.must_equal p1
  end

  it "handles multiple instertions" do
    t.insert_earliest(p1)
    t.insert_latest(p2)
    t.earliest.must_equal p1
    t.latest.must_equal p2
  end

  it "handles array access" do
    t.insert p1
    t.insert p2
    t.insert p3
    t[0].must_equal p1
    t[1].must_equal p2
    t[2].must_equal p3
  end

  it "handles last" do
    t.insert p1
    t.insert p2
    t.insert p3
    t.last.must_equal p3
  end

  it "handles multiple instertions at the beginning" do
    t.insert_earliest(p1)
    t.insert_earliest(p2)
    t.earliest.must_equal p2
    t.latest.must_equal p1
  end

  it "handles instertions after something" do
    t.insert(p1)
    t.insert_before(p1, p2)
    t.earliest.must_equal p2
    t.latest.must_equal p1
  end
  
  it "handles instertions after something" do
    t.insert_earliest(p1)
    t.insert_earliest(p2)
    t.insert_after(p2, p3)
    t.earliest.must_equal p2
    t.latest.must_equal p1
    t.count.must_equal 3
  end

  describe "Provenance Records" do
     before do
        t.insert(p1)
        t.insert(p2)
      end
      it "generates a record" do
        t.provenance.must_be_instance_of String
      end
      it "connects transfers with periods" do
        t.provenance.must_equal "#{p1.provenance}. #{p2.provenance}."
      end
      it "connects several direct transfers with semicolons" do
        t.insert_direct(p3)
        t.provenance.must_equal "#{p1.provenance}. #{p2.provenance}; #{p3.provenance}."
      end
      it "handles linking footnotes to elements" do
        p1.note = "note 1"
        p2.note = "note 2"
        t.provenance.must_include " 1. note 1"
        t.provenance.must_include " 2. note 2"
      end

      it "handles earliest dates" do
        p1.beginning = Date.new(2000,10,17)
        t.provenance.must_include p1.beginning.to_s
      end
  end

  describe "Meeting" do
  
    it "does not assume meetings" do
      p1.direct_transfer.must_be_nil
    end

    it "defaults to false" do
      t.insert(p1)
      t.insert(p2)
      p1.direct_transfer.must_equal false
    end

    it "will not allow a transfer to nothing" do
      t.insert(p1)
      t.insert(p2)
      p2.direct_transfer = true
      p2.direct_transfer.must_be_nil    
    end

    it "allows explicit meetings" do
      t.insert(p1)
      t.insert(p2)
      p1.direct_transfer = true
      p1.direct_transfer.must_equal true
      p2.was_directly_transferred.must_equal true
    end

    it "does not carry over with new assignments" do
      t.insert(p1)
      t.insert(p2)
      p1.direct_transfer = true
      t.insert_after(p1,p3)
      p1.direct_transfer.must_equal false
      p2.was_directly_transferred.must_equal false
    end

    it "does not carry over when the met party changes" do
      t.insert(p1)
      t.insert(p2)
      p1.direct_transfer = true
      t.insert_before(p2,p3)
      p1.direct_transfer.must_equal false
      p2.was_directly_transferred.must_equal false
    end

    it "allows explicit insertion" do
      t.insert(p1)
      t.insert_directly_after(p1,p2)
      p1.direct_transfer.must_equal true
      p2.was_directly_transferred.must_equal true
    end

    it "allows shortcut explicit insertion" do
      t.insert_direct(p1)
      p1.direct_transfer.must_be_nil
      t.insert_direct(p2)
      p1.direct_transfer.must_equal true
      t.insert_after(p1,p3)
      p1.direct_transfer.must_equal false
    end
  end

  describe "Linking" do
      before do
        t.insert(p1)
      end
      it "links to previous and next objects" do
        t.insert_before(p1,p2)
        assert_equal p1, p2.next_period 
        assert_equal p2, p1.previous_period 
      end
      it "does not let things precede themselves" do
        p1.is_before?(p1).must_equal false
        p1.is_after?(p1).must_equal false
      end
      it "doesn't assume is_before" do
        p1.is_before?(p3).must_equal false
        p1.is_after?(p3).must_equal false
      end
      it "handles single is_before?" do
          t.insert_before(p1,p2)
          p2.is_before?(p1).must_equal true
          p1.is_after?(p2).must_equal true
      end
      it "follows forward links " do
        t.insert_before(p1,p2)
        t.insert_before(p2,p3)
        p3.is_before?(p1).must_equal true    
        p1.is_after?(p3).must_equal true    
      end
      it "has no default siblings" do
        assert_equal p1.siblings.size, 1
        assert_includes p1.siblings, p1
      end
      it "gathers siblings" do
        t.insert_before(p1,p2)
        t.insert_before(p2,p3)
        t.insert_after(p2,p4)
        assert_equal p1.siblings.size, 4
        assert_includes p1.siblings, p4
      end
      it "orders siblings" do
        t.insert_before(p1,p2)
        t.insert_before(p2,p3)
        t.insert_after(p1,p4)
        assert_equal p1.siblings.first, p3
        assert_equal p1.siblings.last, p4
      end
    end
  end