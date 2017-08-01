# Docxelixir

Docxelixir reads docx files and can extract paragraphs (texts in general) and table of contents.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `docxelixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:docxelixir, "~> 1.0.0"}
  ]
end
```

## Usage

```elixir
  # Reading all paragraphs of samples/demo.docx
  Docxelixir.read_paragraphs('samples/demo.docx')
  # ['paragraph 1', 'paragraph 2', '...']
```
