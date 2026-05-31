# Il Secondo Cervello Agentico: Architettura di Conoscenza MCP Multi-Agente Sincronizzata via Git

## Sintesi
Un'architettura di persistenza del contesto e memoria di livello di produzione, progettata per supportare agenti AI locali e cloud (Claude Code, Codex CLI, connettori ChatGPT personalizzati). Mappando operazioni aziendali strutturate, capacità operative personali e procedure (SOP) in un database Markdown tracciato con Git, questo sistema fornisce agli agenti AI un contesto operativo istantaneo e ad altissima densità.

Questa architettura risolve definitivamente il problema della "perdita di contesto" (*context drift*) e dello spreco di token implementando un protocollo di recupero mirato (*requirements-first*) accoppiato a un sistema di sincronizzazione event-driven e a endpoint server MCP (Model Context Protocol) ibridi.

*Nota: Questo caso studio è completamente sanificato. Indirizzi IP, domini, token di sicurezza, percorsi di sistema privati e credenziali cifrate in GPG sono strettamente isolati e mantenuti privati.*

---

## Il Problema Operativo
Quando si collabora con agenti AI avanzati per lo sviluppo di codice e l'automazione su più dispositivi, emergono tre sfide critiche:
1. **Perdita di Contesto e Inefficienza dei Token:** Gli agenti AI perdono la memoria tra una sessione e l'altra. Ricostruire ogni volta il contesto manualmente o caricare interi blocchi di file non correlati intasa la finestra di contesto del modello e fa impennare i costi di consumo dei token.
2. **Rischi di Sicurezza:** Memorizzare informazioni sensibili (credenziali, webhook di API, dati dei clienti) direttamente nelle cartelle di lavoro o nei prompt di testo porta a inevitabili leak di sicurezza.
3. **Attrito di Sincronizzazione:** Mantenere aggiornata la memoria operativa su più workstation fisiche (es. laptop Fedora Linux, desktop Windows) e ambienti di automazione cloud senza dover fare continui copia-incolla manuali.

---

## L'Architettura Costruita (I 4 Layer del Sistema)

```mermaid
graph TD
    subgraph Workstation Locali (Fedora / Windows)
        Obsidian["Interfaccia Umana (Obsidian)"] -->|Modifica Locale| LocalVault["Vault Markdown Locale"]
        LocalVault -->|Watchdog Event-driven (Python)| GitPush["Commit & Push Automatico"]
        LocalAgents["Agenti Locali (Claude Code, Codex)"] <-->|Filesystem MCP Diretto| LocalVault
    end

    subgraph Controllo Versione
        GitPush -->|SSH / HTTPS| GitHubPrivate["Repository Git Privato"]
        GitPush -->|SSH Push| OracleBareGit["Repo Git Bare (Oracle Cloud)"]
    end

    subgraph Runtime Cloud (VPS Oracle Cloud)
        OracleBareGit -->|post-receive git hook| WorkingCopy["Copia di Lavoro Attiva su Oracle"]
        
        Caddy["Reverse Proxy Caddy (TLS)"] <--> TrustedMCP["Server MCP Trusted (Autenticato)"]
        Caddy <--> PublicMCP["Server MCP Pubblico (Solo Lettura)"]
        
        WorkingCopy <-->|Scritture Trusted (Commit-Backed)| TrustedMCP
        WorkingCopy --->|Solo Lettura con Filtro Path| PublicMCP
    end

    subgraph AI Esterne
        CustomChatGPT["Connettore Custom ChatGPT"] <-->|Chiamate API| Caddy
    end
```

### Layer 1: Il Vault Markdown Canonico (Base di Conoscenza)
La fondazione è un vault Obsidian in Markdown strutturato appositamente per un recupero ad alta precisione (*retrieval-first*). Funge da singola fonte di verità per fatti, limiti operativi, progetti attivi, guide operative e brand voice.
* **Requirements-First Routing:** Un protocollo di ingresso rigoroso (`00-START-HERE.md`) obbliga gli agenti a leggere prima la mappa dell'indice e poi ad accedere esclusivamente alla singola nota utile per il task corrente.
* **Isolamento di Sicurezza:** Le credenziali in chiaro sono severamente vietate. Il vault contiene solo un indice dei sistemi non sensibile (`99-SECRETS/secrets-registry.md`), mentre le credenziali e i segreti reali sono conservati in un archivio locale cifrato offline via GPG.

