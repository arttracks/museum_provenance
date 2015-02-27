require_relative "test_helper.rb"

def check(pattern,result)
  string = "John Doe, Paris, France, "

  part_a, part_b = pattern.split("...")
  botb,eotb = part_a.split("-")
  bote,eote = part_b.split("-")


  botb = case botb
      when "?" then nil
      when "X" then @x
      when "Y" then @y
      when "Z" then @z
      when "A" then @a
  end

  bote = case bote
      when "?" then nil
      when "X" then @x
      when "Y" then @y
      when "Z" then @z
      when "A" then @a
  end

  eotb = case eotb
      when "?" then nil
      when "X" then @x
      when "Y" then @y
      when "Z" then @z
      when "A" then @a
  end

  eote = case eote
      when "?" then nil
      when "X" then @x
      when "Y" then @y
      when "Z" then @z
      when "A" then @a
  end

  it "handles #{pattern} for '#{result}'" do
    p.parse_time_string string + result
    if p.beginning
      if p.beginning.earliest_raw
        p.beginning.earliest_raw.smart_to_s(:long).must_equal botb
      else 
        botb.must_be_nil
      end
      if p.beginning.latest_raw
        p.beginning.latest_raw.smart_to_s(:long).must_equal eotb
      else
        eotb.must_be_nil
      end
    else 
      botb.must_be_nil
      eotb.must_be_nil
    end
   if p.ending
      if p.ending.earliest_raw
        p.ending.earliest_raw.smart_to_s(:long).must_equal bote
      else
        bote.must_be_nil
      end
      if p.ending.latest_raw
        p.ending.latest_raw.smart_to_s(:long).must_equal eote
      else
        eote.must_be_nil
      end
   else
    eote.must_be_nil
    bote.must_be_nil
   end
   p.time_string.must_equal result 
  end
end

describe "Specific date checks" do

  let(:p) {Period.new("Date Test Period")}

  # x_dates = ["the 18th century", "the 1700s", "1707", "June 1709", "June 1, 1707"]
  # y_dates = ["the 19th century", "the 1800s", "1807", "June 1807", "June 1, 1807"]
  # z_dates = ["the 20th century", "the 1900s", "1907", "June 1907", "June 1, 1907"]
  # a_dates = ["the 21st century", "the 2000s", "2007", "June 2007", "June 1, 2007"]

  x_dates = ["June 1, 1707"]
  y_dates = ["June 1, 1807"]
  z_dates = ["June 1, 1907"]
  a_dates = ["June 1, 2007"]


  #check "?-?...?-?", ""
  x_dates.each do |x|
    @y,@z,@a = nil
    @x = x
   
    check "X-?...?-?", "after #{x}"
    check "?-X...?-?", "by #{x}"
    check "?-?...X-?", "until at least #{x}"
    check "?-?...?-X", "until sometime before #{x}"
    check "X-X...?-?", "#{x}"
    check "?-?...X-X", "until #{x}"
    check "X-X...X-X", "on #{x}"


    # check "?-X...X-?", "in #{x}"// OR on july 1, 1995 (if known to the day)
    y_dates.each do |y|
      @z,@a = nil
      @y = y

      check "X-Y...?-?", "sometime between #{x} and #{y}"
      check "X-?...Y-?", "after #{x} until at least #{y}"
      check "X-?...?-Y", "after #{x} until sometime before #{y}"
      check "?-X...Y-?", "by #{x} until at least #{y}"
      check "?-X...?-Y", "by #{x} until sometime before #{y}"
      check "?-?...X-Y", "until sometime between #{x} and #{y}"
      check "X-X...Y-?", "#{x} until at least #{y}"
      # check "X-Y...Y-?", "sometime between 1995 and 1996 until at least 1996 (after 1995, in 1996)?"
      check "X-X...?-Y", "#{x} until sometime before #{y}"
      check "?-X...Y-Y", "by #{x} until #{y}"
      check "?-X...X-Y", "in #{x} until sometime before #{y}"
      check "X-?...Y-Y", "after #{x} until #{y}"
      check "X-X...Y-Y", "#{x} until #{y}"

      z_dates.each do |z|
        @a = nil
        @z = z
        check "X-Y...Z-?", "sometime between #{x} and #{y} until at least #{z}"
        check "X-Y...?-Z", "sometime between #{x} and #{y} until sometime before #{z}"
        check "?-X...Y-Z", "by #{x} until sometime between #{y} and #{z}"
        check "X-?...Y-Z", "after #{x} until sometime between #{y} and #{z}"
        check "X-X...Y-Z", "#{x} until sometime between #{y} and #{z}"
        check "X-Y...Z-Z", "sometime between #{x} and #{y} until #{z}"

        a_dates.each do |a|
          @a = a
          check "X-Y...Z-A", "sometime between #{x} and #{y} until sometime between #{z} and #{a}"
        end
      end
    end
  end

end