# Appunti del Corso di Reti di Calcolatori

Questa repository raccoglie appunti dettagliati sul corso di **Reti di Calcolatori** dell’Università degli Studi di Milano (UniMi). Gli appunti includono testi, schemi e illustrazioni per facilitare la comprensione dei concetti trattati.

## 📌 Contenuto

**Legenda degli stati degli appunti:**

- ✅ **Completo**: Argomento trattato in modo esaustivo, con spiegazioni chiare e schemi/disegni.  
- 📝 **Parziale**: Contenuto presente ma potrebbe mancare qualche dettaglio o esempio.  
- 🔧 **Da revisionare**: Spiegazioni incomplete o possibili errori da correggere.  
- 🚧 **In lavorazione**: Sezione in fase di scrittura/aggiornamento.  
- ❌ **Non ancora trattato** – Argomento che deve ancora essere affrontato

#### 1️⃣ Modelli di Rete e Architetture
- **Modello OSI**  ✅
  - I sette livelli  
  - Incapsulamento e deincapsulamento  
- **Modello TCP/IP** ❌
  - Confronto con OSI  
  - Percorso dei pacchetti in rete  
- **Livello Data Link** ✅ 
  - Frame vs Pacchetti  
  - Affidabilità end-to-end  
  - MAC layer e LLC layer  
- **Livello di Rete (IP)** ✅
  - Struttura di un router  
  - Forwarding vs Routing  

#### 2️⃣ Protocolli di Comunicazione
- **ARP (Address Resolution Protocol)** ✅
  - Risoluzione IP-MAC  
  - Proxy ARP  
- **DHCP (Dynamic Host Configuration Protocol)** ✅
  - Protocollo DORA  
  - Rinnovo e rilascio IP  
- **NAT (Network Address Translation)** ✅
  - Funzionamento e limitazioni  
  - NAT e server esterni  
- **ICMP** ✅
  - Formato del pacchetto  
  - Ruolo nella diagnostica  
- **BGP (Border Gateway Protocol)** 🚧
  - Path Vector Routing  
  - Gestione delle rotte tra Autonomous System  

#### 3️⃣ Tecnologie di Trasmissione Dati
- **Ethernet** ✅
  - CSMA/CD e gestione collisioni  
  - Binary Exponential Backoff (BEB)  
  - Dominio di collisione  
- **Bridge e Switch** ✅
  - Separazione domini di collisione  
  - Store e Forwarding  
  - Tabelle di forwarding  
- **VLAN (Virtual LAN)** ✅
  - Tagging VLAN  
  - Comunicazione tra VLAN diverse  
- **MPLS (Multi-Protocol Label Switching)** 🚧
  - Funzionamento e ottimizzazione del traffico  

#### 4️⃣ Gestione degli Errori e Affidabilità
- **Protocolli Stop-and-Wait** ✅ 
  - Limiti e inefficienze  
- **Protocolli a Finestra** ✅ 
  - Go-Back-N  
  - Selective Repeat  
  - ACK selettivi vs cumulativi  
- **Ritrasmissione** ✅
  - Numerazione ciclica dei frame  
  - Timeout e gestione perdite  

#### 5️⃣ Routing e Instradamento
- **Distance Vector** 🔧
  - Algoritmo RIP  
  - Problemi: Count to Infinity, Bouncing Effect  
  - Soluzioni: Split Horizon, Triggered Updates  
- **Link State**  🚧
  - Algoritmo OSPF  
  - Misurazione costi di rete  
- **Software Defined Networking (SDN)** ✅
  - Separazione controllo e forwarding  
  - Tunneling  

#### 6️⃣ Indirizzamento IP e Subnetting
- **IPv4** ✅
  - Struttura dell’header  
  - Frammentazione e riassemblaggio  
- **Classi di Indirizzi** ✅ 
  - Limiti e transizione a CIDR  
- **Subnetting e CIDR** 🔧
  - Assegnazione gerarchica  
  - Esempi pratici (es. Milano)  

#### 7️⃣ Gestione della Congestione e Prestazioni
- **TCP e Controllo della Congestione** 🚧
  - Meccanismi di riduzione della velocità  
  - Adattamento in reti wireless  
- **Jitter e Buffer di Playout** ✅
  - Gestione del delay nella multimedialità  
- **Efficienza del Canale** 🔧
  - Formula e ottimizzazioni (es. Gigabit Ethernet)  

#### 8️⃣ Tecnologie Avanzate
- **Reti Wireless**  ❌
  - Problemi specifici e adattamenti TCP  
- **SDN (Software Defined Networking)** 🚧
  - Architettura ibrida hub-switch  
- **Tecnologie di Transizione** ❌
  - Dual Stack IPv4/IPv6  

## 👥 Collaborazioni
I disegni presenti negli appunti sono stati realizzati da [Gabriele Paulon](https://github.com/casten01), che contribuisce come collaboratore alla repository.

## 🤝 Come contribuire

Se trovi errori, vuoi proporre miglioramenti o aggiungere contenuti, sei il benvenuto!
Apri una issue per segnalare problemi o suggerimenti, oppure una pull request per contribuire direttamente.

## 📜 Licenza
Questi appunti sono rilasciati sotto licenza MIT, quindi puoi utilizzarli e modificarli liberamente.

Per domande o suggerimenti, sentiti libero di aprire una discussione nella sezione Issues!