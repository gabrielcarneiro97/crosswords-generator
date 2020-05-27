defmodule Palavra do
  defstruct charlist: '', pai: nil, thisId: nil, paiId: nil
end


defmodule Cwgen do

  def is_palavra palavra do
    case palavra do
      %Palavra{} -> true
      _ -> false
    end
  end

  def novaPalavra string do
    %Palavra{charlist: to_charlist(string)}
  end

  def novaPalavra(string, palavraPai) when is_struct(palavraPai) do
    %Palavra{charlist: to_charlist(string), pai: palavraPai}
  end

  def cruzarPalavras(palavra) when is_struct(palavra) do
    case palavra do
      %{pai: nil} -> "ué"
      %{pai: %Palavra{}} -> "é palavra"
      _ -> "resto"
    end
  end
end
