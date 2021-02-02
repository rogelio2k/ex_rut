defmodule ExRut do
  @moduledoc """
  A library to format and validate a chilean ID/TAX (RUT/RUN)
  """

  @regex_rut ~r/^((?'num'\d{1,3}(?:([\.\,]?)\d{1,3}){2})(-?)(?'dv'[\dkK]))$/
  @defaults [
    delimiter: ".",
    show_dv: true
  ]

  # @doc """
  # Hello world.
  #
  # ## Examples
  #
  #     iex> ExRut.hello()
  #     :world
  #
  # """
  def valid?(rut) when is_binary(rut) do
    case get_rut_values(rut) do
      {:ok, number, dv} ->
        calculated_dv = calculate_dv_value(number)
        calculated_dv == dv
      {:error, :invalid_value} ->
        false
    end
  end

  def valid?(rut) when is_integer(rut) do
    rut
    |> Integer.to_string
    |> valid?
  end

  def valid?(rut) when is_nil(rut), do: false
  def valid?(_), do: false

  def calculate_dv(number) when is_integer(number) do
    {:ok, calculate_dv_value(number)}
  end

  def calculate_dv(number) when is_binary(number) do
    number = clean_rut(number)

    case Integer.parse(number) do
      {number_as_int, ""} ->
        {:ok, calculate_dv_value(number_as_int)}
      {_num_as_int, _} ->
        {:error, :invalid_value}
      :error ->
        {:error, :invalid_value}
    end
  end

  def calculate_dv!(number) do
    case calculate_dv(number) do
      {:ok, dv} ->
        dv
      {:error, :invalid_value} ->
        raise "Invalid Value"
    end
  end

  def format(rut, options \\ [])
  def format(rut, options) when is_binary(rut) do
    if valid?(rut) do
      options = Keyword.merge(@defaults, options)
      delimiter = Keyword.get(options, :delimiter)
      show_dv = Keyword.get(options, :show_dv)

      {:ok, num, dv} = get_rut_values(rut)

      dv = if show_dv, do: dv, else: nil
      dash = if show_dv, do: "-", else: ""

      formatted_rut =
        [delimit_integer(num, delimiter), dv]
        |> Enum.reject(&is_nil/1)
        |> Enum.join(dash)
      {:ok, formatted_rut}
    else
      {:error, :invalid_value}
    end
  end

  def format(rut, options) when is_integer(rut) do
    format(Integer.to_string(rut), options)
  end

  def format!(number, options \\ []) do
    case format(number, options) do
      {:ok, formatted_rut} ->
        formatted_rut
      {:error, :invalid_value} ->
        raise "Invalid Value"
    end
  end

  defp calculate_dv_value(number) when is_integer(number) do
    calculated_dv =
      number
      |> split_integer
      |> Enum.reverse
      |> Enum.with_index(2)
      |> Enum.map(fn {n, index} ->
        if index > 7 do
          {n, (index-6)}
        else
          {n, index}
        end
      end)
      |> Enum.reduce(0, fn {n, index}, acc ->
        acc + (n * index)
      end)
      |> Kernel.rem(11)
      |> Kernel.-(11)
      |> Kernel.abs

    cond do
      calculated_dv == 11 -> "0"
      calculated_dv == 10 -> "k"
      true -> Integer.to_string(calculated_dv)
    end
  end

  defp get_rut_values(rut) do
    rut = clean_rut(rut)

    cond do
      Regex.match?(@regex_rut, rut) ->
        get_clean_rut_values(@regex_rut, rut)
      # invalid format
      true ->
        {:error, :invalid_value}
    end
  end

  defp get_clean_rut_values(regex, rut) do
    rut = clean_rut(rut)

    %{"num" => number, "dv" => dv} = Regex.named_captures(regex, rut)

    dv = String.downcase(dv)

    case Integer.parse(number) do
      {number_as_int, ""} ->
        {:ok, number_as_int, dv}

      :error ->
        {:error, :invalid_rut}
    end
  end

  defp clean_rut(rut) do
    rut
    |> String.replace(".", "")
    |> String.replace(",", "")
  end

  defp split_integer(number) when is_integer(number) do
    number
    |> Kernel.to_string()
    |> String.split("", trim: true)
    |> Enum.map(fn int_string ->
      Integer.parse(int_string)
      |> case do
        {int, _} ->
          int
        _ ->
          0
      end
    end)
  end

  defp delimit_integer(number, delimiter) when is_binary(number) do
    case Integer.parse(number) do
      {number_as_int, ""} -> delimit_integer(number_as_int, delimiter)
      :error -> number
    end
  end

  defp delimit_integer(number, delimiter) when is_integer(number) do
    integer =
      abs(number)
      |> Integer.to_charlist()
      |> :lists.reverse()
      |> delimit_integer(delimiter, [])

    Enum.join([integer])
  end

  defp delimit_integer([a, b, c, d | tail], delimiter, acc) do
    delimit_integer([d | tail], delimiter, [delimiter, c, b, a | acc])
  end

  defp delimit_integer(list, _, acc) do
    :lists.reverse(list) ++ acc
  end

end
