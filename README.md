# Burette

Burette is a library for generating fake data for tests.

Burette's differential is that it is hand-tailored to provide good random data
with maximum performance.

Most other fake data generation libraries are suboptimized and will affect
considerably the test suite run time.

Burette high performance comes from using hand-tailored algorithms to produce
the expected data and using maps as arrays to collect the "universe of
possibilities"

## Components
- [x] Date (date/time/datetime/future/present)
- [x] Number (integer in range/digits)
- [x] Network (ipv4/ipv6)
- [ ] Internet (hostname/url/email/password)
- [ ] Address (street address)
- [ ] Name (first name/last name/full name)
- [ ] File (file name/file path)
- [ ] Corporation (corporation name)
- [ ] Image (thumbnail/avatar)
- [ ] Lorem (lorem ipsum)
