# Cine Alarm

- **App web (Angular):** `app_web/cine_alarm_web`
- **App móvil (Flutter):** raíz del repositorio

## Estructura

```
flutter_UX/
├── lib/              ← app móvil 
├── assets/           ← pósters, actores y movies.json
├── pubspec.yaml
└── app_web/
    └── cine_alarm_web/
        ├── public/   ← pósters 
        └── src/app/  ← app web 
```
## App web

Requisito: Node.js. y Angular CLI

```bash
cd app_web/cine_alarm_web
npm install
ng serve -o
```

Se abre en http://localhost:4200.

---

## App móvil 

Requisito: Flutter 

```bash
flutter pub get
flutter devices
flutter run
```