# Appunti del Corso di Reti di Calcolatori

Questa repository raccoglie appunti dettagliati sul corso di **Reti di Calcolatori** dell’Università degli Studi di Milano (UniMi). Gli appunti includono testi, schemi e illustrazioni per facilitare la comprensione dei concetti trattati.

## 📌 Stato degli Appunti  

| Simbolo | Significato |
|---------|------------|
| ✅ | **Completo** – Argomento trattato in modo esaustivo |
| 📝 | **Parziale** – Potrebbero mancare dettagli o esempi |
| 🔧 | **Da revisionare** – Possibili errori da correggere |
| 🚧 | **In lavorazione** – Sezione in aggiornamento |
| ❌ | **Non ancora trattato** – Argomento da affrontare |

---

## 📂 Contenuti  

### 🏗 **1. Modelli di Rete e Architetture**  

| Argomento | Stato |
|-----------|-------|
| **Modello OSI** – I sette livelli, incapsulamento e deincapsulamento | ✅ |
| **Modello TCP/IP** – Confronto con OSI, percorso pacchetti in rete | ❌ |
| **Livello Data Link** – Frame vs pacchetti, affidabilità end-to-end, MAC e LLC | ✅ |
| **Livello di Rete (IP)** – Struttura di un router, forwarding vs routing | ✅ |

### 📡 **2. Protocolli di Comunicazione**  

| Argomento | Stato |
|-----------|-------|
| **ARP (Address Resolution Protocol)** – Risoluzione IP-MAC, Proxy ARP | ✅ |
| **DHCP (Dynamic Host Configuration Protocol)** – Protocollo DORA, rinnovo IP | ✅ |
| **NAT (Network Address Translation)** – Funzionamento, NAT e server esterni | ✅ |
| **ICMP** – Formato del pacchetto, ruolo nella diagnostica | ✅ |
| **BGP (Border Gateway Protocol)** – Path Vector Routing, gestione delle rotte | 🚧 |

### 🔗 **3. Tecnologie di Trasmissione Dati**  

| Argomento | Stato |
|-----------|-------|
| **Ethernet** – CSMA/CD, gestione collisioni, Binary Exponential Backoff | ✅ |
| **Bridge e Switch** – Separazione domini di collisione, forwarding | ✅ |
| **VLAN (Virtual LAN)** – Tagging VLAN, comunicazione tra VLAN diverse | ✅ |
| **MPLS (Multi-Protocol Label Switching)** – Ottimizzazione del traffico | 🚧 |

### 🛠 **4. Gestione degli Errori e Affidabilità**  

| Argomento | Stato |
|-----------|-------|
| **Protocolli Stop-and-Wait** – Limiti e inefficienze | ✅ |
| **Protocolli a Finestra** – Go-Back-N, Selective Repeat, ACK selettivi | ✅ |
| **Ritrasmissione** – Numerazione ciclica dei frame, timeout e gestione perdite | ✅ |

### 📍 **5. Routing e Instradamento**  

| Argomento | Stato |
|-----------|-------|
| **Distance Vector** – Algoritmo RIP, Count to Infinity, Split Horizon | 🔧 |
| **Link State** – Algoritmo OSPF, misurazione costi di rete | 🚧 |
| **Software Defined Networking (SDN)** – Separazione controllo e forwarding | ✅ |

### 📊 **6. Indirizzamento IP e Subnetting**  

| Argomento | Stato |
|-----------|-------|
| **IPv4** – Struttura dell’header, frammentazione e riassemblaggio | ✅ |
| **Classi di Indirizzi** – Limiti e transizione a CIDR | ✅ |
| **Subnetting e CIDR** – Assegnazione gerarchica, esempi pratici | 🔧 |

### ⚙ **7. Gestione della Congestione e Prestazioni**  

| Argomento | Stato |
|-----------|-------|
| **TCP e Controllo della Congestione** – Meccanismi di riduzione velocità | 🚧 |
| **Jitter e Buffer di Playout** – Gestione del delay nella multimedialità | ✅ |
| **Efficienza del Canale** – Formula e ottimizzazioni (es. Gigabit Ethernet) | 🔧 |

### 🚀 **8. Tecnologie Avanzate**  

| Argomento | Stato |
|-----------|-------|
| **Reti Wireless** – Problemi specifici e adattamenti TCP | ❌ |
| **SDN (Software Defined Networking)** – Architettura ibrida hub-switch | 🚧 |
| **Tecnologie di Transizione** – Dual Stack IPv4/IPv6 | ❌ |

---

## 👥 Collaborazioni
I disegni presenti negli appunti sono stati realizzati da [Gabriele Paulon](https://github.com/casten01), che contribuisce come collaboratore alla repository.

## 🤝 Come contribuire

Se trovi errori, vuoi proporre miglioramenti o aggiungere contenuti, sei il benvenuto!
Apri una issue per segnalare problemi o suggerimenti, oppure una pull request per contribuire direttamente.

## 📜 Licenza
Questi appunti sono rilasciati sotto licenza MIT, quindi puoi utilizzarli e modificarli liberamente.

Per domande o suggerimenti, sentiti libero di aprire una discussione nella sezione Issues!