defmodule Anoma.Utility do
  @moduledoc """

  I provide utility functions for users.

  ### Public API

  I posess the following public API:

  - message_label/1
  """

  @doc """
  Helps labeling for `Kino.Process.seq_trace/2`, for the Router abstraction
  """
  def message_label(message) do
    case message do
      {:"$gen_call", _ref, {:router_call, _, term}} ->
        {:ok, "CALL: #{label_from_value(term)}"}

      # Custom logs for logger
      {:"$gen_cast", {:router_cast, _, {:add, _, level, _}}} ->
        {:ok, "ADD LEVEL: #{label_from_value(level)}"}

      {:"$gen_cast", {:router_cast, _, term}} ->
        {:ok, "CAST: #{label_from_value(term)}"}

      _ ->
        :continue
    end
  end

  # taken from the source code itself
  defp label_from_value(tuple)
       when is_tuple(tuple) and is_atom(elem(tuple, 0)),
       do: elem(tuple, 0)

  defp label_from_value(atom) when is_atom(atom), do: atom
  defp label_from_value(ref) when is_reference(ref), do: inspect(ref)
  defp label_from_value(tuple) when is_tuple(tuple), do: "tuple"
  defp label_from_value(_), do: "term"
end