<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Storico Sonno</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="page">
        <div class="topbar">
            <a href="/sleep" class="back">← Indietro</a>
            <h1>📋 Storico</h1>
        </div>

        <div class="actions">
            <a href="/sleep/history?n=7"  class="btn {{!'active' if n==7 else ''}}">7 giorni</a>
            <a href="/sleep/history?n=14" class="btn {{!'active' if n==14 else ''}}">14 giorni</a>
            <a href="/sleep/history?n=30" class="btn {{!'active' if n==30 else ''}}">30 giorni</a>
        </div>

        % if rows:
        <table>
            <thead>
                <tr>
                    <th>Data</th>
                    <th>Letto</th>
                    <th>Sveglia</th>
                    <th>Durata</th>
                    <th>Stato</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                % for r in rows:
                <tr>
                    <td>{{r['date']}}</td>
                    <td>{{r['bed_time']}}</td>
                    <td>{{r['wake_time']}}</td>
                    <td>{{r['duration_fmt']}}</td>
                    <td><span class="badge {{r['status'].lower()}}">{{r['status']}}</span></td>
                    <td><a href="/sleep/delete/{{r['date']}}" class="del" onclick="return confirm('Eliminare?')">✕</a></td>
                </tr>
                % end
            </tbody>
        </table>
        % else:
        <p class="empty">Nessun dato nel periodo selezionato.</p>
        % end
    </div>
</body>
</html>
