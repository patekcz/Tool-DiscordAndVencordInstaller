# Barvy pro terminál
if [[ $TERM == *"color"* ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  MAGENTA='\033[0;35m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  MAGENTA=''
  CYAN=''
  BOLD=''
  NC=''
fi

# Výchozí konfigurace
DEFAULT_INSTALL_DIR="$HOME/Programs/DiscordCanary"
DEFAULT_CREATE_DESKTOP=false
DEFAULT_INSTALL_VENCORD=true
DEFAULT_VENCORD_URL="https://github.com/Vencord/Installer/releases/latest/download/VencordInstallerCli-linux"

# Inicializace proměnných
INSTALL_DIR="$DEFAULT_INSTALL_DIR"
CREATE_DESKTOP=$DEFAULT_CREATE_DESKTOP
INSTALL_VENCORD=$DEFAULT_INSTALL_VENCORD
INTERACTIVE=true
FORCE_INSTALL=false
FORCE_VENCORD=false

# Funkce pro vypsání boxu
print_box() {
  local message="$1"
  local width=50
  local padding=$(( (width - ${#message}) / 2 ))
  
  echo -e "${BLUE}╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
  echo -e "${BLUE}║${NC}$(printf ' %.0s' $(seq 1 $padding))${BOLD}$message${NC}$(printf ' %.0s' $(seq 1 $((width - ${#message} - padding))))${BLUE}║${NC}"
  echo -e "${BLUE}╚$(printf '═%.0s' $(seq 1 $width))╝${NC}"
}

# Funkce pro vypsání sekce
print_section() {
  local title="$1"
  echo -e "\n${CYAN}${BOLD}=== $title ===${NC}\n"
}

# Funkce pro vypsání kroku
print_step() {
  local step="$1"
  echo -e "${GREEN}➤ $step${NC}"
}

# Funkce pro vypsání chyby
print_error() {
  local error="$1"
  echo -e "${RED}✗ $error${NC}"
}

# Funkce pro vypsání varování
print_warning() {
  local warning="$1"
  echo -e "${YELLOW}⚠ $warning${NC}"
}

# Funkce pro vypsání úspěchu
print_success() {
  local message="$1"
  echo -e "${GREEN}✓ $message${NC}"
}

# Funkce pro kontrolu závislostí
check_dependency() {
  local cmd="$1"
  local package="$2"
  local install_cmd="$3"
  
  if ! command -v "$cmd" &> /dev/null; then
    print_warning "$cmd není nainstalován. Je vyžadován pro instalaci."
    if [ "$INTERACTIVE" = true ]; then
      read -p "Chcete nainstalovat $package? (ano/ne) [ano]: " install_dep
      if [[ -z "$install_dep" || "$install_dep" =~ ^[Aa][Nn][Oo]$ ]]; then
        print_step "Instaluji $package..."
        eval "$install_cmd" || { print_error "Nepodařilo se nainstalovat $package."; exit 1; }
      else
        print_error "$package je vyžadován pro pokračování. Instalace se ukončuje."
        exit 1
      fi
    else
      print_error "$package je vyžadován pro pokračování. Instalace se ukončuje."
      exit 1
    fi
  fi
}

# Zpracování parametrů příkazové řádky
for arg in "$@"; do
  case $arg in
    --installDirName=*)
      INSTALL_DIR="${arg#*=}"
      INTERACTIVE=false
      ;;
    --createDesktop)
      CREATE_DESKTOP=true
      INTERACTIVE=false
      ;;
    --skipDesktop)
      CREATE_DESKTOP=false
      INTERACTIVE=false
      ;;
    --skipVencord)
      INSTALL_VENCORD=false
      INTERACTIVE=false
      ;;
    --installVencord)
      INSTALL_VENCORD=true
      INTERACTIVE=false
      ;;
    --force)
      FORCE_INSTALL=true
      ;;
    --forceVencord)
      FORCE_VENCORD=true
      ;;
    --interactive)
      INTERACTIVE=true
      ;;
    --help)
      echo -e "${BOLD}Použití: install.sh [parametry]${NC}"
      echo -e "${BOLD}Parametry:${NC}"
      echo "  --installDirName=CESTA    Specifikuje instalační adresář (výchozí: $DEFAULT_INSTALL_DIR)"
      echo "  --createDesktop           Vytvoří .desktop soubor pro snadné spouštění"
      echo "  --skipDesktop             Přeskočí vytvoření .desktop souboru"
      echo "  --skipVencord             Přeskočí instalaci Vencordu"
      echo "  --installVencord          Instaluje Vencord (výchozí)"
      echo "  --force                   Vynucená instalace (přepíše existující soubory)"
      echo "  --forceVencord            Vynucená reinstalace Vencordu"
      echo "  --interactive             Vynutí interaktivní režim i při použití dalších parametrů"
      echo "  --help                    Zobrazí tuto nápovědu"
      echo ""
      echo "Bez parametrů se spustí interaktivní režim."
      exit 0
      ;;
  esac
