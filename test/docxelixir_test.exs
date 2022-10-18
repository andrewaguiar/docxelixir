defmodule DocxelixirTest do
  use ExUnit.Case
  doctest Docxelixir

  test "reads all paragraphs older word" do
    result = Docxelixir.read_paragraphs('samples/demo.docx')

    assert result == [
             "Demonstration of DOCX support in calibre",
             "This document demonstrates the ability of the calibre DOCX Input plugin to convert the various typographic features in a Microsoft Word (2007 and newer) document. Convert this document to a modern ebook format, such as AZW3 for Kindles or EPUB for other ebook readers, to see it in action.",
             "There is support for images, tables, lists, footnotes, endnotes, links, dropcaps and various types of text and paragraph level formatting.",
             "To see the DOCX conversion in action, simply add this file to calibre using the “Add Books” button and then click “Convert”.  Set the output format in the top right corner of the conversion dialog to EPUB or AZW3 and click “OK”."
           ]
  end

  test "reads all paragraphs newer word" do
    result = Docxelixir.read_paragraphs('samples/demo_newer_word.docx')

    assert result == [
             "Demonstration of DOCX support in calibre",
             "This document demonstrates the ability of the calibre DOCX Input plugin to convert the various typographic features in a Microsoft Word (2007 and newer) document. Convert this document to a modern ebook format, such as AZW3 for Kindles or EPUB for other ebook readers, to see it in action.",
             "There is support for images, tables, lists, footnotes, endnotes, links, dropcaps and various types of text and paragraph level formatting.",
             "To see the DOCX conversion in action, simply add this file to calibre using the button and then click  Set the output format in the top right corner of the conversion dialog to EPUB or AZW3 and click .“Add Books” “Convert”. “OK”"
           ]
  end

  test "fails to read bad docx files" do
    result = Docxelixir.read_paragraphs('samples/bad.docx')

    assert result ==
             {:error, :no_parser_found,
              [%Zstream.Unzip.Error{message: "Unexpected end of input"}]}
  end
end
