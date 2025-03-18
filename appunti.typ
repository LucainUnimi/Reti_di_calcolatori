#import "@preview/bubble:0.2.2": *
#import "@preview/note-me:0.4.0": *

#show: bubble.with(
  title: "Reti di calcolatori",
  author: "Giacomo Comitani",
  affiliation: "Università degli studi di Milano",
  date: datetime.today().display(),
  year: "2025",
  logo: image("logo.png"),
  main-color: "#005FDB"
)

#let green(x) = text(fill: rgb("#2ecc40"), x)
#let orange(x) = text(fill: rgb("#ff851b"), x)
#let red(x) = text(fill: rgb("#ff2929"), x)
#let blue(x) = text(fill: rgb("#2971b8"), x)

#show table.cell: set text(weight: "bold")

#set table(
  fill: (_, y) => if calc.odd(y) { rgb("#a5e1f7") },
  stroke: rgb("#000000"),
)

#outline()

#pagebreak()

= Lezione 1

#important[Una *Rete di calcolatori* è un sistema distribuito che interconnette *host* distribuiti geograficamente attraverso un sistema di rete composto da cavi e nodi di collegamento]

== Host e funzionalità della rete

Un *host* è un apparato utente in cui sono in esecuzione le applicazioni finali. La *rete* permette di mettere in collegamento host con host remoti o host con server remoti per eseguire applicazioni di rete.

#align(center, image("images/image-2.png", width: 8cm))

Qui ad esempio la rette permette ad `A` di mandare file al server `D` o inviare mail a `B`.

== Instradamento e router

Un sistema di collegamento tra host deve interagire con nodi di rete, chiamati *router*, che si occupano dell'_instradamento_.

- *Instradamento*: determinare il percorso migliore in un dato istante di tempo tra sorgente e destinazione.
- Le metriche di instradamento più comuni sono:
 - *Distanza minore*, misurata in *hop* (salti tra router)
 - *Tempo di percorrenza*

#align(center, image("images/image-4.png", width: 8cm))

Le macchine host #green[A], #green[B] e #green[C] ospitano l'applicazione di rete dell'utente finale, mentre i nodi di rete #orange[1],#orange[2],#orange[3],#orange[4] e #orange[5], ovvero i router, sono interamente *dedicati* alla funzione di instradamento su una rete di calcolatori

== Struttura di un router

Un router è composto da:

- *Link bidirezionali* che lo collegano ad altri router.
- *Porte di ingresso*, ognuna con un buffer gestito mediante code.
- *Scheduler*: processo che gestisce il traffico in ingresso e uscita.
- *Processo di routing*: interpreta ogni messaggio e consulta le tabelle di instradamento per determinare la porta di uscita corretta.

#note[
I router possono diventare *colli di bottiglia* poiché devono processare le code di pacchetti in ingresso e possono andare in congestione se hanno molteplici link.
]
#image("images/image-5.png")

ma per quanto riguarda il tempo di trasmissione?

== Trasmissione dei dati

Prendiamo in considerazione un canale che ha una velocità di 1 Megabit/s. Questo vuol dire che sul canale verranno trasmessi 1 milione di bit al secondo. Indichiamo con $T_x$ il *tempo di trasmissione* di un'unità sulla rete, che in questo caso sarà di 1 microsecondo.

Nei router sono presenti delle porte I/O, connesse all'esterno del nodo ai link bidirezionali, e all'interno del nodo a un databus. Queste porte sono anche chiamate *Parallel Input Serial Output*, poichè hanno il compito di trasformare i dati in arrivo in _parallelo_ dal db in uscita *in seriale*.

#align(center, image("images/image-6.png", width: 10cm))

I databus spostano i bit in dei buffer, e quando i buffer sono pieni, la porta si occupa di inviare i bit *in seriale* sui link.

Il ritmo di invio di questi bit è scandito da un *clock di trasmissione*: Il clock genera degli _impulsi_, transizioni binarie da 0 a 1. se voglio quindi trasferire 1Mbps, allora il clock di trasmissione deve generare 1 impulso ogni microsecondo per 1 milione di volte. Mediante il clock impongo alla porta il trigger per trasmettere un bit. se il clock garantisce un periodo costante di transizoni 0 e 1 nell'unità di tenpo, associa ad ogni transizone di stato la trasmissione di un singolo bit 

in base al clock di trasmissione determino il numero di bit immessi nel  canale seriale. il ritmo di trasmissione è costante. 

Quindi il clock associato ad una porta I/O determina la velocità con cui trasmetto sul canale.

Se ad esempio voglio conoscere il tempo necessario alla porta di I/O per trasmettere 1000 bit, = 1000/un milione. 

Posso quindi andare a calcolare il tempo che la nostra porta impiega a mandare 1000 bit sul nostro canale a 1Mbps:

$T_x = 10^3/10^6 = 10^-3 = 1 $ms

quindi in questo caso diciam che in un millisecondo, la porta è impegnata e non puo fare altro, e riesce a svuotare il suo buffer di 1000 bit e spedirli nel canale.

== Pacchettizzazione dei dati

In rete non si trasmettono file interi, ma *frammenti* chiamati *pacchetti*. i pacchetti hanno *dimensione fissa* per evitare la *frammentazione esterna*.

Ogni pacchetto viaggia autonomamente all'interno della rete, potendo seguire percorsi diversi per raggiungere la destinazione. Questo significa che potrebbero arrivare in ordine sparso o con ritardi, perdendo così il legame diretto con il file originale. Per garantire che i dati possano essere ricostruiti correttamente, ogni pacchetto include informazioni aggiuntive che ne permettono il riassemblaggio

Ogni pacchetto ha un'intestazione (*header*) che contiene informazioni come:
- Indirizzo sorgente e destinazione
- Numero di sequenza per riassemblaggio

Il protocollo *IP* richiede un header di *40 byte* ( 20 per l'indirizzo sorgente e 20 per la destinazione). Un equilibrio tra *overhead* (causata dall'header che viene ripetuto su ogni pacchetto) e *funzionalità* è necessario per ottimizzare la trasmissione

Ad esempio scrivo che vengo da host a e vado in host b, scrivo le destinazioni  del file. Se frammento il file, non posso permettere che i frammenti che vengonoinviati separatamente NON portino la stessa dicitura. Ogni pacchetto quindi ha la sua intestazione. l'informaziione dell'header deve essere reploicata ovunque. In questo modo ho un sacco di byte in piu da trasmettere, anche se facilito la vita a router. creo overhead sulla rete.

È compito dell'host frammentare il file in pacchetti e riassemblarli quando arrivano a destinazione. ma come fa il ricevitore ad essere sicuro che quello che riassemblo è uguale al file iniziale?

== Affidabilità della trasmissione

L'host deve garantire:

1. Ordine dei pacchetti (possono seguire percorsi diversi in rete)
2. Assenza di duplicati
3. Integrità dei dati

Questi tre aspetti costituiscono l'*affidabilità* della trasmissione e sono garantiti dal protocollo *TCP*, che lavora all'interno dell'host.

#note[Il protocollo *IP* lavora nel sistema di rete, mentre il protocollo *TCP* lavora all'interno dell'host ed è responsabile dell'affidabilità]

Quale che sia la velocità di trasmissione, quello che mi interessa è l'affidabilità.

== Conferma della ricezione (ack)

Per verificare la corretta ricezione, il destinatario invia un acknowledgment (*ACK*) al mittente. Il mittente trasmette il pacchetto successivo solo *dopo* aver ricevuto l'ack. Questo segnale è in realtà un vero e proprio pacchetto di traffico di controllo di rete, e introduce *latenza* nella trasmissione

#align(center, image("images/image-7.png", width: 10cm))

Il tempo $T$ è il #red[ritardo di trasmissione]: dobbiamo cercare di ridurlo il più possibile, poichè più è grande il ritardo più è lenta la trasmissione.

Il *tempo totale di trasmissione* di un pacchetto include:
- Tempo di trasmissione del pacchetto
- *Doppio* del tempo di trasmissione del pacchetto

Di seguito un esempio: Supponiamo di avere un canale `Ch` a 1Mbps, e un pacchetto `Pk` da 1000 bit. A questo punto sappiamo calcolare il tempo di trasmissione $t_x$d della porta:

$t_x = 10^3/10^6 = 1$ms. A questo punto possiamo calcolare il ritardo di trasmissione $T$ come segue:

#align(center,image("images/image-8.png",width: 9cm))

#blue[cosa ci manca ?]

sul canale l'informazione viaggia ad una velocita che dipede dal mezzo fisico che sto considerando. Questo significa che oltre al tempo di trasmissione di ogni unità della rete ( bit sequenzialmente messi sul canale dalla porta), devo considerare il tempo che ogni bit impiega a viaggiare lungo il canale.

#important[Tempo di trasmissione e tempo di propagazione sono concetti ben diversi]

#note[la velocità di propagazione dipende anche dalla lunghezza del canale fisico]

Conoscendo la *lunghezza del canale* e la *velocità di propagazione* è possibile calcolare il *tempo di propagazione*:

$t_p = L/V_p$

#important[Il tempo che intercorrre tra la spedizione di un pacchetto e la recezione dell'ack relativo a quel pacchetto, è uguale al tempo di trasmissione del pacchetto più due volte il tempo di propagazione]

#align(center,image("images/image-9.png", width: 19cm))


== Protocolli di rete

Due macchine che comunicano, devono avere delle regole *convenzionate* condivise per poterlo fare. Queste regole sono efinite in quellio che vengono chiamati *protocolli*

#important[Un protocollo è un algoritmo distribuito che regola la comunicazione tra le macchine.]

Un protocollo definisce quindi delle *regole di sincronizzazione* per garantire affidabilità. Un esempio di protocolli sono i protocolli *IP* e *TCP*

== Gestione degli errori e timer

Se l'ACK non arriva, il sistema potrebbe bloccarsi in un'attesa *infinita*. per evitarlo, si utilizza un *timer di ritrasmissione*:
- Se l'ack non arriva entro un certo tempo (il pacchetto si è perso, si è deteriorato sulla porta di I/O...), il pacchetto viene *ritrasmesso*
- La macchina a stati può uscire dallo *wait state* con:
 -La ricezione dell'ack
 - L'interrupt del timer che segnala un errore e richiede una ritrasmissione.

Questo meccanismo garantisce che la comunicazione rimanga affidabile anche in presenza di errori di trasmissione

#pagebreak()

= Lezione 2

Le reti a pacchetti si dividono in due grandi famiglie:

- reti *best-effort*: trasferiscono il pacchetto senza garantire affidabilità
- reti *connection-oriented*: garantiscono affidabilità utilizzando maggiori protocolli

Internet si basa su reti best effort dove l'affidabilità è delegata agli host-riceventi, e la minor presenza di protocolli produce una maggiore velocità di trasmissione.

Supponiamo di voler mandare più pacchetti sulla rete. Una possibile situazione potrebbe quindi essere la seguente:

#align(center, image("images/image-10.png", width: 8cm))

Ma il valore $Delta T$ che il destinatario deve aspettare prima di ricevere un pacchetto dal mittente, è sempre lo stesso?

Nella condizione più semplice in cui `S` e `D` sono collegati da un filo, la variabilità di quel tempo può essere molto limitata. In condizioni reali, questo tempo dipende da diversi fattori, quindi posso calcolare una *varianza* sul ritardo di ricezione della sequenza.

== Jitter e varianza del delay di trasmissione

Ogni pacchetto subisce un ritardo di trasmissione che può variare nel tempo. Anche se il mittente invia i pacchetti con cadenza regolare, il ricevitore li riceve con tempi variabili. Questa varianza nel ritardo è chiamata *jitter*.

Per molte trasmissioni dati (es. invio di un file), il jitter non è un problema, perché il ricevitore può ricostruire i dati in qualsiasi momento.

#important[Tuttavia, se si trasmette un flusso continuo, come voce o video in tempo reale, il jitter può causare interruzioni e distorsioni, rendendo l'ascolto o la visione poco fluida.]

== Trasmissione di voce e multimedialità

Quando si trasmette la voce o un contenuto multimediale, il segnale analogico viene *digitalizzato*.

#note[Digitalizzare un segnale significa convertirlo in una sequenza di dati discreti che possono essere trasmessi sulla rete.]

=== Digitalizzazione: campionamento e quantizzazione

La digitalizzazione avviene in due fasi:
- *Campionamento*: l segnale viene misurato a intervalli regolari, ottenendo una serie di valori discreti.
- *Quantizzazione*: Ogni valore campionato viene trasformato in una rappresentazione numerica digitale.

Il risultato finale è un array di coordinate di punti, che descrivono il segnale originale in forma numerica.

#align(center, image("images/image-11.png", width: 8cm))

=== Teorema di Nyquist-Shannon

Per ricostruire correttamente un segnale digitalizzato senza perdita di informazioni, la frequenza di campionamento deve essere almeno il doppio della massima frequenza contenuta nel segnale originale.

#tip[Poiché la voce umana arriva fino a circa 4000 Hz, la frequenza minima di campionamento deve essere 8000 campioni al secondo (8 kHz).]

=== Il Ruolo del Buffer di Playout e Come Risolve il Problema

Per contrastare il jitter, il ricevitore utilizza un *buffer di playout*. Questo buffer è una memoria temporanea che raccoglie i pacchetti ricevuti, li riordina se necessario e li riproduce a intervalli regolari, come se fossero arrivati senza variazioni di ritardo. Senza un buffer di playout, il ricevitore riprodurrebbe i pacchetti immediatamente, con il rischio di
- Silenzio o interruzioni quando i pacchetti subiscono ritardi e non arrivano in tempo.
- Distorsioni e scatti quando i pacchetti arrivano con tempi irregolari.

Questo meccanismo permette di compensare il jitter, garantendo una riproduzione fluida. Tuttavia, la dimensione del buffer deve essere bilanciata:
- Se è troppo piccolo, il jitter causa ancora interruzioni.
- Se è troppo grande, introduce un ritardo nella riproduzione, rendendo difficile la comunicazione in tempo reale.

== Congestione della rete e buffer overflow

Uno dei problemi principali delle reti moderne è la *congestione nei nodi intermedi*. I pacchetti devono attraversare una rete complessa di router e switch, ognuno con memoria limitata.

Quando troppi pacchetti arrivano contemporaneamente a un nodo, si può verificare un *buffer overflow*: la memoria del router si riempie e i pacchetti in eccesso vengono eliminati.

#important[La perdita di pacchetti avviene nei router e non sui link di trasmissione.]

Questo problema rende necessarie strategie di controllo della congestione, come quelle adottate dal protocollo TCP.

== Il ruolo di TCP nella gestione della congestione

Il protocollo TCP è progettato per gestire la congestione della rete, evitando il buffer overflow nei router. La sua strategia è simile all'azione di "chiudere il rubinetto" quando il flusso di dati è troppo elevato:

- Se TCP rileva una congestione, riduce la quantità di dati inviati.
- Non ritrasmette subito i pacchetti persi, ma aspetta che la congestione si risolva.

#warning[Questa tecnica funziona bene nelle reti cablate, dove la perdita di pacchetti è spesso dovuta alla congestione. Tuttavia, nelle reti wireless, la situazione è diversa.]

== TCP e reti wirelesss: problemi e revisione del protocollo

