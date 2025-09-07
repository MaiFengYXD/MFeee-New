local Original = {
    "Fetching translations for %s...",
    "Translator raw page error or HttpGet problem, please report it!",
    "Http Error: %s",
    "Missing 'HttpGet' function!",
    "Timeout! time exceeded 10 seconds.",
    "Translator:",
    "Failed to fetch translations for %s due to %s"
} :: {string} -- ["en-us"]

local BuiltInTranslationsTree = {
    ["sq-al"] = {
        "Po marr përkthime për %s...",
        "Gabim në faqen e papërpunuar të përkthimeve ose problem me HttpGet, ju lutemi raportojeni!",
        "Gabim HTTP: %s",
        "Mungon funksioni 'HttpGet'!",
        "Koha skadoi! Koha kaloi 10 sekonda.",
        "Përkthimet:",
        "Dështoi të marrë përkthimet për %s për shkak të %s"
    },
    ["ar-001"] = {
        "جاري جلب الترجمات لـ %s...",
        "خطأ في صفحة الترجمات الأولية أو مشكلة في HttpGet، الرجاء الإبلاغ عنها!",
        "خطأ HTTP: %s",
        "وظيفة 'HttpGet' مفقودة!",
        "انتهت المهلة! تجاوز الوقت 10 ثوانٍ.",
        "الترجمات:",
        "فشل في جلب الترجمات لـ %s بسبب %s"
    },
    ["bn-bd"] = {
        "অনুবাদ আনছে %s এর জন্য...",
        "অনুবাদ কাঁচা পৃষ্ঠার ত্রুটি বা HttpGet সমস্যা, অনুগ্রহ করে রিপোর্ট করুন!",
        "HTTP ত্রুটি: %s",
        "'HttpGet' ফাংশন অনুপস্থিত!",
        "সময় শেষ! 10 সেকেন্ড অতিক্রম করেছে।",
        "অনুবাদ:",
        "%s এর জন্য অনুবাদ আনতে ব্যর্থ হয়েছে কারণ %s"
    },
    ["nb-no"] = {
        "Henter oversettelser for %s...",
        "Feil på rå oversettelsesside eller HttpGet-problem, vennligst rapporter!",
        "Http-feil: %s",
        "Mangler 'HttpGet'-funksjon!",
        "Tidsavbrudd! Tiden overskred 10 sekunder.",
        "Oversettelser:",
        "Klarte ikke å hente oversettelser for %s på grunn av %s"
    },
    ["bs-ba"] = {
        "Dohvatanje prijevoda za %s...",
        "Greška na sirovoj stranici prijevoda ili problem sa HttpGet-om, molimo prijavite!",
        "HTTP greška: %s",
        "Nedostaje funkcija 'HttpGet'!",
        "Isteklo vrijeme! Prekoračeno je 10 sekundi.",
        "Prijevodi:",
        "Dohvatanje prijevoda za %s nije uspjelo zbog %s"
    },
    ["bg-bg"] = {
        "Извличане на преводи за %s...",
        "Грешка в необработената страница на преводите или проблем с HttpGet, моля, докладвайте!",
        "Http грешка: %s",
        "Липсва функцията 'HttpGet'!",
        "Изтече времето! Времето надвиши 10 секунди.",
        "Преводи:",
        "Неуспешно извличане на преводи за %s поради %s"
    },
    ["my-mm"] = {
        "%s အတွက် ဘာသာပြန်များကို ရယူနေသည်...",
        "ဘာသာပြန်အစိမ်းစာမျက်နှာ အမှား သို့မဟုတ် HttpGet ပြဿနာ၊ ကျေးဇူးပြု၍ သတင်းပို့ပါ!",
        "Http အမှား: %s",
        "'HttpGet' လုပ်ဆောင်ချက် ပျောက်ဆုံးနေသည်!",
        "အချိန်ကုန်! ၁၀ စက္ကန့် ကျော်လွန်သွားသည်။",
        "ဘာသာပြန်များ:",
        "%s အတွက် ဘာသာပြန်များကို ရယူရာတွင် %s ကြောင့် မအောင်မြင်ပါ။"
    },
    ["zh-cn"] = {
        "正在获取 %s 的翻译...",
        "翻译原始页面错误或 HttpGet 问题，请反馈！",
        "HTTP 错误: %s",
        "缺少 'HttpGet' 函数！",
        "超时！已超过 10 秒。",
        "翻译:",
        "获取 %s 的翻译失败，原因：%s"
    },
    ["zh-tw"] = {
        "正在獲取 %s 的翻譯...",
        "翻譯原始頁面錯誤或 HttpGet 問題，請回報！",
        "HTTP 錯誤: %s",
        "缺少 'HttpGet' 函數！",
        "逾時！已超過 10 秒。",
        "翻譯:",
        "獲取 %s 的翻譯失敗，原因：%s"
    },
    ["hr-hr"] = {
        "Dohvaćanje prijevoda za %s...",
        "Pogreška na sirovoj stranici prijevoda ili problem s HttpGet-om, molimo prijavite!",
        "Http pogreška: %s",
        "Nedostaje funkcija 'HttpGet'!",
        "Isteklo vrijeme! Prekoračeno je 10 sekundi.",
        "Prijevodi:",
        "Dohvaćanje prijevoda za %s nije uspjelo zbog %s"
    },
    ["cs-cz"] = {
        "Načítám překlady pro %s...",
        "Chyba na nezpracované stránce překladů nebo problém s HttpGet, nahlaste prosím!",
        "HTTP chyba: %s",
        "Chybí funkce 'HttpGet'!",
        "Vypršel časový limit! Překročeno 10 sekund.",
        "Překlady:",
        "Nepodařilo se načíst překlady pro %s z důvodu %s"
    },
    ["da-dk"] = {
        "Henter oversættelser for %s...",
        "Fejl på rå oversættelsesside eller HttpGet-problem, rapporter venligst!",
        "Http-fejl: %s",
        "Mangler 'HttpGet'-funktion!",
        "Timeout! Tiden overskred 10 sekunder.",
        "Oversættelser:",
        "Kunne ikke hente oversættelser for %s på grund af %s"
    },
    ["nl-nl"] = {
        "Vertalingen ophalen voor %s...",
        "Ruwe vertalingspaginafout of HttpGet-probleem, meld dit alstublieft!",
        "HTTP-fout: %s",
        "Functie 'HttpGet' ontbreekt!",
        "Time-out! Tijd overschreden 10 seconden.",
        "Vertalingen:",
        "Niet gelukt om vertalingen op te halen voor %s vanwege %s"
    },
    ["et-ee"] = {
        "Tõlkeid laaditakse %s jaoks...",
        "Tõlgete toorlehe viga või HttpGet probleem, palun teata sellest!",
        "HTTP viga: %s",
        "Puudub 'HttpGet' funktsioon!",
        "Aeg läbi! Aega ületati 10 sekundit.",
        "Tõlked:",
        "Tõlgete laadimine %s jaoks ebaõnnestus %s tõttu"
    },
    ["fil-ph"] = {
        "Kinukuha ang mga pagsasalin para sa %s...",
        "Mali ang raw page ng mga pagsasalin o may problema sa HttpGet, paki-ulat!",
        "HTTP Error: %s",
        "Nawawala ang function na 'HttpGet'!",
        "Time-out! Lumampas ng 10 segundo.",
        "Mga Pagsasalin:",
        "Hindi nakuha ang mga pagsasalin para sa %s dahil sa %s"
    },
    ["fi-fi"] = {
        "Haetaan käännöksiä kohteelle %s...",
        "Käännösten raakasivuvirhe tai HttpGet-ongelma, ilmoita siitä!",
        "HTTP-virhe: %s",
        "Puuttuu 'HttpGet'-funktio!",
        "Aikakatkaisu! Aika ylittyi 10 sekuntia.",
        "Käännökset:",
        "Käännösten haku epäonnistui kohteelle %s syystä %s"
    },
    ["fr-fr"] = {
        "Récupération des traductions pour %s...",
        "Erreur de page brute des traductions ou problème HttpGet, veuillez le signaler !",
        "Erreur HTTP: %s",
        "Fonction 'HttpGet' manquante !",
        "Délai d'attente dépassé ! Temps excédé de 10 secondes.",
        "Traductions :",
        "Échec de la récupération des traductions pour %s à cause de %s"
    },
    ["ka-ge"] = {
        "მიმდინარეობს თარგმანების მოძიება %s-სთვის...",
        "თარგმანების უმი გვერდის შეცდომა ან HttpGet პრობლემა, გთხოვთ შეატყობინოთ!",
        "HTTP შეცდომა: %s",
        "აკლია 'HttpGet' ფუნქცია!",
        "დროის ამოწურვა! დრომ გადააჭარბა 10 წამს.",
        "თარგმანები:",
        "თარგმანების მოძიება %s-სთვის ვერ მოხერხდა %s-ის გამო"
    },
    ["de-de"] = {
        "Übersetzungen für %s werden abgerufen...",
        "Rohdaten-Seitenfehler der Übersetzungen oder HttpGet-Problem, bitte melden!",
        "HTTP-Fehler: %s",
        "Funktion 'HttpGet' fehlt!",
        "Zeitüberschreitung! Zeit hat 10 Sekunden überschritten.",
        "Übersetzungen:",
        "Fehler beim Abrufen der Übersetzungen für %s aufgrund von %s"
    },
    ["el-gr"] = {
        "Ανάκτηση μεταφράσεων για %s...",
        "Σφάλμα ακατέργαστης σελίδας μεταφράσεων ή πρόβλημα HttpGet, παρακαλώ αναφέρετέ το!",
        "Σφάλμα HTTP: %s",
        "Λείπει η συνάρτηση 'HttpGet'!",
        "Χρονικό όριο! Ο χρόνος ξεπέρασε τα 10 δευτερόλεπτα.",
        "Μεταφράσεις:",
        "Αποτυχία ανάκτησης μεταφράσεων για %s λόγω %s"
    },
    ["hi-in"] = {
        "%s के लिए अनुवाद लाए जा रहे हैं...",
        "अनुवादों का कच्चा पृष्ठ त्रुटि या HttpGet समस्या, कृपया इसकी रिपोर्ट करें!",
        "Http त्रुटि: %s",
        "'HttpGet' फ़ंक्शन गायब है!",
        "समय समाप्त! 10 सेकंड से अधिक हो गया।",
        "अनुवाद:",
        "%s के लिए अनुवाद लाने में विफलता %s के कारण"
    },
    ["hu-hu"] = {
        "Fordítások letöltése ehhez: %s...",
        "Fordítások nyers oldalhiba vagy HttpGet probléma, kérjük jelentse!",
        "HTTP hiba: %s",
        "Hiányzik az 'HttpGet' funkció!",
        "Időtúllépés! Az idő túllépte a 10 másodpercet.",
        "Fordítások:",
        "A fordítások letöltése ehhez: %s sikertelen %s miatt"
    },
    ["id-id"] = {
        "Mengambil terjemahan untuk %s...",
        "Kesalahan halaman mentah terjemahan atau masalah HttpGet, harap laporkan!",
        "Kesalahan HTTP: %s",
        "Fungsi 'HttpGet' hilang!",
        "Waktu habis! Waktu melebihi 10 detik.",
        "Terjemahan:",
        "Gagal mengambil terjemahan untuk %s karena %s"
    },
    ["it-it"] = {
        "Recupero delle traduzioni per %s...",
        "Errore nella pagina raw delle traduzioni o problema HttpGet, si prega di segnalarlo!",
        "Errore HTTP: %s",
        "Funzione 'HttpGet' mancante!",
        "Timeout! Tempo superato di 10 secondi.",
        "Traduzioni:",
        "Impossibile recuperare le traduzioni per %s a causa di %s"
    },
    ["ja-jp"] = {
        "%s の翻訳を取得中...",
        "翻訳の生ページエラーまたは HttpGet の問題が発生しました。報告してください！",
        "HTTP エラー: %s",
        "'HttpGet' 関数が見つかりません！",
        "タイムアウト！10秒を超過しました。",
        "翻訳:",
        "%s の翻訳の取得に失敗しました。理由：%s"
    },
    ["kk-kz"] = {
        "%s үшін аудармалар алуда...",
        "Аудармалардың бастапқы бетінде қате немесе HttpGet мәселесі бар, хабарлаңыз!",
        "Http қатесі: %s",
        "'HttpGet' функциясы жоқ!",
        "Уақыт бітті! уақыт 10 секундтан асып кетті.",
        "Аудармалар:",
        "%s үшін аудармаларды алу %s себебінен сәтсіз аяқталды"
    },
    ["km-kh"] = {
        "កំពុងយកការបកប្រែសម្រាប់ %s...",
        "មានកំហុសទំព័រដើមនៃការបកប្រែ ឬបញ្ហា HttpGet សូមរាយការណ៍!",
        "កំហុស Http: %s",
        "បាត់ 'HttpGet' function!",
        "អស់ពេល! លើសពី 10 វិនាទី។",
        "ការបកប្រែ:",
        "មិនអាចយកការបកប្រែសម្រាប់ %s បានទេ ដោយសារ %s"
    },
    ["ko-kr"] = {
        "%s에 대한 번역을 가져오는 중...",
        "번역 원시 페이지 오류 또는 HttpGet 문제, 보고해주세요!",
        "HTTP 오류: %s",
        "'HttpGet' 함수가 없습니다!",
        "시간 초과! 10초를 초과했습니다.",
        "번역:",
        "%s에 대한 번역을 가져오지 못했습니다. 원인: %s"
    },
    ["lv-lv"] = {
        "Iegūst tulkojumus priekš %s...",
        "Tulkojumu neapstrādātas lapas kļūda vai HttpGet problēma, lūdzu, ziņojiet!",
        "HTTP kļūda: %s",
        "Trūkst 'HttpGet' funkcijas!",
        "Laika ierobežojums! Laiks pārsniedza 10 sekundes.",
        "Tulkojumi:",
        "Neizdevās iegūt tulkojumus priekš %s dēļ %s"
    },
    ["lt-lt"] = {
        "Gaunami vertimai %s...",
        "Vertimų neapdoroto puslapio klaida arba HttpGet problema, prašome pranešti!",
        "HTTP klaida: %s",
        "Trūksta 'HttpGet' funkcijos!",
        "Laikas baigėsi! Laikas viršijo 10 sekundžių.",
        "Vertimai:",
        "Nepavyko gauti vertimų %s dėl %s"
    },
    ["ms-my"] = {
        "Sedang mengambil terjemahan untuk %s...",
        "Ralat halaman mentah terjemahan atau masalah HttpGet, sila laporkan!",
        "Ralat HTTP: %s",
        "Fungsi 'HttpGet' tiada!",
        "Masa tamat! Masa melebihi 10 saat.",
        "Terjemahan:",
        "Gagal mengambil terjemahan untuk %s disebabkan oleh %s"
    },
    ["pl-pl"] = {
        "Pobieranie tłumaczeń dla %s...",
        "Błąd surowej strony tłumaczeń lub problem z HttpGet, prosimy zgłosić!",
        "Błąd HTTP: %s",
        "Brak funkcji 'HttpGet'!",
        "Przekroczono limit czasu! Czas przekroczył 10 sekund.",
        "Tłumaczenia:",
        "Nie udało się pobrać tłumaczeń dla %s z powodu %s"
    },
    ["pt-br"] = {
        "Buscando traduções para %s...",
        "Erro na página bruta de traduções ou problema HttpGet, por favor, relate!",
        "Erro HTTP: %s",
        "Função 'HttpGet' ausente!",
        "Tempo esgotado! O tempo excedeu 10 segundos.",
        "Traduções:",
        "Falha ao buscar traduções para %s devido a %s"
    },
    ["ro-ro"] = {
        "Se preiau traducerile pentru %s...",
        "Eroare la pagina brută a traducerilor sau problemă HttpGet, vă rugăm să raportați!",
        "Eroare HTTP: %s",
        "Lipsește funcția 'HttpGet'!",
        "Timp expirat! Timpul a depășit 10 secunde.",
        "Traduceri:",
        "Eșec la preluarea traducerilor pentru %s din cauza %s"
    },
    ["ru-ru"] = {
        "Получение переводов для %s...",
        "Ошибка на исходной странице переводов или проблема с HttpGet, пожалуйста, сообщите!",
        "Ошибка HTTP: %s",
        "Отсутствует функция 'HttpGet'!",
        "Тайм-аут! Время превысило 10 секунд.",
        "Переводы:",
        "Не удалось получить переводы для %s из-за %s"
    },
    ["sr-rs"] = {
        "Преузимање превода за %s...",
        "Грешка на сировој страници превода или проблем са HttpGet-ом, молимо пријавите!",
        "ХТТП грешка: %s",
        "Недостаје функција 'HttpGet'!",
        "Време истекло! Време је прекорачило 10 секунди.",
        "Преводи:",
        "Преузимање превода за %s није успело због %s"
    },
    ["si-lk"] = {
        "%s සඳහා පරිවර්තන ලබා ගනිමින්...",
        "පරිවර්තනවල අමු පිටු දෝෂයක් හෝ HttpGet ගැටලුවක්, කරුණාකර වාර්තා කරන්න!",
        "HTTP දෝෂය: %s",
        "'HttpGet' කාර්යය නැත!",
        "කාලය ඉක්ම ගොස් ඇත! තත්පර 10 ක් ඉක්මවා ඇත.",
        "පරිවර්තන:",
        "%s සඳහා පරිවර්තන ලබා ගැනීමට නොහැකි විය %s නිසා"
    },
    ["sk-sk"] = {
        "Načítavam preklady pre %s...",
        "Chyba na neupravenej stránke prekladov alebo problém s HttpGet, prosím, nahláste to!",
        "HTTP chyba: %s",
        "Chýba funkcia 'HttpGet'!",
        "Časový limit! Čas prekročil 10 sekúnd.",
        "Preklady:",
        "Nepodarilo sa načítať preklady pre %s z dôvodu %s"
    },
    ["sl-sl"] = {
        "Pridobivanje prevodov za %s...",
        "Napaka surove strani prevodov ali težava z HttpGet, prosimo, prijavite!",
        "HTTP napaka: %s",
        "Manjka funkcija 'HttpGet'!",
        "Časovna omejitev! Čas je presegel 10 sekund.",
        "Prevodi:",
        "Pridobivanje prevodov za %s ni uspelo zaradi %s"
    },
    ["es-es"] = {
        "Obteniendo traducciones para %s...",
        "Error en la página de traducciones o problema de HttpGet, ¡por favor, repórtalo!",
        "Error HTTP: %s",
        "¡Falta la función 'HttpGet'!",
        "¡Tiempo agotado! Se excedieron 10 segundos.",
        "Traducciones:",
        "Error al obtener traducciones para %s debido a %s"
    },
    ["sv-se"] = {
        "Hämtar översättningar för %s...",
        "Fel på rå översättningssida eller HttpGet-problem, vänligen rapportera det!",
        "Http-fel: %s",
        "Saknar 'HttpGet'-funktion!",
        "Tidsgräns! Tiden överskred 10 sekunder.",
        "Översättningar:",
        "Misslyckades med att hämta översättningar för %s på grund av %s"
    },
    ["th-th"] = {
        "กำลังดึงการแปลสำหรับ %s...",
        "ข้อผิดพลาดหน้าเว็บแปลดิบหรือปัญหา HttpGet โปรดรายงาน!",
        "ข้อผิดพลาด Http: %s",
        "ฟังก์ชัน 'HttpGet' หายไป!",
        "หมดเวลา! เกิน 10 วินาที",
        "การแปล:",
        "ไม่สามารถดึงการแปลสำหรับ %s ได้เนื่องจาก %s"
    },
    ["tr-tr"] = {
        "%s için çeviriler getiriliyor...",
        "Çeviri ham sayfa hatası veya HttpGet problemi, lütfen bildirin!",
        "HTTP Hatası: %s",
        "'HttpGet' fonksiyonu eksik!",
        "Zaman aşımı! Süre 10 saniyeyi aştı.",
        "Çeviriler:",
        "%s için çeviriler alınamadı, neden: %s"
    },
    ["uk-ua"] = {
        "Отримання перекладів для %s...",
        "Помилка сирої сторінки перекладів або проблема HttpGet, будь ласка, повідомте!",
        "Помилка HTTP: %s",
        "Відсутня функція 'HttpGet'!",
        "Тайм-аут! Час перевищив 10 секунд.",
        "Переклади:",
        "Не вдалося отримати переклади для %s через %s"
    },
    ["vi-vn"] = {
        "Đang lấy bản dịch cho %s...",
        "Lỗi trang thô bản dịch hoặc lỗi HttpGet, vui lòng báo cáo!",
        "Lỗi HTTP: %s",
        "Thiếu hàm 'HttpGet'!",
        "Hết giờ! Đã quá 10 giây.",
        "Bản dịch:",
        "Không thể lấy bản dịch cho %s do %s"
    }
} :: {[LocaleID]: {string}}

return Original, BuiltInTranslationsTree
