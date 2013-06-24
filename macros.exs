defmodule MyMacros do
  defmacro my_unless(expr, opts) do
    quote do
      if(!unquote(expr), opts)
    end
  end
end
