# Discord Canary Installer pro Linux

Tento skript automatizuje instalaci Discord Canary na Linux s volitelnou podporou pro [Vencord](https://github.com/Vencord/Vencord), který umožňuje rozšířit funkce Discordu.

## Funkce

- Automatická instalace nejnovější verze Discord Canary
- Volitelná instalace rozšíření Vencord
- Vytvoření .desktop souboru pro snadné spuštění
- Interaktivní i neinteraktivní režim
- Kontrola verze a podpora aktualizací
- Automatická kontrola a instalace závislostí

## Požadavky

Skript automaticky zkontroluje a případně nainstaluje všechny potřebné závislosti:
- curl
- wget
- tar
- rsync
- nodejs (pouze pokud instalujete Vencord)

## Použití

Stáhněte skript a nastavte ho jako spustitelný:

```bash
chmod +x install.sh
```

### Příklady použití

**1. Interaktivní instalace (doporučeno pro nové uživatele)**

```bash
./install.sh
```

Skript vás provede celým procesem instalace.

**2. Rychlá instalace s Vencordem a .desktop souborem**

```bash
./install.sh --installVencord --createDesktop
```

**3. Instalace bez Vencordu**

```bash
./install.sh --skipVencord
```

**4. Instalace do vlastního adresáře**

```bash
./install.sh --installDirName=/cesta/k/instalaci
```

**5. Vynucená reinstalace (přepíše existující instalaci)**

```bash
./install.sh --force
```

**6. Kompletní vlastní instalace (neinteraktivní)**

```bash
./install.sh --installDirName=$HOME/Applications/DiscordCanary --installVencord --createDesktop --force
```

## Parametry příkazové řádky

- `--installDirName=CESTA` - Specifikuje instalační adresář (výchozí: $HOME/Programs/DiscordCanary)
- `--createDesktop` - Vytvoří .desktop soubor pro snadné spouštění
- `--skipVencord` - Přeskočí instalaci Vencordu
- `--installVencord` - Instaluje Vencord (výchozí)
- `--force` - Vynucená instalace (přepíše existující soubory)
- `--interactive` - Vynutí interaktivní režim
- `--help` - Zobrazí nápovědu

## Odinstalace

Pro odinstalaci Discord Canary a Vencord jednoduše odstraňte instalační adresář a .desktop soubor:

```bash
rm -rf ~/Programs/DiscordCanary
rm ~/.local/share/applications/discord-canary-vencord.desktop
```

## Licence

Tento skript je poskytován zdarma k použití, úpravám a redistribuci.