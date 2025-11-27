# app.py
import os
from fastapi import FastAPI, HTTPException, Request, Depends, status
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List
from datetime import timedelta

# Importaciones locales
import database
import models
import auth # Importar módulo de autenticación

# Crear tablas al inicio (si no existen)
database.create_db_and_tables()

app = FastAPI(title="API Luminarias PRO-MG (Dinámica)")

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Montar carpeta static
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = os.path.join(BASE_DIR, "static")
if not os.path.isdir(STATIC_DIR):
    print(f"[WARN] static dir no encontrada en: {STATIC_DIR}")
else:
    app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

# Dependencia para DB
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def root():
    return {"mensaje": "API de luminarias PRO-MG funcionando (Dinámica con DB)."}

# --- Autenticación ---

@app.post("/token", response_model=models.Token)
async def login_for_access_token(form_data: auth.OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = auth.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuario o contraseña incorrectos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

# --- Endpoints Públicos (Lectura) ---

@app.get("/brands", response_model=List[dict])
def get_brands(request: Request, db: Session = Depends(get_db)):
    # Obtener todas las marcas de la DB
    marcas = db.query(database.Marca).all()
    
    base_url = f"{request.url.scheme}://{request.url.netloc}"
    
    brands_list = []
    for marca in marcas:
        # Por ahora usamos un logo por defecto o podríamos agregarlo al modelo Marca
        logo_url = f"{base_url}/static/images/default_logo.png"
        
        brands_list.append({
            "name": marca.nombre,
            "logo": logo_url,
            "description": f"Catálogo de {marca.nombre}"
        })
    return brands_list

@app.get("/fixtures/{marca_nombre}")
def get_fixtures(marca_nombre: str, request: Request, db: Session = Depends(get_db)):
    # Buscar la marca
    marca = db.query(database.Marca).filter(database.Marca.nombre == marca_nombre).first()
    if not marca:
        raise HTTPException(status_code=404, detail="Marca no encontrada")
    
    base_url = f"{request.url.scheme}://{request.url.netloc}"
    
    fixtures_response = []
    for fixture in marca.fixtures:
        # Convertir rutas relativas a absolutas si es necesario
        imagen_url = fixture.imagen
        if imagen_url and imagen_url.startswith("/"):
            imagen_url = f"{base_url}{imagen_url}"
            
        manual_url = fixture.manual
        if manual_url and manual_url.startswith("/"):
            manual_url = f"{base_url}{manual_url}"
            
        libreria_url = fixture.libreria
        if libreria_url and libreria_url.startswith("/"):
            libreria_url = f"{base_url}{libreria_url}"

        fixtures_response.append({
            "nombre": fixture.nombre,
            "tipo": fixture.tipo,
            "imagen": imagen_url,
            "manual": manual_url,
            "libreria": libreria_url,
            "marca": marca.nombre
        })
            
    return fixtures_response

# --- Endpoints Protegidos (Escritura) ---

@app.post("/brands", response_model=models.Marca)
def create_brand(marca: models.MarcaBase, current_user: models.User = Depends(auth.get_current_active_user), db: Session = Depends(get_db)):
    db_marca = db.query(database.Marca).filter(database.Marca.nombre == marca.nombre).first()
    if db_marca:
        raise HTTPException(status_code=400, detail="La marca ya existe")
    new_marca = database.Marca(nombre=marca.nombre)
    db.add(new_marca)
    db.commit()
    db.refresh(new_marca)
    return new_marca

@app.post("/fixtures", response_model=models.Fixture)
def create_fixture(fixture: models.FixtureBase, marca_nombre: str, current_user: models.User = Depends(auth.get_current_active_user), db: Session = Depends(get_db)):
    # Buscar la marca por nombre
    db_marca = db.query(database.Marca).filter(database.Marca.nombre == marca_nombre).first()
    if not db_marca:
        raise HTTPException(status_code=404, detail="Marca no encontrada")
    
    new_fixture = database.Fixture(
        nombre=fixture.nombre,
        imagen=fixture.imagen,
        manual=fixture.manual,
        tipo=fixture.tipo,
        libreria=fixture.libreria,
        marca_id=db_marca.id
    )
    db.add(new_fixture)
    db.commit()
    db.refresh(new_fixture)
    return new_fixture

@app.delete("/fixtures/{fixture_id}")
def delete_fixture(fixture_id: int, current_user: models.User = Depends(auth.get_current_active_user), db: Session = Depends(get_db)):
    fixture = db.query(database.Fixture).filter(database.Fixture.id == fixture_id).first()
    if not fixture:
        raise HTTPException(status_code=404, detail="Fixture no encontrado")
    
    db.delete(fixture)
    db.commit()
    return {"ok": True}

# Ejecutar con uvicorn en puerto 8000
if __name__ == "__main__":
    import uvicorn
    # Crear usuario admin por defecto si no existe
    db = database.SessionLocal()
    if not auth.get_user(db, "admin"):
        print("Creando usuario admin por defecto...")
        hashed_pwd = auth.get_password_hash("admin")
        admin_user = database.User(username="admin", hashed_password=hashed_pwd)
        db.add(admin_user)
        db.commit()
    db.close()
    
    print("Iniciando servidor en http://127.0.0.1:8000")
    uvicorn.run(app, host="0.0.0.0", port=8000)