Il tipo di link più soggetto a errori sul canale è il canale wireless. Questo rappresenta una criticità per TCP, perché:
- Quando un pacchetto viene perso su una rete wireless, TCP potrebbe erroneamente interpretare la perdita come un segnale di congestione.
- Di conseguenza, TCP riduce inutilmente il flusso di dati, peggiorando le prestazioni della rete.

Per questo motivo, l'uso di TCP su reti wireless deve essere gestito con attenzione. In alcuni casi, sono necessarie modifiche o protocolli alternativi per evitare che TCP interpreti erroneamente gli errori del canale come congestione.

D'altro canto, su reti a basso tasso di errore, TCP funziona perfettamente ed è il protocollo più adatto per garantire una trasmissione affidabile.

= Lezione 3

Le reti informatiche sono organizzate secondo un'*architettura gerarchica* suddivisa in livelli, ciascuno con specifiche funzioni di rete. Il modello di riferimento accettato dalla comunità scientifica come standard per l'interconnessione dei sistemi aperti (Open System Interconnection, *OSI*) è strutturato in sette livelli, ognuno dei quali è associato a uno o più protocolli di rete.

== I sette livelli del modello OSI

1. *Livello fisico*: si occupa della trasmissione dei bit attraverso il mezzo fisico di comunicazione (cavi, fibre ottiche, onde radio, ecc.). Gestisce parametri come la velocità di trasmissione e il tipo di segnale.

2. *Livello Data Link* (Collegamento dati): fornisce un formato logico ai dati trasmessi tra due nodi adiacenti. Garantisce un trasferimento affidabile delle informazioni su un singolo collegamento fisico e utilizza protocolli come Ethernet o PPP.

3. *Livello Network* (Rete): gestisce l'instradamento (routing) e l'indirizzamento (addressing) dei pacchetti tra dispositivi non direttamente connessi. Il protocollo più noto di questo livello è l'IP (Internet Protocol), che si occupa di determinare il percorso migliore per far arrivare un pacchetto a destinazione.

4. *Livello Transport* (Trasporto): garantisce un trasferimento dati affidabile ed efficiente tra host finali. Controlla la segmentazione e l'ordine dei pacchetti, offrendo servizi di trasmissione affidabile (TCP) o non affidabile (UDP).

5. *Livello Session* (Sessione): gestisce le sessioni di comunicazione tra applicazioni. Si occupa di stabilire, gestire e terminare le connessioni tra processi remoti. In Internet, le funzionalità di sessione sono integrate nelle socket del sistema operativo.

6. *Livello Presentation* (Presentazione): si occupa della traduzione, compressione e cifratura dei dati, garantendo che le informazioni vengano interpretate correttamente tra diversi sistemi.

7. *Livello Application* (Applicazione): rappresenta il punto di accesso ai servizi di rete per le applicazioni dell’utente, con protocolli come HTTP, FTP e SMTP.

== Il modello Internet (TCP/IP)

Sebbene il modello OSI sia un riferimento teorico, il modello TCP/IP utilizzato in Internet semplifica questa struttura, riducendola a cinque livelli:

- Livello Fisico

- Livello Data-link

- Livello Network

- Livello Transport (con i protocolli TCP e UDP);

- Livello applicazione, che incorpora le funzioni di sessione e presentazione del modello OSI.

#important[Il livello sessione, in particolare, non esiste come entità separata in Internet, ma le sue funzioni sono delegate alle *socket* del sistema operativo, che permettono di gestire le comunicazioni tra processi remoti.]

#align(center, image("images/image-12.png"))

== Il percorso dei pacchetti in rete

Quando un pacchetto di dati viene inviato attraverso la rete, esso attraversa i vari livelli della pila protocollare in un processo chiamato *incapsulamento*. Ogni livello aggiunge un proprio *header* al pacchetto, contenente informazioni di controllo necessarie per la corretta elaborazione dei dati a destinazione.

=== Incapsulamento e deincapsulamento

Il processo inizia con il livello applicazione, che genera i dati da trasmettere. Successivamente, il livello trasporto segmenta i dati in porzioni gestibili e vi aggiunge un'intestazione (header) contenente informazioni sulla connessione. A questo punto interviene il livello rete, che incapsula i segmenti in pacchetti IP, aggiungendo le informazioni necessarie per l'instradamento dei dati. Il livello Data Link prende in carico i pacchetti, incapsulandoli in frame e inserendo informazioni per la trasmissione sul collegamento fisico. Infine, il livello fisico si occupa della trasmissione vera e propria, convertendo il tutto in segnali elettrici, ottici o radio che viaggiano attraverso il mezzo fisico.

Quando il pacchetto arriva a destinazione, il processo viene eseguito in ordine inverso (deincapsulamento), rimuovendo gli header man mano che il pacchetto risale attraverso i livelli della pila protocollare, fino a raggiungere l'applicazione destinataria.

#align(center, image("images/image-13.png", width: 14cm))

In sintesi, l'architettura delle reti segue una struttura stratificata per garantire una comunicazione efficiente e modulare tra i dispositivi connessi. Il modello OSI fornisce un riferimento teorico, mentre il modello TCP/IP rappresenta la realtà delle reti moderne, semplificando l'approccio ma mantenendo le funzionalità essenziali per il funzionamento di Internet.

= Lezione 4

== Livello Data-link

Consideriamo una rete in cui analizziamo il funzionamento di due nodi al suo interno. Ogni nodo possiede tanti livelli Data-Link quanti sono i link a cui è connesso, e altrettanti livelli fisici.


#align(center, image("images/image-14.png", width: 14cm))

=== Comunicazione tra livelli

Il livello 3 (Network Layer) può richiedere la trasmissione di un pacchetto al livello fisico secondo due modalità:

- *Affidabile*: il pacchetto viene trasmesso e il livello fisico conferma la ricezione.
- *Non affidabile*: il pacchetto viene trasmesso senza garanzia di ricezione.

Il livello 3 sceglie quale livello Data-Link attivare in base alla *politica di instradamento* e alle condizioni della rete.

#note[L'algoritmo di instradamento, che opera al livello 3, seleziona dinamicamente la porta di output del router più adatta per il trasferimento dei pacchetti, privilegiando la linea di flusso attualmente più scorrevole.]

=== Affidabilità end-to-end

Al livello 2 si privilegia il *Best Effort*, evitando di sovraccaricare la rete con meccanismi di conferma su ogni collegamento. L'affidabilità diventa così un problema *end-to-end*, gestito direttamente dagli host (livello 4 – Transport Layer), mentre la rete si occupa solo di instradare i pacchetti nel modo più efficiente possibile.

=== Differenza tra livello 2 e livello 3

- *Livello 2*(Data-Link Layer): conosce solo il proprio nodo adiacente e gestisce la trasmissione dei frame tra dispositivi direttamente connessi
- *Livello 3*(Network Layer): ha una visione globale della rete e costruisce tabelle di instradamento per determinare i percorsi migliori in base ai tempi di percorrenza.

== Struttura della trasmissione al livello 2

A livello fisico, l'informazione viene trasmessa attraverso variazioni di tensione (bit alti e bassi per rappresentare 1 e 0). Tuttavia, quando non si trasmette, il canale si trova in stato di *idle*, rappresentato da una sequenza continua di bit a 1

=== Problemi di delimitazione dei frame

Per distinguere un nuovo frame dallo stato di idle e segnalare correttamente l’inizio e la fine di una trasmissione, si utilizza un meccanismo di *flagging*:

- I protocolli di livello 2 definiscono un delimitatore di inizio e fine del frame chiamato *flag*, rappresentato dalla sequenza fissa di bit `01111110`.

#note[Un esempio di protocollo che utilizza questa tecnica è *HDLC* (High-Level Data Link Control)]

=== Problema della sequenza flag nei dati

Se la sequenza `01111110` compare all'interno dei dati del frame, potrebbe essere erroneamente interpretata come un delimitatore, causando errori di trasmissione. La soluzione a questo problema risiede in una tecnica chiamata *bit stuffing*.

Durante la *trasmissione* il trasmettitore conta i bit a `1` consecutivi. Se ne rileva cinque, inserisce automaticamente un bit `0` dopo la sequenza. Durante la *ricezione*, il ricevitore esegue la stessa operazione in modo inverso, su *TUTTO* quello che arriva sul canale, anche sui bit del flag di fine frame:

- Conta i bit a `1` consecutivi
- Se rileva cinque bit `1`, verifica il bit successivo:
  - Se è `0`, lo scarta (bit di stuffing)
  - Se è `1`, riconosce il flag di fine frame e termina la ricezione

#important[Il bit stuffing garantisce la corretta trasmissione dei dati senza influenzare i tempi di elaborazione!]

#warning[il bit stuffing viene applicato solamente sull'unità dati, e non sui flag di inizio e fine del frame, altrimenti anche questi verrebbero interpretati erroneamente. I flag sono quindi le uniche sequenze di bit dove possono comparire sei bit a `1` consecutivi.]

== Differenza tra pacchetto e frame

Mentre un *pacchetto* è un'unità di dati gestita al livello 3, un *frame* è un'unità di dati gestita al livello 2. Il livello 3 decide il percorso migliore per il trasferimento dei pacchetti, mentre il livello 2 si occupa di trasmettere i frame tra dispositivi direttamente connessi.

La segmentazione e l'incapsulamento delle informazioni seguono questa gerarchia, garantendo un'efficace trasmissione e instradamento dei dati sulla rete.

== Gestione della trasmissione affidabile

Quando si trasmettono pacchetti in modo affidabile attraverso un canale con conferme di ricezione (ACK), possono verificarsi errori di trasmissione, sia per la perdita di frame che per la perdita degli ACK. È quindi necessario un meccanismo per garantire che ogni pacchetto venga ricevuto correttamente e senza duplicati

=== Caso 1: Perdita del frame

- Il trasmettitore invia un frame, ma questo si perde durante la trasmissione
- Il ricevitore non riceve il frame e, di conseguenza, non invia alcun ACK
- Il timer associato alla trasmissione scade, generando un'interrupt
- Il sistema operativo rileva il timeout e comprende che la trasmissione non è andata a buon fine.
- Il frame viene recuperato dal buffer di trasmissione e ritrasmesso.
- Il ricevitore riceve correttamente il frame, lo elabora e invia l'ACK corrispondente.

=== Caso 2: Perdita dell'ACK

- Il trasmettitore invia un frame e il ricevitore lo riceve correttamente.
- Il ricevitore invia l’ACK, ma questo si perde lungo il canale.
- Il trasmettitore, non ricevendo l’ACK entro il tempo previsto, rileva un timeout e ritrasmette il frame.
- Il ricevitore riceve nuovamente lo stesso frame e lo elabora. 

#important[Tuttavia, per garantire affidabilità, il protocollo deve impedire la duplicazione dei frame elaborati.]


#align(center, image("images/image-15.png", width: 12cm))

== Soluzione: sequenziamento dei frame e ack

Per evitare problemi di duplicazione, è necessario implementare un *meccanismo di numerazione* dei frame e degli ACK. Vengono quindi introdotte delle *Variabili di sequenza* utilizzate dal trasmettitore e dal ricevitore:
- *Send*: per numerare i frame trasmessi
- *Receive*: per numerare i frame ricevuti

Entrambe le variabili sono inizializzate a zero, quindi il primo Il primo frame trasmesso avrà numero di sequenza `0`, così come il primo frame atteso dal ricevitore. Se il numero di sequenza di un frame ricevuto non corrisponde a quello atteso, il frame viene scartato per evitare duplicati.

Nonostante l'utilizzo delle variabili di sequenza, potrebbero comunque esserci dei problemi dovuti ad esempio ad un ritardo della ricezione dell'ack, come si può notare nel seguente esempio:

#align(center, image("images/image-16.png"))

#important[Anche gli Ack devono includere un numero di sequenza corrispondente al frame ricevuto correttamente. Questo evita problemi di Ack ritardati relativi a pacchetti precedenti.]

== Componenti necessari per il protocollo affidabile
Per implementare un protocollo di livello 2 affidabile, sono necessari: 
- *Buffer di trasmissione*: per conservare una copia del frame finchè non viene ricevuto l'Ack, in modo da poterlo rispedire sul canale.
- *Clock* e *Timer*: per rilevare timeout in caso di perdita di frame o ACK.
- *Sequenziamento*: gestione delle variabili di invio e ricezione per evitare duplicati

Grazie a questi elementi, il protocollo può garantire un trasferimento dati affidabile, anche in presenza di perdite di pacchetti o ritardi nella trasmissione.

== Efficienza della trasmissione e utilizzo del canale

=== Introduzione all'utilizzo del canale

L’efficienza di un protocollo di trasmissione può essere valutata attraverso una metrica chiamata *utilizzo del canale*, che indica quanto efficacemente il protocollo sfrutta la capacità del canale fisico.

ricordando che: 

- Tempo di trasmissione del pacchetto: $t_x = "Dimensione del pacchetto"/"Larghezza di banda del canale"$
- Tempo di propagazione del pacchetto: $t_p = "Distanza"/"Velocità del segnale"$
- Tempo totale di trasmissione: $T = t_x + 2t_p$

Possiamo calcolare l'utilizzo del canale come: 

#align(center, $U = t_x/T$)

Finora, il protocollo trattato prevede l’invio di un singolo frame alla volta, attendendo la ricezione dell’ACK prima di inviarne un altro. Questo metodo, sebbene garantisca affidabilità, è inefficiente perché lascia il trasmettitore inattivo durante il tempo di propagazione dell’ACK

=== Fattori che influenzano l'efficienza

- *Tempo di trasmissione*: il tempo necessario per trasmettere completamente un frame sul canale.
- *Tempo di propagazione*: il tempo impiegato dal segnale per viaggiare dal trasmettitore al ricevitore.
- *Tempo di andata e ritorno* (RTT, Round Trip Time): il tempo totale affinché un frame e il relativo ACK completino il ciclo di trasmissione.

== Limiti dell'approccio stop-and-wait

Nel protocollo attuale (Stop-and-Wait), il trasmettitore invia un frame e attende il relativo ACK prima di inviare il successivo. Questo comporta che dopo aver trasmesso il frame, il trasmettitore rimane inattivo fino alla ricezione dell'ACK. Se $t_p$ è elevato rispetto a $t_x$, gran parte del tempo il canale rimane inutilizzato.

== Miglioramento: invio di più frame in sequenza

Per migliorare l’efficienza, l’obiettivo è raggiungere un utilizzo del canale pari al 100%, evitando i tempi morti tra un frame e l’altro. Un metodo per ottenere questo risultato è l’invio di una sequenza di frame prima di attendere gli ACK, noto come *finestra di trasmissione* (Sliding Window Protocol).

Questo approccio consente al trasmettitore di inviare più frame consecutivamente senza aspettare l’ACK di ciascuno, aumentando drasticamente l’utilizzo del canale.

Quando utilizziamo un protocollo a finestra (come Stop-and-Wait o Sliding Window), la formula per il calcolo dell'utilizzo del canale cambia, poiché dobbiamo considerare il numero di frame che possiamo trasmettere prima di dover attendere un ACK:

#align(center, $U = k * t_x / T$)

Dove k è il numero di frame inviati nella finestra.

Esaminiamo degli esempi per comprendere meglio quanto trattato fino ad ora.

