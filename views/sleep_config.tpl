<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Configurazione</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="page">
        <div class="topbar">
            <a href="/sleep" class="back">← Indietro</a>
            <h1>⚙️ Configurazione</h1>
        </div>

        % if saved:
        <div class="alert green">Configurazione salvata!</div>
        % end

        <form method="POST" action="/sleep/config">
            <div class="form-group">
                <label>Obiettivo sonno (minuti)</label>
                <input type="number" name="target" value="{{cfg['target_minutes']}}" min="60" max="720">
                <small>Default: 480 = 8 ore</small>
            </div>
            <div class="form-group">
                <label>Soglia Verde ± (minuti)</label>
                <input type="number" name="green" value="{{cfg['green_tol_min']}}" min="0" max="120">
                <small>Quanto margine per essere in verde</small>
            </div>
            <div class="form-group">
                <label>Soglia Gialla ± (minuti)</label>
                <input type="number" name="yellow" value="{{cfg['yellow_tol_min']}}" min="0" max="180">
                <small>Quanto margine per essere in giallo</small>
            </div>
            <button type="submit" class="btn blue">Salva</button>
        </form>
    </div>
</body>
</html>
