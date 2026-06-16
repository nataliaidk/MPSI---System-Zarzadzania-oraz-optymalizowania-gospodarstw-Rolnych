# ZAPYTANIE OFERTOWE
## RailTravel — Serwis Zarządzania Podróżą Kolejową
*(Konsorcjum Projektowe PKP i innych dostawców przewozów kolejowych)*  
Wrocław, marzec 2026

---

## 1. Zamawiający

*Zespół projektowy „RailTravel”*  
| Autorzy           | Indeks |
| ----------------- | ------ |
| Mieszko Szczekla  | 272688 |
| Mateusz Dejewski  | 272691 |
| Wiktor Piekarski  | 272726 |
| Mateusz Gawłowski | 264463 |

---

## 2. Opis aktualnego procesu biznesowego

Obecnie obsługa pasażerów, sprzedaż biletów oraz kontrola przejazdów u przewoźników kolejowych odbywa się w sposób rozproszony i zależny od wielu niespójnych narzędzi. Każdy przewoźnik utrzymuje własny system sprzedaży biletów oraz prezentacji rozkładu jazdy, co utrudnia pasażerom porównywanie ofert oraz zakup biletów na połączenia mieszane (różnych przewoźników).

**I — Zakup biletu przez pasażera**  (wyzwalacz: pasażer planuje podróż) 
1. Pasażer wyszukuje połączenia korzystając z różnych źródeł (Każdy przewoźnik posiada własny system sprzedaży).
2. Pasażer kupuje oddzielne bilety u różnych przewoźników nawet na jedno połączenie z przesiadką.
3. Rezerwacja miejsc zależy od przewoźnika.

![](BPMN/zakup_biletu.svg)

**II — Monitorowanie i publikacja opóźnień** (wyzwalacz: zgłoszenie opóźnienia)
1. Załoga lub dyspozytor ręcznie zgłasza opóźnienia.
2. Informacje trafiają do różnych systemów przewoźników i pkp.
3. Publikacja opóźnień odbywa się w wielu kanałach.

![](BPMN/sledzenie_opoznienia.svg)

**III — Kontrola biletów** (wyzwalacz: rozpoczęcie przejazdu, działanie konduktora)
1. Kontroler korzysta z czytnika QR i skanuje bilet.
2. System przewoźnika weryfikuje ważność biletu i wyświetla informacje o nim.

![](BPMN/kontrola_biletu.svg)

**IV — Edycja rozkładu jazdy** (wyzwalacz: zmiana operacyjna)
1. Przewoźnik przygotowuje zmiany w tabelach.
2. Dyspozytor weryfikuje poprawność danych - sprawdza czy są miejsca na stacjach, odcinkach trasy.
3. Aktualizacje trafiają do systemów wewnętrznych i są rozpowszechniane w różnych formach (np. stronach, papierowych rozkładach)

![](BPMN/edycja_rozkladu_jazdy.svg)


**Zidentyfikowane problemy:**

- brak jednego punktu zakupu biletów dla wielu przewoźników,
- brak centralnej rezerwacji miejsc zgodnej ze składem pociągu,
- brak geolokalizacji pociągów i automatycznego przetwarzania opóźnień,
- brak integracji procesu kontroli biletów i analizy ruchu pasażerów,
- wysoka pracochłonność i rozproszenie danych pomiędzy systemami przewoźników.

---

## 3. Uzasadnienie zapotrzebowania na dedykowany system

| System | Sprzedaż biletów wielu przewoźników | Obsługa planów miejsc | Informowanie o opóźnieniach | Śledzenie pociągów (GPS / real‑time) | Kontrola biletów – QR |
|--------|--------------------------------------|-------------------------|------------------------------|---------------------------------------|------------------------|
| *KOLEO* | Tak | Tak, ale nie zawsze | Nie | Nie  | Nie — generuje bilety, ale nie prowadzi systemu kontroli QR |
| *Portal Pasażera (PLK)* | Nie —  tylko wyszukiwarka połączeń | Brak | Tak | Częściowo - dla niewielu pociągów | Nie|
| *e-Podróżnik* | Tak | Nie | Nie | Nie | Nie |
| *mPay (bilety kolejowe)* | Tak | Brak | Nie | Nie | Nie |

Analiza dostępnych systemów wykazała, że choć istnieją aplikacje zbierające rozkłady jazdy i sprzedające bilety pojedynczych przewoźników, żadna nie oferuje *pełnej integracji*:

- sprzedaży biletów *wielu przewoźników* z jedną płatnością,
- *centralnej rezerwacji miejsc* na podstawie planu składu pociągu,
- *bieżącej geolokalizacji pociągów* z powiązaniem opóźnień,
- integracji z *urządzeniem IoT w pociągu* (GPS + GSM),
- systemu kontroli biletów opartego o szybki odczyt kodów QR,
- spójnego procesu obsługi pasażera i raportowania.

