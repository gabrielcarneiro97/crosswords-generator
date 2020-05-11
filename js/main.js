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


class Cruzamento {
  constructor(palavra, paiLetraId, letraId) {
    this.palavra = palavra;
    this.paiId = paiLetraId;
    this.thisId = letraId;
  }
}

class Palavra {
  constructor(string, palavraPai) {
    this.string = string;
    this.cruzamentos = [];
    this.palavraPai = palavraPai;
  }


  encaixar(outraString) {

  }
}

function novoJogo(palavrasQnt) {
  const listaPalavras = pegarLista();
  const primeiraPalavra = new Palavra(pegarPalavra(listaPalavras), null);

  for (let i = 1; i < palavrasQnt; i += 1) {
    let string = pegarPalavra(listaPalavras);
  }
}

