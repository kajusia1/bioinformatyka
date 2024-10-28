# zapisz cały dotychczasowo uruchamiany kod
# do pliku output/history.py
import os
os.makedirs('output', exist_ok=True)
%history -f output/history.py
# wykorzystaj funkcję print(),
# aby wyświetlić zawartość dokumentacyjnego
# ciągu tekstowego (docstring)
# funkcji print(), czyli ciąg zapisany
# w zmiennej print.__doc__

print(print.__doc__)
# a teraz wyświetl tę zawartość,
# stosując magiczną komendę %pdoc

%pdoc print
# spróbuj ponownie zrobić to samo,
# stosując skrót klawiaturowy Shift + Tab
# tuż po wpisaniu nazwy funkcji

print  # w vcs nie działa
# zaimportuj moduł numpy a następnie
# wyświetl pomoc do funkcji np.stack,
# stosując pojedynczy znak zapytania
# postawiony za nazwą funkcji

import numpy as np

np.stack?
# wyświetl pomoc do funkcji np.stack,
# tym razem korzystając z podwójnego
# znaku zapytania

np.stack??
# zapisz cały dotychczasowo uruchamiany kod
# do pliku output/history.py
import os
os.makedirs('output', exist_ok=True)
%history -f output/history.py
