# Discord Canary + Vencord - Instalátor pro Linux

Jednoduchý a výkonný instalátor Discord Canary s možností instalace Vencord rozšíření pro Linux.

## Rychlý start - jediný příkaz

Pro rychlou instalaci přímo z GitHub můžete použít tento příkaz:

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash
```

Tím spustíte instalátor v interaktivním režimu, který vás provede celým procesem.

## Pokročilé příkazy

### Kompletní instalace s Vencordem a .desktop souborem

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --installVencord --createDesktop
```

### Instalace bez Vencordu

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --skipVencord
```

### Instalace do vlastního adresáře

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --installDirName=$HOME/Applications/DiscordCanary
```

### Vynucená reinstalace

```bash
curl -fsSL https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh | bash -s -- --force
```

## Funkce

* Automatická instalace nejnovější verze Discord Canary
* Volitelná instalace rozšíření Vencord
* Vytvoření .desktop souboru pro snadné spuštění
* Interaktivní i neinteraktivní režim
* Kontrola verze a podpora aktualizací
* Automatická kontrola a instalace závislostí

## Požadavky

Skript automaticky zkontroluje a případně nainstaluje všechny potřebné závislosti:

* curl
* wget
* tar
* rsync
* nodejs (pouze pokud instalujete Vencord)

## Použití přes stažení skriptu

Pokud preferujete nejprve stáhnout skript a pak jej spustit:

```bash
# Stažení skriptu
curl -fsSL -o install.sh https://raw.githubusercontent.com/patekcz/Tool-DiscordAndVencordInstaller/main/install.sh

# Nastavení oprávnění
chmod +x install.sh

# Spuštění skriptu
./install.sh
```

## Parametry příkazové řádky

* `--installDirName=CESTA` - Specifikuje instalační adresář (výchozí: $HOME/Programs/DiscordCanary)
* `--createDesktop` - Vytvoří .desktop soubor pro snadné spouštění
* `--skipVencord` - Přeskočí instalaci Vencordu
* `--installVencord` - Instaluje Vencord (výchozí)
* `--force` - Vynucená instalace (přepíše existující soubory)
* `--interactive` - Vynutí interaktivní režim
* `--help` - Zobrazí nápovědu

## Odinstalace

Pro odinstalaci Discord Canary a Vencord jednoduše odstraňte instalační adresář a .desktop soubor:

```bash
rm -rf ~/Programs/DiscordCanary
rm ~/.local/share/applications/discord-canary-vencord.desktop
```

## Licence

Tento skript je poskytován zdarma k použití, úpravám a redistribuci.