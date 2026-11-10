# 🦉 Uilenschool

Educatieve game voor de **kleuterschool (1ste–3de kleuterklas)** en de **lagere school (1ste–6de leerjaar)**, afgestemd op de Vlaamse minimumdoelen basisonderwijs. Zie **[DOELEN.md](DOELEN.md)** voor het overzicht per klas met de decreetcodes.

- 9 klassen met Rekenen, Meten en meetkunde en Taal, plus Frans, Engels en Duits vanaf het 3de leerjaar.
- Elk spel: 5 vragen, alles wordt **voorgelezen**, 1–3 sterren, twee niveaus (⭐ begin / ⭐⭐ einde schooljaar).
- Volledig **offline**: één HTML-bestand, geen externe bibliotheken, geen tracking.

Eén spel, vier manieren om het te gebruiken. Ze delen allemaal dezelfde map `www/`.

| Manier | Voor wie | Hoe |
|---|---|---|
| 🌐 **Web-app (GitHub Pages)** | iPhone, iPad, Android, pc | link openen → *Zet op beginscherm* |
| 🤖 **Android-app (.apk)** | Android-tablets en -gsm's | automatisch gebouwd door GitHub |
| 🍏 **iPhone-app** | iPhone / iPad als echte app | Mac of Apple Developer-account nodig |
| 🏠 **NAS (VM of Docker)** | thuis- of klasnetwerk | `install-vm.sh` of `docker compose` |

```
www/          ← het spel (index.html) + web-app-bestanden — pas inhoud HIER aan
android/      ← Android-project (Capacitor)
ios/          ← Xcode-project (Capacitor)
assets/       ← bron voor app-icoon en opstartscherm
.github/      ← automatische bouw: web-app, Android-APK, iOS-test
Dockerfile, docker-compose.yml, install-vm.sh  ← NAS-installatie
```

---

## 🌐 Web-app via GitHub Pages (ook voor iPhone)

**Eenmalig instellen:** ga in deze repository naar **Settings › Pages** en kies bij *Source* voor **GitHub Actions**. Start daarna in het tabblad **Actions** de workflow *Web-app publiceren* (of push een wijziging in `www/`).

Het spel staat dan op **https://jellicvandenreyken.github.io/uilenschool/**

- **iPhone/iPad:** open de link in **Safari** › deel-knop › **Zet op beginscherm**. Het spel opent schermvullend met eigen icoon.
- **Android:** open in Chrome › menu ⋮ › **App installeren**.
- Na de eerste keer openen werkt het spel ook **zonder internet** (service worker `www/sw.js`).

> GitHub Pages werkt alleen bij een **publieke** repository, of een privé-repository met een betaald GitHub-abonnement.

## 🤖 Android-app (automatisch)

Bij elke push naar `main` bouwt GitHub de app. Ga naar **Actions › Android APK bouwen** › laatste run › onderaan **Uilenschool-android** (zip met `Uilenschool.apk`). Zet de APK op het toestel en tik erop; Android vraagt eenmalig om *installeren uit onbekende bronnen* toe te staan.

**Google Play Store?** Kan met een Play Console-account (eenmalig ±25 USD) en een ondertekende release-build. Een kinderapp valt onder het *Families*-beleid; omdat de app geen gegevens verzamelt is dat eenvoudig.

## 🍏 iPhone-app

Apple laat apps alleen op een iPhone installeren als ze **ondertekend** zijn.

| Wat je hebt | Wat kan je? |
|---|---|
| Niets extra | Gebruik de **web-app** hierboven, werkt prima op iPhone/iPad. |
| Een Mac + gratis Apple ID | `npm install` › `npm run ios` › in Xcode je Apple ID kiezen bij *Signing* › ▶️ op een aangesloten toestel. De app werkt 7 dagen, daarna opnieuw installeren. |
| Apple Developer Program (99 USD/jaar) | 1 jaar geldig, delen via **TestFlight** of publiceren in de **App Store**. Kan ook zonder eigen Mac: GitHub bouwt dan op een Mac in de cloud, met je certificaten als *Secrets* in de repository. |

De workflow **iOS testbouw** (handmatig te starten in *Actions*) controleert of de iPhone-app bouwt, zonder ondertekening. macOS-minuten zijn duurder, start hem dus alleen als je hem nodig hebt.

## 🏠 NAS

### Ubuntu/Debian-VM (bv. Synology Virtual Machine Manager)
```bash
git clone https://github.com/JellicVandenreyken/uilenschool.git
cd uilenschool
sudo bash install-vm.sh        # of: sudo bash install-vm.sh 8080
```
**Updaten:** `git pull` en `sudo bash install-vm.sh` opnieuw.

### Docker / Synology Container Manager
```bash
docker compose up -d --build   # daarna op http://IP:8080
```

---

## Aanpassen

- **Inhoud** (woordjes, rijmparen, beginklanken): bovenaan het script in `www/index.html` (`VOCAB`, `RHYMES`, `SOUNDS`, `ITEMS`). Pushen naar GitHub = web-app en Android-app worden automatisch bijgewerkt.
- Verhoog bij een wijziging `VERSION` in `www/sw.js`, zodat geïnstalleerde web-apps de nieuwe versie ophalen.
- **App-naam / ID**: `capacitor.config.json`. **Icoon / opstartscherm**: vervang de PNG's in `assets/` en voer `npm run icons` uit.

## Tips

- **Stem:** het voorlezen gebruikt de spraak van het toestel. Kies bij voorkeur een Vlaamse stem (nl-BE) via *Voor juf, meester en ouders › Stem*. Controleer of er een Nederlandse stem is geïnstalleerd: iPhone *Instellingen › Toegankelijkheid › Gesproken materiaal › Stemmen*, Android *Instellingen › Toegankelijkheid › Tekst-naar-spraak*.
- **Kind in de app houden:** iPad *Begeleide toegang*, Android *Scherm vastzetten*.