#tip[
  Consideriamo la seguente situazione:
  - Larghezza di banda del canale: $T_x  = 10$ Mbps.
  - Lunghezza del canale: $L$ = 2 km.
  - Dimensione dei pacchetti: 1000 bit.

  Calcoliamo il tempo di trasmissione $t_x$ e il tempo di propagazione $t_p$ per un pacchetto, e determiniamo l'utilizzo del canale per un protocollo Stop-and-Wait.

  $t_x = 10^3/10^7 = 10^-4 = 0,1$ms.\
  $t_p = 2 * 10^3/2*10^8 = 10^-5 = 10$ micro-secondi\

  Il tempo totale di trasmissione è quindi pari a $T = 0,1 + 0,02 = 0,12$ ms

  Consideriamo poi una seconda situazione avente:
  - Larghezza di banda del canale: $T_x  = 10$ Mbps.
  - Lunghezza del canale: $L$ = 20 km.
  - Dimensione dei pacchetti: 1000 bit.

  Calcoliamo il tempo di trasmissione $t_x$ e il tempo di propagazione $t_p$ per un pacchetto, e determiniamo l'utilizzo del canale per un protocollo Stop-and-Wait.

  $t_x = 10^3/10^7 = 10^-4 = 0,1$ms.\
  $t_p = 20 * 10^3/2*10^8 = 10^-4 = 100$ micro-secondi\

  il tempo totale di trasmissione è quindi pari a $T = 0,1 + 0,2 = 0,3$ ms

  Quanto pesa quindi il tempo di propagazione e quanto quello di trasmissione sul tempo finale $T$?

  Nel primo caso, la maggior parte di $T$ è occupata da $t_x$, quindi non posso fare altro

  Nel secondo caso, in cui $2t_p > t_x$, posso *aumentare l'efficienza* della porta di I/O, perchè posso mandare più frame prima di ricevere l'ACK.

  Possiamo accorgerci di questo proprio grazie al  calcolo dell'utilizzo del canale:

  - 1° caso: $U = (0,1)/(0,12) = 0,83$. *utilizzo del canale del 83%*
  - 2° caso: $U = (0,1)/(0,3) = 0,33$. *utilizzo del canale del 33%*

  Per massimizzare il secondo caso, devo riuscire a mandare in parallelo 3 frame, in modo tale che: 

  #align(center, $U = (3 * 1/3)= 1$)

  Mandando quindi 3 frame, riesco a sfruttare al massimo il canale ( $U$ tende a 1), e quindi a massimizzare l'efficienza della porta di I/O.

]

= Lezione 5

== Dinamica della trasmissione

Nel caso di un protocollo a finestra, il trasmettitore è in grado di inviare più frame consecutivi prima di ricevere un ACK di conferma per ciascuno di essi. Questo sfrutta meglio la capacità del canale rispetto all'approccio stop-and-wait, dove il trasmettitore deve attendere un ACK per ogni frame prima di inviare il successivo. 

#align(center, image("images/image-17.png"))

Come si può osservare, il trasmettitore invia una sequenza di frame senza interrompersi, e ogni ACK ricevuto permette di scorrere la finestra di trasmissione, liberando spazio nel buffer per nuovi frame.

Quando un ACK valido arriva al trasmettitore, il frame corrispondente viene rimosso dal buffer, poiché la sua corretta ricezione è stata confermata.

#important[Quando l'ACK arriva al trasmettitore, il frame corrispondente viene eliminato dal buffer]

== Gestione delle perdite di frame

Nel caso in cui un frame venga perso o danneggiato, il protocollo deve adottare strategie di ritrasmissione che garantiscano:
1. Mantenimento dell'ordine corretto dei frame
2. Assenza di frame mancanti
3. Nessuna duplicazione di frame

== Modalitàdi ricezione nei protocolli a finestra

Nell'ambito dei protocolli di trasmissione a finestra, esistono due approcci principali per la gestione dei frame ricevuti:

1. *Selective repeat*: *utilizza un buffer di ricezione*, permettendo di conservare i frame ricevuti correttamente anche se fuori sequenza. Il trasmettitore ritrasmette solo i frame mancanti, senza dover reinviare l'intera finestra.
2. *Go-back-n*: *Non utilizza un  buffer di ricezione*, quindi il ricevitore accetta solo frame ricevuti nell'ordine corretto. Se un frame è perso o ricevuto fuori sequenza, tutti i frame successivi vengono ignorati fino a quando il frame mancante no viene correttamente ritrasmesso

== Go-back-n

In *Go-back-n*, se il ricevitore rileva un'interruzione nella sequenza (ovvero, manca un frame), deve negoziare con il trasmettitore la ritrasmissione del frame corretto, che è ancora presente nel buffer di trasmissione del mittente.

Durante questo periodo, *nessun altro frame viene accettato*, rendendo il protocollo meno efficiente.

In particolare:

1. Il ricevitore rileva un "buco" nella sequenza e non può validare il frame successivo.
2. Invia un *NAK* (Negative Acknowledgment) con il numero di sequenza del frame mancante.
3. Il trasmettitore *ritrasmette il frame richiesto* e tutti quelli successivi.
4. Nel frattempo, il ricevitore *smette di inviare ACK*, quindi il buffer del trasmettitore si riempie.
5. Una volta ricevuto il frame corretto, il ricevitore riprende la trasmissione degli ACK, permettendo al trasmettitore di liberare il buffer e inviare nuovi dati.

#align(center, image("images/image-18.png"))

== ACK selettivi vs ACK cumulativi

Per ottimizzare il meccanismo di conferma della ricezione, possiamo utilizzare due tipi di ACK:

1. ACK *selettivi*: Ogni ACK conferma la ricezione di un singolo frame specifico, identificato dal numero di sequenza. Se un ACK viene perso, il trasmettitore potrebbe dover ritrasmettere frame già ricevuti correttamente, generando overhead aggiuntivo.
2. ACK *cumulativi*: Ogni ACK non è associato a un singolo frame, ma indica che tutti i frame fino a un certo numero di sequenza sono stati ricevuti correttamente. *Se un ACK viene perso, non ha alcun impatto*, perché il trasmettitore riceverà comunque il successivo, che conferma la ricezione della sequenza completa.

L'ACK cumulativo riduce il numero totale di messaggi di conferma, ottimizzando l'uso della banda, evita la necessità di inviare NAK separati, e dona una maggior robustezza in caso di perdita di ack.

== Selective repeat

In *selective repeat*, si consente al ricevitore di accettare e memorizzare frame fuori sequenza, evitando di ritrasmettere inutilmente frame già ricevuti correttamente.

In particolare: 

1. Il trasmettitore invia i frame secondo una finestra di trasmissione (Sliding Window Protocol).
2. Il ricevitore accetta e bufferizza i frame ricevuti correttamente, *anche se fuori ordine*.
3. Se un frame viene perso o corrotto, il ricevitore invia un NAK (Negative Acknowledgment) o evita di inviare un ACK per quel frame.
4. Il trasmettitore ritrasmette solo i frame mancanti, senza dover reinviare l’intera finestra.
5. Quando tutti i frame fino a un certo numero sono stati ricevuti e riconosciuti, il ricevitore rilascia i frame in ordine al livello superiore e sposta avanti la finestra di ricezione.

#align(center, image("images/image-20.png"))

#important[Differenza principale rispetto a GO-back-n: Selective repeat mantiene un buffer di ricezione grando n (finestra), permettendo di conservare frame ricevuti correttamente fuori ordine. Questo evita di dover ritrasmettere tutta la finestra quando si verifica un errore. Go-back-n invece ha un buffer di ricezione grande 1]

#important[In Go-Back-N, il trasmettitore usa un unico timer per tutta la finestra: se un pacchetto va perso, ritrasmette tutta la finestra.
In Selective Repeat, ogni pacchetto ha un proprio timer: se un singolo pacchetto non viene confermato entro il tempo limite, viene ritrasmesso senza toccare gli altri pacchetti.]

== Dimensione del campo del numero di sequenza in base alla finestra di trasmissione (k)

In protocolli di trasmissione come Go-Back-N e Selective Repeat, il numero di sequenza di un pacchetto deve essere unico all'interno della finestra attuale, ma non necessariamente globale per tutta la trasmissione. Per ottimizzare lo spazio, si utilizza un numero di sequenza ciclico, cioè si riutilizzano i numeri dopo un certo limite.

Se la finestra di trasmissione ha dimensione k, il numero di sequenza deve avere abbastanza valori unici per identificare correttamente i pacchetti.

Il numero massimo di sequenze distinte rappresentabili con m bit è:

#align(center, $N = 2^m$)

Analizziamo ora un caso particolare: 

#align(center, image("images/image-19.png"))

== Gestione della ritrasmissione con numerazione ciclica

Quando si usa un numero di sequenza ciclico (che si resetta dopo un certo valore massimo), è importante assicurarsi che il ricevitore non confonda un pacchetto ritrasmesso con uno nuovo. Vediamo come si affronta il problema nei due protocolli principali:

Nel protocollo *Go-Back-N*, il ricevitore accetta solo i frame in ordine e scarta quelli fuori sequenza.

- La dimensione del numero di sequenza deve essere $k+1$ per evitare ambiguità.
- se $k = 3$, il numero di sequenza ha un massimo di $2^m$ valori.
- Quando il ricevitore aspetta il frame `4`, tutti i frame con numero `0`, `1`, `2` vengono scartati.
- Questo assicura che, quando il trasmettitore ritrasmette, il ricevitore possa distinguere tra un frame nuovo e uno vecchio ritrasmesso.

#tip[Se la finestra di trasmissione ha dimensione $k$, il numero di sequenza deve essere $k+1$ per evitare ambiguità.
Dopo aver ricevuto i pacchetti `1`, `2`, `3`, il ricevitore si aspetta `4`.Se il trasmettitore ritrasmette il pacchetto `1`, il ricevitore capisce che non sono arrivati gli ACK e scarta il pacchetto perché fuori sequenza.]

Nel protocollo *Selective repeat*, questo tipo di numerazione non funziona. Ricordiamo infatti che i pacchetti rimangono in un buffer di ricezione, quindi nel caso di ritrasmissione di un pacchetto, il ricevitore non saprebbe distinguere il pacchetto ritrasmesso da quello vecchio.

- Per distinguere un vecchio pacchetto ritrasmesso da uno nuovo, la finestra di numerazione deve essere almeno $2k$.
- Se $k=3$, allora la numerazione deve avere almeno 6 valori distinti (da 0 a 5).
- Questo assicura che, quando il numero di sequenza si ripete, il ricevitore abbia già eliminato i pacchetti precedenti e possa accettare i nuovi senza confusione.

= Lezione 6

Le reti locali (Local Area Networks, *LAN*) presentano una topologia differente rispetto a quella vista per il livello 2. In particolare, le LAN adottano una topologia di tipo *broadcast*, a differenza della topologia magliata, nota anche come *point-to-point*, in cui ogni nodo è collegato ai suoi adiacenti mediante un link diretto.

In una topologia broadcast, ogni nodo è collegato contemporaneamente a tutti gli altri nodi della rete. Questo significa che quando un nodo trasmette un segnale, esso è ricevuto da tutti i nodi connessi alla rete, *compreso il trasmettitore stesso*.

== Tipologie di topologie di broadcast

=== 1. Topologia a stella con hub passivo

Una delle prime implementazioni della topologia broadcast è quella basata su un *hub*, un dispositivo che funge da centro stella passivo. L'hub riceve il segnale trasmesso da un nodo e lo propaga simultaneamente su tutte le linee di uscita, raggiungendo tutti i dispositivi connessi. La caratteristica principale dell'hub passivo è che esso non introduce alcuna logica di gestione del traffico, limitandosi alla semplice propagazione del segnale.

#align(center, image("images/image-21.png", width: 8cm))

=== 2. Topologia a bus lineare

Un'alternativa alla rete a stella con hub passivo è rappresentata dalla *rete a bus lineare*, utilizzata nelle prime versioni di Ethernet. Questo tipo di rete si basa su un unico mezzo trasmissivo condiviso da tutte le stazioni. Il termine "Ethernet" deriva proprio dal concetto di comunicazione via etere, in cui ogni nodo condivide il mezzo trasmissivo senza connessioni dirette punto-punto.

#align(center, image("images/image-22.png", width: 8cm))

#note[Dal punto di vista concettuale, le topologie a bus lineare e a stella con hub passivo sono entrambe configurazioni di rete broadcast, e quindi equivalenti. Tuttavia, con l'evoluzione delle tecnologie di rete, le reti locali hanno progressivamente abbandonato la topologia a bus lineare in favore della topologia a stella.]

== Problemi e soluzioni nella trasmissione su reti broadcast

In una rete di tipo broadcast, nasce la necessità di implementare un meccanismo che consenta la comunicazione mirata tra dispositivi specifici. Per farlo, ogni pacchetto trasmesso contiene un'intestazione che specifica l'indirizzo del nodo sorgente e dell'eventuale nodo destinatario. In questo modo, i nodi ricevono tutti i pacchetti trasmessi sulla rete, ma elaborano solo quelli destinati a loro.

=== Contesa per l'accesso al canale

Un'altra problematica fondamentale nelle reti broadcast è la *gestione dell'accesso al mezzo trasmissivo condiviso*. Poiché tutti i nodi condividono il canale, deve essere garantito un accesso *mutuamente esclusivo* alla trasmissione dei dati. Senza un meccanismo di regolazione, più nodi potrebbero tentare di trasmettere contemporaneamente, causando collisioni e impedendo una comunicazione efficiente.

Per risolvere questo problema, esistono due principali strategie di accesso al canale:

1. === Accesso deterministico: Token ring

Una rete ad anello con token utilizza un meccanismo *deterministico* per la gestione dell'accesso al canale. Il principio di funzionamento prevede che un *token*, ovvero un piccolo pacchetto speciale, venga fatto circolare lungo l'anello. La stazione che possiede il token è autorizzata a trasmettere un solo pacchetto. Quando il pacchetto inviato completa il giro dell'anello, il token viene rilasciato per consentire ad un altro nodo di trasmettere.

Questo sistema garantisce un *accesso equo* alla rete, permettendo a tutte le stazioni di trasmettere senza rischio di collisioni. Tuttavia, presenta alcuni svantaggi:
- Il tempo di attesa per ottenere il token può essere lungo, specialmente se l'anello è esteso.
- Se una stazione si aggiunge o viene rimossa dalla rete, il sistema deve essere aggiornato.
- È necessaria una *stazione master* che gestisca l'inserimento del token e intervenga nel caso in cui venga perso.

#note[A causa di questi limiti, la topologia Token Ring è stata progressivamente abbandonata.]

2. === Accesso NON detrministico: CSMA/CD in Ethernet

Abbiamo detto che il nostro obiettivo è quello di evitare la collisione tra due frame che sono spediti sul canale nello stesso momento.

#align(center, image("images/image-23.png", width: 8cm))

In questo caso ho quindi accesso libero al cavo, ma accetto la presenza di *collisioni* e quindi del dover ritrasmettere dei frame corrotti.

Al tempo $t_3$ `B` e `C` si accorgono di avere colliso, ma non posso permettere che ritrasmettino subito, altrimenti avrei una nuova collisione. Genero quindi un *ritardo di trasmissione casuale*, diverso per ogni stazione.

Questo algoritmo viene chiamato *Aloha*. 

L'algoritmo Aloha è uno dei primi protocolli sviluppati per la gestione dell’accesso multiplo su un canale condiviso. Tuttavia, presenta una curva di efficienza che tende a diminuire con l’aumentare del numero di stazioni connesse, garantendo un utilizzo del canale di circa il 18%.

