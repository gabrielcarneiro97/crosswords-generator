defmodule Palavra do
  defstruct charlist: '', pai: nil, cruzamento: {this: -1, pai: -1}, letras_cruzadas: []
end

defmodule Cwgen do
  use Memoize

  defmemo ler_lista_arquivo do
    case File.read("../lista-palavras.txt") do
      {:ok, body} -> String.split(body, "\r\n")
      _ -> []
    end
  end

  defp pegar_palavras lista, qnt, listaArquivo do
    [head | tail] = Enum.shuffle(listaArquivo)
    case qnt do
      0 -> lista
      _ -> lista ++ [head] |> pegar_palavras(qnt - 1, tail)
    end
  end

  defp pegar_palavras lista, qnt do
    listaArquivo = ler_lista_arquivo()
    pegar_palavras(lista, qnt, listaArquivo)
  end

  def pegar_palavras(qnt), do: pegar_palavras [], qnt

  def nova_palavra string do
    %Palavra{charlist: to_charlist(string)}
  end

  def nova_palavra(string, palavra_pai) when is_struct(palavra_pai) do
    %Palavra{charlist: to_charlist(string), pai: palavra_pai}
  end

  def cruzar_palavras(palavra_pai, palavra_filha) do

  end
end
