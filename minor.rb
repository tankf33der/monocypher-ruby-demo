require "ffi"

module Monocypher
  extend FFI::Library
  ffi_lib "libmonocypher.so"

  attach_function :crypto_blake2b, [:buffer_out, :pointer, :size_t], :void

  def self.blake2b(bytes)
    bytes = bytes.pack("С*") if bytes.respond_to?(:pack)
    size = bytes.bytesize
    size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
    data = FFI::MemoryPointer.new(:uint8, size)
    data.put_bytes(0, bytes)
    result = FFI::MemoryPointer.new(:uint8, 64)
    crypto_blake2b(result, bytes, size)
    result.get_bytes(0, 64).unpack("H*")[0]
  end
end

puts "start"

s1 = Monocypher.blake2b("abc")
puts s1

s1 = Monocypher.blake2b("миша")
puts s1

b1 = File.binread("/bin/date")
puts Monocypher.blake2b(b1)
