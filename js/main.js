const fs = require('fs');

function randomInt(min, max) {
	return min + Math.floor((max - min) * Math.random());
}

function randomIndex(arrayLen) {
  return randomInt(0, arrayLen);
}

function removeElement(arr, index) {
  return arr.splice(index, 1)[0];
}

let _palavrasChache = [];
function pegarLista() {
  if (_palavrasChache.length !== 0) return [ ..._palavrasChache ];

  const file = fs.readFileSync('../lista-palavras.txt', 'utf8');

  _palavrasChache = file.replace(/\r/g, '').split('\n');

  return [ ..._palavrasChache ];
}

function pegarPalavra(lista) {
  const id = randomIndex(lista.length);
  return removeElement(lista, id);
}


class CartPos {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }
}

class MtxPos {
  constructor(cartPos, farLeftPos) {
    this.x = farLeftPos.x - cartPos.x;
    this.y = farLeftPos.y - cartPos.y;
  }
}

class Cruzamento {
  constructor(palavra, paiLetraId, letraId) {
    this.palavra = palavra;
    this.paiLetraId = paiLetraId;
    this.thisLetraId = letraId;
  }
}

class Palavra {
  constructor(string, palavraPai) {
    this.string = string;
    this.cruzamentos = [];
    this.palavraPai = palavraPai || null;

    if (!this.palavraPai) {
      this.cartPos = new CartPos(0, 0);
    }
  }


  encaixar(outraString) {
    let encaixou = null;
    this.string.split('').every((char, paiId) => {
      let naoAchei = true;
      outraString.split('').every((char2, filhoId) => {
        if (char === char2) {
          const used = this.cruzamentos.find((cz) => cz.paiId === paiId);

          if (!used) {
            const novoCruzamento = new Cruzamento(new Palavra(outraString, this), paiId, filhoId);
            this.cruzamentos.push(novoCruzamento);
            naoAchei = false;
            encaixou = novoCruzamento;
          }
        }

        return naoAchei;
      });

      return naoAchei;
    });

    return encaixou;
  }
}

function novoJogo(palavrasQnt) {
  const listaPalavras = pegarLista();
  const primeiraPalavra = new Palavra(pegarPalavra(listaPalavras));

  let agora = primeiraPalavra;
  for (let i = 1; i < palavrasQnt; i += 1) {
    let encaixou = false;
    let string = pegarPalavra(listaPalavras);
    let primeira = agora;
    while (!encaixou) {
      let cruzamento = agora.encaixar(string);

      if (cruzamento) {
        agora = cruzamento.palavra;
        encaixou = true;
      } else if (agora.palavraPai) {
        agora = agora.palavraPai;
      } else {
        string = pegarPalavra(listaPalavras);
        agora = primeira;
      }
    }
  }

  return primeiraPalavra;
}

const jogo = novoJogo(2);

console.log(jogo);
