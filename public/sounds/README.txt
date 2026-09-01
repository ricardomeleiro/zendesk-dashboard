O dashboard toca 3 sons diferentes. Para trocar cada um, coloque o arquivo
nesta pasta com um dos nomes abaixo (o dashboard carrega o primeiro formato
que existir, na ordem: .mp3 → .wav → .ogg).

1) NOVO TICKET
   - new-ticket.mp3   (recomendado)
   - new-ticket.wav
   - new-ticket.ogg
   Toca a cada ticket novo detectado no refresh.

2) CHAMADOS ZERADOS
   - all-clear.mp3
   - all-clear.wav
   - all-clear.ogg
   Toca quando o total de chamados abertos/pendentes zera
   (transicao de "tinha algum" para "zero").

3) MUITOS NAO ATRIBUIDOS
   - many-unassigned.mp3
   - many-unassigned.wav
   - many-unassigned.ogg
   Toca quando os nao atribuidos ULTRAPASSAM o limiar
   (padrao: 15 tickets). So dispara na transicao (abaixo -> acima),
   nao repete a cada refresh enquanto estiver alto.

Configuracoes (em public/index.html):
  SOUND_VOLUME                  = 0.7   (volume 0.0 a 1.0)
  SOUND_MAX_PLAYS_PER_REFRESH   = 1     (max de sons "novo ticket" por refresh)
  UNASSIGNED_ALERT_THRESHOLD    = 15    (limiar dos nao atribuidos)

Dica: procure "notification sound" / "chime" / "alert" em
https://freesound.org ou https://mixkit.co/free-sound-effects/notification/
