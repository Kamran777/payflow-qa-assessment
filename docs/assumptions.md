# PayFlow | Açıq suallar və ilkin fərziyyələr

Bu siyahı **təsdiqlənmiş məhsul qaydaları deyil**. Yekun PDF-də `BLOCKED` işarəsi həmin testin gözlənilən nəticəsində PO/developer qərarının çatışmadığını göstərir. Testlər icra olunmayıb (`Not Run`).

| ID | Dəqiqləşdirilməli məsələ | Təsdiqə qədər QA yanaşması |
| --- | --- | --- |
| A-01 | 0,5% komissiya necə yuvarlaqlaşdırılır? | İki onluq yerə `ROUND_HALF_UP` fərziyyəsi ilə sərhəd testləri hazırlamaq. |
| A-02 | Gündəlik limit hansı saat qurşağına əsasən 00:00-da sıfırlanır? | `Asia/Baku` fərziyyəsi; idarə olunan saatla yoxlamaq. |
| A-03 | Uğursuz debit üçün `REVERSED` statusu və tam refund nə vaxt tamamlanmalıdır? | Maliyyə balansının yekunda credit və ya tam refund ilə bağlandığını yoxlamaq; SLA qərarı gözlənir. |
| A-04 | `PENDING` və sonradan `REVERSED` olmuş əməliyyatlar gündəlik limitə necə təsir edir? | Limitin xərclənmə/geri qaytarılma anını ayrıca test etmək; hesablamanı biznes faktı kimi qəbul etməmək. |
| A-05 | SMS OTP kodunun müddəti, təkrar göndərilməsi və yenidən istifadəsi necə işləyir? | 300 AZN-dən yuxarı məbləğdə OTP tələbini yoxlamaq; TTL/resend/replay iddialarını bloklu saxlamaq. |
| A-06 | Üç yanlış OTP-dən sonrakı 30 dəqiqəlik blok hansı səviyyəyə aiddir? | OTP təsdiqi bloku ilə bütün köçürmə funksiyasının blokunu fərqləndirmək. |
| A-07 | OTP tələb olunduğu halda kod göndərilməyəndə API hansı HTTP statusunu qaytarır? | Təsdiq olmadan konkret HTTP kodu üzrə pass/fail yazmamaq (`TC-10`). |
| A-08 | Eyni `Idempotency-Key` fərqli JSON gövdəsi ilə gələndə dəqiq cavab necə olmalıdır? | Yeni köçürmə/debit olmamalıdır; cavabın statusu və gövdəsi PO qərarıdır (`TC-19`). |
| A-09 | İdempotency açarının tam 24-cü saatında və sonra davranış necədir? | Dəqiq saatla `T0+23:59:59`, `T0+24:00:00` sərhədlərini yoxlamaq (`TC-20`). |
| A-10 | `201` cavabı `PENDING` qaytara bilərmi; vəziyyəti sorğulamaq üçün ayrıca API varmı? | Status dəyişməsini ledger və razılaşdırılmış endpoint vasitəsilə test etmək. |
| A-11 | Eyni sorğuda OTP və gündəlik limit kimi birdən çox validasiya xətası olduqda prioritet hansıdır? | Qərar cədvəlində rədd nəticəsini yoxlamaq, dəqiq kod seçimini təsdiqə saxlamaq. |
| A-12 | Alıcının push bildirişi və hər iki PDF qəbzin çatdırılma müddəti neçədir? | Tək dəfə göndərilmə və düzgün məzmunu yoxlamaq; çatdırılma SLA-sını bloklu saxlamaq (`TC-24`). |
| A-13 | `note` sahəsinin maksimum 100 simvolu Unicode üçün necə sayılır? | ASCII və Unicode (o cümlədən emoji) testləri hazırlamaq; hesablamanı təsdiqlətmək (`TC-25`). |

## Qeyd

- `KYC` — müştərinin şəxsiyyət təsdiqi; təsdiqsiz gündəlik limit 200 AZN, təsdiqli limit 1000 AZN.
- `K` — UUID v4 formatlı `Idempotency-Key`, yəni təkrar sorğu açarı.
- `T0` — həmin açarla ilk POST sorğusunun göndərildiyi vaxt.
- Bir əməliyyatda `amount + fee` göndərənin balansından çıxılır və gündəlik limitə daxil edilir.
- İnkişaf etməmiş və ya sonradan kompensasiya edilən əməliyyatın faktiki maliyyə vəziyyəti yoxlanmadan refund ikinci dəfə edilməməlidir.
