require "edtf"
module MuseumProvenance
  module Transformers
    class DateTransform < Parslet::Transform
     
      rule(:begin => subtree(:x)) { {botb: x, eotb: x}}
      rule(:end => subtree(:x)) { {bote: x, eote: x}}
      rule(:nodate => simple(:x)) {nil}

      rule(:date => subtree(:x)) do |dictionary|
        obj = regularize(dictionary[:x])
        date = to_edtf_date(obj)

        {
          edtf: date.edtf,
          earliest: earliest(date),
          latest: latest(date),
          certainty: obj[:certainty],
          string: formatted_string(date, obj[:certainty])
        }
        
      end

    class << self

      def earliest(d)
        EDTF.parse(d.to_s)
      end

      def latest(d)
        new_d = d.clone
        if new_d.unspecified.year[2]
          new_d = new_d.advance(:years =>99)
          new_d.year_precision!
        elsif new_d.unspecified.year[3]
          new_d = new_d.advance(:years =>9)
          new_d.year_precision!
        elsif new_d.unspecified? :day
         new_d.month_precision!
         if new_d.unspecified? :month
           new_d.year_precision!
         end
        end
        new_d = new_d.succ
        new_d.day_precision!
        new_d - 1
      end
      
       def formatted_string(date, certain = false)
        str = ""
        if !date.unspecified? :day
          str = date.strftime("%B%e, ")
          if date.year >=1
            year_str = date.year.to_s
            year_str += " CE" if date.year < 1000
          elsif year == 0
            year_str = "1 BCE"
          else
            year_str = "#{-year} BCE"
          end
          str += year_str

        elsif !date.unspecified? :month
          str = date.strftime("%B ")
          if date.year >=1
            year_str = date.year.to_s
            year_str += " CE" if date.  year < 1000
          elsif year == 0
            year_str = "1 BCE"
          else
            year_str = "#{-year} BCE"
          end
          str += year_str

        elsif !date.unspecified? :year
          if date.year >=1
            str = date.year.to_s
            str += " CE" if date.year < 1000
          elsif date.year == 0
            str = "1 BCE"
          else
            str = "#{-year} BCE"
          end
         elsif !date.unspecified.year[2]
           str = "the #{date.year}s"
         else
           bce = false
           year = (date.year/100+1)
           if year <= 0
             year = -(year-2)
             bce = true
           end  
           str = "the #{year.ordinalize} century"
           str += " CE" if year >= 1 && year < 10 && !bce
           str += " BCE" if bce
           str
         end
         str += "?" unless certain
         str
       end

       def to_edtf_date(d)
        
        if d[:day]
          date = Date.new(d[:year],d[:month],d[:day])
          date.day_precision!
          date.uncertain! unless  d[:certainty]      
        elsif(d[:month])
          date = Date.new(d[:year],d[:month])
          date.unspecified! :day
          date.uncertain! unless  d[:certainty]      

        elsif(d[:year])
          date = Date.new(d[:year])
          date.unspecified! :month
          date.unspecified! :day
          date.uncertain! unless  d[:certainty]      
        elsif(d[:decade])
          date = Date.new(d[:decade])
          date.unspecified.year[3]= true 
          date.unspecified! :month
          date.unspecified! :day

        elsif(d[:century])
          date = Date.new(d[:century] * 100)
          date.unspecified.year[3]= true 
          date.unspecified.year[2]= true
          date.unspecified! :month
          date.unspecified! :day 
        end  
        date
       end


      def regularize(date_obj)
        date_obj = regularize_era(date_obj)
        date_obj = regularize_century(date_obj)
        date_obj = regularize_decade(date_obj)
        date_obj = regularize_year(date_obj)
        date_obj = regularize_month(date_obj)
        date_obj = regularize_day(date_obj)
        date_obj
      end



        private

        def regularize_era(date_obj)
          if date_obj[:era].to_s[0] && date_obj[:era].to_s[0].downcase == "b" 
            date_obj[:era] = "BCE"
          else
            date_obj[:era] = "CE"
          end
          date_obj
        end

        def regularize_century(date_obj)
          return date_obj if date_obj[:century].is_a? Integer
          if date_obj[:century]
            date_obj[:century] = date_obj[:century].to_i - 1
            if date_obj[:era] == "BCE" 
              date_obj[:century] = -date_obj[:century]
            end
          else
            date_obj[:century] = nil
          end
          date_obj
        end

        def regularize_decade(date_obj)
          return date_obj if date_obj[:decade].is_a? Integer

          if date_obj[:decade]
            date_obj[:decade] = date_obj[:decade].to_i
            if date_obj[:era] == "BCE" 
              date_obj[:decade] = -date_obj[:decade]
            end
          else
            date_obj[:decade] = nil
          end
          date_obj
        end

        def regularize_year(date_obj)
          return date_obj if date_obj[:year].is_a? Integer

          if date_obj[:year]
            date_obj[:year] = date_obj[:year].to_i
            if date_obj[:era] == "BCE" 
              date_obj[:year] = -date_obj[:year]
            end
          else
            date_obj[:year] = nil
          end
          date_obj
        end

        def regularize_day(date_obj)
          return date_obj if date_obj[:day].is_a? Integer
          if date_obj[:day]
            date_obj[:day] = date_obj[:day].to_i
          else
            date_obj[:day] = nil
          end
          date_obj
        end

        def regularize_month(date_obj)
          return date_obj if date_obj[:month].is_a? Integer

          if date_obj[:month]
            month = date_obj[:month].to_i
            if month == 0
              month = case date_obj[:month].to_s[0...3].downcase
                when "jan" then 1
                when "feb" then 2 
                when "mar" then 3
                when "apr" then 4
                when "may" then 5
                when "jun" then 6
                when "jul" then 7
                when "aug" then 8
                when "sep" then 9
                when "oct" then 10
                when "nov" then 11
                when "dec" then 12             
              end
            end
            date_obj[:month] = month
          else
            date_obj[:month] = nil
          end

          return date_obj 
        end
      end
    end
  end
end