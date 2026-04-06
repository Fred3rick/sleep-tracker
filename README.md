# 🌙 Sleep Tracker

Una web app leggera per tracciare il proprio sonno, costruita con **Python** e **Bottle**. Progettata per girare anche su dispositivi come un **Kindle** o qualsiasi cosa con un browser integrato.

---

## ✨ Funzionalità

### 🏠 Home
- Pagina principale con griglia di applicazioni disponibili
- **Sleep Tracker** (attivo) — per tracciare il sonno
- *Abitudini* e *Note* — in arrivo nelle prossime versioni

### 🌙 Sleep Tracker
Il cuore dell'app. Permette di registrare e analizzare il proprio sonno ogni notte.

#### ➕ Aggiungere una notte
- Inserimento di **data**, **ora in cui ci si è coricati** e **ora di sveglia**
- Calcolo automatico della **durata del sonno** (gestisce anche il passaggio di mezzanotte)
- Assegnazione automatica di uno **stato** (GREEN / YELLOW / RED) basato sull'obiettivo configurato
- Protezione da duplicati: se esiste già una voce per la data selezionata, viene chiesta conferma prima di sovrascrivere

#### 📋 Storico
- Visualizzazione delle ultime **7, 14 o 30 notti**
- Tabella con data, orario a letto, sveglia, durata e stato
- Possibilità di **eliminare** singole registrazioni

#### 📊 Statistiche
Calcolate su **tutti i dati registrati**:
| Statistica | Descrizione |
|---|---|
| Notti totali | Numero di notti registrate |
| Media durata | Durata media del sonno (es. `7h 45m`) |
| Minimo / Massimo | Notte più corta e più lunga |
| Streak verde | Quante notti consecutive sei in zona verde |
| Giorno migliore | Il giorno della settimana in cui dormi meglio in media |
| Distribuzione | Grafico a barre con % di notti GREEN / YELLOW / RED |

#### ⚙️ Configurazione
Personalizza le soglie di valutazione del sonno:
| Impostazione | Default | Descrizione |
|---|---|---|
| Obiettivo sonno | 480 min (8h) | La durata ideale di sonno |
| Soglia Verde ± | 15 min | Margine per essere considerato "in target" |
| Soglia Gialla ± | 60 min | Margine prima di finire in rosso |

**Come funziona la valutazione:**
- 🟢 **GREEN** — la durata è entro ±15 min dall'obiettivo
- 🟡 **YELLOW** — la durata è entro ±60 min dall'obiettivo
- 🔴 **RED** — la durata si discosta di più di 60 min dall'obiettivo

---

## 🗂️ Struttura del progetto

```
sleep-tracker/
├── app.py              # Server principale (routing, logica, API)
├── requirements.txt    # Dipendenze Python
├── config.json         # Configurazione utente (creato al primo avvio)
├── data/
│   └── sleep_log.csv   # Database CSV con le notti registrate (creato al primo avvio)
├── static/
│   └── style.css       # Stile CSS dell'interfaccia
└── views/              # Template HTML (Bottle SimpleTemplate)
    ├── home.tpl
    ├── sleep_index.tpl
    ├── sleep_add.tpl
    ├── sleep_history.tpl
    ├── sleep_stats.tpl
    └── sleep_config.tpl
```

---

## 🚀 Installazione e avvio

### Prerequisiti
- Python 3.7+
- pip

### 1. Clona il repository

```bash
git clone https://github.com/tuo-utente/sleep-tracker.git
cd sleep-tracker
```

### 2. Installa le dipendenze

```bash
pip install -r requirements.txt
```

### 3. Avvia il server

```bash
python app.py
```

Il server partirà su `http://0.0.0.0:8080`.  
Apri il browser e vai su **[http://localhost:8080](http://localhost:8080)**.

> 💡 Al primo avvio vengono creati automaticamente la cartella `data/` e il file `sleep_log.csv`.

---

## 💾 Dati

I dati vengono salvati localmente in due file:

- **`data/sleep_log.csv`** — contiene tutte le notti registrate con i campi:
  ```
  date, bed_time, wake_time, duration_min, status
  ```
- **`config.json`** — contiene le impostazioni personalizzate (obiettivo, soglie verde/gialla)

Non è richiesto alcun database esterno.

---

## 🛠️ Stack tecnologico

| Componente | Tecnologia |
|---|---|
| Backend | Python 3 + [Bottle](https://bottlepy.org/) |
| Template | Bottle SimpleTemplate (`.tpl`) |
| Persistenza | CSV + JSON (nessun DB esterno) |
| Frontend | HTML + CSS vanilla |
| Server | Bottle built-in WSGI server |

---

## 🗺️ Roadmap

- [x] Sleep Tracker completo (aggiunta, storico, statistiche, configurazione)
- [ ] App **Abitudini** (habit tracker)
- [ ] App **Note**
- [ ] Grafici interattivi per le statistiche del sonno
- [ ] Esportazione dati in CSV

---

## 📄 Licenza

Progetto personale — libero uso e modifica.