System dedykowany jest konieczny, aby zintegrować wiele rozproszonych obszarów w jednym spójnym ekosystemie.

---

## 4. Wymagania funkcjonalne

Wymagania opisano w formie historyjek użytkownika. Role: *Pasażer*, *Dyspozytor*, *Kontroler*, *Przewoźnik*.

### 4.1 Rozkład jazdy i planowanie podróży

| ID | Historyjka | Kryteria akceptacyjne |
|---|---|---|
| US-01 | Jako *pasażer* chcę przeglądać aktualny rozkład jazdy, aby zaplanować podróż. | 1. Rozkład jazdy ładuje się w czasie < 3 s. 2. Dane są zsynchronizowane z bazą przewoźników i odświeżane co najwyżej co 5 minut. 3. Wyświetlane są: przewoźnik, numer linii, stacje, godziny odjazdów i przyjazdów oraz ceny. |
| US-02 | Jako *pasażer* chcę wyszukać połączenie według trasy i czasu, aby wybrać najlepszą opcję. | 1. Wyszukiwarka przyjmuje stację początkową, docelową, liczbę i rodzaj pasażerów oraz preferowany czas odjazdu lub przyjazdu. 2. Wyniki wyświetlają się w czasie < 2 s. 3. Wyświetlane są przesiadki, czas podróży i przewoźnicy oraz ceny przejazdów. |
| US-03 | Jako *przewoźnik* chcę edytować rozkład jazdy, aby zmiany były natychmiast widoczne w systemie. | 1. Zmiana rozkładu przez przewoźnika jest widoczna dla pasażerów w czasie < 60 s. 2. Edycja wymaga uwierzytelnienia konta przewoźnika. 3. System zapisuje historię zmian z datą i autorem modyfikacji. 4. Nie można zapisać rozkładu z konfliktami czasowymi na tej samej linii. |

### 4.2 Sprzedaż biletów i rezerwacja miejsc

| ID | Historyjka | Kryteria akceptacyjne |
|---|---|---|
| US-04 | Jako *pasażer* chcę kupić bilet u wielu przewoźników w jednej transakcji, aby ułatwić podróż wielo-przewoźnikową. | 1. Koszyk może zawierać bilety wielu przewoźników na raz. 2. Płatność realizowana jest jedną transakcją. 3. Po pomyślnej płatności pasażer otrzymuje jeden bilet na daną podróż. 4. W przypadku błędu płatności żaden bilet nie jest wystawiony. |
| US-05 | Jako *pasażer* chcę wybrać miejsce na planie wagonu, aby dopasować komfort podróży. | 1. Wyświetlany jest interaktywny plan składu pociągu z podziałem na wagony i klasy. 2. Zajęte miejsca są oznaczone i niemożliwe do wyboru. 3. Wybrane miejsce jest rezerwowane natychmiast po potwierdzeniu zakupu. 4. Numer miejsca i wagonu widnieje na bilecie. |
| US-06 | Jako *przewoźnik* chcę dodawać i aktualizować ofertę przewozową, aby sprzedaż była aktualna. | 1. Przewoźnik może dodać nową trasę, cennik i dostępne klasy biletów. 2. Aktualizacja oferty jest widoczna w systemie sprzedaży w czasie < 5 minut. 3. Nie można aktywować oferty bez podania ceny oraz co najmniej jednej daty kursu. 4. System informuje o próbie zduplikowania istniejącej oferty. |

### 4.3 Informacje o opóźnieniach

| ID | Historyjka | Kryteria akceptacyjne |
|---|---|---|
| US-07 | Jako *pasażer* chcę otrzymywać powiadomienia o aktualnych opóźnieniach mojego pociągu w czasie rzeczywistym. | 1. Powiadomienie push/SMS jest wysyłane w ciągu 30 s od wykrycia opóźnienia > 5 minut. 2. Powiadomienie zawiera numer pociągu, aktualną stację i szacowany nowy czas przyjazdu. 3. Dane o opóźnieniu pochodzą z urządzenia IoT pokładowego. 4. Pasażer może wyłączyć powiadomienia dla wybranej podróży. |
| US-08 | Jako *dyspozytor* chcę widzieć geolokalizację pociągów na mapie, aby monitorować ruch. | 1. Mapa wyświetla pozycje wszystkich aktywnych pociągów, odświeżane co ≤ 60 s. 2. Pozycja pochodzi z modułu GPS+GSM pojazdu. 3. Kliknięcie ikony pociągu pokazuje szczegóły: numer, trasę, opóźnienie i prędkość. 4. Przy utracie sygnału GPS ikona pociągu jest wyróżniona jako „sygnał utracony". |
| US-09 | Jako *dyspozytor* chcę wprowadzać awarie i komunikaty specjalne, aby informować pasażerów. | 1. Dyspozytor może utworzyć komunikat przypisany do konkretnej linii lub stacji. 2. Komunikat jest widoczny dla pasażerów w aplikacji w czasie < 60 s od zapisania. 3. Komunikat zawiera obowiązkowe pola: tytuł, treść, czas obowiązywania. 4. Po upływie czasu obowiązywania komunikat jest automatycznie archiwizowany. |

### 4.4 Kontrola biletów

| ID | Historyjka | Kryteria akceptacyjne |
|---|---|---|
| US-10 | Jako *kontroler* chcę zeskanować kod QR biletu w czasie < 200 ms, aby przeprowadzać kontrolę szybciej. | 1. Czas od przyłożenia kodu QR do wyświetlenia wyniku nie przekracza 200 ms. 2. Skanowanie działa w trybie offline (weryfikacja na podstawie lokalnej kopii bazy). 3. Aplikacja działa poprawnie przy oświetleniu < 100 lx. 4. Błędny lub nieczytelny kod QR skutkuje komunikatem o błędzie w czasie < 500 ms. |
| US-11 | Jako *kontroler* chcę widzieć status biletu (ważny, nieważny, duplikat, zniżki), aby szybko informować pasażera. | 1. Ekran wyniku wyraźnie rozróżnia 4 stany: WAŻNY (zielony), NIEWAŻNY (czerwony), DUPLIKAT (pomarańczowy), ZNIŻKA (niebieski). 2. Dla statusu ZNIŻKA wyświetlany jest typ zniżki i wymagany dokument do okazania. 3. Status DUPLIKAT jest rejestrowany w systemie z datą, godziną i ID kontrolera. 4. Historia ostatnich 50 skanów jest dostępna offline na urządzeniu kontrolera. |
| US-12 | Jako *przewoźnik* chcę generować raporty sprzedaży i kontroli biletów, aby analizować obciążenie ruchu. | 1. Raport można wygenerować dla dowolnego zakresu dat z granulacją: dzień / tydzień / miesiąc. 2. Raport sprzedaży zawiera: liczbę biletów, przychód, podział na klasy i trasy. 3. Raport kontroli zawiera: liczbę skanowań, odsetek biletów nieważnych i duplikatów. 4. Raport można pobrać w formacie CSV i PDF. 5. Generowanie raportu za okres 30 dni zajmuje < 10 s. |

---

## 5. Wymagania niefunkcjonalne

| Obszar | Wymaganie |
|---|---|
| Dostępność | Web + mobile: dostępność ≥ 99,7% |
| Wydajność | Skan biletu < 200 ms; odświeżanie pozycji pociągu ≤ 60 s; wyszukiwanie połączeń < 2 s |
| Bezpieczeństwo | TLS 1.2+, SCA, zgodność z RODO |
| Integracja | Publiczne API REST, możliwość integracji z systemami przewoźników |
| IoT | Urządzenie pokładowe z GSM + GPS; transmisja danych ≤ 60 s |
| Skalowalność | Obsługa ≥ 10 mln pasażerów miesięcznie i 50 000 pociągów dziennie |

---

## 6. Wymagania wobec Oferenta

Oferent powinien wykazać:

- min. 3 wdrożone systemy webowo‑mobilne o wysokiej dostępności,
- doświadczenie w integracji z urządzeniami IoT (GPS + GSM),
- doświadczenie w pracy ze skanerami i kodami QR,
- możliwość prowadzenia projektu o złożonej integracji API.

---

## 7. Kryteria oceny ofert

| Kryterium | Waga |
|---|---|
| Cena | 35% |
| Jakość techniczna (architektura, cyberbezpieczeństwo, UX) | 30% |
| Harmonogram i propozycja MVP | 20% |
| Doświadczenie w systemach transportowych / IoT | 15% |

---

## 8. Oczekiwana zawartość oferty

1. Proponowana architektura systemu (model C4 lub komponenty).
2. Zakres MVP — w szczególności bilet + IoT + QR.
3. Harmonogram realizacji (np. roadmapa sprintowa).
4. Kosztorys z podziałem na etapy (fixed price / T&M — z uzasadnieniem).
5. Wykaz referencji i skład zespołu.
---

## 9. Warunki formalne

- *Termin składania ofert:* 30.04.2026, godz. 12:00
- *Forma:* elektroniczna na adres rfp@railtravel.eu
- *Termin związania ofertą:* 45 dni
- *Pytania do RFP:* do 20.04.2026

---