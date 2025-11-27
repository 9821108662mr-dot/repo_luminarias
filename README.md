# Catálogo PRO-MG - README

## Descripción
Aplicación de catálogo de luminarias profesionales con Flutter (frontend) y FastAPI (backend).

## Características

### Frontend (Flutter)
- ✅ Sistema de login (admin/admin)
- ✅ Diseño moderno con colores azules
- ✅ Lista de marcas de luminarias
- ✅ Catálogo de productos por marca
- ✅ Tarjetas flip interactivas para cada modelo
- ✅ Visualización de PDFs y librerías
- ✅ Responsive design

### Backend (Python/FastAPI)
- ✅ API RESTful
- ✅ Servir archivos estáticos (imágenes y PDFs)
- ✅ CORS configurado para desarrollo
- ✅ JSON como base de datos

## Requisitos

### Backend
- Python 3.8+
- FastAPI
- Uvicorn

### Frontend
- Flutter 3.9.2+
- Dart SDK

## Instalación

### 1. Backend

```bash
cd backend
pip install -r requirements.txt
```

### 2. Frontend

```bash
flutter pub get
```

## Ejecución

### Iniciar Backend

Opción 1 - Script conveniente:
```bash
cd backend
python run_backend.py
```

Opción 2 - Directamente:
```bash
cd backend
python app.py
```

El backend iniciará en: **http://127.0.0.1:8000**

### Iniciar Frontend

```bash
flutter run -d chrome
```

Para web:
```bash
flutter run -d chrome
```

Para Windows:
```bash
flutter run -d windows
```

## Uso

1. Inicia el backend primero
2. Luego inicia la aplicación Flutter
3. En la pantalla de login, ingresa:
   - Usuario: `admin`
   - Contraseña: `admin`
4. Navega por las marcas y explora los fixtures
5. Haz clic en las tarjetas para voltearlas y ver opciones de PDF/Librería

## Estructura del Proyecto

```
repo_luminarias/
├── backend/
│   ├── app.py              # Aplicación FastAPI principal
│   ├── fixtures.json       # Datos de luminarias
│   ├── run_backend.py      # Script para iniciar servidor
│   ├── requirements.txt    # Dependencias Python
│   └── static/             # Archivos estáticos
│       ├── descargas/      # PDFs y archivos descargables
│       └── luminarias/     # Imágenes de productos
├── lib/
│   ├── config/
│   │   └── app_config.dart # Configuración centralizada
│   ├── data/
│   │   ├── api_service.dart      # Servicio API
│   │   └── fixtures_data.dart    # Datos locales fallback
│   ├── models/
│   │   └── fixture.dart          # Modelo de datos
│   ├── screens/
│   │   ├── login_screen.dart     # Pantalla de login
│   │   ├── home_screen.dart      # Listado de marcas
│   │   └── details_screen.dart   # Detalles de marca
│   ├── widgets/
│   │   └── fixture_card.dart     # Tarjeta flip de fixture
│   └── main.dart                 # Punto de entrada
└── pubspec.yaml                  # Dependencias Flutter
```

## Configuración

### Cambiar Puerto del Backend

Edita `lib/config/app_config.dart`:
```dart
static const String backendUrl = "http://127.0.0.1:PUERTO";
```

Y `backend/app.py` o `backend/run_backend.py`:
```python
uvicorn.run(app, host="0.0.0.0", port=PUERTO)
```

### Colores del Tema

Todos los colores están centralizados en `lib/config/app_config.dart`:
```dart
static const int primaryColorValue = 0xFF0D1B2A;      // Fondo azul oscuro
static const int primaryLightColorValue = 0xFF1B263B; // Paneles
static const int accentColorValue = 0xFF2F80ED;       // Acento azul
static const int cardColorValue = 0xFF1B263B;         // Tarjetas
static const int cardBackColorValue = 0xFF243B55;     // Reverso de tarjetas
```

## Agregar Nuevas Luminarias

Edita `backend/fixtures.json`:

```json
{
  "NombreMarca": [
    {
      "nombre": "Nombre del Modelo",
      "tipo": "Tipo (Beam/Wash/Spot/etc)",
      "imagen": "assets/luminarias/imagen.jpg",
      "manual": "assets/descargas/manual.pdf",
      "libreria": "assets/descargas/libreria.zip",
      "marca": "NombreMarca"
    }
  ]
}
```

Luego coloca:
- Imágenes en `backend/static/luminarias/`
- PDFs/Archivos en `backend/static/descargas/`

## Solución de Problemas

### Backend no inicia
- Verifica que las dependencias estén instaladas: `pip install -r requirements.txt`
- Verifica que el puerto 8000 esté disponible

### Frontend no conecta con backend
- Verifica que el backend esté corriendo en puerto 8000
- Revisa la URL en `lib/config/app_config.dart`

### Imágenes no se cargan
- Verifica que las imágenes existan en `backend/static/luminarias/`
- Verifica que los nombres en `fixtures.json` coincidan con los archivos

### Login no funciona
- Usa: usuario `admin`, contraseña `admin`
- Verifica que no haya errores en la consola

## Tecnologías Utilizadas

- **Frontend**: Flutter, Dart
- **Backend**: Python,FastAPI, Uvicorn
- **UI/UX**: Material Design, Animaciones personalizadas
- **Datos**: JSON (fixtures.json)

## Licencia

Proyecto privado - PRO-MG

## Contacto

Para soporte técnico o consultas sobre luminarias PRO-MG.
