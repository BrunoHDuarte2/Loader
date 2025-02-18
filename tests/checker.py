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
        ["Mensagem 1: Cabe no Primeiro!"],
        "Sample"
    ),

    UnitTest(
        [100, 1, 1],
        ["O programa não cabe na memória!"],
        "Input simples, nao cabe em nenhum"
    ),

    UnitTest(
        [100, 1, 100, 200, 1, 300, 1],
        ["Mensagem 1: Cabe no Primeiro!"],
        "Cabe APENAS no primeiro"
    ),

    UnitTest(
        [100, 1, 1, 200, 100, 300, 1],
        ["Mensagem 2: Cabe no Segundo!"],
        "Cabe APENAS no segundo"
    ),

    UnitTest(
        [100, 1, 1, 200, 1, 300, 100],
        ["Mensagem 3: Cabe no Terceiro!"],
        "Cabe APENAS no terceiro"
    ),

    UnitTest(
        [100, 1, 1, 200, 1, 300, 1, 400, 100],
        ["Mensagem 4: Cabe no Quarto!"],
        "Cabe APENAS no quarto"
    ),

    UnitTest(
        [100, 1, 50, 200, 50],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 50 byte.",
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte."
        ],
        "Não cabe inteiramente em nenhum, precisa do primeiro e do segundo"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 25, 300, 25],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte."
            "Alocação no segmento: 200, alocado do 200 byte ao 224 byte."
            "Alocação no segmento: 300, alocado do 300 byte ao 324 byte."
        ],
        "Usa todos os bytes dos 4 segumentos"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 50, 300, 25],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte."
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte."
        ],
        "Usa todos os bytes dos 3 primeiros segmentos"
    ),

    UnitTest(
        [100, 1, 25, 100, 99],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 174 byte."
        ],
        "Usa o primeiro e o segundo"
    ),

    UnitTest(
        [100, 1, 25, 100, 25, 200, 50],
        [
            "Alocação no segmento: 1, alocado do 1 byte ao 24 byte.",
            "Alocação no segmento: 100, alocado do 100 byte ao 124 byte."
            "Alocação no segmento: 200, alocado do 200 byte ao 249 byte."
        ],
        "Usa o primeiro, segundo e terceiro"
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

    # if test.expected_out != parsed_out:
        # print(f"\tOut = {output}, Expected = { test.expected_out }")