L’efficienza così bassa è dovuta a diversi fattori:
- *Attesa dell’ACK*: Anche se una stazione trasmette da sola, deve attendere un riscontro (ACK) prima di poter inviare un nuovo pacchetto, introducendo ritardi.
- *Collisioni imprevedibili*: Una trasmissione può iniziare in qualsiasi momento, senza alcun meccanismo di coordinazione, aumentando la probabilità di sovrapposizione tra pacchetti.
- *Rilevazione tardiva degli errori*: La stazione trasmittente si accorge di un’eventuale collisione solo dopo aver ricevuto o meno l’ACK, il che comporta spreco di banda nel caso di pacchetti corrotti.
- *Tempi di propagazione elevati*: Originariamente, Aloha fu sviluppato per comunicazioni via satellite, dove il ritardo di propagazione introduceva ulteriori inefficienze.

Per migliorare l’efficienza, sono stati sviluppati protocolli più avanzati che regolano in modo più intelligente l’accesso al canale.

Un’evoluzione di Aloha è il Carrier Sense Multiple Access with Collision Detection (*CSMA/CD*), adottato da *Ethernet*. A differenza di Aloha, dove le stazioni trasmettono senza controllare lo stato del canale, CSMA/CD introduce un meccanismo di ascolto preventivo:

- Ogni nodo ascolta il canale prima di trasmettere (*Carrier Sense*).
- Se il canale è libero, il nodo trasmette il pacchetto.
- Se due nodi trasmettono contemporaneamente, si verifica una collisione
- In caso di collisione, i nodi interrompono la trasmissione e attendono un intervallo di tempo casuale prima di riprovare.

#align(center, image("images/image-24.png", width: 8cm))

#important[In questo modo, si elimina il problema di trasmettere pacchetti completi senza sapere se sono corrotti.]

Con CSMA/CD, ogni stazione è in grado di monitorare il segnale che sta trasmettendo e di confrontarlo con ciò che riceve sul canale. Se una stazione rileva una discrepanza tra il segnale inviato e quello effettivamente presente sul canale, significa che si è verificata una collisione. In questo caso, interrompe immediatamente la trasmissione, evitando di occupare inutilmente il canale con pacchetti lunghi ma corrotti.

Questo meccanismo di *Collision Detection* è possibile grazie alla presenza di due collegamenti sul canale: uno per la trasmissione e uno per la ricezione. Così, la stazione può ascoltare il canale mentre trasmette e accorgersi istantaneamente delle collisioni.

Una volta rilevata una collisione, la stazione applica un meccanismo di ritrasmissione con attesa casuale (backoff esponenziale). In pratica, non prova a trasmettere subito, ma aspetta un intervallo di tempo casuale prima di ritentare, riducendo la probabilità di una nuova collisione.

Grazie a questo sistema, CSMA/CD migliora significativamente l’efficienza rispetto ad Aloha, riducendo lo spreco di banda e ottimizzando l’utilizzo del canale di comunicazione.

Questo approccio permette una gestione più dinamica del traffico di rete, senza necessità di coordinatori centralizzati o token. Tuttavia, essendo un sistema *probabilistico*, non garantisce che ogni nodo trasmetta con la stessa equità di un sistema deterministico come il Token Ring.

#important[*Differenza tra approccio Ethernet e approccio Token-ring*: nell'approccio ethernet il controllo di accesso al canale è totalmente distribuito, non ho un'istituzione centrale che genera il token. Il controllo è equamente distribuito tra tutte le stazioni in rete]

== Gestione della ritrasmissione dopo una collisione

Dopo aver rilevato una collisione, una stazione deve decidere quando ritentare la trasmissione per evitare nuove collisioni immediate. Esistono diversi approcci per determinare il tempo di attesa prima della ritrasmissione, tra cui:

=== *1-Persistent CSMA/CD*

Il protocollo CSMA/CD è *1-persistent*, il che significa che le stazioni monitorano costantemente il canale e, non appena lo rilevano libero, trasmettono immediatamente. Questo comportamento massimizza l’utilizzo del canale ma può aumentare la probabilità di collisioni, specialmente in reti con un alto numero di stazioni.
=== *Binary Exponential Backoff (BEB)*

Per gestire le collisioni e ridurre la probabilità che si ripetano, CSMA/CD utilizza un meccanismo di backoff esponenziale chiamato Binary Exponential Backoff (*BEB*). Dopo ogni collisione, la stazione attende un tempo casuale prima di ritentare la trasmissione. Questo intervallo di attesa è scelto in modo crescente, in base al numero di collisioni subite
#align(center, $"ritardo" = "random"(0, 2^i-1) * T_"slot"$)

#note[`i` è il numero di collisioni subite fino a quel momento dalla stazione (ogni stazione tiene traccia autonomamente di questo valore).\
$T_"slot"$ è il tempo minimo di attesa tra due trasmissioni, tipicamente legato al tempo di propagazione del segnale nella rete.]

Ogni stazione è ancora completamente *autonoma* nella gestione delle collisioni e del backoff. In particolare:

- Sa se ha subito una collisione perché può rilevarla mentre trasmette.
- Tiene traccia del numero di collisioni avvenute per determinare il valore di i.
- Decide in modo indipendente il tempo di attesa prima di ritentare la trasmissione, senza bisogno di coordinazione centralizzata.

Grazie a questo meccanismo, CSMA/CD bilancia l'aggressività delle stazioni (1-persistent) con un sistema di attesa progressiva (BEB), ottimizzando l’utilizzo del canale e riducendo il numero di collisioni nel tempo.

=== Definizione dell'unità di tempo nel Binary Exponential Backoff (BEB) secondo IEEE 802.3

Nel protocollo CSMA/CD 1-Persistent, l'unità di tempo utilizzata nel meccanismo di Binary Exponential Backoff (BEB) è derivata dallo standard *IEEE 802.3*, che specifica le caratteristiche fisiche della rete Ethernet cablata.

Lo standard stabilisce che un segmento di rete ethernet classico può avere una lunghezza massima di 2500 metri suddivisa in 5 tratte da 500 metri ciascuna, separate da 4 ripetitori che rigenerano il segnale.

Questa configurazione determina il tempo massimo di propagazione di un segnale attraverso l'intera rete.

Per garantire il corretto funzionamento del protocollo CSMA/CD, lo standard IEEE 802.3 definisce un tempo minimo di attesa, noto come *Slot Time*  che rappresenta il tempo massimo necessario affinché un segnale possa propagarsi attraverso l'intera rete e tornare alla stazione trasmittente in caso di collisione.

=== Calcolo dello slot time

La velocità di propagazione del segnale nei cavi Ethernet in rame è circa $2 × 10^8$m/s, ovvero circa 2/3 della velocità della luce nel vuoto. Considerando una rete con lunghezza massima di 2500 metri, il tempo necessario affinche un segnale percorra questa distanza è:\
#align(center, $"Tempo di andata" = 2500/2*10^8 = 12.5 "micro-secondi"$ )

Tuttavia, lo standard impone uno Slot Time di *512 bit time*, che per una velocità di 10 Mbps corrisponde a:

#align(center, $512_"bit"/10^7_"bit/s" = 51.2 "micro-secondi"$)

Questo valore è superiore ai 25 µs calcolati per il solo tempo di andata e ritorno. Il motivo di questa scelta è legato a diversi fattori:

- *Margine di sicurezza*: il segnale può subire ritardi nei ripetitori e altri dispositivi di rete.
- *Garanzia di rilevamento della collisione*: tutte le stazioni devono avere il tempo necessario per rilevare la collisione e reagire.
- *Compatibilità con altre configurazioni di rete*: lo Slot Time è un parametro fisso che garantisce il corretto funzionamento della rete Ethernet in diverse condizioni operative.

Grazie a questo meccanismo, il protocollo CSMA/CD può rilevare in modo affidabile le collisioni e gestire il backoff esponenziale per ridurre la probabilità di collisioni ripetute.

= Lezione 7

== Codifica di manchester

Nella trasmissione di dati su lunghe distanze, possono verificarsi problemi legati alla corretta interpretazione dei bit, specialmente quando vengono trasmessi lunghi intervalli di zeri o uni consecutivi. Inoltre, i livelli di tensione possono subire distorsioni, rendendo difficile il riconoscimento dei dati trasmessi. Infine, vogliamo dare al ricevitore la capacità di distinguere chiaramente uno stato idle ad uno stato dove ci sono dei bit che stanno arrivando

La *codifica di Manchester* risolve questo problema raddoppiando la velocità del clock di trasmissione, in modo da avere i fronti di clock a metà periodo del bit trasmesso. Questo approccio consente di ridurre la distorsione e garantire una sincronizzazione più precisa tra trasmettitore e ricevitore.

=== Codifica del bit

Secondo lo standard manchester:

- Per trasmettere un `0`, si genera una transizione da alto a basso a metà del periodo.
- Per trasmettere un `1`, si genera una transizione da basso ad alto a metà del periodo.

Questa tecnica garantisce che vi sia almeno una transizione per ogni bit trasmesso, consentendo al ricevitore di sincronizzarsi con il flusso di dati.

#align(center, image("images/image-25.png"))

Un aspetto importante della codifica di Manchester è la presenza di uno *shift* di mezzo bit nella trasmissione. Questo significa che la sequenza di bit sul cavo inizia con un ritardo di mezzo ciclo di clock rispetto al buffer del trasmettitore (guardo a metà del fronte).

L'innovazione principale di questa tecnica risiede quindi nella combinazione di transizioni *per ogni bit trasmesso* e nella sincronizzazione migliorata, che riduce la probabilità di errori e migliora l'affidabilità della comunicazione su lunghe distanze.

=== Recupero del clock 

Poiché ogni bit contiene almeno una transizione di stato, il ricevitore può sincronizzare il proprio clock su queste transizioni. Ogni transizione, che avviene esattamente nel mezzo del bit, rappresenta un colpo di clock che il ricevitore può utilizzare per allineare il proprio orologio.

Il ricevitore non si sincronizza con tutte le transizioni, ma solo con quelle che sono "necessarie". Il preambolo (una sequenza di bit speciali) è fondamentale per questa operazione: fornisce una serie di transizioni consecutive che consentono al ricevitore di allinearsi con il trasmettitore in modo affidabile. Durante la sequenza di preambolo, il ricevitore può perfezionare la sua sincronizzazione, assicurandosi che il suo clock di ricezione sia correttamente allineato con quello del trasmettitore.

#note[Il *preambolo* è una sequenza di bit (tipicamente alternati 1 e 0, quindi con transizioni continue) che precede il vero e proprio messaggio. Il suo scopo principale è quello di consentire al ricevitore di "rilevare" il clock del trasmettitore. Durante il preambolo, la sequenza di transizioni è abbastanza lunga da permettere al ricevitore di adattarsi e sincronizzarsi al clock di trasmissione. Il preambolo consente quindi di "riconoscere" l'inizio della trasmissione e di avere un allineamento preciso per il resto dei dati.]

#important[Il trasmettitore crea il preambolo prima di inviare i dati reali. Se il protocollo prevede la codifica di Manchester, il trasmettitore invia una sequenza di bit alternati `(1, 0, 1, 0...)` come preambolo.\ Nel contesto di una trasmissione di dati, il preambolo è generalmente generato automaticamente dalla logica del trasmettitore in fase di trasmissione. Non è qualcosa che viene "inserito" manualmente, ma è un componente del protocollo di comunicazione che il trasmettitore sa di dover inviare.]

Una volta che il ricevitore si è sincronizzato con la transizione del preambolo, il suo clock di ricezione è allineato con quello del trasmettitore. Successivamente, ogni bit trasmesso, con le sue transizioni in corrispondenza dei confini di bit, consente al ricevitore di continuare a mantenere il proprio clock allineato con il trasmettitore. Non è più necessario un segnale esterno di clock, poiché il ricevitore continua a estrarre il clock dai dati stessi.

La codifica di manchester fornisce dunque una serie di vantaggi: 

- *Affidabilità*: La sincronizzazione avviene in modo continuo tramite le transizioni, eliminando la necessità di un clock separato o di un segnale di sincronizzazione esterno.
- *Robustezza alle distorsioni*: Poiché la sincronizzazione si basa sulle transizioni (e non solo sul livello di segnale), la codifica di Manchester è più resistente a distorsioni come rumore o attenuazione del segnale.
- *Efficiente in canali non sincronizzati*: La codifica di Manchester è particolarmente utile in situazioni in cui il canale di comunicazione non è sincronizzato, o quando è difficile fornire un segnale di clock separato.

== Efficienza del canale in una rete Ethernet

Per analizzare l'efficienza dell'uso del canale in una rete *Ethernet* punto a punto, possiamo considerare il modello di *contesa* e come influisce sulle prestazioni globali, in particolare il *tempo di contesa* (delay) e la *probabilità di collisione*.

La *contesa* si riferisce alla probabilità che più stazioni cercano di accedere al canale nello stesso momento, portando a collisioni.

Il parametro $1/A$ rappresenta questa probabilità di contesa media, dove `A` è il numero medio di contese sul canale. La formulazione del tempo di accesso, pertanto, include questa probabilità di contesa, e il valore di `A` tende a $1/e$ quando il numero di stazioni `k` tende all'infinito (approccio asintotico).

=== Formula dell'efficienza del canale

Nel contesto di una rete punto a punto, l'efficienza d'uso del canale può essere espressa come:

#align(center, $U =t_x /(t_x + 2t_p*e)$)

Dove:

- $t_x$ = tempo di trasmissione
- $t_p$ = tempo di propagazione
- $e$ = parametro che tiene conto della contesa e della probabilità di collisione

Sostituiendo questi valori nella formula:

- $t_x = L_"frame"/B$, dove $L_"frame"$ è la lunghezza del frame e $B$ è la valocità di trasmissione
- $t_p = L_"canale"/v_p$ dove $L_"canale"$ è la lunghezza del canale e $v_p$ è la  velocità di propagazione nel mezzo di trasmissione.

La formula dell'utilizzo si semplifica nel seguente modo:

#align(center, $U = 1/(1 + (2*B*L_"canale"*e)/(L_"frame"*v_p))$)

Questa formula mostra che all'aumentare della banda $B$ o della lunghezza del canale $L_"canale"$, l'efficienza diminuisce. Questo accade perché l'aumento della banda o la lunghezza del canale aumentano il tempo di propagazione rispetto al tempo di trasmissione del frame, il che può portare a un maggiore impatto delle collisioni e della contesa sul canale.

#note[*Contesa e probabilità di collisione*: Il termine $A$ (il quale tende a $1/e$ per $k$ stazioni molto grandi) indica l'impatto delle collisioni nel contesto di un protocollo come *CSMA/CD*. Maggiore è la probabilità di contesa sul canale, più tempo viene perso nel processo di accesso al canale, riducendo l'efficienza complessiva.]

== Topologia ad albero mediante hub

La topologia ad albero formata tramite hub è oggi una delle architetture più utilizzate nelle reti Ethernet. In questa configurazione, le stazioni sono collegate all'hub tramite due cavi: uno per la trasmissione dei dati e uno per la ricezione. Ogni stazione invia e riceve i dati attraverso l'hub, il quale si occupa di ritrasmettere i segnali a tutte le altre stazioni connesse.

#align(center, image("images/image-26.png", width: 10cm))

