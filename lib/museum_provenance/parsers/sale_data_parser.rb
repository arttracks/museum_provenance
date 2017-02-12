require_relative "parser_helpers"

module MuseumProvenance
  module Parsers
      # 
      # This parser will parse a standard sale info block, for example:
      # > (Stock no. 1, for $100)
      # 
      # If it parses, it can return:
      #
      # * :stock_number           # The text of the stock number phrase
      # * :sale_amount            # A text representation of the sale amount
      # * :sale_currency_symbol   # A symbol for the currency
      # * :sale_value             # A numeric value for the sale amount
      #
      # Note that it may return the sale_amount OR the 
      # sale_value/sale_currency_symbol, never both.
      # @author [davidnewbury]
      # 
    class SaleDataParser < Parslet::Parser

      include ParserHelpers
      include Parslet
      root(:sale_clause)

      rule(:currency_value)  { 
                               (currency_symbol.as(:currency_symbol) >> space? >> numeric.as(:value)) | 
                               (numeric.as(:value) >> space? >> currency_symbol.as(:currency_symbol))
                             }
      rule(:currency_phrase) {currency_value | texts.as(:string)}
      rule(:stock_number)    {str("for").absent? >> texts.as(:stock_number) >> comma.maybe}
      rule(:sale_amount)     {str("for") >> space >> currency_phrase.as(:purchase)}
      rule(:sale_clause)     {(space | comma).maybe >> lparen >> stock_number.maybe >> sale_amount.maybe >> rparen}

    end
  end
end