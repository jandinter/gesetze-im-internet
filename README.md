# Gesetze im Internet

[English version](#english-version)

Hier findest Du alle deutschen Gesetze einschließlich der Änderungen seit Januar 2022.

Die Gesetzestexte liegen im Verzeichnis [gesetze](/gesetze).

## Warum?

Das Bundesjustizministerium veröffentlicht die auf Bundesebene geltenden deutschen Gesetze und Verordnungen auf der Webseite [gesetze-im-internet.de](https://www.gesetze-im-internet.de). Leider ist dort nur die aktuelle Fassung der Texte abrufbar.

Hier werden auch alte Fassungen der Gesetze archiviert: Einmal wöchentlich werden alle Texte der Gesetze und Verordnungen von der Internetseite [gesetze-im-internet.de](https://www.gesetze-im-internet.de) abgerufen und gespeichert. Die Commits zeigen daher, wie sich Regelungen verändert haben und welche Gesetze und Verordnungen neu hinzugekommen oder weggefallen sind.

## Wie?

Die Gesetzestexte werden einmal wöchentlich mit einem [Scraper](/scraper.rb) abgerufen. Der Scraper lädt alle Dateien herunter, die im Inhaltsverzeichnis von [gesetze-im-internet.de](https://www.gesetze-im-internet.de) gelistet sind. Der Scraper verwendet diese XML-Datei mit dem Inhaltsverzeichnis: [https://www.gesetze-im-internet.de/gii-toc.xml](https://www.gesetze-im-internet.de/gii-toc.xml)

Die Gesetzestexte werden als XML-Dateien heruntergeladen (mehr zu dem verwendeten Dateiformat [hier](https://www.gesetze-im-internet.de/hinweise.html)).

Die XML-Dateien liegen im Verzeichnis [gesetze](/gesetze). Die Namen der Unterverzeichnisse orientieren sich an den offiziellen Abkürzungen der Gesetzes- bzw. Verordnungstitel.

# English version

This repository contains XML files for all legal acts published on the website of the Federal Ministry of Justice: [gesetze-im-internet.de](https://www.gesetze-im-internet.de)

The XML files are downloaded from that site on a weekly basis. Therefore, the commits show a history of the legal acts on the federal level in Germany from January 2022 onwards.
