defmodule Docxelixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :docxelixir,
      version: "1.0.1",
      elixir: "~> 1.0",
      name: "Docxelixir",
      description: "reads docx document files (paragraphs, tables)",
      source_url: "https://github.com/andrewaguiar/docxelixir",
      package: package(),
      deps: deps()
    ]
  end

  defp deps() do
    [
      {:sweet_xml, "~> 0.7.1"},
      {:zstream, "~> 0.6", github: "ananthakumaran/zstream", branch: "master"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      name: :docxelixir,
      files: ["lib", "samples", "mix.exs", "README.md", "LICENSE.txt"],
      maintainers: ["Andrew S Aguiar"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/andrewaguiar/docxelixir"}
    ]
  end

  def application do
    [extra_applications: [:xmerl, :zstream]]
  end
end
