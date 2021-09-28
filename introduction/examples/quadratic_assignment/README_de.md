### Beispiel: Lageplanung einer Fabrik

Bei der intelligenten Produktion gibt es sowohl dynamische als auch statische Aspekte, sowie viele Nuancen dazwischen.
Die Frage nach der Lageplanung für eine Fabrik ist ein eher statischer aber doch recht wichtiger Aspekt.
Nehmen wir also an, dass uns eine Firma gehört und wir haben ein großes Grundstück gekauft, um eine neue Fabrik aufzubauen.
Natürlich wissen wir, welche Produkte wir in der Fabrik herstellen wollen.
Wir wissen auch, welche Abteilungen wir aufbauen müssen, also zum Beispiel welche Werkhallen und Lagerhallen wir brauchen, vielleicht dazu noch ein Verwaltungsgebäude und so weiter.
Jetzt müssen wir entscheiden, wo wir diese Abteilungen auf unserem Grundstück bauen wollen, wie in [@fig:qap_example] skizziert.

\rel.figure{qap_example}{Skizze des Szenarios als Quadratisches Zuordnungsproblem, wo verschiedene Gebäude einer Fabrik auf einem Grundstück platziert werden müssen.}{qap_example.svg}{width=72%}

Nehmen wir an, dass wir $n$&nbsp;verschiedene mögliche Bauplätze auf unserem Grundstück haben.
Wir müssen nun die (ebenfalls) $n$&nbsp;Abteilungen der geplanten Fabrik diesen Bauplätzen zuweisen.
In einigen der Bauplätzen gibt es vielleicht schon Gebäude, an anderen muss man neue bauen.
Für jede Kombination aus einer Abteilung und einem Bauplatz entstehen daher verschiedene Baukosten.
Ein Bauplatz, auf dem bereits eine Halle steht, könnte vielleicht direkt als Lagerhalle genutzt werden.
Wenn dort aber ein Verwaltungsgebäude hinstellen wollen, müssen wir die Halle zuerst abreisen.

Für jeden möglichen Plan entstehen auch Kosten durch die Entfernungen der Abteilungen zu einander.
Vielleicht gibt es einen großen Materialfluss zwischen zwei der geplanten Werkhallen.
Viel fertiges Endprodukt und Rohmaterial muss vielleicht zwischen einer Lagerhallte und eine der Werkhallen transportiert werden.
Dagegen gibt es fast keinen Materialfluss zwischen dem Verwaltungsgebäude und den Werkhallen.
Natürlich wird die Entfernung zwischen zwei Abteilungen von den Bauplätzen abhängen, die wir für sie auswählen.
Für jedes Paar von Abteilungen das wir auf der Karte platzieren entstehen Flusskosten als eine Funktion von der Menge der Materials, das zwischen ihnen transportiert werden muss, und der Entfernung zwischen den jeweiligen Bauplätzen.

Die Gesamtkosten des Zuweisungsproblems von Abteilungen zu Bauplätzen ist daher eine gewichtete Summe aus den Grundkosten für die Platzierung und den Flusskosten.
Unser Ziel wäre es also, die Zuweisung (den Plan) mit den kleinsten Gesamtkosten zu finden.

Dieses Szenario wird "Quadratisches Zuweisungsproblem" genannt (quadratic assignment problem, QAP)&nbsp;[@BCPP1998TQAP].
Es wird seit den 1950er Jahren untersucht&nbsp;[@BK1957APATLOEA].
QAPs tauchen in einer großen Vielfalt von Szenario auf, zum Beispiel beim Zuweisen von Einrichtungen zu Plätzen auf einem Stück Land, oder beim Platzieren von Arbeitsstationen zu Stellen in einer Werkhalle.
Selbst das Platzieren von Komponenten auf einer Schaltplatte mit dem Ziel, die gesamte Länge an (Kabel-)Verbindungen zu minimieren, ist ein QAP&nbsp;[@S1961TBWPAPA]!
Obwohl diese Problem an sich relativ einfach zu verstehen sind, sind sie sehr schwer zu lösen&nbsp;[@SGA1976PCAP].
