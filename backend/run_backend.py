# Script para iniciar el backend
# Ejecutar: python run_backend.py

import os
import sys

# Cambiar al directorio del script
os.chdir(os.path.dirname(os.path.abspath(__file__)))

print("="*60)
print(" Catálogo PRO-MG - Backend API")
print("="*60)
print()
print("Iniciando servidor en http://127.0.0.1:8000")
print()
print("Endpoints disponibles:")
print("  - GET /               : Info de la API")
print("  - GET /marcas         : Lista de marcas")
print("  - GET /fixtures/{marca} : Fixtures de una marca")
print()
print("Archivos estáticos servidos desde /static/")
print()
print("Presiona Ctrl+C para detener el servidor")
print("="*60)
print()

# Importar e iniciar la app
try:
    import uvicorn
    from app import app
    
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
except KeyboardInterrupt:
    print("\n\nServidor detenido.")
    sys.exit(0)
except Exception as e:
    print(f"\nError al iniciar el servidor: {e}")
    print("\nAsegúrate de tener instaladas las dependencias:")
    print("  pip install -r requirements.txt")
    sys.exit(1)
