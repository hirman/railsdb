$:.unshift File.join(File.dirname(__FILE__),'../..','lib')

require 'test/unit'
require 'export/dsv_exporter'

class DsvExporterTest < Test::Unit::TestCase
  DELIMITER = ','
  
  def setup
    @exporter = DsvExporter.new(DELIMITER)
    @header = %W{A B C}
    row1 = [1,2,3]
    row2 = [4,5,6]
    row3 = [7,8,9]
    @rows = [row1, row2, row3]
  end
  
  def test_export_empty_table
    assert_equal [], @exporter.export([])
  end
  
  def test_export_with_header
    @exporter.header = @header
    export = @exporter.export(@rows)
    assert_equal @rows.size + 1, export.size
    assert_equal @header.collect { |e| "#{e}" }.join(DELIMITER) , export[0]
    assert_equal @rows[0].collect { |e| "#{e}" }.join(DELIMITER), export[1]
    assert_equal @rows[1].collect { |e| "#{e}" }.join(DELIMITER), export[2]
    assert_equal @rows[2].collect { |e| "#{e}" }.join(DELIMITER), export[3]
  end
  
  def test_export_as_text_with_header
    @exporter.header = @header
    text_export = @exporter.export_as_text(@rows)
    assert_equal(@rows.size + 1, text_export.split($/).size)
    text_tab = text_export.split($/)
    assert_equal @header.collect { |e| "#{e}" }.join(DELIMITER) , text_tab[0]
    assert_equal @rows[0].collect { |e| "#{e}" }.join(DELIMITER), text_tab[1]
    assert_equal @rows[1].collect { |e| "#{e}" }.join(DELIMITER), text_tab[2]
    assert_equal @rows[2].collect { |e| "#{e}" }.join(DELIMITER), text_tab[3]
  end
  
  def test_export_without_header
    export = @exporter.export(@rows)
    assert_equal @rows.size, export.size
    assert_equal @rows[0].collect { |e| "#{e}" }.join(DELIMITER), export[0]
    assert_equal @rows[1].collect { |e| "#{e}" }.join(DELIMITER), export[1]
    assert_equal @rows[2].collect { |e| "#{e}" }.join(DELIMITER), export[2]
  end
  
  def test_quotes_values
    value_with_quote = 'val"ue'
    export = @exporter.export_as_text([[value_with_quote]])
    assert_equal(4, export.count('"'), "Should have 2 quotation marks.")   
  end
  
  def test_value_with_delimiter
    value_with_delimiter = "one" + DELIMITER + "two"
    export = @exporter.export_as_text([[value_with_delimiter]])
    assert_equal(2, export.count('"'), "Should have 2 quotation marks.") 
  end
  
  def test_empty_value
    empty_value = ''
    export = @exporter.export_as_text([[empty_value]])
    assert_equal(2, export.count('"'), "Should have 2 quotation marks.")
  end
  
  def test_nil_value
    nil_value = nil
    export = @exporter.export_as_text([[nil_value]])
    assert_equal(2, export.count('"'), "Should have 2 quotation marks.")    
  end
end