Un aspetto importante da notare in questa topologia è che le collisioni si verificano all'interno dell'hub, ma non creano problemi per il ricevitore in quanto le stazioni sono in grado di monitorare il proprio traffico. Se un file trasmesso risulta corrotto, la stazione si accorge dell'errore e può richiedere una ritrasmissione del pacchetto, evitando la necessità di ritrasmettere un file errato senza che il ricevitore se ne accorga.

Le collisioni si verificano quando due stazioni tentano di trasmettere nello stesso momento. In questo caso, il segnale che raggiunge l'hub da entrambe le stazioni si sovrappone e le informazioni vengono danneggiate. Tuttavia, questo problema può essere gestito grazie al protocollo CSMA/CD, che è implementato nelle stazioni.

Quando una stazione rileva una collisione, smette di trasmettere e avvia un processo di *ritrasmissione esponenziale backoff*, durante il quale attende un periodo di tempo casuale prima di riprovare a trasmettere.

Quando il numero di stazioni in una rete cresce significativamente, la topologia a stella con hub può diventare inefficace, principalmente a causa della crescente probabilità di collisione. Questo accade perché, all'aumentare del numero di stazioni, il dominio di collisione si espande, e più stazioni competono per l'accesso al canale condiviso, riducendo l'efficienza complessiva della rete. Questo fenomeno si traduce in una riduzione della capacità di trasmissione disponibile e in una maggiore latenza dovuta ai continui tentativi di accesso concorrente al canale.

== Dominio di collisione

Il *dominio di collisione* rappresenta l'insieme di stazioni che condividono un canale di comunicazione e che, pertanto, sono vulnerabili a collisioni tra i loro pacchetti di dati. Quando due stazioni tentano di trasmettere nello stesso momento, si verifica una collisione, e i dati devono essere ritrasmessi. In una topologia centralizzata con hub, tutte le stazioni appartengono al medesimo dominio di collisione, il che significa che l'accesso simultaneo di più stazioni al canale porta inevitabilmente a collisioni, riducendo l'efficienza della rete.

== Soluzione: introduzione del bridge

Per ridurre le collisioni e migliorare l'efficienza della rete, una soluzione comune consiste nell'introdurre un dispositivo chiamato *bridge*. Il bridge funge da "ponte" tra due segmenti di rete, separando fisicamente i domini di collisione. In altre parole, il bridge divide il dominio di collisione in più sottoreti, ognuna delle quali è gestita separatamente.

#align(center, image("images/image-27.png", width: 10cm))

Questa separazione riduce la probabilità di collisione all'interno di ciascun dominio di collisione, poiché solo le stazioni appartenenti a una specifica sottorete competono tra loro per l'accesso al canale. 

#note[Le stazioni appartenenti a sottoreti diverse possono comunque comunicare tra loro attraverso il bridge.]

== Funzionamento del bridge

A differenza di un hub, che è un dispositivo passivo che trasmette semplicemente i pacchetti a tutte le stazioni connesse, il bridge è un *dispositivo intelligente*. Esso esegue una serie di operazioni avanzate per ottimizzare il traffico tra le diverse sottoreti.

Il bridge ha il compito di collegare due o più segmenti di rete, separando i domini di collisione ma mantenendo un unico dominio di broadcast. Il suo funzionamento si basa su un processo di *store and forward*, filtrando e inoltrando i pacchetti solo quando necessario.

=== *Separazione dei Domini di Collisione*

Il bridge agisce come un *ponte* tra due segmenti di rete, riducendo il numero di stazioni che competono per lo stesso canale di trasmissione e, di conseguenza, il numero di collisioni. Tuttavia, *non controlla direttamente le collisioni*, ma le evita separando il traffico tra i segmenti.

=== *Store e fowording*

- Quando un frame arriva al buffer del bridge, il dispositivo esamina l'indirizzo MAC di destinazione.
- Se la destinazione si trova nello stesso segmento da cui proviene il frame, il bridge scarta il pacchetto, evitando traffico inutile.
- Se la destinazione si trova nell'altro segmento, il bridge inoltra il pacchetto attraverso la porta corrispondente.

=== Tabella di fowording

Per determinare su quale porta inoltrare i pacchetti, il bridge mantiene una *tabella di forwarding*, che può essere costruita manualmente o attraverso un processo di apprendimento automatico (learning).

Ogni voce nella tabella di forwarding contiene:

- Indirizzo *MAC* della stazione.
- Porta di *I/O* corrispondente.
- *Timestamp* per il timeout delle voci obsolete (nelle versioni avanzate).

#align(center, image("images/image-28.png", width: 10cm))

Il bridge aggiorna la tabella automaticamente:

1. Quando riceve un pacchetto, estrae l'indirizzo MAC sorgente e lo associa alla porta da cui è arrivato.
2. Se l'indirizzo di destinazione è già presente nella tabella, il pacchetto viene inoltrato alla porta corretta.
3. Se l'indirizzo non è presente, il bridge trasmette il pacchetto su tutte le porte (*flooding*), in attesa di apprendere la posizione del destinatario.

#important[Mentre gli hub lavorano a livello fisico, i bridge lavorano a livello 2]

== Ottimizzazione della rete: l'introduzione dello switch

Per migliorare ulteriormente le prestazioni di una rete e superare i limiti di hub e bridge, si introduce un dispositivo avanzato: lo *switch*.

Lo switch rappresenta un'evoluzione rispetto agli hub e ai bridge, ottimizzando la gestione del traffico di rete e riducendo drasticamente le collisioni. La sua principale innovazione sta nel modo in cui gestisce la connettività tra le porte di ingresso e uscita.

=== Il funzionamento dello switch

Lo switch è un dispositivo di livello 2, proprio come il bridge, e si basa sul concetto di *store and forward*:

1. Riceve il frame e lo immagazzina in un buffer
2. Analizza il MAC address di destinazione
3. Consulta la tabella di fowording per determinare la porta di uscita corretta
4. inoltra il pacchetto *Solo sulla porta corretta*, evitando traffico inutile sulle altre porte.

La tabella di forwarding viene costruita dinamicamente con lo stesso meccanismo del bridge: il dispositivo apprende gli indirizzi MAC associati a ciascuna porta e aggiorna la tabella automaticamente.

#align(center, image("images/image-29.png"))

=== Vantaggi dello switch rispetto al bridge

1. *Connessioni punto-a-punto*: A differenza del bridge, che connette due segmenti di rete condivisi, lo switch stabilisce connessioni dirette tra i dispositivi, creando canali dedicati tra mittente e destinatario. Questo elimina la necessità di gestire le collisioni con il protocollo *CSMA/CD*.
2. *Prestazioni superiori*: Poiché ogni connessione è indipendente, più dispositivi possono comunicare simultaneamente senza interferenze.
3. *Eliminazione delle collisioni*: Mentre un bridge separa il dominio di collisione in due parti, uno switch *crea un dominio di collisione separato per ogni porta*. Ciò significa che non avvengono più collisioni tra dispositivi collegati a porte diverse dello switch.
4. *Supporto a Tecnologie Avanzate*: Gli switch possono utilizzare fibra ottica per connessioni più veloci e affidabili. 

=== Architettura ibrida: Hub e switch

Nelle reti moderne, gli hub vengono spesso utilizzati solo nella *periferia della rete*, per connettere più dispositivi locali. Tuttavia, invece di essere collegati direttamente tra loro, *gli hub vengono collegati a uno switch*, che gestisce il traffico in modo intelligente.

Questa configurazione permette di *limitare i domini di collisione solo alle reti locali* (collegate agli hub), mentre la parte principale della rete, gestita dallo switch, rimane priva di collisioni.

= Lezione 8

== Ottimizzaziione dell'utilizzo in reti Ethernet ad alta velocità

L’evoluzione delle reti Ethernet ha portato a un aumento significativo della velocità di trasmissione, ma ha anche introdotto nuove problematiche legate all’efficienza della comunicazione e alla gestione delle collisioni. Uno degli aspetti critici è la relazione tra velocità di trasmissione e lunghezza massima del canale, che incide direttamente sulle prestazioni della rete.

=== Problema della lunghezza massima del canale

Consideriamo una rete Ethernet con velocità di *1 Gbps*. Con l’aumento della velocità, la lunghezza massima del canale `L` diventa un parametro fondamentale, in quanto determina il tempo massimo di propagazione e, di conseguenza, la gestione delle collisioni.

Per garantire un elevato utilizzo della rete, una lunghezza $L = 2,5$ km risulta *NON accettabile*. Lo standard Ethernet impone che la distanza massima tra le stazioni più lontane non superi i *200 m* per evitare problemi di latenza e garantire un funzionamento corretto del protocollo di accesso al mezzo trasmissivo.

#align(center, image("images/image-30.png", width: 8cm))

=== Calcolo del tempo di propagazione

#tip[Esempio:\
Per comprendere meglio il problema, consideriamo il tempo di propagazione massimo di un frame inviato da una stazione `A` a una stazione `C` attraverso un hub:

- `A` -> `Hub` -> `C`
- `C` -> `Hub` -> `A`

La distanza totale percorsa dal segnale è:

#align(center, $200+200+200+200= 800m$)

Calcoliamo il tempo di propagazione massimo ($2_"tp"$):

#align(center, $2_"tp" = (8*10^2m)/(2*10^8m/s) = 4 "µs"$)

Con una scheda di rete a *1Gbps*, calcoliamo quanti bit possono essere trasmessi in *4 µs*:

#align(center, $1 "µs" = 1000 "bit"$)
#align(center, $4 * 1000 = 4000 "bit" = 500 "byte"$)
Questa relazione evidenzia come la velocità di trasmissione influisca sulla gestione dei frame e sulla loro dimensione minima per garantire un’efficienza ottimale della rete.]

=== Dimensione minima di un frame in Gigabit Ethernet

A causa della maggiore velocità di trasmissione, lo standard Ethernet ha dovuto modificare la dimensione minima dei frame per evitare inefficienze legate alle collisioni. In particolare:

- La dimensione minima del frame viene aumentata da *64 byte* a *512 byte*.
- La lunghezza massima del canale viene ridotta da *2500 m* a *800 m*.

Questa modifica consente di mantenere un tempo di trasmissione sufficiente affinché i frame si propaghino attraverso il canale prima che un'altra stazione inizi una trasmissione, riducendo così il rischio di collisioni.

=== Il ruolo del livello MAC

Per comprendere meglio l’impatto di queste modifiche, è utile analizzare il ruolo del livello *MAC* (Media Access Control), che si colloca all’interno del livello Data Link (Livello 2), tra il livello Fisico (PHY) e il Logical Link Control (LLC).

#align(center, image("images/image-32.png", width: 10cm))

- Il *Livello Fisico* (PHY) si occupa della trasmissione effettiva dei bit sulla rete, attraverso il mezzo trasmissivo (rame, fibra, ecc.).
- Il *Livello MAC*, invece, è responsabile della gestione dell'accesso al mezzo trasmissivo e del formato delle frame Ethernet.
- Il *Logical Link Control* (LLC), che si trova sopra il MAC, gestisce l'integrità dei dati e il controllo degli errori.

Questa struttura garantisce che le diverse tecnologie di rete possano essere utilizzate senza modificare il funzionamento logico della comunicazione, adattandosi alle specifiche richieste del mezzo trasmissivo.

il formato dei frame ethernet, generato dal livello MAC, è cosi strutturato:

#align(center, image("images/image-33.png"))

=== Cosa succede se si cambia scheda di rete?

Un aspetto importante dell’adattabilità dello standard Ethernet riguarda la possibilità di sostituire una scheda di rete *10 Mbit/s* con una *1 Gbit/s*. In questo caso, il livello *MAC* continuerà a generare frame minimi da *64 byte*, come previsto dallo standard Ethernet originale. Tuttavia, per garantire la compatibilità con Gigabit Ethernet, la porta di I/O potrebbe applicare un *padding* per aumentare la dimensione del frame fino a *512 byte*, come richiesto dallo standard.

#align(center, image("images/image-31.png", width: 6cm))

Questa flessibilità consente di mantenere la compatibilità con le tecnologie precedenti, senza compromettere le prestazioni delle reti ad alta velocità. Tuttavia, sottolinea anche l'importanza di comprendere come i diversi livelli del modello OSI interagiscano tra loro per ottimizzare l’efficienza della rete.

==  Il ruolo del livello Data Link

Il livello Data Link ha il compito di gestire la comunicazione tra dispositivi direttamente collegati su una rete.

- *Nelle reti magliate*,il livello data link permetteva di creare connessioni punto-punto tra nodi adiacenti.
- *Nelle reti broadcast*, è necessario gestire l'accesso al mezzo condiviso (entra in gioco il *MAC*)

In Ethernet (IEEE 802.3), il livello Data Link si divide in due sottolivelli:

- *MAC* (Media Access Control) -> Gestisce l’accesso al canale condiviso.
- *LLC* (Logical Link Control) → Fornisce un’astrazione punto-punto sopra il livello MAC.

#align(center, image("images/image-34.png", width: 8cm))

=== Riassunto MAC layer

Il MAC è responsabile della gestione dell’accesso al mezzo trasmissivo.

- Definisce come i dispositivi possono trasmettere i dati.
- In Ethernet, quando si usa un *mezzo condiviso*, viene utilizzato *CSMA/CD* per rilevare e gestire le collisioni.
- Oggi, con gli switch, ogni dispositivo ha un canale dedicato, quindi *CSMA/CD non è più necessario*.

=== LLC Layer (Logical Link Control)

Sopra il MAC troviamo il sottolivello LLC, che ha il compito di:

- *Fornire una connessione logica punto-punto* tra due dispositivi su una rete broadcast.
- *Nascondere le specifiche del MAC* ai livelli superiori, fornendo un’interfaccia unificata.
- *Supportare diversi tipi di servizio*, sia *best effort* (come Ethernet) che *affidabile* (con meccanismi di ritrasmissione e controllo degli errori).

#note[Anche se il livello LLC può supportare protocolli affidabili, nella pratica la versione usata è sempre best effort, come avviene in Ethernet.]

#important[A differenza del MAC, che gestisce il mondo broadcast, il livello LLC fornisce una visione logica indipendente dal broadcast, creando canali *punto-punto* tra dispositivi sulla rete.]

Cosa significa?

Se il nodo `A` deve inviare un frame al nodo `C`, il LLC si occupa di astrarre la complessità del MAC, presentando la connessione come se fosse un semplice collegamento diretto tra `A` e `C`. Non è più necessario preoccuparsi di come il MAC trasformi il link fisico per funzionare correttamente. Il livello LLC costruisce un *grafo di connessioni logiche* tra le stazioni, indipendentemente dalla tecnologia sottostante.

#align(center, image("images/image-35.png", width: 8cm))

== Virtual LAN(VLAN)

#important[Una *VLAN* (Virtual LAN) è un'astrazione delle macchine collegate a una rete Ethernet che consente di raggruppare dispositivi in modo logico, indipendentemente dalla loro posizione fisica.]

L'uso di una VLAN comporta numerosi vantaggi quali:

- *Maggiore sicurezza*: Le macchine in VLAN diverse *non possono comunicare direttamente*, riducendo il rischio di accessi non autorizzati.
- *Maggiore Flessibilità*: I dispositivi possono essere raggruppati per *funzione* e non per posizione fisica.
- *Ottimizzazione del traffico*: Il traffico viene confinato all'interno della VLAN, riducendo la congestione e migliorando le prestazioni.

=== VLAN e forwarding nei bridge

Nei dispositivi di rete come gli switch (bridge multiporta), le tabelle di *forwarding* devono essere aggiornate per supportare le VLAN.

