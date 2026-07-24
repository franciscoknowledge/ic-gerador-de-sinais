extends Node

var SUFIXOS: Dictionary[int, String] = {
	-12: "p",
	-9 : "n",
	-6 : "µ",
	-3 : "m",
	0  : "",
	3  : "k",
	6  : "M",
	9  : "G",
	12 : "T",
}

# TODO: limitar o expoente à -12 e 12, porém para o escopo desse
# talvez programa não vai ser necessario
func formatar_numero(n: float, pad: int = 1) -> ParamsEngenharia:
	var params := ParamsEngenharia.new(String.num(0, pad), 0, "")
	
	var sinal: int = sign(n)
	var valor: float = abs(n)
	var expoente: int = 0
	
	if valor != 0:
		while valor / 1000 >= 1:
			valor /= 1000
			expoente += 3
			
		while valor < 1:
			valor *= 1000
			expoente -= 3
			
	params.base = "%.*f" % [pad, valor * sinal]
	params.sufixo = SUFIXOS[expoente]
	params.expoente = expoente
	
	return params

# faz o padding em relação aos digitos, pq é assim que funciona no display
func formatar_grandeza(g: Grandeza) -> ParamsEngenharia:
	var params = formatar_numero(g.valor, g.digitos)
	var base_len = str(int(params.base)).length()
	params.base = params.base.substr(0, params.base.length() - 4 - base_len)
	
	return params
