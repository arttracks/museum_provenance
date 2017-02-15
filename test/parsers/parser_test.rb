require_relative "../test_helper.rb"
describe Parser do  

  def p(obj={})
    paragraph   = obj.fetch(:paragraph, "David Newbury, 1990[1][a].")
    notes       = obj.fetch(:notes, "[1]: Footnote.")
    citations   = obj.fetch(:citations, "[a]: Citation.")
    authorities = obj.fetch(:authorities, "David Newbury:  http://www.davidnewbury.com")

    <<~EOF
      #{paragraph}

      #{"Notes:" if notes}

      #{notes}

      #{"Authorities:" if authorities}

      #{authorities}

      #{"Citations:" if citations}

      #{citations}
    EOF
  end

  it "preserves the original text" do
    results = Parser.new(p)
    results.original.must_equal p
  end

  it "maintains the original text of each period" do
    str = p({paragraph: "David Newbury, 1990. John Doe, 1995."})
    results = Parser.new(str)
    results.first[:text].must_equal "David Newbury, 1990."
    results.last[:text].must_equal "John Doe, 1995."
  end


  it "works without notes" do
    str = p({notes: nil, paragraph: "David Newbury, 1990[a]."})
    results = Parser.new(str)
    results.first[:footnote].must_be_nil
    results.first[:owner][:name][:string].must_equal "David Newbury"
  end

  it "works without citations" do
    str = p({citations: nil, paragraph: "David Newbury, 1990[1]."})
    results = Parser.new(str)
    results.first[:citations].must_be_nil
    results.first[:owner][:name][:string].must_equal "David Newbury"
  end

  it "works without authorities" do
    str = p({authorities: nil, paragraph: "David Newbury, 1990[1][a]."})
    results = Parser.new(str)
    results.first[:owner][:name][:string].must_equal "David Newbury"
    results.first[:owner][:name][:uri].must_be_nil
  end

  it "works with only a paragraph" do
    str = p({authorities: nil, citations: nil, notes: nil, paragraph: "David Newbury, 1990."})
    results = Parser.new(str)
    results.first[:owner][:name][:string].must_equal "David Newbury"
    results.first[:owner][:name][:uri].must_be_nil
    # puts results
  end

  it "allows reuse of authorities" do
    str = p({authorities: nil, paragraph: "David Newbury, 1990[1][a]; David Newbury, 1999."})
    results = Parser.new(str)
    results.first[:owner][:name][:string].must_equal "David Newbury"
    results.last[:owner][:name][:string].must_equal "David Newbury"
  end

  it "replaces tokens in garbage test" do
    str = p({paragraph: "David Newbury; David Newbury ain't nobody, (yo)."})
    results = Parser.new(str)
    results.count.must_equal 2
    results.first[:owner][:name][:string].must_equal "David Newbury"
    results.last[:unparsable].to_s.must_include "David Newbury"
  end

end