done

# Konfigurace URLs a cest
URL="https://discord.com/api/download/canary?platform=linux&format=tar.gz"
VERSION_FILE="$HOME/.discord_canary_version.txt"
DOWNLOAD_DIR="$(mktemp -d)"
DOWNLOAD_FILE="$DOWNLOAD_DIR/discord-canary.tar.gz"
VENCORD_DIR="$DOWNLOAD_DIR/VencordInstaller"
VENCORD_CLI="$VENCORD_DIR/VencordInstallerCli-linux"
VENCORD_SCRIPT="$VENCORD_DIR/InstallVencord.js"

# Uvítací zpráva
clear
print_box "Discord Canary Installer"
echo ""
echo -e "${BOLD}Tento skript nainstaluje Discord Canary s volitelným Vencord rozšířením.${NC}"
echo ""

# Kontrola závislostí
print_section "Kontrola závislostí"

check_dependency "curl" "curl" "sudo apt-get install -y curl || sudo dnf install -y curl || sudo pacman -S --noconfirm curl"
check_dependency "wget" "wget" "sudo apt-get install -y wget || sudo dnf install -y wget || sudo pacman -S --noconfirm wget"
check_dependency "tar" "tar" "sudo apt-get install -y tar || sudo dnf install -y tar || sudo pacman -S --noconfirm tar"
check_dependency "rsync" "rsync" "sudo apt-get install -y rsync || sudo dnf install -y rsync || sudo pacman -S --noconfirm rsync"

if [ "$INSTALL_VENCORD" = true ]; then
  check_dependency "node" "nodejs" "sudo apt-get install -y nodejs || sudo dnf install -y nodejs || sudo pacman -S --noconfirm nodejs"
fi

# Interaktivní režim, pokud nebyl zadán žádný parametr nebo byl vynucen
if [ "$INTERACTIVE" = true ]; then
  print_section "Konfigurace instalace"
  
  echo -e "Zadej cestu pro instalaci Discord Canary ${YELLOW}[$DEFAULT_INSTALL_DIR]${NC}: "
  read user_input
  INSTALL_DIR=${user_input:-$DEFAULT_INSTALL_DIR}
  
  echo -e "Vytvořit .desktop soubor? ${YELLOW}(ano/ne) [ne]${NC}: "
  read create_desktop_input
  if [[ "$create_desktop_input" =~ ^[Aa][Nn][Oo]$ ]]; then
    CREATE_DESKTOP=true
  fi
  
  echo -e "Instalovat Vencord? ${YELLOW}(ano/ne) [ano]${NC}: "
  read install_vencord_input
  if [[ "$install_vencord_input" =~ ^[Nn][Ee]$ ]]; then
    INSTALL_VENCORD=false
  fi
  
  echo ""
  echo -e "${BOLD}Shrnutí instalace:${NC}"
  echo -e "  ${CYAN}Instalační složka:${NC} $INSTALL_DIR"
  echo -e "  ${CYAN}Vytvoření .desktop souboru:${NC} $([ "$CREATE_DESKTOP" = true ] && echo "Ano" || echo "Ne")"
  echo -e "  ${CYAN}Instalace Vencord:${NC} $([ "$INSTALL_VENCORD" = true ] && echo "Ano" || echo "Ne")"
  echo ""
  
  echo -e "Pokračovat s instalací? ${YELLOW}(ano/ne) [ano]${NC}: "
  read continue_input
  if [[ "$continue_input" =~ ^[Nn][Ee]$ ]]; then
    print_warning "Instalace zrušena."
    exit 0
  fi
fi

# Kontrola instalačního adresáře
if [ -d "$INSTALL_DIR" ] && [ "$FORCE_INSTALL" != true ]; then
  if [ "$INTERACTIVE" = true ]; then
    print_warning "Adresář $INSTALL_DIR již existuje."
    echo -e "Chcete přepsat existující instalaci? ${YELLOW}(ano/ne) [ne]${NC}: "
    read overwrite
    if [[ ! "$overwrite" =~ ^[Aa][Nn][Oo]$ ]]; then
      print_warning "Instalace zrušena."
      exit 0
    else
      print_step "Přepisování existující instalace..."
      # Zde můžeš přidat kód pro odstranění staré instalace, pokud je to potřeba
    fi
  else
    print_warning "Adresář $INSTALL_DIR již existuje. Použijte --force pro přepsání."
    exit 1
  fi
