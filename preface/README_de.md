# Vorwort {-}

Nachdem ich während meiner Doktorandenzeit das Buch *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] geschrieben habe, möchte ich nun eine eher praktisch ausgerichtete Übersicht über Optimierungsverfahren und Metaheuristiken schreiben.
Aktuell ist diese neue [Buch](http://thomasweise.github.io/oa/index.html) in einer frühen Entwicklungsphase.
Erwartet also viele Änderungen.

Es ist mein Ziel, Optimierungsverfahren in einer zugänglichen Art für Studenten ohne Hintergrundwissen auf dem Gebiet zu erschließen.
Ich versuche, ein Gefühl dafür zu vermitteln, wie Optimierungsverfahren in der Praxis funktionieren und woran man denken muss, wenn man ein (Optimierungs-)Problem lösen will.
Es wird durchgespielt, wie von man einem einfachen funktionierenden "proof-of-concept" Ansatz zu einer effizienten Lösung für ein gegebenes Problem kommt.
Wir verfolgen dabei einen "learning-by-doing" Ansatz, in dem wir in diesem Buch durchgängig ein praktisches Optimierungsproblem bearbeiten.
Alle Algorithmen werden direkt implementiert und auf das Problem angewendet, nachdem wir sie eingeführt haben.
Das erlaubt es uns, ihre Stärken und Schwächen basierend auf echten Ergebnissen zu diskutieren.
Wir lernen, wie man die Performanz von Algorithmenimplementierungen vergleicht.
Wir versuchen, Algorithmen Schritt für Schritt zu verbessern und arbeiten uns von einfachen Ansätzen, die nicht gut funktionieren, hin zu effizienten Metaheuristiken vor. 

Wir verwenden konkrete Beispiele und Algorithmusimplementierungen in [Python](https://python.org).
Diese werden frei im Repository *[thomasWeise/mopitpy](https://thomasweise.github.io/moptipy)* unter der GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 Lizenz zur Verfügung gestellt.
Jedes Quellkode-Listing im Buch ist mit einem *(src)*-Link in der Überschrift versehen, mit dem man zur vollen Version des Kodes im Repository kommt.
Diese Quellkode-Listings sind normalerweise verkürtzte Ausschnitte des tatsächlichen Kodes.
Wir werden viele Details weglassen, die für das Verständnis der Algorithmen nicht notwendig sind, wie zum Beispiel Type Hints, Parameterüberprüfungen, oder auch ganze Methoden.
Diese sind dann natürlich in der vollständigen Version des Kodes im [GitHub-Repository](\repo{mp}{repo.url}) enthalten.
Der verlinkte Kode kann also durchaus anders aussehen, als der im Buch abgebildete, verkürzte Kode.
Um die Quellkodebeispiele vollständig zu verstehen, empfehlen wir der Leserin, sich mit Python, [numpy](https://numpy.org/), und [matplotlib](https://matplotlib.org/) vertraut zu machen.
Natürlich ist es auch völlig OK, die Quellkodebeispiele einfach komplett zu ignorieren.

Der Text des Buches selbst wird aktiv geschrieben und liegt komplett im Repository *[thomasWeise/oa](https://github.com/thomasWeise/oa)*.
Dort kannst Du auch *[Meldungen](https://github.com/thomasWeise/oa/issues)* einstellen, wie zum Beispiel Änderungsanfragen, Vorschläge, gefundene (Schreib-)Fehler, oder Du kannst Bescheid sagen, wenn etwas unklar ist.
Dann kann ich den Text entsprechend verbessern.
Wenn Du Fehler oder Probleme im Beispielkode findest, dann kannst Du diese [hier](http://github.com/thomasWeise/moptipy/issues) melden.
Dieses Buch steht unter der *Namensnennung &ndash; Nicht-kommerziell &ndash; Weitergabe unter gleichen Bedingungen&nbsp;4.0 International* (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0) Lizenz, deren Zusammenfassung auf <https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de> gefunden werden kann.
Ich versuche, das Buch parallel in mehreren Sprachen zu schreiben, aber es wird mir nicht gelingen, diese Synchron zu halten.
English wird wahrscheinlich die Sprache mit der aktuellsten Version werden.


| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/5)
| Institute of Applied Optimization ([IAO](http://iao.hfuu.edu.cn)),
| School of Artificial Intelligence and Big Data,
| [Hefei University](http://www.hfuu.edu.cn/english/),
| Hefei, Anhui, China.
| Web: <http://iao.hfuu.edu.cn/5>
| Email: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>
| &nbsp;


Wenn Du das Buch zitieren möchtest, dann kannst Du die folgende [BibTeX](http://www.bibtex.org/) Information verwenden:


```
@book{oa,
  author    = {Thomas Weise},
  title     = {\meta{title}},
  year      = {\meta{year}},
  publisher = {Institute of Applied Optimization ({IAO}),
               School of Artificial Intelligence and Big Data,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/oa/},
  edition   = {\meta{date}}
}
```


Die Versionsinformation des Buchs ist wie folgt:


| &nbsp;
| Buch Repository: [\meta{repo.name}](\meta{repo.url})
| Buch Commit: \meta{repo.commit}
| Buch Datum: \meta{repo.date}
| Kode Repository: [\repo{mp}{repo.name}](\repo{mp}{repo.url})
| Kode Commit: \repo{mp}{repo.commit}
| Kode Datum: \repo{mp}{repo.date}
| &nbsp;
