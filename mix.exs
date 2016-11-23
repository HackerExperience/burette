defmodule Arand.Mixfile do

  use Mix.Project

  def project do
    [
      app: :arand,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      preferred_cli_env: [espec: :test],
      name: "Arand",
      description: "Library to efficiently generate random data for testing",
      package: package(),
      deps: deps()]
  end

  def application do
    []
  end

  defp deps do
    [
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:credo, "~> 0.5", only: :dev},
      {:dialyze, "~> 0.2", only: :dev},
      {:espec, "~> 1.1.2", only: :test}]
  end

  defp package do
    [
      files: ~w/mix.exs lib README.md/,
      maintainers: ["Charlotte Lorelei Oliveira"],
      links: %{"Github" => "https://github.com/mememori/arand"}]
  end
end
