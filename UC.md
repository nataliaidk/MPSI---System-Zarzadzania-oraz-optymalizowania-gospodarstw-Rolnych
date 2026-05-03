# Opis przypadków użycia systemu RailTravel

## 4.2 Sprzedaż biletów i rezerwacja miejsc

---

## UC-04: Zakup biletu wielo-przewoźnikowego

**Powiązana historia użytkownika:**  
Jako pasażer chcę kupić bilet u wielu przewoźników w jednej transakcji, aby ułatwić podróż wielo-przewoźnikową.

**Główny aktor:**  
Pasażer

**Warunki wstępne:**

- Pasażer wyszukał połączenie w wyszukiwarce.
- Wybrane połączenie składa się z co najmniej jednego odcinka trasy.

**Przepływ główny:**

1. Pasażer dodaje wybrane połączenie, które może zawierać wielu przewoźników, do koszyka.
2. System wyświetla podsumowanie koszyka z listą wszystkich odcinków i łączną kwotą.
3. Pasażer wybiera opcję „Przejdź do płatności”.
4. System przekierowuje do zewnętrznego operatora płatności.
5. Pasażer dokonuje płatności za całe zamówienie.
6. System otrzymuje potwierdzenie autoryzacji płatności.
7. System generuje jeden zbiorczy bilet elektroniczny lub pakiet biletów pod jednym identyfikatorem.
8. System wysyła bilet na adres e-mail pasażera i zapisuje go w jego koncie.

**Przepływy alternatywne:**

**A1: Nieudana autoryzacja płatności**

1. System otrzymuje informację o odrzuceniu transakcji.
2. System wyświetla komunikat o błędzie płatności.
3. System umożliwia ponowną próbę płatności lub powrót do koszyka.

**A2: Wygaśnięcie sesji lub rezerwacji w trakcie płatności**

1. Pasażer zwleka z płatnością zbyt długo.
2. System informuje o wygaśnięciu czasu na zakup i zwalnia zablokowane miejsca lub bilety.
3. Pasażer zostaje przekierowany do strony głównej wyszukiwarki.

**A3: Błąd komunikacji z API jednego z przewoźników**

1. System nie może potwierdzić rezerwacji u jednego z partnerów.
2. System automatycznie inicjuje zwrot środków, jeśli zostały pobrane.
3. Pasażer otrzymuje komunikat o braku możliwości wystawienia biletu zbiorczego i prośbę o kontakt z biurem obsługi.

**Warunki końcowe:**

- **Sukces:** Pasażer posiada ważny dokument podróży, np. plik PDF lub kod QR, środki zostały przekazane przewoźnikom, a transakcja widnieje w historii zamówień.
- **Błąd:** Środki nie zostają pobrane lub zostają zwrócone, a miejsca w pociągach pozostają wolne w systemie sprzedaży.

---

## UC-05: Wybór i rezerwacja miejsca na planie wagonu

**Powiązana historia użytkownika:**  
Jako pasażer chcę wybrać miejsce na planie wagonu, aby dopasować komfort podróży.

**Główny aktor:**  
Pasażer

**Warunki wstępne:**

- Pasażer jest w procesie zakupu biletu, przed płatnością.
- Przewoźnik udostępnia interaktywny plan składu pociągu.

**Przepływ główny:**

1. Pasażer wybiera opcję „Wybierz miejsce” przy konkretnym kursie.
2. System wyświetla interaktywny schemat składu pociągu z podziałem na wagony i klasy.
3. System oznacza miejsca zajęte jako nieaktywne i wolne jako możliwe do wyboru.
4. Pasażer klika w ikonę wybranego wolnego miejsca.
5. System wizualnie zatwierdza wybór i przypisuje numer miejsca do biletu w koszyku.
6. Pasażer zatwierdza wybór przyciskiem „Potwierdź wybór miejsc”.
7. System czasowo blokuje wybrane miejsca na czas trwania transakcji.
8. Po sfinalizowaniu płatności system trwale rezerwuje miejsca i nanosi ich numery na bilet.

**Przepływy alternatywne:**

**A1: Brak dostępności miejsc obok siebie dla biletów grupowych**