### Layer 2: Pipeline di Sincronizzazione e Deployment Ibrida
Gli aggiornamenti della memoria operativa sono completamente automatizzati tramite Git e un daemon locale leggero:
* **Autosync Event-Driven:** Un daemon Python in background basato sulla libreria `watchdog` gira come servizio utente `systemd` su Linux (e replicato su Windows). Rileva le modifiche ai file del vault, attende 60 secondi di inattività (debounce) per evitare spam di commit, esegue il commit automatico e lancia il push.
* **Deployment lato Cloud:** Le modifiche vengono pushate a un repository Git bare ospitato su Oracle Cloud. Un hook Git `post-receive` personalizzato esegue automaticamente il checkout dell'ultimo commit su una directory di lavoro attiva, rendendo gli aggiornamenti immediatamente disponibili.

### Layer 3: Layer di Accesso Model Context Protocol (MCP)
Per rendere questo "secondo cervello" accessibile in modo sicuro a tutti i diversi assistenti AI, l'infrastruttura espone due server MCP configurati dietro un reverse proxy Caddy con gestione TLS/SSL automatica:
1. **MCP Filesystem Locale:** Gli agenti che girano sulla macchina locale (come Claude Code o Codex CLI) interrogano direttamente il filesystem del vault locale, garantendo latenza zero.
2. **Server MCP Remoto Trusted (Lettura/Scrittura):** Permette ad agenti cloud autorizzati o workflow remoti di interagire con il vault. Ogni operazione di scrittura (es. creazione di una nota, aggiornamento dello stato di avanzamento) è gestita con un sistema di file lock per evitare conflitti, committata automaticamente su Git con metadati strutturati, e deployata.
3. **Server MCP Remoto Pubblico (Solo Lettura):** Un endpoint remoto ad accesso limitato e filtrato sui percorsi del vault, progettato per connettere in sicurezza sistemi esterni come custom connector di ChatGPT senza esporre moduli privati o architetture di backend sensibili.

---

## Risultati Ottenuti
* **Bootstrap Istantaneo degli Agenti:** Inizializzare un nuovo workspace di sviluppo o di automazione richiede meno di 3 secondi. L'agente interroga il file `00-START-HERE.md` e conosce immediatamente lo stile di collaborazione, le specifiche esatte della macchina ospite e i limiti decisionali da rispettare.
* **Risparmio del 80% dei Token:** Anziché caricare interi documenti o pesanti manuali di istruzioni ad ogni turno, gli agenti estraggono note Markdown brevi e iper-mirate solo quando necessario tramite i tool di ricerca e lettura MCP.
* **Sincronizzazione Multi-Workstation Real-time:** Qualsiasi aggiornamento di processo o nota tecnica scritto da un agente su una macchina locale o cloud viene pushato sul server centrale Oracle, storicizzato su Git e scaricato automaticamente su tutti gli altri dispositivi dell'operatore umano al login successivo, mantenendo l'intera infrastruttura perfettamente allineata.

---

## Sviluppi Futuri: OpsVault

Questa architettura è attualmente in fase di refactoring e pacchettizzazione per essere rilasciata come strumento open-source con il nome di **[OpsVault](https://github.com/matteopasseri407/opsvault)**.

L'obiettivo è fornire uno stack pronto all'uso deployabile con un singolo comando (MCP Server + Caddy reverse proxy), un daemon Python leggero per la sincronizzazione Git automatica in background, e template Obsidian standard già ottimizzati per i token. Questo permetterà a qualsiasi sviluppatore o team di configurare il proprio layer di memoria remota multi-agente in pochi minuti.

*Il repository pubblico è in fase di preparazione e verrà rilasciato a breve sotto il brand **AI Enabled Ops**.*
