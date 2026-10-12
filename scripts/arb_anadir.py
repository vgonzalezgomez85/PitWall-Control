#!/usr/bin/env python3
# Añade claves a los cinco diccionarios ARB de lib/l10n de una vez.
# Uso: python3 scripts/arb_anadir.py datos.json
# datos.json = {"clave": {"es": "...", "ca": "...", "en": "...", "fr": "...",
#                         "it": "...", "meta": {...opcional: placeholders...}}}
import json
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
IDIOMAS = ["es", "ca", "en", "fr", "it"]


def cargar(idioma):
    with open(RAIZ / f"lib/l10n/app_{idioma}.arb", encoding="utf-8") as f:
        return json.load(f)


def main():
    datos = json.load(open(sys.argv[1], encoding="utf-8"))
    arbs = {i: cargar(i) for i in IDIOMAS}
    anadidas = 0
    for clave, textos in datos.items():
        if clave in arbs["es"]:
            print(f"AVISO: ya existe {clave}, se omite")
            continue
        for i in IDIOMAS:
            arbs[i][clave] = textos[i]
        if textos.get("meta"):
            arbs["es"][f"@{clave}"] = textos["meta"]
        anadidas += 1
    for i in IDIOMAS:
        with open(RAIZ / f"lib/l10n/app_{i}.arb", "w", encoding="utf-8") as f:
            json.dump(arbs[i], f, ensure_ascii=False, indent=2)
            f.write("\n")
    print(f"{anadidas} claves añadidas a {len(IDIOMAS)} idiomas")


if __name__ == "__main__":
    main()
