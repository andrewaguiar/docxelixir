defmodule Docxelixir do
  @moduledoc """
  Reads paragraphs and tables from a docx document
  """

  @doc """
  Reads all paragraphs from a given docx file
  """
  @spec read_paragraphs(String.t) :: [String.t] | {:error, atom}
  def read_paragraphs(file) do
    case read(file) do
      {:ok, doc} ->
        doc
        |> extract_paragraphs
        |> extract_paragraphs_texts
        |> extract_paragraphs_texts_nodes
      error ->
        error
    end
  end

  defp extract_paragraphs({xml_elements, _}) do
    :xmerl_xpath.string('//w:document//w:body//w:p', xml_elements)
  end

  defp extract_paragraphs_texts(paragraphs) do
    Enum.map(paragraphs, fn paragraph ->
      :xmerl_xpath.string('w:r//text()|w:hyperlink/w:r//text()', paragraph)
    end)
  end

  defp extract_paragraphs_texts_nodes(text_nodes) do
    Enum.map(text_nodes, &extract_text_node_values/1)
  end

  defp extract_text_node_values(text_nodes) do
    text_nodes
    |> Enum.map(&extract_text_content/1)
    |> Enum.join
  end

  defp extract_text_content({:xmlText, _, _, _, text, :text}), do: to_string(text)

  defp read(file) do
    case :zip.unzip(file, [:memory]) do
      {:ok, inner_files} ->
        doc = inner_files
        |> Enum.find(fn {name, _} -> name == 'word/document.xml' end)
        |> case do {'word/document.xml', doc} -> doc end
        |> :binary.bin_to_list
        |> :xmerl_scan.string

        {:ok, doc}
      error ->
        error
    end
  end
end