fi

# Vytvoření instalační složky
print_section "Příprava prostředí"
print_step "Vytvářím instalační složky..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$VENCORD_DIR"
print_success "Složky vytvořeny."

# Instalace Discord Canary
print_section "Instalace Discord Canary"
print_step "Zjišťuji nejnovější verzi Discord Canary..."
NEW_VERSION=$(curl -Is "$URL" | grep -i location | grep -oP '\d+\.\d+\.\d+')

if [ -z "$NEW_VERSION" ]; then
  print_error "Nepodařilo se získat informace o verzi Discord Canary"
  exit 1
fi

print_success "Nalezena verze Discord Canary: $NEW_VERSION"

# Kontrola existující verze
UPGRADE=true
if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
  if [ "$NEW_VERSION" == "$CURRENT_VERSION" ] && [ "$FORCE_INSTALL" != true ]; then
    if [ "$INTERACTIVE" = true ]; then
      print_warning "Verze $CURRENT_VERSION je již nainstalována."
      echo -e "Chcete přesto pokračovat s instalací? ${YELLOW}(ano/ne) [ne]${NC}: "
      read reinstall
      if [[ ! "$reinstall" =~ ^[Aa][Nn][Oo]$ ]]; then
        UPGRADE=false
      fi
    else
      print_warning "Verze je aktuální: $CURRENT_VERSION. Žádné stahování není potřeba. Použijte --force pro vynucenou instalaci."
      UPGRADE=false
    fi
  fi
fi

if [ "$UPGRADE" = true ]; then
  print_step "Stahuji Discord Canary..."
  wget --progress=bar:force:noscroll -O "$DOWNLOAD_FILE" "$URL" 2>&1 | \
  awk '/[0-9]+%/ { printf "\r\x1b[32m⬇️ Stahování: %s\x1b[0m", $0; fflush(stdout); } END { print ""; }'
  
  print_step "Rozbaluji archiv..."
  tar -xzf "$DOWNLOAD_FILE" -C "$DOWNLOAD_DIR"
  
  print_step "Instaluji Discord Canary do složky $INSTALL_DIR..."
  rsync -av --delete "$DOWNLOAD_DIR/DiscordCanary/" "$INSTALL_DIR/"
  
  # Uložení verze
  echo "$NEW_VERSION" > "$VERSION_FILE"
  print_success "Discord Canary úspěšně nainstalován."
else
  print_success "Používá se existující instalace Discord Canary."
fi

# Instalace Vencord, pokud je zvoleno
if [ "$INSTALL_VENCORD" = true ]; then
  print_section "Instalace Vencord"
  
  # Kontrola, zda je Vencord již nainstalován a zda je požadována vynucená reinstalace
  if [ -d "$INSTALL_DIR/resources/app.asar.unpacked/node_modules/vencord-desktop" ] && [ "$FORCE_VENCORD" = false ]; then
    print_warning "Vencord je již nainstalován. Použijte --forceVencord pro vynucenou reinstalaci."
    print_success "Používá se existující instalace Vencord."
  else
    if [ "$FORCE_VENCORD" = true ]; then
      print_step "Vynucená reinstalace Vencord..."
    fi
    
    print_step "Stahuji Vencord instalátor..."
  wget --progress=bar:force:noscroll -O "$VENCORD_CLI" "$DEFAULT_VENCORD_URL" 2>&1 | stdbuf -o0 tr '\r' '\n' | grep --line-buffered -o "[0-9]*%" | awk '{ printf "\r\x1b[32m⬇️ Stahování: %s\x1b[0m", $0; fflush(stdout); } END { print ""; }'
  chmod +x "$VENCORD_CLI"
  
  # Vytvoření skriptu pro instalaci Vencord
  print_step "Připravuji instalaci Vencord..."
  cat > "$VENCORD_SCRIPT" << EOF
const { spawn } = require('child_process');
const path = require('path');

// Cesta k instalátoru Vencordu
const instalatorCesta = path.join(__dirname, 'VencordInstallerCli-linux');

// Spuštění instalátoru
const instalator = spawn(instalatorCesta, [], {
  stdio: ['pipe', process.stdout, process.stderr]
});

console.log('\n\x1b[36m\x1b[1m=== Průvodce instalací Vencord ===\x1b[0m\n');

// Funkce pro simulaci stisku klávesy Enter
function stiskniEnter() {
  instalator.stdin.write('\n');
  console.log('\x1b[32m➤ Stisknuta klávesa Enter\x1b[0m');
}