1. System informuje o braku wolnych miejsc w wybranym wagonie.
2. Pasażer zmienia wagon za pomocą nawigacji w schemacie składu.

**A2: Miejsce zajęte w ostatniej chwili**

1. W momencie kliknięcia w ikonę miejsca inny użytkownik zdążył już zablokować to miejsce.
2. System odświeża status miejsca na „zajęte”.
3. System wyświetla komunikat o konieczności wyboru innego fotela.

**A3: Przewoźnik nie udostępnia graficznego planu**

1. System zamiast mapy wyświetla listę preferencji, np. „okno”, „korytarz”, „miejsce przy stoliku”.
2. System automatycznie przydziela najlepsze dostępne miejsce na podstawie wybranych kryteriów.

**Warunki końcowe:**

- **Sukces:** Wybrane identyfikatory miejsc są powiązane z pozycją w koszyku i czasowo zablokowane w bazie danych pociągu ze statusem `pending`.
- **Błąd:** Miejsce nie zostaje przypisane, system wymusza ponowny wybór lub przydziela miejsce automatycznie, zależnie od konfiguracji.

---

## UC-06: Zarządzanie ofertą przewozową przez przewoźnika

**Powiązana historia użytkownika:**  
Jako przewoźnik chcę dodawać i aktualizować ofertę przewozową, aby sprzedaż była aktualna.

**Główny aktor:**  
Przewoźnik

**Warunki wstępne:**

- Użytkownik jest zalogowany z uprawnieniami przewoźnika.

**Przepływ główny:**

1. Przewoźnik wybiera opcję „Zarządzaj ofertą” w panelu administracyjnym.
2. System wyświetla listę aktualnych tras i kursów.
3. Przewoźnik wybiera opcję „Dodaj nową ofertę” lub edytuje istniejącą.
4. Przewoźnik definiuje parametry trasy, cennik dla poszczególnych klas oraz daty kursowania.
5. Przewoźnik zatwierdza zmiany przyciskiem „Zapisz i publikuj”.
6. System weryfikuje kompletność danych, np. czy podano cenę i datę, oraz sprawdza, czy oferta nie jest duplikatem.
7. System zapisuje zmiany w bazie danych.
8. System aktualizuje ofertę w module sprzedaży, widoczną dla pasażerów w ciągu mniej niż 5 minut.

**Przepływy alternatywne:**

**A1: Błędne dane wejściowe**

1. System wykrywa brak ceny lub ujemną wartość.
2. System podświetla pola z błędami na czerwono i blokuje przycisk „Zapisz”.
3. Przewoźnik koryguje dane i ponawia próbę.

**A2: Konflikt w rozkładzie jazdy**

1. System wykrywa, że na danej trasie o tej samej godzinie i tym samym numerze pociągu istnieje już aktywna oferta.
2. System odrzuca zapis i wyświetla komunikat o konflikcie z istniejącym kursem.

**A3: Usunięcie lub wyłączenie oferty z aktywną sprzedażą**

1. Przewoźnik próbuje usunąć ofertę, na którą sprzedano już bilety.
2. System blokuje usuwanie.
3. System sugeruje opcję „Wycofaj ze sprzedaży”, która blokuje nowe zakupy przy zachowaniu ważności już sprzedanych biletów.

**Warunki końcowe:**

- **Sukces:** Nowa lub zmodyfikowana oferta jest zapisana w bazie danych, posiada unikalny identyfikator i jest gotowa do wyświetlenia pasażerom.
- **Błąd:** Dane w bazie pozostają niezmienione, następuje rollback, a przewoźnik widzi komunikat o przyczynie niepowodzenia operacji.

---

## 4.3 Śledzenie opóźnień

---

## UC-07: Sprawdzenie aktualnego opóźnienia pociągu

**Powiązana historia użytkownika:**  
Jako pasażer chcę sprawdzić aktualne opóźnienie mojego pociągu, aby wiedzieć, czy podróż przebiega zgodnie z planem.

**Główny aktor:**  
Pasażer

**Warunki wstępne:**

- Pasażer ma dostęp do aplikacji lub serwisu RailTravel.
- Pasażer wybrał konkretną podróż lub wyszukał dany pociąg.
- System posiada aktualny rozkład jazdy dla wybranego kursu.
- System posiada ostatnie dane lokalizacyjne dla pociągu.

