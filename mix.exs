defmodule DEC.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :dec,
      version: "0.7.1",
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
      maintainers: ["Namdak Tonpa"],
      name: :dec,
      links: %{"GitHub" => "https://github.com/enterprizing/dec"}
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
