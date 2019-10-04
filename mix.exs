defmodule DEC.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :dec,
      version: "0.10.2",
      elixir: "~> 1.7",
      description: "DEC Decimal Arbitrary Precision",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(doc include lib src mix.exs LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa", "Oleksandr Palchikovskiy"],
      name: :dec,
      links: %{"GitHub" => "https://github.com/erpuno/dec"}
    ]
  end

  def application() do
    [mod: {:dec, []}]
  end

  def deps() do
    [
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
