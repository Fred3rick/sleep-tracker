<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aggiungi Notte</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="page">
        <div class="topbar">
            <a href="/sleep" class="back">← Indietro</a>
            <h1>+ Aggiungi Notte</h1>
        </div>

        % if error:
        <div class="alert red">{{error}}</div>
        % end

        % if exists:
        <div class="alert yellow">
            Esiste già un'entry per oggi. Vuoi sovrascriverla?
        </div>
        % end

        <form method="POST" action="/sleep/add">
            <div class="form-group">
                <label>Data</label>
                <input type="date" name="date" value="{{today}}" required>
            </div>
            <div class="form-group">
                <label>Ora in cui sei andato a letto</label>
                <input type="time" name="bed_time" required>
            </div>
            <div class="form-group">
                <label>Ora in cui ti sei svegliato</label>
                <input type="time" name="wake_time" required>
            </div>

            % if exists:
            <input type="hidden" name="force" value="1">
            <button type="submit" class="btn red">Sovrascrivi</button>
            % else:
            <button type="submit" class="btn blue">Salva</button>
            % end
        </form>
    </div>
</body>
</html>
