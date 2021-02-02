defmodule ExRut.MixProject do
  use Mix.Project

  @source_url "https://github.com/bloqzilla/ex_rut"
  @version "0.1.0"

  def project do
    [
      app: :ex_rut,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "An Elixir library to validate and format chilean ID/TAX number ('RUN\/RUT')",
      package: package(),

      # docs
      name: "ExRut",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Rogelio Castillo A."],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      # files: [".formatter.exs", "mix.exs", "README.md", "CHANGELOG.md", "lib"]
    ]
  end

  defp docs do
    [
      main: "ExRut",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/ex_rut",
      source_url: @source_url
    ]
  end

end