- *Tabella di forwarding tradizionale*:

#align(center, table(
  columns: (4fr, 4fr),

  table.header[MAC Address][Porta],
  [51], [2],
  [58], [5],
))

- *Tabella di forwarding con VLAN*:

#align(center, table(
  columns: (4fr, 4fr, 4fr),

  table.header[MAC Address][Porta][VLAN ID],
  [51], [2], [10 (ROSSA)],
  [58], [5], [20 (VERDE)],
  [59], [6], [20(VERDE)],
))

Ora una macchina non è più identificata solo dal *MAC address*, ma anche dal *VLAN ID*.

#align(center, image("images/image-36.png"))

- Due dispositivi con MAC address diversi possono appartenere alla stessa VLAN (es. 58 e 59 → VLAN VERDE).
- Due dispositivi con lo stesso switch fisico possono essere separati logicamente (es. 51 → VLAN ROSSA, mentre 58 → VLAN VERDE).
- *Il traffico è vincolato alla VLAN* → Una macchina può comunicare solo con dispositivi della stessa VLAN, a meno che non intervenga un router.

#warning[Come popolo la tabella?]

La soluzione è piuttosto semplice: Una macchina si fa "conoscere" non solo mostrando il suo MAC address, ma anche il suo VLAN id.

#warning[Come permetto la comunicazione tra VLAN diverse?]

=== Comunicazione tra VLAN diverse: Routing di Livello 3

Per permettere la comunicazione tra VLAN diverse, è necessario implementare il routing di livello 3. Questo perché le VLAN operano a livello 2 (Data Link) e segmentano la rete in domini di broadcast separati. Per far comunicare dispositivi appartenenti a VLAN differenti, è necessario un dispositivo di livello 3, come un router o uno switch Layer 3 (switch con funzionalità di routing).

#align(center, image("images/image-37.png", width: 10cm))

In una rete VLAN, ogni dispositivo connesso a una porta di uno switch può appartenere a una VLAN specifica. Gli switch gestiscono il traffico tra dispositivi della stessa VLAN senza bisogno di un router. Tuttavia, se un dispositivo in VLAN 10 vuole comunicare con un dispositivo in VLAN 20, sarà necessario un router o uno switch Layer 3.

=== Tipologie di frame nella rete VLAN

1. *Frame Untagged*: Sono i frame inviati da un host a uno switch. Non contengono alcun identificatore VLAN. Quando un frame untagged arriva su una porta I/O, lo switch lo associa a una VLAN specifica.
2. *Frame tagged*: Sono i frame inviati tra switch per trasportare informazioni su VLAN diverse. Lo switch aggiunge un *Tag VLAN* ai frame per indicare a quale VLAN appartengono.

=== Come avviene il tagging VLAN?

Lo standard IEEE 802.3 originale non prevedeva un campo per il tag VLAN. Per risolvere questo problema, è stato introdotto lo standard *IEEE 802.1Q*, che aggiunge un campo di tag VLAN ai frame Ethernet

#align(center, image("images/image-38.png"))

Il campo Tag VLAN è composto da: 

- VLAN protocol identifier (TPID): valore fisso a 0x8100 che indica la presenza del tag VLAN.
- VLAN identifier (VID): Specifica a quale VLAN appartiene il frame (colore)

L’aggiunta di questo tag fa aumentare la lunghezza del frame Ethernet da 64-1518 byte a 68-1522 byte.

#note[Il campo *Destination address* viene messo sempre prima del campo *Source address*: Questo è importante per effettuare più velocemente il fowarding: il source address infatti serve solamente per quelle stazioni che non sono ancora presenti in tabella!]

Quando due switch devono comunicare e supportare più VLAN, utilizzano un collegamento chiamato *trunk*. Una porta trunk può trasportare frame di più VLAN utilizzando il *tag VLAN 802.1Q*.

= Lezione 9

Quando un dispositivo comunica al di fuori della LAN, non può più fare affidamento sugli indirizzi MAC per identificare gli apparati, ma deve utilizzare il *protocollo IP*. Il protocollo IP è responsabile dell'instradamento dei pacchetti attraverso reti diverse fino alla loro destinazione.

In questa trattazione ci occupiamo dello standard *IPv4*.

== Struttura di un pacchetto IPv4

Un pacchetto IPv4 è composto da un *header* e un *payload*. L'header standard è di 20 byte (5 parole da 32 bit), ma può essere esteso con il campo "Options".

=== Struttura dell'header IPv4

L'header IPv4 è suddiviso in diversi campi:

1. *Version*(4 bit): Indica la versione del protocollo IP (4 per IPv4, 6 per IPv6)
2. *Lunghezza Header* (4 bit): Specifica la lunghezza dell'header IP in parole da 32 bit (necessario in caso di opzioni aggiuntive).
3. Type of Service (*TOS*) (8 bit): Definisce la priorità del pacchetto. Questo campo permette di assegnare differenti livelli di servizio in base alla tipologia di traffico.
4. *Total Length* (16 bit): Indica la lunghezza totale del pacchetto (header + payload) in byte. Valore massimo: 65.535 byte

#align(center, image("images/image-39.png"))

=== Gestione della frammentazione

Il secondo blocco da 32 bit riguarda la frammentazione del pacchetto:

5. *Identification* (16 bit): Numero identificativo del pacchetto, utile per la riassemblaggio di frammenti.
6. *Flags*:
  - Bit 0 (riservato)
  - *D bit*: se impostato impedisce la frammentazione del pacchetto
  - *M bit*: se impostato, indica che  ci sono frammenti successivi
7. *Fragment Offset*: Indica la posizione del frammento rispetto al pacchetto originale

L'IP può frammentare i pacchetti quando la rete sottostante ha limiti di dimensione. Questo livello di frammentazione è distinto da quello del livello 4 (es. segmentazione TCP). Infatti, la frammentazione avviene su due livelli:

- *Frammentazione di livello 4*: Avviene quando un'unità dati utente (User Data Unit) viene generata al livello 7, poi passata al livello 4, dove viene frammentata in segmenti. Ogni segmento può avere una lunghezza massima di 65.535 byte.
- *Frammentazione di livello 3*: Si occupa di adattare i pacchetti alla rete fisica sottostante. Ad esempio, una rete Ethernet ha una dimensione massima di frame di 1500 byte (inclusi header e dati). Se il pacchetto IP è più grande, deve essere frammentato ulteriormente a livello 3, altrimenti viene scartato.

#align(center, image("images/image-40.png"))

L'interfaccia di livello 3 deve conoscere la Maximum Transmission Unit (*MTU*) della rete sottostante per determinare la grandezza massima dei pacchetti che possono essere inviati senza frammentazione.

=== Gestione della durata e integrità del pacchetto

L'header prosegue con informazioni essenziali per il controllo del pacchetto:

8. Time To Live (*TTL*): Indica il numero massimo di `hop` (router attraversabili). Ad ogni `hop` il valore viene decrementato. Se arriva a 0, il pacchetto viene scartato.
9. *Protocol Selector*: A seconda del protocollo sorgente seleziona quello nnecessario in ricezione. (TCP - TCP, UDP - UDP)
10. *Header Checksum* (16 bit): Controllo di errore sull'header. Viene ricalcolato a ogni hop. IPv4 è una rete best effort, quindi non garantisce l'affidabilità. L'header checksum fornisce un'ulteriore verifica di integrità sull'header (non sui dati) calcolando una somma sulle 5 parole da 32 bit dell'header.

=== Indirizzamento IP

L'IP è un protocollo *best-effort*, quindi non garantisce la consegna dei pacchetti.

11. *Source IP Address* (32 bit): Indirizzo IP del mittente.
12. *Destination IP Address* (32 bit): Indirizzo IP del destinatario.

=== Opzioni e payload

13. *Options* (variabile): Campo opzionale per funzionalità avanzate (es. Source Routing).
14. *Payload*: Dati trasportati (es. segmenti TCP o datagrammi UDP)

come si frammentano i paccehtti al livello 3?

si sono inventati del contare gli ottetti. indice framment offset a 1? ho mandato il primo ottetto. questo ha delle implicazini su quello che posso mandare: deve essere un multiplo di 8

== Frammentazione dei pacchetti IP a livello 3

La frammentazione dei pacchetti IP avviene a livello 3 (IP) quando i dati da trasmettere superano la *MTU* (Maximum Transmission Unit) della rete sottostante.

#note[La MTU rappresenta la dimensione massima di un pacchetto che può essere trasmesso senza dover essere suddiviso]

Se un pacchetto è più grande della MTU, viene frammentato in più parti, ciascuna con il proprio header IP.

=== Processo di frammentazione

Quando un pacchetto IP supera la MTU del collegamento in uso, viene suddiviso in più frammenti. Ogni frammento contiene:

- Un header IP con informazioni specifiche sulla frammentazione.
- Una porzione dei dati originali.

=== Campi coinvolti nella frammentazione

Rianalizziamo i campi che contiene l'header IPv4, specifici per la frammentazione:

- *Total Length* (16 bit): Indica la lunghezza totale del pacchetto, inclusi header e dati.
- *Identification* (16 bit) – Identifica univocamente il pacchetto originale, permettendo ai frammenti di essere riassemblati correttamente.
- *Flags* (3 bit):
  - D Bit (Don't Fragment, bit 1): Se impostato, impedisce la frammentazione. Se il pacchetto supera la MTU e DF è attivo, il pacchetto viene scartato e viene inviato un messaggio ICMP "Fragmentation Needed".
  - M Bit (More Fragments, bit 2): Se impostato, indica che il pacchetto è stato frammentato e ci sono ulteriori frammenti in arrivo.
- *Fragment Offset* (13 bit): Indica la posizione del frammento all'interno del pacchetto originale. *Il valore è espresso in multipli di 8 byte* (ottetti).

=== Regole di frammentazione

Il primo frammento ha sempre offset 0. *Gli offset devono essere multipli di 8*, poichè il campo Fragment Offset usa unità di 8 byte. tutti i frammenti tranne l'ultimo devono avere una dimensione che sia multipla di 8 byte. Infine l'ultimo frammento non ha l'M bit impostato e può avere una dimensione inferiore.

#tip[

=== Esempio di frammentazione

Consideriamo un pacchetto originale di 7000B che attraversa due reti con diverse MTU.

#align(center, image("images/image-41.png"))

1. Token Ring LAN (MTU = 4000B)

Il pacchetto viene frammentato in: 

- Primo frammento: 3976B
- Secondo frammento: 3024B

2. Ethernet LAN (MTU = 1500B)

I frammenti precedenti devono essere ulteriormente frammentati per adattarsi alla nuova MTU:

- Il frammento da 4000B viene diviso in 3 sotto-frammenti:

  - 1480B, offset 0
  - 1480B, offset 185
  - 1048B, offset 370

- Il frammento da 3024B viene diviso in 3 sotto-frammenti:

  - 1480B, offset 497
  - 1016B, offset 682
  - 528B, offset 813 (ultimo frammento, MF = 0)

#important[Il valore di Fragment Offset è espresso in unità di 8 byte, quindi ad esempio un offset di 185 indica che il frammento inizia a 185 × 8 = 1480B dall'inizio del pacchetto originale.]
]

=== Riassemblaggio dei frammenti

Quando i frammenti raggiungono il destinatario, vengono riassemblati utilizzando il campo Identification per raggrupparli e il Fragment Offset per riordinarli. Il processo di riassemblaggio avviene solo nel dispositivo finale, non nei router intermedi.

== Il Ruolo degli Indirizzi IP

L'indirizzo *IP* ha permesso di interconnettere reti preesistenti, consentendo la comunicazione tra dispositivi su scala globale. La gestione e l'assegnazione degli indirizzi IP è responsabilità dell'*ICANN* (Internet Corporation for Assigned Names and Numbers), che delega questa funzione ai registri regionali.

Il livello 3 del modello OSI (Network Layer) è suddiviso in due sotto-livelli:

1. *Network*: si occupa della gestione del traffico all'interno della rete.
2. *IP*: si occupa della generazione e gestione degli indirizzi IP su tutta la rete.

== Tecniche di indirizzamento

Esistono cinque tecniche principali di assegnazione degli indirizzi IP:

1. *Classi di Indirizzi IP*

2. *Subnetting*

3. *CIDR (Classless Inter-Domain Routing)*

4. *NAT (Network Address Translation)*

5. *IPv6*

== Classi di Indirizzi IP

L'indirizzamento IP inizialmente era organizzato in classi, suddividendo gli indirizzi in cinque categorie: `A`, `B`, `C`, `D`, `E`.

#align(center, image("images/image-42.png"))

#note[
  Dot Notation degli Indirizzi IP

Un indirizzo IP v4 è formato da 32 bit e viene scritto nella forma decimale puntata, detta *dot notation*, suddiviso in quattro blocchi (ottetti) da 8 bit ciascuno.

Esempio:
11000000 10101000 00000001 00000001 (binario) = 192.168.1.1 (decimale puntato).

Ogni ottetto può variare da 00000000 (0 in decimale) a 11111111 (255 in decimale).
Quindi un indirizzo IP può andare da 0.0.0.0 a 255.255.255.255.
]

Gli indirizzi IP di classe A (che vanno da `0.0.0.0` a `127.255.255.255`) sono caratterizzati da:

- Primo bit uguale a 0, quindi l'intervallo di indirizzi va da 0.0.0.0 a 127.255.255.255.
- Net ID (identificativo di rete): 7 bit.
- Host ID (identificativo dell'host all'interno della rete): 24 bit.

Quindi Il numero di reti disponibili in una classe A si calcola come $2^7$, dato che ci sono 7 bit per il net ID. Ci sono dunque 128 reti disponibili.

Il numero di host per rete si calcola come $2^24$ poiché ci sono 24 bit per l'host ID.

L'ultimo indirizzo di una classe `A` è `127.255.255.255` perché il primo bit è fissato a 0 e il massimo valore possibile negli altri 31 bit definisce l'ultimo indirizzo disponibile della classe.

In egual modo si può ragionare per le altre classi, e in particolare: 

- *Classe B*: Identificata dai primi due bit impostati a `10`.

  - Intervallo: 128.0.0.0 - 191.255.255.255

  - Numero di reti disponibili: 16.384 (2^14)

  - Numero di host per rete: 65.534 (2^16 - 2)

  - Struttura: 14 bit per il Net ID, 16 bit per l'Host ID

  - Il primo ottetto varia da 128 a 191

- *Classe C*: Identificata dai primi tre bit impostati a `110`.

  - Intervallo: 192.0.0.0 - 223.255.255.255

  - Numero di reti disponibili: 2.097.152 (2^21)

  - Numero di host per rete: 254 (2^8 - 2)

  - Struttura: 21 bit per il Net ID, 8 bit per l'Host ID

  - Il primo ottetto varia da 192 a 223

== Struttura dell'indirizzo IP

Ogni rete su Internet è identificabile gerarchicamente tramite:

- *Net ID*: identifica la rete.

- *Host ID*: identifica il dispositivo all'interno della rete.

Questo approccio facilita il routing: un router esamina solo il Net ID per determinare se il pacchetto deve essere instradato all'interno della rete locale o inviato a una rete esterna.

Analizziamo un esempio:

