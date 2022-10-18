defmodule Docxelixir do
  @moduledoc """
  Reads paragraphs and tables from a docx document
  """

  import SweetXml

  @doc """
  Reads all paragraphs from a given docx file
  """
  @spec read_paragraphs(String.t()) :: [String.t()] | {:error, atom}
  def read_paragraphs(file) do
    case first_non_throwing(file, [], [&read_zip/1, &read_zstream/1]) do
      {:ok, doc} ->
        doc
        |> parse()
        |> xpath(~x"//w:document//w:body//w:p"l)
        |> Enum.map(&xpath(&1, ~x"w:r//text()|w:hyperlink/w:r//text()"l))
        |> Enum.map(&Enum.join(&1))

      error ->
        error
    end
  end

  defp first_non_throwing(_file, errors, []), do: {:error, :no_parser_found, errors}

  defp first_non_throwing(file, errors, [fun | rest]) do
    try do
      {:ok, val} = fun.(file)
      {:ok, val}
    rescue
      e -> first_non_throwing(file, [e | errors], rest)
    end
  end

  defp read_zip(file) do
    case :zip.unzip(file, [:memory]) do
      {:ok, inner_files} ->
        doc =
          inner_files
          |> Enum.find(fn {name, _} -> name == 'word/document.xml' end)
          |> case do
            {'word/document.xml', doc} -> doc
          end

        {:ok, doc}

      error ->
        {:error, error}
    end
  end

  defp read_zstream(file) do
    result =
      file
      |> File.stream!([], 1024)
      |> Zstream.unzip()
      |> Enum.reduce(%{}, fn
        {:entry, %Zstream.Entry{name: "word/document.xml"}}, state ->
          state
          |> Map.put(:in_document, true)
          |> Map.put(:data, "")

        {:data, :eof}, %{in_document: true, data: data} ->
          {:ok, data}

        {:data, data}, %{in_document: true, data: existing_data} = state ->
          Map.put(state, :data, existing_data <> IO.chardata_to_string(data))

        _, state ->
          state
      end)

    if result == %{} do
      {:error, :no_document}
    else
      result
    end
  end
end
