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

function novoJogo(palavrasQnt) {
  const listaPalavras = pegarLista();
  const palavra = pegarPalavra(listaPalavras);
}

novoJogo(2);
