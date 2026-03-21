def "open map" [path: string] {
	open $path
		| parse -r '(?<type>[\.A-Za-z\d\-_]+)?\s+(?<addr>[\da-fA-Fx]+)\s+(?<size>[\da-fA-Fx]+)\s+(?<path>[/A-Za-z\d\.\-_\(\)]+)'
		| update size { into int -r 16 }
		| update addr { into int -r 16 }
		| sort-by size
		| where not (($it.type != null) and ($it.type | str starts-with ".debug"))
}

open map ./build/micromod/mod-stm32f1-v5/Release/output.map
