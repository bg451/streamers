Code.require_file "test_helper.exs", __DIR__

defmodule StreamersTest do
  use ExUnit.Case

  test 'find index file in a directory' do
    assert Streamers.find_index('test/fixtures/emberjs') ==
      "9af0270acb795f9dcafb5c51b1907628.m3u8"
  end

  test "returns nil for not available index files" do
    assert Streamers.find_index('this/doesnt/exist') == nil
  end
end
