import json
import os
from sqlalchemy.orm import Session
from database import SessionLocal, engine, Base, Marca, Fixture

# Crear tablas si no existen
Base.metadata.create_all(bind=engine)

def migrate_data():
    db = SessionLocal()
    
    # Ruta al archivo fixtures.json
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    FIXTURES_JSON = os.path.join(BASE_DIR, "fixtures.json")
    
    if not os.path.exists(FIXTURES_JSON):
        print(f"No se encontró {FIXTURES_JSON}")
        return

    with open(FIXTURES_JSON, "r", encoding="utf-8") as f:
        data = json.load(f)

    print("Iniciando migración...")

    for marca_nombre, fixtures_list in data.items():
        # Buscar o crear la marca
        marca = db.query(Marca).filter(Marca.nombre == marca_nombre).first()
        if not marca:
            print(f"Creando marca: {marca_nombre}")
            marca = Marca(nombre=marca_nombre)
            db.add(marca)
            db.commit()
            db.refresh(marca)
        
        for fixture_data in fixtures_list:
            fixture_nombre = fixture_data.get("nombre")
            
            # Verificar si ya existe el fixture
            existing_fixture = db.query(Fixture).filter(Fixture.nombre == fixture_nombre).first()
            
            if not existing_fixture:
                print(f"  - Creando fixture: {fixture_nombre}")
                new_fixture = Fixture(
                    nombre=fixture_nombre,
                    imagen=fixture_data.get("imagen"),
                    pdf=fixture_data.get("manual"),
                    marca_id=marca.id
                )
                db.add(new_fixture)
            else:
                print(f"  - Fixture ya existe: {fixture_nombre}")
        
        db.commit()

    print("Migración completada exitosamente.")
    db.close()

if __name__ == "__main__":
    migrate_data()
