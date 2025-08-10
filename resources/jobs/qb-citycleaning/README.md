# qb-citycleaning

Erweiterter Stadtreinigungs-Job für QB-Core.

## Features
- Dienst-Tablet am Depot (`Config.Depot`)
- Arbeitsfahrzeuge (Müllwagen/Kehrmaschine) über Tablet abrufbar
- Uniformen für männliche und weibliche Charaktere
- Aufgaben: Müllsäcke einsammeln und Graffiti entfernen
- Bonuszahlung wenn alle Aufgaben erledigt werden

## Installation
1. Resource in den Ordner `resources/[jobs]/qb-citycleaning` legen
2. In der `server.cfg` starten: `ensure qb-citycleaning`
3. Job in `qb-core/shared/jobs.lua` hinzufügen:
```lua
['stadtreinigung'] = { label = 'Stadtreinigung', defaultDuty = true, grades = { ['0'] = { name = 'Mitarbeiter', payment = 100 } } }
```

## Nutzung
- An das Depot laufen und mit `E` das Tablet öffnen
- Dienst beginnen, Fahrzeug holen, Uniform anlegen
- Markierte Müllsäcke und Graffiti mit `E` entfernen
- Nach Abschluss aller Aufgaben erfolgt eine Bonuszahlung
