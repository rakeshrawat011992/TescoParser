require "test_helper"

class TescoParserTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TescoParser::VERSION
  end


  def test_is_previous_line_total
    parserobj = TescoParser::TescoParsercls
    assert_equal(true, parserobj.isReducedPrice("REDUCED PRICE") && parserobj.isReducedPrice("REDUCED") && parserobj.isReducedPrice("PRICE"))
  end

  def test_is_previous_line_total_negate
    parserobj = TescoParser::TescoParsercls
    assert_equal(false, parserobj.isReducedPrice("red rice"))
  end

  def test_is_card_cash_sale
    parserobj = TescoParser::TescoParsercls
    assert_equal(true, parserobj.isCardOrCashSale("VISA TRAVEL SALE") && parserobj.isCardOrCashSale("CASH") && parserobj.isCardOrCashSale("CHANGE DUE") &&
        parserobj.isCardOrCashSale("SALE"))
  end

  def test_is_card_cash_sale_negate
    parserobj = TescoParser::TescoParsercls
    assert_equal(false, parserobj.isCardOrCashSale("VSA RAVEL ALE") && parserobj.isCardOrCashSale("CoSH") && parserobj.isCardOrCashSale("CANGE UE") &&
        parserobj.isCardOrCashSale("SAEL"))
  end

  def test_is_line_a_price
    parserobj = TescoParser::TescoParsercls
    assert_equal(true, parserobj.isLineAPrice("EUR0.29") && parserobj.isLineAPrice("EUR1,32"))
  end

  def test_is_line_a_price_negate
    parserobj = TescoParser::TescoParsercls
    assert_equal(false, parserobj.isLineAPrice("0.29") || parserobj.isLineAPrice("EOR1.32"))
  end

  def test_is_text_a_keyword
    parserobj = TescoParser::TescoParsercls
    assert_equal(true, parserobj.isAKeyWord("y") || parserobj.isAKeyWord("O.32 VAT") || parserobj.isAKeyWord("EURO") || parserobj.isAKeyWord("Total") ||
        parserobj.isAKeyWord("Debit") || parserobj.isAKeyWord("Total Discount"))
  end

  def test_is_text_a_keyword_negate
    parserobj = TescoParser::TescoParsercls
    assert_equal(false, parserobj.isAKeyWord("yo") || parserobj.isAKeyWord("O.32VAr") || parserobj.isAKeyWord("erRO") || parserobj.isAKeyWord("Totel") ||
        parserobj.isAKeyWord("Debut") || parserobj.isAKeyWord("Totel Dissscount"))
  end


end
