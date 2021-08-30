# Vorwort {-}

Nachdem ich während meiner Doktorandenzeit das Buch *Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB] geschrieben habe, möchte ich nun eine eher praktisch ausgerichtete Übersicht über Optimierungsverfahren und Metaheuristiken schreiben.
Aktuell ist diese neue [Buch](http://thomasweise.github.io/oa/index.html) in einer frühen Entwicklunsphase.
Erwartet also viele Änderungen.

Dieser Text versucht Optimierungsverfahren in einer zugänglichen Art für Studenten ohne viel Hintergrundwissen auf dem Gebiet zu erschließen.
Er versucht, ein Gefühl dafür zu vermitteln, wie Optimierungsverfahren in der Praxis funktionieren, woran man denken muss, wenn man ein (Optimierungs-)Problem lösen will, und wie von man einem einfachen funktionierenden proof-of-concept Ansatz zu einer effizienten Lösung für ein gegebenes Problem kommt.
Wir verfolgen einen "learning-by-doing" Ansatz, in dem wir in diesem Buch durchgängig ein praktisches Optimierungsproblem bearbeiten.
Alle Algorithmen werden direkt implementiert und auf das Problem angewendet, nachdem wir sie eingeführt haben.
Das erlaubt es uns, ihre Stärken und Schwächen basierend auf echten Ergebnissen zu diskutieren.
Wir versuchen, die Algorithmen Schritt für Schritt zu verbessern und arbeiten uns von einfachen Ansätzen, die nicht gut funktionieren, hin zu effizienten Metaheuristiken vor. 

Wir verwenden konkrete Beispiele und Algorithmusimplementierungen in Python.
Alles das wird frei im Repository *[thomasWeise/mopitpy](https://github.com/thomasWeise/moptipy)* on [GitHub](http://www.github.com) unter der MIT&nbsp;Lizenz zur Verfügung gestellt.
Jedes Quellkode-Listing ist daher mit einem *(src)*-Link in der Überschrift versehen, mit dem man zur vollen Version des Kodes im GitHub-Repository kommt.

Der Text des Buches selbst wird aktiv geschrieben und liegt komplett im Repository *[thomasWeise/oa](http://github.com/thomasWeise/oa)* auf GitHub.
Dort kannst Du auch *[Meldungen](http://github.com/thomasWeise/oa/issues)* einstellen, wie zum Beispiel Änderungsanfragen, Vorschläge, gefundene Fehler, Schreibfehler, oder Du kannst Bescheid sagen, wenn etwas unklar ist.
Dann kann ich den Text dann verbessern.
Wenn Du Fehler oder Probleme im Beispielkode findest, dann kannst Du diese [hier](http://github.com/thomasWeise/moptipy/issues) melden.

Dieses Buch und alle seine Teile stehen unter der Namensnennung - Nicht-kommerziell - Weitergabe unter gleichen Bedingungen 4.0 International (CC BY-NC-SA 4.0) Lizenz (CC&nbsp;BY&#8209;NC&#8209;SA&nbsp;4.0), deren Zusammenfassung auf <https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de> gefunden werden kann.
Ich versuche, das Buch parallel in mehreren Sprachen zu schreiben, aber es wird mir nicht gelingen, diese Synchron zu halten.
English wird die die vorderste Arbeitssprache sein, mit der aktuellsten Version.

| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/5)
| Institute of Applied Optimization ([IAO](http://iao.hfuu.edu.cn)),
| School of Artificial Intelligence and Big Data,
| [Hefei University](http://www.hfuu.edu.cn/english/),
| Hefei, Anhui, China.
| Web: <http://iao.hfuu.edu.cn/team/director>
| Email: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>

Wenn Du das Buch zitieren möchtest, dann kannst Du die folgende Information verwenden:

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
| Kode Repository: [\repo{mp}{repo.name}](\repo{mp}{repo.url})
| Kode Commit: \repo{mp}{repo.commit}
| Kode Datum: \repo{mp}{repo.date}

