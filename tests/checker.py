import subprocess
from colorama import Fore, Style

class UnitTest:
    args = []
    expected_out = []
    description = ""

    def __init__(self, args, expected_out, description):
        self.args = args
        self.expected_out = expected_out
        self.description = description

        assert(len(self.args) % 2 == 1)


unit_tests = [
    
    UnitTest(
        [125, 100, 500, 4000, 300, 20000, 125, 30000, 345], 
        [
            "Mensagem 1: Cabe no Primeiro!",
            "Alocação no segmento 100: alocado do 100 byte ao 224 byte.",
        ],
        "Sample",
    ),

    UnitTest(
        [100, 1, 1],
        ["O programa não cabe na memória!"],
        "Input simples, nao cabe em nenhum",
    ),

    UnitTest(
        [100, 1, 100, 200, 1, 300, 1],
        [
            "Mensagem 1: Cabe no Primeiro!",
            "Alocação no segmento 1: alocado do 1 byte ao 100 byte.",
        ],
        "Cabe APENAS no primeiro",
    ),

    UnitTest(
        [100, 1, 1, 200, 100, 300, 1],
        [
            "Mensagem 2: Cabe no Segundo!",
            "Alocação no segmento 200: alocado do 200 byte ao 299 byte.",
        ],
        "Cabe APENAS no segundo",
    ),

    UnitTest(
        [100, 1, 1, 200, 1, 300, 100],
        [
            "Mensagem 3: Cabe no Terceiro!",
            "Alocação no segmento 300: alocado do 300 byte ao 399 byte.",
        ],
        "Cabe APENAS no terceiro",
    ),

    UnitTest(
        [100, 1, 1, 200, 1, 300, 1, 400, 100],
        [
            "Mensagem 4: Cabe no Quarto!",
            "Alocação no segmento 400: alocado do 400 byte ao 499 byte.",
        ],
        "Cabe APENAS no quarto",
    ),

    UnitTest(
        [100, 1, 50, 200, 50],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 50 byte.",
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte.",
        ],
        "Não cabe inteiramente em nenhum, precisa do primeiro e do segundo"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 25, 300, 25],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte.",
            "Alocação no segmento: 200, alocado do 200 byte ao 224 byte.",
            "Alocação no segmento: 300, alocado do 300 byte ao 324 byte.",
        ],
        "Usa todos os bytes dos 4 segumentos"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 50, 300, 25],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte.",
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte.",
        ],
        "Usa todos os bytes dos 3 primeiros segmentos"
    ),

    UnitTest(
        [100, 1, 25, 100, 99],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 174 byte.",
        ],
        "Usa o primeiro e o segundo"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 50],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte.",
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte.",
        ],
        "Usa o primeiro, segundo e terceiro"
    ),

    UnitTest(
        [81, 124, 27, 478, 3, 749, 50, 1000000, 1],
        [
            "Alocação no segmento: 124, alocado do 124 byte ao 150 byte.",
            "Alocação no segmento: 478, alocado do 478 byte ao 480 byte.",
            "Alocação no segmento: 749, alocado do 749 byte ao 798 byte.",
            "Alocação no segmento: 1000000, alocado do 1000000 byte ao 1000000 byte.",
        ],
        "Numeros aleatorios 01"
    ),

    UnitTest(
        [26, 3, 1, 19, 25],
        [
            "Alocação no segmento: 3, alocado do 3 byte ao 3 byte.",
            "Alocação no segmento: 19, alocado do 19 byte ao 43 byte.",
        ],
        "Numeros aleatorios 02"
    ),

    UnitTest(
        [786, 378, 146, 1567, 25],
        ["O programa não cabe na memória!"],
        "Numeros aleatorios 03"
    ),

    UnitTest(
        [1279, 45, 478, 1764, 2147],
        ["Mensagem 2: Cabe no Segundo!"],
        "Numeros aleatorios 04"
    ),

]

for i in range(len(unit_tests)):
    test = unit_tests[i]

    args_str = ' '.join(map(str, test.args))
    full_command = "../carregador " + args_str
    process = subprocess.run(full_command, shell=True, capture_output=True, text=True)
    
    output = process.stdout.strip().split("\n")

    parsed_out = []

    for o in output:
        parsed_out.append(o.replace("\x00", ""))

    result = Fore.GREEN + "Accepted!" + Style.RESET_ALL

    if test.expected_out != parsed_out:
        result = Fore.RED + "Wrong answer" + Style.RESET_ALL

    print(f"Test {i + 1} -> {test.description}: {result}")

    if test.expected_out != parsed_out:
        # print(f"\tOut = {output}, Expected = { test.expected_out }")
        exit(0)
