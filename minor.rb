require 'ffi'

module Monocypher
  extend FFI::Library
  ffi_lib 'libmonocypher.so'

  attach_function :crypto_blake2b, [:buffer_out, :pointer, :size_t], :void

  def self.mike()
    puts "mike"
  end
end

puts "start"
Monocypher.mike()

str = FFI::MemoryPointer.from_string("abc")
hash = FFI::MemoryPointer.new(:uint8, 64)
Monocypher.crypto_blake2b(hash, str, 4)
puts str
#a = hash.get_array_of_uint8(0, 64)
a = hash.get_string { |b| sprintf(", 0x%02x", b) }.join
puts a
