require 'ffi'

module Monocypher
  extend FFI::Library
  ffi_lib 'libmonocypher.so'

  attach_function :crypto_blake2b, [:buffer_out, :pointer, :size_t], :void

  def self.mike()
    puts "mike"
  end
  def self.blake2b(bytes)
    bytes = bytes.pack('С*') if bytes.respond_to?(:pack)
    size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
    #puts bytes.bytesize
    #puts bytes.size
    data = FFI::MemoryPointer.new(:uint8, size)
    data.put_bytes(0, bytes)
    result = FFI::MemoryPointer.new(:uint8, 64)
    crypto_blake2b(result, bytes, size)
    #puts result
    result
  end
end

puts "start"
Monocypher.mike()

=begin
str = FFI::MemoryPointer.from_string("abc")
hash = FFI::MemoryPointer.new(:uint8, 64)
Monocypher.crypto_blake2b(hash, str, 3)
puts str
a = hash.get_array_of_uint8(0, 64)
#a = hash.get_string { |b| sprintf(", 0x%02x", b) }.join
puts a
=end


s1 = Monocypher.blake2b("abc")
puts s1.get_bytes(0, 64).unpack('H*')[0]
s1 = Monocypher.blake2b("The quick brown fox jumps over the lazy dog")
puts s1.get_bytes(0, 64).unpack('H*')[0]



=begin
bytes = "abc"
bytes = bytes.pack('c*') if bytes.respond_to?(:pack)
size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
#puts bytes.bytesize
#puts bytes.size
#puts size
data = FFI::MemoryPointer.new(:uint8, size)
data.put_bytes(0, bytes)
result = FFI::MemoryPointer.new(:uint8, 64)
Monocypher.crypto_blake2b(result, bytes, size)
puts result.
=end