// Funkce pro simulaci stisku klávesy šipka dolů
function stiskniDolu() {
  instalator.stdin.write('\u001b[B');
  console.log('\x1b[32m➤ Posun na další položku (šipka dolů)\x1b[0m');
}

// Funkce pro vložení cesty instalace
function vlozCestu(cesta) {
  instalator.stdin.write(cesta + '\n');
  console.log(\`\x1b[32m➤ Vložena cesta instalace: \${cesta}\x1b[0m\`);
}

console.log('\x1b[33m⚠ Automatická instalace Vencord bude dokončena za několik sekund...\x1b[0m');

// Počkáme 2 sekundy a pak stiskneme Enter poprvé (pro zobrazení menu)
setTimeout(() => {
  console.log('\x1b[36m[1/4] Potvrzení úvodní obrazovky...\x1b[0m');
  stiskniEnter();
  
  // Počkáme další 1 sekundu a stiskneme šipku dolů (posun na položku "Install")
  setTimeout(() => {
    console.log('\x1b[36m[2/4] Posun na položku pro instalaci...\x1b[0m');
    stiskniDolu();
    
    // Počkáme další 1 sekundu a stiskneme Enter (pro výběr "Install")
    setTimeout(() => {
      console.log('\x1b[36m[3/4] Potvrzení instalace...\x1b[0m');
      stiskniEnter();
      
      // Počkáme další 1 sekundu a vložíme cestu instalace
      setTimeout(() => {
        console.log('\x1b[36m[4/4] Vkládání cesty k Discord Canary...\x1b[0m');
        vlozCestu('${INSTALL_DIR}');
        console.log('\x1b[32m✓ Příkazy pro automatickou instalaci byly úspěšně odeslány\x1b[0m');
      }, 1500);
    }, 1500);
  }, 1500);
}, 2000);

// Zachycení ukončení procesu
instalator.on('close', (code) => {
  if (code === 0) {
    console.log('\n\x1b[32m✓ Vencord byl úspěšně nainstalován!\x1b[0m\n');
  } else {
    console.log(\`\n\x1b[31m✗ Instalátor Vencord byl ukončen s kódem: \${code}\x1b[0m\n\`);
  }
});

// Zachycení chyby
instalator.on('error', (err) => {
  console.error('\x1b[31m✗ Chyba při spouštění instalátoru Vencord:', err, '\x1b[0m');
});
EOF
  
  print_step "Instaluji Vencord..."
  node "$VENCORD_SCRIPT"
  print_success "Vencord úspěšně nainstalován."
  fi
fi

# Vytvoření .desktop souboru, pokud je požadováno
if [ "$CREATE_DESKTOP" = true ]; then
  print_section "Vytváření spouštěče"
  
  DESKTOP_DIR="$HOME/.local/share/applications"
  DESKTOP_FILE="$DESKTOP_DIR/discord-canary-vencord.desktop"
  
  mkdir -p "$DESKTOP_DIR"
  
  print_step "Vytvářím .desktop soubor: $DESKTOP_FILE"
  
  cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Discord Canary$([ "$INSTALL_VENCORD" = true ] && echo " (Vencord)")
Comment=Discord Canary$([ "$INSTALL_VENCORD" = true ] && echo " s Vencord rozšířením")
Exec="$INSTALL_DIR/DiscordCanary"
Icon="$INSTALL_DIR/discord.png"
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupWMClass=DiscordCanary
EOF
  
  # Aktualizace databáze .desktop souborů
  if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
  fi
  
  print_success "Spouštěč byl úspěšně vytvořen."
fi

# Úklid
print_section "Dokončování instalace"
print_step "Odstraňuji dočasné soubory..."
rm -rf "$DOWNLOAD_DIR"
print_success "Dočasné soubory odstraněny."

# Výsledky instalace
print_section "Instalace dokončena"
echo -e "  ${BOLD}Discord Canary verze:${NC} $NEW_VERSION"
echo -e "  ${BOLD}Instalační složka:${NC} $INSTALL_DIR"
echo -e "  ${BOLD}Vencord:${NC} $([ "$INSTALL_VENCORD" = true ] && echo "Nainstalován" || echo "Přeskočen")"
if [ "$CREATE_DESKTOP" = true ]; then
  echo -e "  ${BOLD}Spouštěč:${NC} Vytvořen ($DESKTOP_FILE)"
fi
echo ""

print_box "Discord Canary byl úspěšně nainstalován"
echo -e "\n${BOLD}Nyní můžete spustit Discord příkazem:${NC} $INSTALL_DIR/DiscordCanary\n"
