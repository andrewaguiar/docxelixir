defmodule DocxelixirTest do
  use ExUnit.Case
  doctest Docxelixir

  test "reads all paragraphs" do
    result = Docxelixir.read_paragraphs('samples/demo.docx')

    assert result == [
      "Demonstration of DOCX support in calibre",
      "This document demonstrates the ability of the calibre DOCX Input plugin to convert the various typographic features in a Microsoft Word (2007 and newer) document. Convert this document to a modern ebook format, such as AZW3 for Kindles or EPUB for other ebook readers, to see it in action.",
      "There is support for images, tables, lists, footnotes, endnotes, links, dropcaps and various types of text and paragraph level formatting.",
      "To see the DOCX conversion in action, simply add this file to calibre using the “Add Books” button and then click “Convert”.  Set the output format in the top right corner of the conversion dialog to EPUB or AZW3 and click “OK”."
    ]
  end
end
