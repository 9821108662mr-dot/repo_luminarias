# app.py
import os
from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from typing import List
import json

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

app = FastAPI(title="API Luminarias PRO-MG (dev)")

# CORS - permitir llamadas locales desde el frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permitir todos los orígenes en desarrollo
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Montar carpeta static (imágenes, descargas) - ruta absoluta
STATIC_DIR = os.path.join(BASE_DIR, "static")
if not os.path.isdir(STATIC_DIR):
    print(f"[WARN] static dir no encontrada en: {STATIC_DIR}")
else:
    app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# Endpoint root
@app.get("/")
def root():
    return {"mensaje": "API de luminarias PRO-MG funcionando (modo dev)."}

# Leer fixtures.json desde backend/fixtures.json
FIXTURES_JSON = os.path.join(BASE_DIR, "fixtures.json")

def read_fixtures_data():
    if not os.path.exists(FIXTURES_JSON):
        raise FileNotFoundError(f"No se encontró {FIXTURES_JSON}")
    with open(FIXTURES_JSON, "r", encoding="utf-8") as f:
        data = json.load(f)
    return data

BRANDS_DATA_JSON = os.path.join(BASE_DIR, "data", "brands_data.json")

def read_brands_data():
    if not os.path.exists(BRANDS_DATA_JSON):
        raise FileNotFoundError(f"No se encontró {BRANDS_DATA_JSON}")
    with open(BRANDS_DATA_JSON, "r", encoding="utf-8") as f:
        data = json.load(f)
    return data

@app.get("/brands")
def get_brands(request: Request):
    fixtures = read_fixtures_data()
    brands_details = read_brands_data()
    
    # Construir URL base para los estáticos
    base_url = f"{request.url.scheme}://{request.url.netloc}"
    
    brands_list = []
    for brand_name in fixtures.keys():
        details = brands_details.get(brand_name, {})
        logo_path = details.get("logo", "/static/images/default_logo.png")
        
        # Convertir ruta relativa a URL absoluta
        logo_url = f"{base_url}{logo_path}"
        
        brands_list.append({
            "name": brand_name,
            "logo": logo_url,
            "description": details.get("description", "Descripción no disponible.")
        })
    return brands_list

@app.get("/fixtures/{marca_nombre}")
def get_fixtures(marca_nombre: str, request: Request):
    data = read_fixtures_data()
    if marca_nombre not in data:
        raise HTTPException(status_code=404, detail="Marca no encontrada")
    
    # Construir URL base para los estáticos
    base_url = f"{request.url.scheme}://{request.url.netloc}"
    
    # Asegurar que cada fixture tenga el campo "marca" y URLs absolutas
    fixtures = data[marca_nombre]
    for fixture in fixtures:
        if "marca" not in fixture:
            fixture["marca"] = marca_nombre
        
        # Convertir rutas relativas a absolutas
        if "imagen" in fixture and isinstance(fixture["imagen"], str):
            fixture["imagen"] = f"{base_url}{fixture['imagen']}"
        
        if "manual" in fixture and isinstance(fixture["manual"], str):
            fixture["manual"] = f"{base_url}{fixture['manual']}"
            
    return fixtures

# Ejecutar con uvicorn en puerto 8000
if __name__ == "__main__":
    import uvicorn
    print("Iniciando servidor en http://127.0.0.1:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
