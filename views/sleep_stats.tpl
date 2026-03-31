<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiche Sonno</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="page">
        <div class="topbar">
            <a href="/sleep" class="back">← Indietro</a>
            <h1>📊 Statistiche</h1>
        </div>

        % if not stats:
        <p class="empty">Nessun dato. <a href="/sleep/add">Aggiungi la prima notte!</a></p>
        % else:

        <div class="stat-grid">
            <div class="stat-card">
                <span class="stat-value">{{stats['total']}}</span>
                <span class="stat-label">Notti registrate</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">{{stats['avg']}}</span>
                <span class="stat-label">Media durata</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">{{stats['min']}}</span>
                <span class="stat-label">Minimo</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">{{stats['max']}}</span>
                <span class="stat-label">Massimo</span>
            </div>
            <div class="stat-card blue">
                <span class="stat-value">{{stats['streak']}}</span>
                <span class="stat-label">Streak verde</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">{{stats['best_day']}}</span>
                <span class="stat-label">Giorno migliore</span>
            </div>
        </div>

        <h2>Distribuzione</h2>
        <div class="dist">
            <div class="dist-row">
                <span class="badge green">GREEN</span>
                <div class="bar-wrap">
                    <div class="bar green" style="width:{{stats['green_pct']}}%"></div>
                </div>
                <span>{{stats['greens']}} ({{stats['green_pct']}}%)</span>
            </div>
            <div class="dist-row">
                <span class="badge yellow">YELLOW</span>
                <div class="bar-wrap">
                    <div class="bar yellow" style="width:{{stats['yellow_pct']}}%"></div>
                </div>
                <span>{{stats['yellows']}} ({{stats['yellow_pct']}}%)</span>
            </div>
            <div class="dist-row">
                <span class="badge red">RED</span>
                <div class="bar-wrap">
                    <div class="bar red" style="width:{{stats['red_pct']}}%"></div>
                </div>
                <span>{{stats['reds']}} ({{stats['red_pct']}}%)</span>
            </div>
        </div>

        % end
    </div>
</body>
</html>
