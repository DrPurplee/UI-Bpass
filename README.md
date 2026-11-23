# M0$$AD V5.3 — Actions par jeu et notifications custom

Ce pack est **complet** : `ui.lua`, `demo_print.lua`, `demo.lua`, `assets/` (PNG), `README.md`.

## Modifications

- Chaque jeu possède une fonction `Action` indépendante dans `demo_print.lua`.
- Les exemples sont des `print` **différents** pour chaque jeu.
- Chaque jeu ne déclenche sa fonction qu'une fois par exécution.
- Premier clic : `M0$$AD ~ NomDuJeu Print Activé`.
- Clic suivant : `M0$$AD ~ NomDuJeu Print déjà activé`, sans relancer sa fonction.
- Les notifications ne passent plus par `StarterGui:SetCore("SendNotification", ...)` : elles utilisent un petit panneau personnalisé bleu nuit, avec transitions et barre de durée.
- Recherche de jeux, scroll, keybind CONFIG, icônes et bannière conservés.

## Upload GitHub

Glisse **le contenu extrait du ZIP**, pas le ZIP lui-même, dans la racine de ton dépôt :

```text
UI-Bpass/
  ui.lua
  demo_print.lua
  demo.lua
  assets/
    hero_m0ssad_bypasser.png
    game_custom.png
    ...
```

Puis lance la démo RP :

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/DrPurplee/UI-Bpass/main/demo_print.lua"))()
```

## Changer un jeu

Dans `demo_print.lua`, modifie l'entrée correspondante dans `GAMES` :

```lua
{
  Name = "Mon jeu",
  Icon = "mon_jeu.png", -- mettre ce PNG dans assets/
  Initial = "MJ",
  Action = function()
    print("[M0$$AD] MON JEU : démo personnalisée")
  end,
},
```

Le champ `Action` est une fonction propre à chaque jeu et n'exécute ici que des commandes `print`.

**Note** : le chargement HTTP et les fichiers d'images locaux du `ui.lua` actuel dépendent des capacités de l'environnement de test ; ce n'est pas une API Roblox Studio standard. Cette démo ne contient pas de bypass réel.