#tip[

  #align(center, image("images/image-43.png"))

  Un pacchetto che deve andare da `1` a `2`, viene interpretato dal router della rete `A` per capire dove instradare il pacchetto. Vengono quindi controllati il *Net Id* della stazione destinazione e sorgente:

  - Se sono *uguali*: Allora l'uscota del pacchetto sarà nella stessa rete
  - Se sono *diversi*: Non viene controllato l'*Host Id*, dato che il pacchetto è solo in transito, quindi si manda subito il pacchetto verso il gataway di uscita.7

  Si può dire quindi che in primo luogo viene eseguito un *instradamento fra reti* (Net Id), poi, se serve, avviene l'*instradamento nella rete destinazione* (Host Id).
]

== Problemi delle Classi di indirizzi IP

L'assegnazione fissa delle classi porta a problemi di inefficienza, come frammentazione esterna o interna ( troope reti con pochi host inutilizzati o reti troppo grandi rispetto alle necessità), o spreco di indidirizzi ( aziende ricevono classi A ma ne  usano una piccola porzione).

Tutto questo ha portato ad una *scarsità di indirizzi IPv4 disponibili*. Per risolvere questi problemi, sono state introdotte nuove tecniche come il *Subnetting*.

== Subnetting

Il subnetting è una tecnica per suddividere una rete IP di grandi dimensioni (es. classe B) in sottoreti più piccole (subnet), introducendo un livello gerarchico aggiuntivo. Questo ottimizza la gestione degli indirizzi, riduce il traffico di broadcast e semplifica le tabelle di routing.

#tip[
Ipotizziamo che ci venga assegnato una classe `B`, e che l'amministratore di rete dedichi ad esempio `6 bit` dei 16 di host id per identificare $2^6$ sottoreti.

A questo punto come fa un router ad identificare una sottorete?

#align(center, image("images/image-44.png"))

Un router determina la subnet di un host eseguendo un'operazione *AND bit a bit* tra l'indrizzo IP dell'host e la *subnet mask*. 

La subnet mask definisce quali bit sono dedicati alla rete/subnet e quali agli host.

]

L'amministratore di rete decide il numero di subnet necessarie, calcola la subnet mask corrispondente e la configura su tutti i router della rete. 

#note[
  Notare come in questo caso la subnet mask è indicata con `/22`: questo va ad indicare che, sui 32 bit di IP, 22 (queli a 1) sono utilizzati per identificare la rete e la subnet, mentre i rimanenti (32-22, quelli a 0) sono utilizzati per identificare gli host.
]

= Lezione 10

== CIDR

*CIDR* (Classless Inter-Domain Routing) è stato introdotto per ottimizzare l'uso degli indirizzi IPv4 e rallentare l'esaurimento dello spazio disponibile. A differenza del precedente schema basato su classi (A, B, C), CIDR consente di assegnare blocchi di indirizzi in base alle reali necessità degli operatori di rete, riducendo lo spreco di IP e migliorando l'efficienza del routing.

=== Struttura e Assegnazione CIDR

Con CIDR, gli indirizzi IP vengono assegnati in blocchi variabili, identificati da una notazione speciale: `P_ADDRESS/SUBNET_MASK`.

Dove `SUBNET_MASK` rappresenta il numero di bit utilizzati per identificare la rete. Ad esempio, 192.168.1.0/24 indica che i primi 24 bit sono riservati per la rete, lasciando gli ultimi 8 bit per gli host (256 indirizzi possibili).

=== Assegnazione degli indirizzi IP in base ai continenti

CIDR assegna gruppi di indirizzi IP in base ai continenti. L'ente IANA suddivide lo spazio disponibile tra i cinque RIR (Regional Internet Registry), ognuno responsabile della distribuzione all'interno della propria area geografica.

Ad esempio, RIPE NCC gestisce l'allocazione degli IP in Europa, suddividendo gli spazi tra i vari stati e operatori di rete.

=== Allocazione di Indirizzi: Esempio di Milano

Supponiamo che un'organizzazione di Milano richieda 2048 indirizzi IP. Un blocco compatibile potrebbe essere `194.24.0.0` fino a `194.24.7.255`.

- Ogni subnet contiene 256 indirizzi (8 bit liberi per gli host).
- Per ottenere 2048 indirizzi servono 8 subnet, ovvero 2^3 = 8, quindi bisogna lasciare 3 bit liberi per identificare questi blocchi.
- La maschera di rete corrispondente sarà /21, ovvero 21 bit riservati alla rete e 11 agli host.

La maschera di rete per `194.24.0.0/21` è: `255.255.248.0`

- I primi 21 bit sono settati a 1, lasciando 11 bit per gli host.
- 248 in binario è `11111000`, quindi lascia liberi 3 bit per rappresentare subnet da 2048 indirizzi.



#tip[
  Analizziamo degli esercizi per comprendere come CIDR ottimizza l'allocazione e la gestione degli indirizzi IP.

  *Domanda*: Un'azienda necessita di `4000` indirizzi IP. Qual è la maschera CIDR minima necessaria?

  *Risposta*: 
  - Il numero di host richiesti è `4000`. Il numero più vicino in potenza di 2 è `4096` (2^12).
  - Sono necessari 12 bit per gli host, quindi la subnet mask sarà `/20`.
  - La subnet mask in decimale è `255.255.240.0`.

  *Domanda*: Dato il blocco `10.10.32.0/20`, quali sono il primo e l'ultimo indirizzo disponibile? 

  *Risposta*: 
  - La maschera `/20` lascia 12 bit per gli host, quindi il numero di indirizzi è 2^12 = `4096`.
  - L'intervallo è da `10.10.32.0` a `10.10.47.255`
  - *Primo indirizzo utilizzabile*: 10.10.32.1
  - *Ultimo indirizzo utilizzabile*: 10.10.47.254

  *Domanda*: Un `ISP` assegna l'intervallo `172.16.64.0/22`. L'indirizzo `172.16.66.25` appartiene a questa rete?

  *Risposta*: 
  - La maschera `/22` lascia 10 bit per gli host, quindi il range va da `172.16.64.0` a `172.16.67.255`.
  - `172.16.66.25` è compreso in questo intervallo, quindi l'IP appartiene alla subnet.
]

Questa soluzione allunga la vita a IPv4, ma non determina la sua eternità. Ma come fanno allora alcune reti a funzionare ancora grazie ad IPv4?

== NAT (Network Address Translation)

L'adozione di *NAT* (Network Address Translation) ha contribuito significativamente a prolungare la vita di IPv4, *pur non rendendolo eterno*. Molte reti continuano a funzionare con IPv4 grazie a NAT, che consente una gestione ottimizzata degli indirizzi IP.

=== Cos'è il NAT e a cosa serve?

NAT è una tecnologia che permette di tradurre gli indirizzi IP privati in un indirizzo IP pubblico e viceversa. Questo meccanismo consente di ottimizzare l'uso degli indirizzi IPv4 disponibili, proteggere la rete privata dall'accesso diretto all'esterno e separare lo spazio degli indirizzi pubblici da quello privato.

=== Struttura del NAT

In una rete *privata*, è possibile assegnare ai dispositivi *indirizzi IP privati*, che non sono visibili su Internet. Un dispositivo NAT, tipicamente un router, possiede un unico indirizzo IP pubblico e funge da intermediario tra la rete privata e il mondo esterno. Gli indirizzi IP privati utilizzabili in una rete interna appartengono ai seguenti intervalli riservati:

- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

#note[Questi indirizzi possono essere riutilizzati in più reti senza causare conflitti, poiché il traffico di rete privata non è instradabile su Internet.]

=== Funzionamento del NAT

Quando un dispositivo all'interno della rete privata invia una richiesta a un server su Internet:

1. Il pacchetto viene intercettato dal NAT.
2. Il NAT sostituisce l'indirizzo IP sorgente del dispositivo privato con il proprio indirizzo IP pubblico.
3. Il pacchetto viene inoltrato al server di destinazione.

Alla ricezione della risposta da parte del server:

1. Il NAT intercetta il pacchetto in ingresso.
2. Utilizzando una *tabella di associazione*, il NAT sostituisce l'indirizzo IP di destinazione con quello del dispositivo privato corrispondente.
3. Il pacchetto viene inoltrato al dispositivo all'interno della rete privata.

#align(center, image("images/image-45.png"))

=== Problema della gestione delle risposte

Il NAT tradizionale permette di inviare richieste all'esterno, ma inizialmente non gestisce correttamente le risposte perché i dispositivi interni utilizzano indirizzi IP privati, che non sono direttamente raggiungibili da Internet. Quando un server su Internet invia una risposta, essa è indirizzata all'IP pubblico del NAT, che però non può sapere a quale dispositivo interno restituire il pacchetto senza un meccanismo di associazione. Per risolvere questa limitazione, si introduce una tabella di associazione con i seguenti campi:

#align(center, image("images/image-46.png"))

Quando un dispositivo interno invia una richiesta:

- Il NAT registra nella tabella l’indirizzo IP privato, la porta sorgente e il corrispondente indirizzo pubblico con una porta temporanea univoca (Port Address Translation - PAT).
- Quando la risposta arriva all’indirizzo pubblico e alla porta assegnata, il NAT consulta la tabella e reindirizza il pacchetto al dispositivo interno corretto.

=== Violazione del modello OSI: il NAT e la manipolazione dei livelli

Il NAT introduce un'anomalia rispetto alla struttura a livelli del modello OSI:

- Il modello OSI prevede una chiara separazione tra i livelli (ad es. il livello di rete non dovrebbe interagire con il livello di trasporto).
- Il NAT, tuttavia, deve modificare informazioni sia nel livello 3 (IP) che nel livello 4 (TCP/UDP), sostituendo non solo gli indirizzi IP, ma anche i numeri di porta.
- Questa "sporcizia" architetturale è necessaria per consentire il funzionamento del NAT, anche se rompe il principio di astrazione tra i livelli.

=== Lavoro del NAT su ogni pacchetto

Ogni pacchetto che passa attraverso il NAT subisce le seguenti modifiche:

1. Livello IP (Livello 3):
  - Il NAT sostituisce l'indirizzo IP sorgente con l'IP pubblico della rete
2. Livello di Trasporto (Livello 4 - TCP/UDP)
  - Il NAT sostituisce il numero di porta sorgente con un numero univoco scelto dal router.
3. Tabella di mappatura:
  - Il NAT registra l'associazione tra IP e porta privata e IP e porta pubblica

#warning[il numero di porta utilizzato da un dispositivo privato potrebbe non essere univoco tra reti diverse]

Il NAT assegna dinamicamente una *porta NAT univoca*. Questo processo permette di mantenere le connessioni attive e garantisce il corretto instradamento dei pacchetti di risposta.

#align(center, image("images/image-47.png"))

=== NAT e server accessibili dall'esterno

Se si desidera esporre un server interno su Internet, esistono due soluzioni:

1. Assegnare un indirizzo IP pubblico statico al server, rendendolo direttamente accessibile.
2. Utilizzare il *Port Forwarding* (o Destination NAT - DNAT): il NAT inoltra il traffico in arrivo su una specifica porta dell'IP pubblico a un IP privato interno

#tip[*Esempio*: per rendere un server web accessibile dall'esterno, si configura il NAT affinché tutto il traffico destinato all'IP pubblico sulla porta 80 venga inoltrato all'IP privato del server web.]

=== Conclusioni

Il NAT è una soluzione fondamentale per la gestione delle reti IPv4, permettendo di superare le limitazioni degli indirizzi IP pubblici e migliorando la sicurezza delle reti private. Tuttavia, introduce una complessità nella gestione delle connessioni e comporta una violazione della separazione dei livelli del modello OSI. Nonostante ciò, il NAT rimane una delle tecnologie chiave per il funzionamento delle reti moderne basate su IPv4.

== ARP (Address Resolution Protocol) 

L’Address Resolution Protocol (*ARP*) è un protocollo di livello Network (Livello 3 OSI) che consente di determinare l’indirizzo MAC (Media Access Control, livello 2) associato a un dato indirizzo IP.

Quando un dispositivo in una rete locale (LAN) deve inviare un pacchetto a un altro dispositivo, conosce il suo indirizzo IP ma ha bisogno dell’indirizzo MAC per poter effettivamente inviare il frame Ethernet.

=== Come risolve un IP in un MAC address?

Il dispositivo sorgente invia una richiesta ARP (*ARP Request*) in broadcast sulla rete, chiedendo "Chi ha l’indirizzo IP X.X.X.X? Rispondi con il tuo indirizzo MAC".

Il dispositivo destinatario, se presente nella LAN, risponde con un messaggio *ARP Reply* in *unicast*, fornendo il proprio MAC address.

Il mittente aggiorna la propria *tabella ARP* con l’associazione IP-MAC ricevuta, in modo da poter inviare direttamente i successivi pacchetti senza dover ripetere la risoluzione ARP.

=== Funzionamento dettagliato di ARP

Ogni macchina di una LAN ha un modulo ARP che si occupa della gestione delle richieste e delle risposte.

1. Verifica della cache ARP
  - Prima di inviare un pacchetto, il dispositivo controlla se ha già il MAC address dell’IP di destinazione nella sua cache ARP.
  - Se l’entry esiste ed è valida, il dispositivo può inviare direttamente il frame
  - Se non esiste, o è scaduta, si procede con una ARP Request.
2. Invio dell’ARP Request
  - Il dispositivo sorgente crea un pacchetto ARP Request e lo invia in broadcast (MAC di destinazione: FF:FF:FF:FF:FF:FF).
  - Il pacchetto contiene IP e MAC mittente e IP del destinatario.
3. Risposta con ARP Reply
  - Il dispositivo con l’IP richiesto riceve l’ARP Request e risponde con un ARP Reply in unicast, includendo il proprio MAC address.
  - Il mittente aggiorna la sua cache ARP e utilizza l’indirizzo MAC ricevuto per la trasmissione dei pacchetti successivi
4. Cache ARP e TTL
  - Le associazioni IP-MAC apprese vengono memorizzate nella cache ARP per un certo periodo di tempo (TTL – Time to Live).
  - Questo evita di dover ripetere continuamente richieste ARP per dispositivi con cui si comunica frequentemente.

=== Formato del pacchetto ARP

Un pacchetto ARP è incapsulato direttamente in un frame Ethernet, con *EtherType 0x0806* (ARP).

#align(center, image("images/image-48.png"))

=== ARP su reti diverse: il ruolo del router (Gateway)

#warning[Quando la destinazione è all’*esterno della LAN*, un’ARP Request tradizionale non riceverebbe risposta, perché i pacchetti broadcast non vengono inoltrati tra reti diverse.]

Come si risolve il problema?

1. Calcolo del Net ID
  - La macchina esegue un AND bit a bit tra il proprio IP e la Subnet Mask, ottenendo il suo Net ID.
  - Fa lo stesso con l’IP di destinazione.
2. Confronto dei Net ID
  - *Se i Net ID coincidono*: la destinazione è nella stessa LAN, può inviare il pacchetto direttamente.
  - *Se i Net ID sono diversi*: la destinazione è fuori dalla LAN, quindi il pacchetto deve passare attraverso il gateway (router).
3. Entra in gioco il gateway
  - *Se i Net ID sono diversi*, il pacchetto non può essere inviato direttamente al destinatario.
  - invece di fare un'ARP Request per la destinazione, la macchina sorgente fa un'ARP Request per il gateway predefinito.
