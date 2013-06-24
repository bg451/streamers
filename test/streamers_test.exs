Code.require_file "test_helper.exs", __DIR__

defmodule StreamersTest do
  use ExUnit.Case
  alias Streamers.M3U8 , as: M3U8
  doctest Streamers
  @index_file "test/fixtures/emberjs/9af0270acb795f9dcafb5c51b1907628.m3u8"

  test 'finds index file in a directory' do
    assert Streamers.find_index("test/fixtures/emberjs") == @index_file
  end

  test "returns nil for not available index files" do
    assert Streamers.find_index('this/doesnt/exist') == nil
  end

  test "extracts m3u8" do
    m3u8s =  Streamers.extract_m3u8(@index_file)
    assert Enum.first(m3u8s) ==
      M3U8[program_id: 1, bandwidth: 110000, path: "test/fixtures/emberjs/8bda35243c7c0a7fc69ebe1383c6464c.m3u8"]

    assert length(m3u8s) == 5
    # PROGRAM-ID=1,BANDWIDTH=110000
    # 8bda35243c7c0a7fc69ebe1383c6464c.m3u8

  end


end
