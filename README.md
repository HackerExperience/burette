# Burette

Burette is a library for generating fake data for tests.

Burette's high performance comes from using hand-tailored algorithms to produce
data and using tuples as arrays to collect the sample data, providing quick
lookup

## Components
- [x] Number (integer in range/digits)
- [x] Date (date/time/datetime/future/present)
- [x] Network (ipv4/ipv6)
- [x] Color (name/hex)
- [x] Name (first name/last name/full name)
- [ ] Internet (hostname/url/email/password)
- [ ] Address (street address)
- [ ] File (file name/file path)
- [ ] Corporation (corporation name)
- [ ] Image (thumbnail/avatar)
- [ ] Lorem (lorem ipsum)

## Usage Examples
### Burette.Number
```elixir
iex> Burette.Number.number 0..9 
6
iex> Burette.Number.number 0, 9
0
iex> Burette.Number.digits 3
"944"
```

### Burette.Calendar
```elixir
iex> Burette.Calendar.date
~D[1978-03-25]
iex> Burette.Calendar.date day: 31
~D[2022-01-31]
iex> Burette.Calendar.date year: 1999
~D[1999-06-22]
iex> Burette.Calendar.date year: 1999, month: 12
~D[1999-12-14]
iex> Burette.Calendar.time
~T[05:39:04]
iex> Burette.Calendar.time hour: 21
~T[21:50:08]
iex> Burette.Calendar.time minute: 59, second: 59
~T[08:59:59]
iex> Burette.Calendar.datetime
%DateTime{...}
iex> Burette.Calendar.datetime year: 1999, month: 12, hour: 23, minute: 59, second: 59
%DateTime{...}
iex> Burette.Calendar.future           
%DateTime{...}
iex> Burette.Calendar.future year: 2050
%DateTime{...}
iex> Burette.Calendar.past
%DateTime{...}
iex> Burette.Calendar.past month: 12, minute: 30
%DateTime{...}
```

### Burette.Network
```elixir
iex> Burette.Network.ipv4
"74.177.174.187"
iex> Burette.Network.ipv6
"BEDD:1F36:5B96:8B46:EEE1:8FAA:328E:FD0F"
```

### Burette.Color
```elixir
iex> Burette.Color.name
"Celadon"
iex> Burette.Color.hex 
"#D1BC5A"
```

### Burette.Name
```elixir
iex> Burette.Name.name
"Derek"
iex> Burette.Name.surname
"Lewis"
iex> Burette.Name.fullname
"Roland Fowler Jr"
```
