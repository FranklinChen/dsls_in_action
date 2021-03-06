## Listing 5.8 Trade DSL in Ruby – Blocks for side-effects  (Iteration #3)

require 'security_trade'
require 'numeric'

class TradeDSL
  class << self
    def const_missing(sym)
      sym.to_s.downcase
    end

    def trade(str)
      yield TradeDSL.new.interpret(str) if block_given?
    end
  end

  def new_trade(ref_no, account, buy_sell, instrument, attributes)
    SecurityTrade.create(ref_no, account, buy_sell, instrument, attributes)
  end

  def interpret(input)
    instance_eval parse(input)
  end

  def parse(dsl_string)
    dsl = dsl_string.clone
    dsl.gsub!(/=/, '=>')
    dsl.sub!(/and /, '')
    dsl.sub!(/at /, '')
    dsl.sub!(/for account /, ',')
    dsl.sub!(/to buy /, ', :buy, ')
    dsl.sub!(/(\d+) shares of ('.*?')/, '\1.shares.of(\2)')
    dsl.sub!(/(\d+) share of ('.*?')/, '\1.shares.of(\2)')
    puts dsl
    dsl
  end
end
