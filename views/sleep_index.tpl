<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sleep Tracker</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="page">
        <div class="topbar">
            <a href="/" class="back">← Home</a>
            <h1>🌙 Sleep Tracker</h1>
        </div>

        <div class="actions">
            <a href="/sleep/add" class="btn blue">+ Aggiungi notte</a>
            <a href="/sleep/history" class="btn">Storico</a>
            <a href="/sleep/stats" class="btn">Statistiche</a>
            <a href="/sleep/config" class="btn">Config</a>
        </div>

        <h2>Ultime 7 notti</h2>

        % if rows:
        <table>
            <thead>
                <tr>
                    <th>Data</th>
                    <th>Letto</th>
                    <th>Sveglia</th>
                    <th>Durata</th>
                    <th>Stato</th>
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
                </tr>
                % end
            </tbody>
        </table>
        % else:
        <p class="empty">Nessuna notte registrata. <a href="/sleep/add">Aggiungi la prima!</a></p>
        % end
    </div>
</body>
</html>
