defmodule Burette.Internet do

  alias Burette.Helper.Lexicon
  alias Burette.Number

  @domain_suffix Lexicon.build ~w/.com .org .net .academy .accountant .adult .aero .agency .apartments .app .bar .best .biz .blog .center .cheap .click .club .coffee .coop .date .design .directory .download .eat .email .farm .feedback .fit .flowers .fly .foo .fyi .gift .glass .global .here .hiv .house .info .ink .jobs .land .lgbt .lighting .link .lol .love .management .menu .mobi .moe .mov .museum .name .ninja .one .ooo .photo .pics .pid .pro .red .rip .social .software .sucks .systems .tel .today .top .video .wiki .wtf .xxx .xyz .co.uk .com.ag .com.br .com.cn .com.es .com.fr .com.gr .com.hr .com.ph .com.ro .com.tw .com.vn .nom.es .asia .net.au .firm.in .org.in .ac .ad .ae .af .ag .ai .al .am .an .ao .aq .ar .as .at .au .aw .ax .az .ba .bb .bd .be .bf .bg .bh .bi .bj .bm .bn .bo .bq .br .bs .bt .bv .bw .by .bz .eu .jp .us .ws/

  @domain_format Lexicon.build ~w/
    {{company}}{{domain_suffix}}
    {{username}}{{domain_suffix}}
    {{color}}{{domain_suffix}}
    {{thing}}{{domain_suffix}}
  /

  @email_format Lexicon.build ~w/
    {{username}}@{{domain_name}}
    {{username}}{{digits}}@{{domain_name}}
    {{username}}{{year}}@{{domain_name}}
    {{color}}_{{username}}@{{domain_name}}
  /

  @company_format Lexicon.build ~w/
    {{thing}}{{thing}}
    {{thing}}{{year}}
    {{thing}}{{digits}}
    {{adjective}}{{thing}}
    {{digits}}{{thing}}
    {{color}}{{thing}}
  /

  @names (
    Burette.Name.lexicons()
    |> Map.fetch!(:names)
    |> Lexicon.merge(Map.fetch!(Burette.Name.lexicons(), :surnames))
    |> Lexicon.values()
    |> Enum.filter(&Regex.match?(~r/^[a-zA-Z]+$/iu, &1))
    |> Enum.map(&String.downcase/1)
    |> Lexicon.build())

  @username_formats Lexicon.build ~w/
    {{name}}{{name}}_{{thing}}
    {{name}}{{year}}
    {{name}}_{{year}}
    {{name}}{{digits}}
    {{name}}_{{digits}}
    {{adjective}}{{thing}}{{year}}
    {{adjective}}{{thing}}_{{year}}
    {{adjective}}{{name}}
    {{adjective}}_{{name}}
    {{adjective}}{{name}}{{digits}}
    {{adjective}}_{{name}}_{{year}}
  /

  # TODO: Move this to another module
  @adjective Lexicon.build ~w/
    amazing
    awesome
    big
    bizarre
    bland
    clever
    cold
    cool
    cute
    dirty
    dry
    easy
    exotic
    daft
    filthy
    fine
    flat
    fruity
    funny
    hard
    healthy
    hot
    huge
    loud
    important
    incredible
    light
    new
    old
    open
    outstanding
    petite
    revolutionary
    salty
    silent
    soft
    sour
    small
    tasty
    warm
    wunderbar
  /

  # TODO: Move this to another module
  @thing Lexicon.build ~w/
    apple
    book
    calendars
    codes
    computers
    directory
    earth
    fire
    games
    globe
    gps
    guitar
    ice
    instruments
    keikaku
    keyboards
    life
    list
    love
    map
    names
    noodles
    object
    pets
    piano
    pie
    pineapple
    phone
    pudding
    punk
    records
    rock
    systems
    token
    wind
  /

  @password_downcase Lexicon.build(String.graphemes("abcdefghijklmnopqrstuvwxyz"))
  @password_uppercase Lexicon.build(String.graphemes("ABCDEFGHIJKLMNOPQRSTUVWXYZ"))
  @password_alpha Lexicon.merge @password_downcase, @password_uppercase
  @password_digits Lexicon.build(String.graphemes("0123456789"))
  @password_alphanum Lexicon.merge @password_alpha, @password_digits
  @password_symbols Lexicon.build(String.graphemes(":;/?.>,<|\\!@#$%^&*()-_=+[]\"'{}~`"))
  @password_any Lexicon.merge @password_alphanum, @password_symbols

  @colors (
    Burette.Color.lexicons()
    |> Map.fetch!(:names)
    |> Lexicon.values()
    |> Enum.filter(&Regex.match?(~r/^[a-zA-Z]+$/iu, &1))
    |> Enum.map(&String.downcase/1)
    |> Lexicon.build())

  @spec email() :: String.t
  def email do
    @email_format
    |> Lexicon.take()
    |> parse()
  end

  @spec domain() :: String.t
  def domain do
    @domain_format
    |> Lexicon.take()
    |> parse()
  end

  @spec username() :: String.t
  def username do
    @username_formats
    |> Lexicon.take()
    |> parse()
  end

  @spec password([{:alpha | :alphanum | :any | :downcase | :uppercase | :digit, pos_integer}]) :: String.t
  def password(params \\ [alphanum: 5, downcase: 1, uppercase: 1, digit: 1]) do
    params
    |> Enum.flat_map(fn {opt, n} -> List.duplicate(opt, n) end)
    |> Enum.shuffle()
    |> Enum.map(&password_char/1)
    |> Enum.join()
  end

  defp password_char(:downcase),
    do: Lexicon.take(@password_downcase)
  defp password_char(:uppercase),
    do: Lexicon.take(@password_uppercase)
  defp password_char(:alpha),
    do: Lexicon.take(@password_alpha)
  defp password_char(:digit),
    do: Lexicon.take(@password_digits)
  defp password_char(:symbol),
    do: Lexicon.take(@password_symbols)
  defp password_char(:alphanum),
    do: Lexicon.take(@password_alphanum)
  defp password_char(:any),
    do: Lexicon.take(@password_any)

  defp parse(string),
    do: parse(string, "")
  defp parse("", acc),
    do: acc
  defp parse(string, acc) do
    {complement, rest} = case string do
      "{{domain_name}}" <> rest ->
        {domain(), rest}
      "{{domain_suffix}}" <> rest ->
        {Lexicon.take(@domain_suffix), rest}
      "{{username}}" <> rest ->
        {username(), rest}
      "{{name}}" <> rest ->
        {Lexicon.take(@names), rest}
      "{{company}}" <> rest ->
        {company(), rest}
      "{{color}}" <> rest ->
        {Lexicon.take(@colors), rest}
      "{{adjective}}" <> rest ->
        {Lexicon.take(@adjective), rest}
      "{{thing}}" <> rest ->
        {Lexicon.take(@thing), rest}
      "{{digits}}" <> rest ->
        {Number.digits(3), rest}
      "{{year}}" <> rest ->
        {to_string(Number.number(1950..2050)), rest}
      <<char::utf8, rest::binary>> ->
        {<<char::utf8>>, rest}
    end

    parse(rest, acc <> complement)
  end

  defp company do
    @company_format
    |> Lexicon.take()
    |> parse()
  end
end
