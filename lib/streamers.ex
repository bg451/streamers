defmodule Streamers do
  defrecord M3U8, program_id: nil, path: nil, bandwidth: nil
  @@@doc """
  Find streaming file in the given directory.

  ## Examples

    iex> Streamers.find_index("this/doesnt/exist")
      nil
  """
  def find_index(directory) do
    files = Path.join(directory, "*.m3u8")
    if file = Enum.find(Path.wildcard(files), is_index?(&1)) do
       file
    end
  end

  defp is_index?(file) do
    File.open! file, fn(pid) ->
      IO.read(pid, 25)  == "#EXTM3U\n#EXT-X-STREAM-INF"
    end
  end

  def extract_m3u8(index_file) do
    File.open! index_file, fn(pid) ->
      IO.readline(pid)
      do_extract_m3u8(pid, [])
    end
  end

  defp do_extract_m3u8(pid, acc) do
    case IO.readline(pid) do
      :eof -> Enum.reverse(acc)
      stream_inf ->
        path = IO.readline(pid)
        do_extract_m3u8(pid, stream_inf, path, acc)
    end
  end

  defp do_extract_m3u8(pid, stream_inf, path, acc) do
    # #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=110000

    << "#EXT-X-STREAM-INF:PROGRAM-ID=", program_id, ",BANDWIDTH=", bandwidth :: binary  >> = stream_inf
    prog_id = binary_to_integer <<program_id>>
    record = M3U8[program_id: prog_id, path: String.strip(path), bandwidth: String.strip bandwidth]
    do_extract_m3u8(pid, [record|acc])
  end
end
