defmodule CrzzWeb.Unauthorized do
  @moduledoc """
  Raised when one of the `accept*` headers is not accepted by the server.

  This exception is commonly raised by `Phoenix.Controller.accepts/2`
  which negotiates the media types the server is able to serve with
  the contents the client is able to render.

  If you are seeing this error, you should check if you are listing
  the desired formats in your `:accepts` plug or if you are setting
  the proper accept header in the client. The exception contains the
  acceptable mime types in the `accepts` field.
  """

  defexception message: nil, plug_status: 400
end
