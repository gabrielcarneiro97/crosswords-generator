defmodule CartPos do
  defstruct x: nil, y: nil
end

defmodule Cruzamento do
  defstruct this: nil, pai: nil
end

defmodule Palavra do
  defstruct charlist: '',
    ot: nil,
    pai: nil,
    cruzamento: %Cruzamento{},
    letras_cruzadas_id: [],
    cart_pos: %CartPos{}
end

defmodule Cwgen do
  use Memoize

  defmemo ler_lista_arquivo do
    case File.read("../lista-palavras.txt") do
      {:ok, body} -> String.split(body, "\r\n")
      _ -> []
    end
  end

  defp pegar_palavras lista, qnt, lista_arquivo do
    [head | tail] = Enum.shuffle lista_arquivo
    case qnt do
      0 -> lista
      _ -> lista ++ [head] |> pegar_palavras(qnt - 1, tail)
    end
  end

  defp pegar_palavras lista, qnt do
    lista_arquivo = ler_lista_arquivo()
    pegar_palavras(lista, qnt, lista_arquivo)
  end

  def pegar_palavras(qnt), do: pegar_palavras [], qnt

  def pegar_palavra, do: pegar_palavras(1) |> hd


  def novo_jogo qnt, p_id, palavras do
    string = pegar_palavra
    atual = Enum.at(palavras, p_id)

    case qnt do
      0 -> palavras
      _ -> case cruzar(atual, string) do
        {:found, pai_novo, p_nova} -> (
          fn ->
            palavras = List.replace_at(palavras, p_id, pai_novo)
            novo_jogo(qnt - 1, p_id + 1, palavras ++ [p_nova])
          end
        ).()
        _ -> novo_jogo(qnt, p_id, palavras)
        end
    end
  end

  def novo_jogo qnt do
    primeira_palavra = pegar_palavra |> set_primeira_palavra
    palavras = [primeira_palavra]
    primeira_palavra_id = 0

    novo_jogo qnt, primeira_palavra_id, palavras
  end

  def set_primeira_palavra string do
    %Palavra{charlist: to_charlist(string), cart_pos: %CartPos{ x: 0, y: 0 }, ot: :v}
  end

  def nova_palavra string do
    %Palavra{charlist: to_charlist(string)}
  end

  def calc_cart_pos palavra_pai, cruzamento do
    case palavra_pai.ot do
      :v -> %CartPos{x: palavra_pai.cart_pos.x - cruzamento.this, y: palavra_pai.cart_pos.y - cruzamento.pai}
      :h -> %CartPos{x: palavra_pai.cart_pos.x + cruzamento.pai, y: palavra_pai.cart_pos.y + cruzamento.this}
      _ -> %CartPos{x: nil, y: nil}
    end
  end

  def nova_palavra(string, palavra_pai, cruzamento) when is_struct(palavra_pai) do
    ot = case palavra_pai.ot do
      :v -> :h
      :h -> :v
      _ -> :error
    end
    %Palavra{
      charlist: to_charlist(string),
      pai: palavra_pai,
      cruzamento: cruzamento,
      letras_cruzadas_id: [cruzamento.this],
      ot: ot,
      cart_pos: calc_cart_pos(palavra_pai, cruzamento)
    }
  end

  defp achar_em_palavra palavra, igualdades do
    [atual | prox] = igualdades

    disp = find_all_indexes(palavra.charlist, atual)
      |> Enum.filter(fn el -> !Enum.member?(palavra.letras_cruzadas_id, el) end)

    case Enum.count(disp) do
      0 -> case Enum.count(prox) do
          0 -> {:not_found}
          _ -> achar_em_palavra palavra, prox
        end
      _ -> hd(disp) |> (fn id -> {:found, id, atual} end).()
    end
  end

  def achar_cruzamento palavra, string do
    charlist = to_charlist string
    igualdades = comp_charlists palavra.charlist, charlist

    case Enum.count(igualdades) do
      0 -> {:not_found}
      _ -> case achar_em_palavra(palavra, igualdades) do
          {:found, id, char} -> find_all_indexes(charlist, char)
            |> Enum.shuffle
            |> hd
            |> (fn f_id -> {:found, %Cruzamento{this: f_id, pai: id}} end).()
          _ -> {:not_found}
        end
    end
  end

  def add_letra_cruzada_id palavra, id do
    %Palavra{palavra | letras_cruzadas_id: palavra.letras_cruzadas_id ++ [id]}
  end

  def cruzar palavra, string do
    case achar_cruzamento(palavra, string) do
      {:found, cruzamento} -> (
        fn ->
          novo_pai = add_letra_cruzada_id(palavra, cruzamento.pai)
          nova = nova_palavra(string, novo_pai, cruzamento)
          {:found, novo_pai, nova}
        end
      ).()
      _ -> {:not_found}
    end
  end

  def find_all_indexes list, char do
    Enum.with_index(list) |> Enum.map(
      fn {el, id} ->
        case el do
          ^char -> id
          _ -> nil
        end
      end
    ) |> Enum.filter(fn el -> el != nil end)
  end

  def comp_charlists list1, list2, igualdades, step do
    l = Enum.at list1, step
    el = Enum.find(list2, nil, fn x -> x == l end)

    last_step = Enum.count(list1)

    case step do
      ^last_step -> Enum.filter(igualdades, fn el -> el != nil end)
      _ -> comp_charlists(list1, list2, igualdades ++ [el], step + 1)
    end
  end

  def comp_charlists list1, list2 do
    igualdades = []
    step = 0
    uniq_list1 = Enum.uniq list1
    uniq_list2 = Enum.uniq list2

    comp_charlists uniq_list1, uniq_list2, igualdades, step
  end
end
