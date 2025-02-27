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

Poiché la voce umana arriva fino a circa 4000 Hz, la frequenza minima di campionamento deve essere 8000 campioni al secondo (8 kHz).

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

l protocollo TCP è progettato per gestire la congestione della rete, evitando il buffer overflow nei router. La sua strategia è simile all'azione di "chiudere il rubinetto" quando il flusso di dati è troppo elevato:

- Se TCP rileva una congestione, riduce la quantità di dati inviati.
- Non ritrasmette subito i pacchetti persi, ma aspetta che la congestione si risolva.

Questa tecnica funziona bene nelle reti cablate, dove la perdita di pacchetti è spesso dovuta alla congestione. Tuttavia, nelle reti wireless, la situazione è diversa.

== TCP e reti wirelesss: problemi e revisione del protocollo

Il tipo di link più soggetto a errori sul canale è il canale wireless. Questo rappresenta una criticità per TCP, perché:
- Quando un pacchetto viene perso su una rete wireless, TCP potrebbe erroneamente interpretare la perdita come un segnale di congestione.
- Di conseguenza, TCP riduce inutilmente il flusso di dati, peggiorando le prestazioni della rete.

Per questo motivo, l'uso di TCP su reti wireless deve essere gestito con attenzione. In alcuni casi, sono necessarie modifiche o protocolli alternativi per evitare che TCP interpreti erroneamente gli errori del canale come congestione.

D'altro canto, su reti a basso tasso di errore, TCP funziona perfettamente ed è il protocollo più adatto per garantire una trasmissione affidabile.