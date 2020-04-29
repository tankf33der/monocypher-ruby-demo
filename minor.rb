require "ffi"

module Monocypher
  class Blake2bCtx < FFI::Struct
    layout :hash,       [:uint64, 8],
        :input_offset,  [:uint64, 2],
        :input,         [:uint64, 16],
        :input_idx,     :size_t,
        :hash_size,     :size_t
  end
  class Blake2b
    extend FFI::Library
    ffi_lib "libmonocypher.so.3"

    attach_function :crypto_blake2b, [:buffer_out, :buffer_in, :size_t], :void
    attach_function :crypto_blake2b_general, [:buffer_out, :size_t, :buffer_in, :size_t, :buffer_in, :size_t], :void

    def self.digest(bytes)
      #bytes = bytes.pack("С*") if bytes.respond_to?(:pack)
      size = bytes.respond_to?(:bytesize) ? bytes.bytesize : 0
      #size = bytes.size
      #data = FFI::MemoryPointer.new(:uint8, size)
      #data.put_bytes(0, bytes)
      result = FFI::MemoryPointer.new(:uint8, 64)
      self.crypto_blake2b(result, bytes, size)
      result.get_bytes(0, 64).unpack("H*")[0]
    end
    def blake2b_general(hashlen, key, bytes)
      #bytes = bytes.pack("C*") if bytes.respond_to?(:pack)
      #size = bytes.respond_to?(:bytesize) ? bytes.bytesize : bytes.size
      keysize = key.respond_to?(:bytesize) ? bytes.bytesize : bytes.size

      result = FFI::MemoryPointer.new(:uint8, hashlen)
      self.crypto_blake2b_general(result, hashlen, key, keysize, bytes, bytes.bytesize)
      result.get_bytes(0, hashlen).unpack("H*")[0]
    end

    def initialize(hashlen=64, key=nil)
      Blake2bCtx.new()
    end
  end
end
puts Monocypher::Blake2b.digest("abc")
puts Monocypher::Blake2b.digest(nil)
puts Monocypher::Blake2b.digest("")
ctx = Monocypher::Blake2b.new(12, "key")
p ctx

=begin
s1 = Monocypher.blake2b("миша")
puts s1

b1 = File.binread("/bin/date")
puts Monocypher.blake2b(b1)
=end
