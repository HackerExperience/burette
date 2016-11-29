defmodule Burette.Mixfile do

  use Mix.Project

  def project do
    [
      app: :burette,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      name: "Burette",
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
      {:ex_doc, "~> 0.14", only: :dev}]
  end

  defp package do
    [
      files: ~w/mix.exs lib README.md/,
      maintainers: ["Charlotte Lorelei Oliveira"],
      links: %{"Github" => "https://github.com/HackerExperience/burette"}]
  end
end
