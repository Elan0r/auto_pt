## Social Engineering BCC Inserter
- Dieses Skript ermögtlicht das Automatisierte Einfügen von Mails aus einer Liste in die EML Header "Bcc:" & "To:" hierbei muss ausgewählt werdne wie viele Mails per Header erwünscht sind.
- Anschließend werden alle erstellten EML Dateien gezippt.

## WICHTIG:
> In Der EML Datei müssen vor Einsatz des Scripts sämtliche Inhalte des Genutzten Headers entfernt werden. Der Header ansich muss bestehend bleiben (To: / Bcc:)

> Mails werden aus Text files Line by Line geparsed.

## Benutzung:
```
$: EMLInsert.py [-h] (--bcc | --to) -m MAIL_FILE -e EML_FILE -o FILENAME -a AMOUNT

optional arguments:
  -h, --help    show this help message and exit
  --bcc         Mails werden im Bcc: Header eingefügt
  --to          Mails werden im To: Header eingefügt
  -m MAIL_FILE  INPUT: Mail Liste (Pfad)
  -e EML_FILE   INPUT: EML Datei (Pfad)
  -o FILENAME   Output Datei Name (Folder/ZIP)
  -a AMOUNT     Amount of Mails per Header
```