4. Risoluzione dell’IP del gateway in un MAC
  - Se *il MAC del gateway predefinito è già noto* (cache ARP), il pacchetto viene subito incapsulato in una trama Ethernet e inviato al router.
  - Se *il MAC del gateway predefinito non è noto*, il dispositivo invia una ARP Request chiedendo: "Chi ha l’IP del gateway? Rispondi con il tuo MAC!"
  - Il router risponde con una ARP Reply, fornendo il suo MAC.
5. Invio del pacchetto al router
  - Il dispositivo sorgente incapsula il pacchetto IP in un frame Ethernet, usando:
    - *MAC sorgente* = suo MAC
    - *MAC destinazione* = MAC del gateway
  - Il router riceve il pacchetto e si occupa di inoltrarlo verso la rete di destinazione.

#align(center, image("images/image-49.png", width: 10cm))

=== Proxy ARP

Esiste un meccanismo chiamato Proxy ARP, usato quando un dispositivo deve raggiungere una destinazione fuori dalla LAN, ma non sa che deve passare per un router.

- Il router, vedendo l’ARP Request per un IP esterno, risponde con il proprio MAC address, anche se l’IP richiesto appartiene a un’altra rete.
- In questo modo, il mittente crede che l’IP di destinazione sia nella stessa LAN e invia i pacchetti al router, che poi li inoltra correttamente.
- Proxy ARP è meno utilizzato oggi a causa della separazione più chiara tra reti e della diffusione del routing statico e dinamico.

= Lezione 11

== DHCP

L'assegnazione degli indirizzi IP alle macchine all'interno di una LAN può avvenire in due modi:

- *Assegnazione statica*: l'IP viene configurato manualmente su ogni macchina
- *Assegnazione dinamica*: l'IP viene assegnato automaticamente da un server DHCP.

L'assegnazione dinamica è gestita dal protocollo *DHCP* (Dynamic Host Configuration Protocol), definito nell’*RFC 2131*, che permette alle macchine di ottenere automaticamente un indirizzo IP e altre configurazioni di rete senza intervento manuale.

#align(center, image("images/image-50.png"))

Il server DHCP possiede un pool di indirizzi IP e li assegna dinamicamente alle macchine che ne fanno richiesta. Il server può essere integrato nel gateway (router) oppure essere una macchina dedicata. 

#note[In reti grandi, possono esserci più server DHCP per garantire ridondanza e bilanciare il carico.]

=== Come funziona il protocollo DHCP (DORA)

Il protocollo DHCP si articola in 4 fasi principali, note con l'acronimo *DORA* (Discover, Offer, Request, Acknowledgment):

#align(center, image("images/image-51.png"))

1. Discover
  - Il client non ha ancora un IP e vuole ottenerne uno. Invia un messaggio DHCP Discover in *broadcast* (destinato all’indirizzo `255.255.255.255`) per cercare un server DHCP.
  - Indirizzo sorgente: `0.0.0.0` (perché il client non ha ancora un IP).
  - Il client include un Transaction ID (*TID*) casuale per identificare la sua richiesta.
  - Poiché il client non conosce l’indirizzo del server DHCP, il messaggio viene ricevuto da tutti i dispositivi della rete, inclusi eventuali server DHCP.

#warning[Come associare la richiesta a un client specifico se l'IP sorgente è `0.0.0.0`?
Il server usa il *MAC* address del client per identificarlo!]

2. Offer
  - I server DHCP che ricevono il messaggio rispondono con un *DHCP Offer*, contenente un IP disponibile.
  - La risposta è ancora in *broadcast*, perché il client non ha ancora un IP assegnato.

#note[*Check dell’indirizzo IP*: Prima di inviare l’Offer, il server DHCP verifica che l’IP proposto non sia già in uso.

Per farlo, Invia un *ping ICMP* (Echo Request) all’IP proposto. Se non riceve risposta, considera l’indirizzo libero.]

3. Request
  - Se ci sono più server DHCP, il client deve scegliere un’offerta tra quelle ricevute.
  - Il messaggio viene inviato in broadcast (`255.255.255.255`) per informare anche gli altri server DHCP che la scelta è stata fatta. includo quindi nel essaggio l'IP del server scelto.
  - Gli altri server DHCP che avevano fatto un’offerta ritirano i loro indirizzi IP e li rimettono nel pool disponibile.

#note[*ARP Check*: Il client può fare un controllo ARP per verificare che l’IP assegnato non sia già in uso.

Invia un *ARP Request* per l’IP ricevuto. Se ottiene una risposta, significa che l’IP è già assegnato a un’altra macchina e richiede un nuovo indirizzo al DHCP.]

4. ACK
  - Il server scelto dal client risponde con un *DHCP Acknowledgment* (ACK) per confermare l’assegnazione dell’IP.
  - Da questo momento, il client può usare l’IP assegnato per comunicare in rete.

=== Rinnovo e Rilascio dell’IP

Gli indirizzi IP assegnati dal DHCP non sono permanenti, ma hanno un *tempo di lease* (validità).

Quando il 50% del lease è trascorso, il client tenta di rinnovarlo con un DHCP Request unicast al server. Se il server risponde con un DHCP ACK, il lease viene rinnovato. Se il server non risponde, il client riprova al 75% del lease. Se il lease scade senza risposta, il client perde l’IP e ripete l’intero processo DORA.

=== Formato ICMP

Abbiamo detto che il server, prima di fare una offer al client, esegue un check per controllare la validità dell'IP. Il check prevede che tramite *ICMP*, il server sia in grado di verificare se per caso quell'IP non sia già stato assegnato a qualcuno per errore. Con ICMP in pratica fa quindi un *ping* di quell' IP address, che prevede un eco nel caso i cui l'IP sia già raggiungibile.

ICMP è quindi un modulo che sta dentro al livello 3 di ogni macchina e genera pacchetti che hanno di base un header e un messaggio. La cosa interessante è che è l'unico messaggio IP che fornisce una checksum del payload.

ICMP ha una serie di compiti tra i queli la rilevazione degli errori, la verifica della raggiungibilità, il controllo della congestione, la misura delle prestazioni e l'indirizzamento delle sottoreti, ma non andremo nei dettagli durante la nostra trattazione.

#align(center, image("images/image-52.png"))

== Routing

Nel livello 2 (Data Link Layer) i dispositivi di rete, come switch e bridge, utilizzano tabelle per associare porte di ingresso e uscita basandosi sugli indirizzi MAC. Tuttavia, questa metodologia è limitata alla trasmissione all'interno della stessa rete locale (LAN) e non consente di instradare pacchetti verso reti remote.

Per superare queste limitazioni, il livello 3 (Network Layer) introduce il concetto di instradamento (*routing*), che permette di determinare il miglior percorso per raggiungere una destinazione che può essere situata anche a grande distanza.

#align(center, image("images/image-53.png", width: 10cm))

=== Fowarding vs Routing

- *Forwarding*: Processo che avviene nei router per inoltrare pacchetti in base alle informazioni contenute nella tabella di routing
- *Routing*: Processo che permette di popolare dinamicamente la tabella di routing tramite protocolli specifici, *apprendendo la topologia della rete*.

A differenza del forwarding di livello 2, che si basa sull'adiacenza fisica, il routing di livello 3 offre una *visibilità più ampia* della rete e permette di determinare percorsi *ottimali* attraverso diversi nodi intermedi.

=== Tabella di routing

La tabella di routing (Routing Table) contiene le informazioni necessarie per instradare i pacchetti verso la destinazione corretta. Rispetto alla forwarding table di livello 2, essa include tutte le possibili destinazioni raggiungibili all'interno della rete.

Le voci tipiche della tabella di routing includono:

- Destinazione (IP di rete o host specifico)

- Miglior next-hop (router o gateway verso cui inoltrare il pacchetto)

- Interfaccia di uscita

- Metrica (distanza o costo del percorso)

- Protocollo di routing utilizzato

Come posso catturare le caratteristiche della rete?

== Distance vector

Il protocollo *Distance Vector* è una tecnica di routing in cui ogni nodo della rete mantiene una *tabella delle adiacenze* e aggiorna la propria conoscenza della rete basandosi sulle informazioni ricevute dai nodi vicini.

=== Costruzione della conoscenza della rete

Ogni nodo della rete, costruisce la propria tabella delle adiacenze  basata sui collegamenti diretti. Poi trasmette *periodicamente* il proprio distance vectore ai nodi vicini. Infine, riceve e utilizza i distance vector dei vicini per aggiornare la propria tabella di routing.

Questo meccanismo consente a ciascun nodo di passare da una conoscenza locale della rete a una conoscenza globale, sebbene in modo graduale e iterativo.

#tip[

Analizziamo ad esempio la seguente topologia di rete:

#align(center, image("images/image-54.png", width: 18cm))

inizialmente i nodi si genereranno delle tabelle di adiacenza di questo tipo:

#align(center, image("images/image-55.png", width: 12cm))

Dopo aver mandato e ricevuto i distance vector, ad esempio la tabella del nodo A diventa la seguente:

#align(center, image("images/image-56.png", width: 6cm))

Possiamo notare quindi come inizialmente la conoscenza della rete di `A` sia limitata, ma man mano che riceve i distance vector riesce a popolare la propria tabella.]

#note[Il distance vector contiene delle coppie `nodo adiacente - costo per raggiungerlo`. Essendo che con questa tecnica un nodo conosce altri nodi della rete solo attraverso i distance vectore mandati, ogni nodo conosce solo IP e costo per raggiungerli, ma non sa nulla riguardo al link usato!]

=== RIP (Routing Information Protocol)

RIP è un protocollo di routing basato su Distance Vector che utilizza *aggiornamenti periodici* per diffondere le informazioni di rete. Per migliorare la velocità di convergenza, RIP utilizza:

- *Triggered Update*: un meccanismo che consente di inviare aggiornamenti immediati in risposta a variazioni della rete, come il guasto di un collegamento.
- *Scambio iniziale di Distance Vector*: al momento dell’avvio, ogni nodo trasmette il proprio Distance Vector per costruire progressivamente la visione globale della rete.

#note[Normalmente, nel protocollo Distance Vector (DV) senza ottimizzazioni, i nodi aggiornano e propagano il loro Distance Vector solo durante gli aggiornamenti periodici, che avvengono a intervalli regolari (es. ogni 30 secondi in RIP).]

=== Problemi del distance vector

L'invio e la ricezione dei distance vector, e gli aggiornamenti delle tabelle di adiacenza dei nodi della rete, avvengono in maniera asincrona, e possono essere persi, rallentando la convergenza della rete.

Questo comporta la presenza di due problematiche: *Bouncing Effect* e *Count to Infinity*.

==== Bouncing Effect

Il problema nasce perché i nodi continuano a scambiarsi informazioni obsolete prima che la rete possa stabilizzarsi.
Si verifica una propagazione errata dell'informazione, che porta i costi a crescere fino a un valore elevato (tipicamente 16 in RIP, valore che indica inaccessibilità).

Consideriamo la seguende rete:

#align(center, image("images/image-57.png", width: 10cm))

Sulla destra troviamo evidenziati i percorsi che i nodi fanno verso il nodo `C` in un dterminato momento $t_0$.

- Il nodo `B`, rileva un guasto nel collegamento diretto con `C` ($t_1$)
- `B` aggiorna la sua tabella, eliminando il percorso diretto verso `C`.
- `B` annuncia ai suoi vicini (A e D) che non può più raggiungere C.
- Tuttavia, `A`, che in precedenza raggiungeva `C` tramite `B`, non ha ancora ricevuto un aggiornamento coerente e continua a pubblicizzare un percorso verso `C` con costo 2.
- `B`, ricevendo questa informazione da `A`, aggiorna erroneamente la sua tabella e ripristina il percorso verso `C`, passando proprio per `A`, con un costo aumentato.
- Questo innesca una serie di aggiornamenti errati, causando un rimbalzo del valore del costo (*Bouncing Effect*), che porta al problema del *Count to Infinity*.

Il problema nasce dal fatto che *i timer di aggiornamento sono asincroni* e le informazioni contenute nei Distance Vector possono essere obsolete o inconsistenti. Poiché la trasmissione avviene in modalità *Best Effort*, i pacchetti possono arrivare in ritardo o andare persi, causando una propagazione errata dell’informazione.

==== Count To infinity

Il Count to Infinity è un problema tipico del Distance Vector, che si verifica quando un nodo non si rende conto immediatamente che una destinazione è irraggiungibile e continua ad aggiornare il costo in maniera incrementale, causando un aumento progressivo fino a raggiungere un valore massimo (tipicamente un valore arbitrario di infinito, come 16 in RIP).

Analizziamo la seguente rete formata da 4 nodi collegati in una topologia lineare:

#align(center, image("images/image-58.png", width: 10cm))

- Il collegamento tra `A` e `B` si rompe.
- `B` rileva che `A` non è più raggiungibile e dovrebbe impostare la distanza verso `A` a infinito.
- Tuttavia, prima che `B` possa diffondere questa informazione, `C` e `D` possiedono ancora una vecchia entry in cui `A` è raggiungibile.
- `C`, che conosceva `A` tramite `B`, pubblicizza ancora un percorso verso `A` con costo 2.
- `B`, ricevendo questa informazione, aggiorna erroneamente la sua tabella credendo di poter raggiungere `A` tramite `C` con costo 3.
- Questo aggiornamento si propaga nuovamente a `C`, che aggiorna il proprio costo per `A` a 4, e così via, causando un incremento infinito del costo.

=== Soluzioni: Triggered Updates e Split Horizon

==== Triggered Updates

I *triggered updates* sono aggiornamenti immediati della tabella di instradamento, inviati non appena viene rilevato un cambiamento critico, come la rottura di un collegamento.

==== Split Horizon

Lo Split Horizon è una tecnica che evita di pubblicizzare una rotta a un vicino se quella rotta è stata appresa proprio da quel vicino. L'idea di base è:

*"Se ho appreso un percorso da te, non ha senso che te lo restituisca, perché significherebbe che sei tu stesso il mio unico accesso a quella destinazione."*

Vediamo un esempio

#align(center, image("images/image-59.png", width: 8cm))

Nell'immagine, vediamo il nodo C che segue questa logica:

- Prima del guasto, `C` raggiungeva `A` passando per `B` con un costo di 2.
- Dopo il guasto, `B` aggiorna il suo costo per `A` a infinito e propaga questa informazione.
- `C` non propaga a `B` il proprio Distance Vector con il costo per `A`, perché sa che `B` era la sua unica via per raggiungere `A`. Verso `B`, manda subito un costo infinito per `A` 
- Verso `D`, mantiene invece il costo originale (2) perché `D` non era coinvolto direttamente nel problema.

#tip[
  Il punto è che ogni nodo `x` sa che i nodi che usa per raggiungere un nodo `y` non possono  aumentare la loro distanza da `y`, quindi quando riceve un infinito rimanda un infinito e dall'altra parte mantiene il costo di prima.
]

=== Limiti di RIP

Nonostante gli accorgimenti come *Triggered Update* e *Split Horizon*, RIP presenta limitazioni significative:

1. È inefficiente su reti di grandi dimensioni a causa della lenta convergenza e del problema del Count to Infinity.
2. Converge verso una soluzione anche quando la rete non è in condizioni ottimali.
3. Per superare queste limitazioni, è necessario utilizzare protocolli più avanzati, come *OSPF* (Open Shortest Path First), basato su Link State, o *BGP* (Border Gateway Protocol) per reti di grandi dimensioni e interconnessioni globali.

= Lezione 12

Soluzioni come triggered update e split horizon, a volte non funzionano.

Vediamo un esempio:

