# QB-Core Stadtreinigung Job

Dieses Repository enthält eine erweiterte Implementierung eines **Stadtreinigung**-Jobs für einen QB-Core-basierten FiveM-Server.

## Installation
1. Den Ordner `resources/jobs/qb-citycleaning` in das `resources` Verzeichnis des Servers kopieren.
2. In der `server.cfg` starten:
   ```
   ensure qb-citycleaning
   ```
3. Job in `qb-core/shared/jobs.lua` eintragen:
   ```lua
   ['stadtreinigung'] = {
       label = 'Stadtreinigung',
       defaultDuty = true,
       offDutyPay = false,
   }
   ```

## Nutzung
- Zum Depot laufen und mit `E` das Dienst-Tablet öffnen
- Dienst beginnen, Fahrzeug anfordern und Uniform anlegen
- Müllsäcke aufsammeln und Graffiti entfernen
- Bei vollständiger Reinigung wird ein Bonus ausgezahlt

## Features
- Dienst-Tablet mit Fahrzeug- und Uniformverwaltung
- Aufgaben für Müllentsorgung und Graffitientfernung
- Bonuszahlung bei kompletter Abarbeitung aller Punkte
