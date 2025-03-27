# Appunti del Corso di Reti di Calcolatori

**Università degli Studi di Milano (UniMi)**  

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

## 📚 **Indice dei Contenuti**  

### 1. **Fondamenti delle Reti**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Modello OSI (7 livelli, incapsulamento/deincapsulamento) | ✅ | 19 |  
| Modello TCP/IP (confronto con OSI, percorso pacchetti) | ✅ | 19 |  
| Affidabilità end-to-end (timer, ACK, gestione errori) | ✅ | 22-25 |  
| Jitter e buffer di playout (gestione delay per multimedialità) | ✅ | 17 |  

---

### 2. **Protocolli di Livello Data Link**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Frame vs pacchetti (delimitazione, sequenze flag) | ✅ | 22-23 |  
| Protocolli affidabili (Stop-and-Wait, Go-Back-N, Selective Repeat) | ✅ | 28-31 |  
| CSMA/CD e Ethernet (BEB, gestione collisioni) | ✅ | 34-37 |  
| VLAN (tagging, comunicazione tra VLAN, bridge) | ✅ | 49-52 |  
| Spanning Tree Protocol (STP) | ✅ | 90-91 |  

---

### 3. **Livello di Rete (IP)**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Struttura IPv4 (header, frammentazione, TTL) | ✅ | 54-57 |  
| Indirizzamento IP (subnetting, CIDR, VLSM) | ✅ | 58-62 |  
| NAT (funzionamento, problematiche, server esterni) | ✅ | 63-65 |  
| ICMP (formato pacchetto, diagnostica) | ✅ | 71 |  
| IPv6 (header semplificato, transizione) | ✅ | 97-100 |  

---

### 4. **Routing e Instradamento**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Distance Vector (RIP, Count to Infinity) | ✅ | 73-76 |  
| Link State (OSPF, tabelle di routing) | ✅ | 78-84 |  
| BGP (Path Vector, gestione AS) | ✅ | 85-86 |  
| MPLS (label switching, ottimizzazione traffico) | ✅ | 87-89 |  
| SDN (separazione controllo/forwarding) | ✅ | 84 |  

---

### 5. **Protocolli di Trasporto**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| TCP (three-way handshake, controllo congestione) | ✅ | 103-118 |  
| UDP (checksum, casi d’uso) | ✅ | 126-128 |  
| RTP/RTCP (streaming multimediale) | ✅ | 129-132 |  
| Ottimizzazioni (Nagle, Clark, SACK) | ✅ | 113-115 |  

---

### 6. **Protocolli Applicativi**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| DNS (struttura gerarchica, risoluzione nomi) | ✅ | 132-136 |  
| HTTP (versioni 1.0/1.1/2/3, metodi) | 🔧 | 144-147 |  
| SMTP e protocolli email (MIME, POP3) | 🔧 | 137-139 |  
| FTP (anomalie connessione dati) | ✅ | 142-143 |  

---

### 7. **Gestione della Congestione e QoS**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Meccanismi TCP (Slow Start, Fast Retransmit) | ✅ | 115-118 |  
| RED (Random Early Detection) | ✅ | 92-93 |  
| Traffic Shaping (Token Bucket, CAC) | ✅ | 95-96 |  
| QoS (WRED, prioritizzazione) | ✅ | 91-95 |  

---

### 8. **Tecnologie Avanzate**  
| Argomento | Stato | Pagina |  
|-----------|-------|--------|  
| Gigabit Ethernet (dimensione minima frame) | ✅ | 46 |  
| Tunneling (IPv6 su IPv4, MPLS) | ✅ | 84, 99 |  

---

## 👥 Collaborazioni
- **Disegni e schemi**: Realizzati da [Gabriele Paulon](https://github.com/casten01).  
- **Contributi tecnici**: Aperti a pull request per correzioni o integrazioni.

## 🤝 **Come Contribuire**  
1. **Segnala errori**: Apri una [issue](https://github.com/comitanigiacomo/Reti_di_calcolatori/issues) con descrizione dettagliata.  
2. **Proponi migliorie**: Invia una **pull request** con modifiche ben documentate.  
3. **Traduzioni**: Collabora alla localizzazione in altre lingue. 


## 📜 **Licenza**  
Questi appunti sono distribuiti sotto licenza **[MIT](https://choosealicense.com/licenses/mit/)**.  
- **Permesso**: Utilizzo, modifica e distribuzione liberi.  
- **Condizioni**: Include attribuzione e licenza originale.  

---

**🔔 Resta Aggiornato**  
⭐ **Segui la repository** per ricevere notifiche sugli aggiornamenti!  