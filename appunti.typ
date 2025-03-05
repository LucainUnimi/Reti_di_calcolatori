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