**Przepływ główny:**

1. Pasażer otwiera szczegóły wybranej podróży lub wyszukuje konkretny pociąg.
2. System pobiera aktualne dane o lokalizacji pociągu z systemu pozycjonowania.
3. System porównuje bieżącą lokalizację i czas przejazdu z rozkładem jazdy.
4. System wylicza aktualne opóźnienie oraz przewidywany czas przyjazdu.
5. System wyświetla pasażerowi status pociągu, aktualną lokalizację, wielkość opóźnienia i szacowany czas przyjazdu.
6. Pasażer zapoznaje się z informacją o statusie podróży.

**Przepływy alternatywne:**

**A1: Brak aktualnych danych lokalizacyjnych**

1. System informuje pasażera, że aktualna lokalizacja pociągu jest chwilowo niedostępna.
2. System wyświetla ostatni znany status pociągu lub informację wynikającą z rozkładu jazdy.

**A2: Nie odnaleziono wskazanego pociągu**

1. System informuje pasażera, że nie znaleziono kursu spełniającego podane kryteria.
2. Pasażer może ponowić wyszukiwanie.

**A3: Pociąg nie jest opóźniony**

1. System wyświetla informację, że pociąg jedzie zgodnie z rozkładem.
2. Pasażer kończy sprawdzanie statusu podróży.

**Warunki końcowe:**

- Pasażer otrzymuje aktualną informację o statusie pociągu albo komunikat o braku dostępnych danych.

---

## UC-08: Otrzymanie powiadomienia o opóźnieniu

**Powiązana historia użytkownika:**  
Jako pasażer chcę otrzymywać powiadomienia o aktualnych opóźnieniach mojego pociągu w czasie rzeczywistym.

**Główny aktor:**  
Pasażer

**Warunki wstępne:**

- System wykrył opóźnienie pociągu przekraczające ustalony próg.
- Pasażer posiada aktywny bilet na dany kurs lub obserwuje daną podróż.
- Pasażer ma włączone powiadomienia dla tej podróży.

**Przepływ główny:**

1. System identyfikuje pasażerów powiązanych z danym kursem.
2. System przygotowuje treść powiadomienia zawierającą numer pociągu, aktualną lokalizację lub stację, wielkość opóźnienia oraz przewidywany czas przyjazdu.
3. System wysyła powiadomienie push lub SMS do pasażera.
4. Pasażer odbiera powiadomienie.
5. Pasażer otwiera komunikat i zapoznaje się ze szczegółami opóźnienia.

**Przepływy alternatywne:**

**A1: Pasażer ma wyłączone powiadomienia**

1. System nie wysyła powiadomienia do pasażera.
2. Informacja o opóźnieniu pozostaje dostępna w szczegółach podróży.

**A2: Zmiana opóźnienia po wysłaniu komunikatu**

1. System ponownie wylicza opóźnienie i przewidywany czas przyjazdu.
2. Jeżeli zmiana jest istotna, system wysyła zaktualizowane powiadomienie do pasażera.

**Warunki końcowe:**

- Pasażer zostaje poinformowany o opóźnieniu pociągu albo informacja pozostaje dostępna w szczegółach podróży.

---

## 4.4 Kontrola biletów

---

## UC-09: Okaż bilet z kodem QR

**Powiązana historia użytkownika:**  
Jako pasażer chcę okazać bilet z kodem QR, aby umożliwić konduktorowi sprawdzenie ważności mojego biletu.

**Główny aktor:**  
Pasażer

**Aktorzy wspierający:**  
Konduktor

**Warunki wstępne:**

- Pasażer posiada bilet z kodem QR w formie elektronicznej lub papierowej.
- Pasażer znajduje się w pociągu podczas kontroli biletów.
- Konduktor rozpoczął procedurę kontroli biletów.

**Przepływ główny:**

1. Konduktor podchodzi do pasażera i prosi o okazanie biletu.
2. Pasażer przygotowuje bilet z kodem QR.
3. Pasażer okazuje kod QR konduktorowi.
4. Konduktor kieruje czytnik lub urządzenie mobilne na kod QR.
5. System umożliwia przejście do przypadku użycia „Zeskanuj kod QR”.
6. Pasażer oczekuje na wynik kontroli biletu.

**Przepływy alternatywne:**

**A1: Pasażer nie może znaleźć biletu**

1. Pasażer informuje konduktora, że nie może odnaleźć biletu.
2. Konduktor informuje pasażera o konieczności okazania biletu lub podjęcia dalszych działań zgodnie z regulaminem przewoźnika.
3. Proces kontroli dla tego pasażera może zostać oznaczony jako problematyczny.

**A2: Kod QR jest nieczytelny**

1. Pasażer okazuje bilet, ale kod QR jest uszkodzony, niewyraźny lub ekran urządzenia jest zbyt ciemny.
2. Konduktor prosi pasażera o poprawienie widoczności kodu lub okazanie innej wersji biletu.
3. Jeżeli kod nadal nie może zostać odczytany, konduktor podejmuje dalsze działania zgodnie z procedurą przewoźnika.

**A3: Pasażer nie posiada biletu**

1. Pasażer informuje, że nie posiada biletu.
2. Konduktor informuje pasażera o konieczności podjęcia dalszych działań, np. zakupu biletu, uiszczenia opłaty dodatkowej lub zgłoszenia sytuacji do systemu.
3. Proces nie przechodzi do skutecznej walidacji kodu QR.

**Warunki końcowe:**

- **Sukces:** Pasażer okazuje bilet z kodem QR, a konduktor może rozpocząć jego skanowanie.
- **Błąd:** Bilet nie zostaje okazany albo kod QR nie nadaje się do odczytu.

---

## UC-10: Zeskanuj kod QR

**Powiązana historia użytkownika:**  
Jako konduktor chcę zeskanować kod QR biletu, aby pobrać dane potrzebne do sprawdzenia ważności biletu.

**Główny aktor:**  
Konduktor

**Aktorzy wspierający:**  
Pasażer

**Warunki wstępne:**

- Pasażer okazał bilet z kodem QR.
- Konduktor posiada urządzenie umożliwiające skanowanie kodów QR.
- Aplikacja kontrolerska jest uruchomiona i gotowa do użycia.
- Kod QR jest widoczny dla urządzenia skanującego.

**Przepływ główny:**

1. Konduktor wybiera w systemie opcję skanowania biletu.
2. System uruchamia moduł skanowania kodu QR.
3. Konduktor kieruje urządzenie na kod QR okazany przez pasażera.
4. System odczytuje kod QR.
5. System przetwarza zawarte w kodzie dane identyfikujące bilet.
6. System przekazuje dane biletu do przypadku użycia „Sprawdź ważność biletu”.
7. Konduktor oczekuje na wynik sprawdzenia biletu.

**Przepływy alternatywne:**

**A1: Nie udało się odczytać kodu QR**

1. System nie rozpoznaje kodu QR.
2. System wyświetla komunikat o nieudanym skanowaniu.
3. Konduktor ponawia próbę skanowania.
4. Jeżeli problem nadal występuje, konduktor może zastosować procedurę alternatywną zgodną z zasadami przewoźnika.

**A2: Kod QR ma niepoprawny format**

1. System odczytuje kod QR, ale nie rozpoznaje go jako poprawnego biletu.
2. System informuje konduktora o błędnym lub nieobsługiwanym kodzie.
3. Konduktor informuje pasażera o problemie z biletem.
4. Proces może przejść do obsługi biletu nieważnego lub niepoprawnego.

**A3: Brak połączenia z systemem centralnym**

1. System odczytuje kod QR, ale nie może połączyć się z systemem centralnym.
2. System informuje konduktora o problemie technicznym.
3. Konduktor może ponowić próbę lub skorzystać z trybu awaryjnego, jeżeli jest dostępny.

**Warunki końcowe:**

- **Sukces:** Kod QR zostaje poprawnie odczytany, a dane biletu trafiają do procesu sprawdzania ważności.
- **Błąd:** Kod QR nie zostaje odczytany albo nie zawiera poprawnych danych biletu.

---

## UC-11: Sprawdź ważność biletu

**Powiązana historia użytkownika:**  
Jako konduktor chcę sprawdzić ważność biletu w systemie, aby ustalić, czy pasażer ma prawo kontynuować podróż na podstawie okazanego biletu.

**Główny aktor:**  
Konduktor

**Aktorzy wspierający:**  
Pasażer, system centralny

**Warunki wstępne:**

- Kod QR biletu został poprawnie zeskanowany.
- System posiada dane identyfikujące bilet.
- System ma dostęp do bazy danych biletów lub lokalnej kopii danych kontrolnych.
- Bilet może zostać jednoznacznie zidentyfikowany na podstawie danych z kodu QR.

**Przepływ główny:**

1. System odbiera dane biletu ze skanera kodu QR.
2. System wysyła żądanie sprawdzenia ważności biletu.
3. System centralny wyszukuje bilet w bazie danych.
4. System centralny sprawdza status biletu.
5. System centralny weryfikuje, czy bilet dotyczy właściwego połączenia, daty, trasy i ewentualnych uprawnień.
6. System zwraca wynik sprawdzenia do aplikacji konduktora.
7. Konduktor otrzymuje informację, czy bilet jest ważny.
8. W przypadku biletu ważnego proces może zostać rozszerzony o przypadek użycia „Potwierdź ważność biletu”.
9. W przypadku zakończenia kontroli proces może zostać rozszerzony o przypadek użycia „Utwórz raport z kontroli”.

**Przepływy alternatywne:**

**A1: Bilet nie istnieje w systemie**

1. System centralny nie znajduje biletu w bazie danych.
2. System zwraca informację o braku biletu.
3. Konduktor otrzymuje komunikat o niepoprawnym lub nieistniejącym bilecie.
4. Konduktor informuje pasażera o konieczności podjęcia dalszych działań.

**A2: Bilet jest nieważny**

1. System odnajduje bilet, ale jego status wskazuje na nieważność.
2. System zwraca informację o nieważnym bilecie.
3. Konduktor informuje pasażera o wyniku kontroli.
4. Konduktor podejmuje dalsze działania zgodnie z procedurą przewoźnika.

**A3: Bilet jest ważny, ale niezgodny z aktualnym przejazdem**

1. System odnajduje bilet.
2. System wykrywa niezgodność, np. inną trasę, datę, pociąg lub klasę.
3. System zwraca wynik negatywny z informacją o przyczynie.
4. Konduktor informuje pasażera o wykrytej niezgodności.

**A4: Błąd komunikacji z systemem centralnym**

1. System nie otrzymuje odpowiedzi z systemem centralnym.
2. System wyświetla komunikat o błędzie połączenia.
3. Konduktor ponawia próbę sprawdzenia biletu lub korzysta z trybu awaryjnego, jeżeli jest dostępny.

**Warunki końcowe:**

- **Sukces:** System ustala ważność biletu i przekazuje wynik konduktorowi.
- **Błąd:** Nie można jednoznacznie określić ważności biletu z powodu błędnych danych, braku biletu lub problemu technicznego.

---

## UC-12: Potwierdź ważność biletu

**Powiązana historia użytkownika:**  
Jako konduktor chcę potwierdzić ważność biletu, aby oznaczyć bilet jako sprawdzony i zakończyć kontrolę danego pasażera wynikiem pozytywnym.

**Główny aktor:**  
Konduktor

**Aktorzy wspierający:**  
System centralny

**Relacja z innym przypadkiem użycia:**  
Przypadek użycia rozszerza „Sprawdź ważność biletu”.

**Warunki wstępne:**

- Bilet został poprawnie zeskanowany.
- System sprawdził ważność biletu.
- Wynik sprawdzenia biletu jest pozytywny.
- Konduktor ma możliwość zatwierdzenia wyniku kontroli.

**Przepływ główny:**

1. System wyświetla konduktorowi pozytywny wynik walidacji biletu.
2. Konduktor wybiera opcję potwierdzenia ważności biletu.
3. System oznacza bilet jako sprawdzony.
4. System zapisuje wynik kontroli w historii biletu.
5. System aktualizuje status biletu w systemie centralnym.
6. Konduktor przechodzi do kontroli kolejnego pasażera albo kończy kontrolę.

**Przepływy alternatywne:**

**A1: Konduktor nie zatwierdza wyniku**

1. System wyświetla wynik pozytywny.
2. Konduktor nie potwierdza wyniku, np. z powodu dodatkowej weryfikacji.
3. System nie zmienia statusu biletu na sprawdzony.
4. Kontrola pozostaje niezakończona dla danego biletu.

**A2: Nie udało się zapisać potwierdzenia**

1. Konduktor potwierdza ważność biletu.
2. System próbuje zapisać status biletu jako sprawdzony.
3. Występuje błąd zapisu lub komunikacji z systemem centralnym.
4. System informuje konduktora o niepowodzeniu.
5. Konduktor może ponowić zapis lub kontynuować pracę w trybie awaryjnym.

**A3: Status biletu zmienia się w trakcie potwierdzania**

1. System początkowo zwraca wynik pozytywny.
2. Podczas zapisu statusu system wykrywa zmianę danych biletu.
3. System odrzuca potwierdzenie i wymaga ponownego sprawdzenia ważności biletu.

**Warunki końcowe:**

- **Sukces:** Bilet zostaje oznaczony jako ważny i sprawdzony, a wynik kontroli zostaje zapisany w systemie.
- **Błąd:** Potwierdzenie nie zostaje zapisane, a status biletu pozostaje niezmieniony lub wymaga ponownej walidacji.

---

## UC-13: Utwórz raport z kontroli

**Powiązana historia użytkownika:**  
Jako konduktor chcę utworzyć raport z kontroli, aby podsumować wykonane sprawdzenia biletów i przekazać ich wyniki do systemu centralnego.

**Główny aktor:**  
Konduktor

**Aktorzy wspierający:**  
System centralny

**Relacja z innym przypadkiem użycia:**  
Przypadek użycia rozszerza „Sprawdź ważność biletu”.

**Warunki wstępne:**

- Konduktor przeprowadził jedną lub więcej kontroli biletów.
- Wyniki kontroli zostały zapisane lokalnie lub w systemie centralnym.
- System posiada dane potrzebne do przygotowania raportu.
- Konduktor zakończył kontrolę lub chce wygenerować raport częściowy.

**Przepływ główny:**

1. Konduktor wybiera opcję utworzenia raportu z kontroli.
2. System pobiera zapisane wyniki kontroli biletów.
3. System agreguje dane dotyczące liczby sprawdzonych biletów.
4. System uwzględnia bilety ważne, nieważne, problematyczne oraz ewentualne błędy kontroli.
5. System generuje raport z kontroli.
6. Konduktor przegląda raport.
7. Konduktor zatwierdza raport.
8. System przesyła raport do systemu centralnego.
9. System centralny zapisuje raport i aktualizuje historię kontroli.

**Przepływy alternatywne:**

**A1: Brak danych do raportu**

1. Konduktor wybiera opcję utworzenia raportu.
2. System nie znajduje żadnych zapisanych wyników kontroli.
3. System informuje konduktora, że raport nie może zostać utworzony.
4. Konduktor wraca do kontroli lub kończy proces bez raportu.

**A2: Raport zawiera niepełne dane**

1. System wykrywa, że część wyników kontroli nie została zsynchronizowana.
2. System oznacza raport jako niepełny.
3. Konduktor może zatwierdzić raport częściowy albo ponowić synchronizację danych.
4. Po udanej synchronizacji system aktualizuje raport.

**A3: Nie udało się przesłać raportu do systemu centralnego**

1. Konduktor zatwierdza raport.
2. System próbuje przesłać raport do systemu centralnego.
3. Występuje błąd połączenia lub błąd zapisu.
4. System zapisuje raport lokalnie jako oczekujący na wysłanie.
5. System informuje konduktora, że raport zostanie przesłany po przywróceniu połączenia.

**A4: Konduktor odrzuca raport przed wysłaniem**

1. System generuje raport.
2. Konduktor zauważa niezgodność lub brakujące dane.
3. Konduktor anuluje zatwierdzenie raportu.
4. System umożliwia powrót do danych kontroli lub ponowne wygenerowanie raportu.

**Warunki końcowe:**

- **Sukces:** Raport z kontroli zostaje utworzony, zatwierdzony i zapisany w systemie centralnym.
- **Błąd:** Raport nie zostaje utworzony albo nie zostaje przesłany do systemu centralnego; system zapisuje go lokalnie lub wymaga ponowienia operacji.

---

## 4.5 Edycja rozkładu jazdy

---

## UC-14: Edycja rozkładu jazdy

**Powiązana historia użytkownika:**  
Jako dyspozytor chcę edytować rozkład jazdy w czasie rzeczywistym, aby dostosować ruch pociągów do nagłego zdarzenia operacyjnego i zapewnić płynność ruchu.

**Główny aktor:**  
Dyspozytor

**Warunki wstępne:**

- Dyspozytor jest zalogowany do systemu z uprawnieniami operacyjnymi.
- Nastąpił wyzwalacz: nagłe zdarzenie operacyjne, np. awaria lub zamknięcie toru, wymagające interwencji w bieżący rozkład.
- System posiada dostęp do mapy geolokalizacyjnej i aktualnych parametrów pociągów.

**Przepływ główny:**

1. Dyspozytor wyszukuje i wybiera pociąg, korzystając z mapy geolokalizacyjnej.
2. System wyświetla aktualny rozkład jazdy oraz bieżącą pozycję pociągu na trasie.
3. Dyspozytor edytuje parametry w rozkładzie, np. wprowadza wymuszone opóźnienie, objazd lub pominięcie stacji.
4. System weryfikuje zedytowany rozkład pod kątem potencjalnych konfliktów przestrzennych lub czasowych z innymi pociągami na trasie.
5. Dyspozytor zatwierdza edycję rozkładu jazdy.
6. System aktualizuje rozkład jazdy w centralnej bazie z wymogiem odświeżania danych w czasie poniżej 60 sekund.

**Przepływy alternatywne:**

**A1: Wykrycie konfliktu w ruchu**

1. System wstrzymuje aktualizację i informuje dyspozytora o kolizji z innym pociągiem.
2. Dyspozytor koryguje wprowadzane parametry, np. wydłuża czas przejazdu.
3. Dyspozytor ponawia próbę zapisu.

**A2: Całkowite odwołanie kursu**

1. Dyspozytor ze względu na powagę sytuacji operacyjnej zamiast edycji trasy oznacza pociąg jako odwołany.
2. System zwalnia trasę i usuwa kurs z aktywnych rozkładów.

**Warunki końcowe:**

- Rozkład jazdy dla danego pociągu zostaje zaktualizowany w systemie operacyjnym bez generowania konfliktów z innymi uczestnikami ruchu.

---

## UC-15: Wprowadzenie komunikatów o awariach

**Powiązana historia użytkownika:**  
Jako dyspozytor chcę wprowadzić komunikat specjalny o awarii, aby szybko poinformować pasażerów o zmianach organizacyjnych wynikających z edycji rozkładu.

**Główny aktor:**  
Dyspozytor

**Warunki wstępne:**

- Dyspozytor zedytował rozkład jazdy lub zidentyfikował awarię na trasie.
- System zidentyfikował pasażerów posiadających aktywne bilety na modyfikowany kurs.

**Przepływ główny:**

1. Dyspozytor wybiera opcję wprowadzania komunikatów specjalnych przypisanych do danej linii lub stacji.
2. Dyspozytor redaguje treść komunikatu, np. powód opóźnienia lub informację o uruchomieniu komunikacji zastępczej.
3. Dyspozytor zatwierdza nadanie komunikatu awaryjnego do systemu.
4. System automatycznie wysyła powiadomienia push lub SMS do przypisanych pasażerów z informacją o utrudnieniach i zmianach w podróży.
5. System wyświetla komunikat o awarii w szczegółach podróży w aplikacji oraz na tablicach informacyjnych.

**Przepływy alternatywne:**

**A1: Brak przypisanych pasażerów**

1. System nie generuje wysyłki powiadomień bezpośrednich, np. push lub SMS.
2. System publikuje komunikat na ogólnodostępnych tablicach stacyjnych i w wynikach wyszukiwania.

**Warunki końcowe:**

- Komunikat o awarii zostaje zarejestrowany w systemie, a pasażerowie otrzymują natychmiastowe powiadomienie o zmianach wynikających ze zdarzenia operacyjnego.
