defmodule Burette.Network do

  use Bitwise

  def ipv6 do
    # Generate 3 numbers within the small integer limit (note that this is
    # expecting a 64-bit architecture).
    i1 = Burette.Number.number(0..0xffff_ffff_ffff)
    i2 = Burette.Number.number(0..0xffff_ffff_ffff)
    i3 = Burette.Number.number(0..0xffff_ffff)

    # Shifts the bits to produce a tuple with 8 elements in the range 0-65535
    {
      (i1 >>> 32) &&& 0xffff,
      (i1 >>> 16) &&& 0xffff,
      i1 &&& 0xffff,
      (i2 >>> 32) &&& 0xffff,
      (i2 >>> 16) &&& 0xffff,
      i2 &&& 0xffff,
      (i3 >>> 16) &&& 0xffff,
      i3 &&& 0xffff}
    |> :inet.ntoa()
    |> List.to_string()
  end

  def ipv4 do
    i = Burette.Number.number(0..0xff_ff_ff_ff)

    {
      (i >>> 24) &&& 0xff,
      (i >>> 16) &&& 0xff,
      (i >>> 8) &&& 0xff,
      i &&& 0xff}
    |> :inet.ntoa()
    |> List.to_string
  end
end
