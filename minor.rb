require "ffi"

module Monocypher
  extend FFI::Library
  ffi_lib "libmonocypher.so"

  attach_function :crypto_blake2b, [:buffer_out, :buffer_in, :size_t], :void
  attach_function :crypto_blake2b_general, [:buffer_out, :size_t, :buffer_in, :size_t, :buffer_in, :size_t], :void

  def self.blake2b(bytes)
    #bytes = bytes.pack("С*") if bytes.respond_to?(:pack)
    #size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
    #size = bytes.size
    #data = FFI::MemoryPointer.new(:uint8, size)
    #data.put_bytes(0, bytes)
    result = FFI::MemoryPointer.new(:uint8, 64)
    self.crypto_blake2b(result, bytes, bytes.bytesize)
    result.get_bytes(0, 64).unpack("H*")[0]
  end
  def self.blake2b_general(hashlen, key, bytes)
    #bytes = bytes.pack("C*") if bytes.respond_to?(:pack)
    #size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
    keysize = key.respond_to?(:bytesize) ? bytes.bytesize : bytes.size

    result = FFI::MemoryPointer.new(:uint8, hashlen)
    self.crypto_blake2b_general(result, hashlen, key, keysize, bytes, bytes.bytesize)
    result.get_bytes(0, hashlen).unpack("H*")[0]
  end

end

puts "start"

s = "abc"
s1 = Monocypher.blake2b(s)
puts s1
puts s

puts Monocypher.blake2b("")

s1 = Monocypher.blake2b("миша")
puts s1

b1 = File.binread("/bin/date")
puts Monocypher.blake2b(b1)

s1 = "abc"
puts Monocypher.blake2b_general(4, "key", s1)
