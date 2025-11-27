# backend/migrate_data.py
import os
import json
from passlib.context import CryptContext
from database import SessionLocal, create_db_and_tables, Marca, Fixture, User

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def migrate():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    fixtures_path = os.path.join(base_dir, "fixtures.json")

    print("Creando tablas (si no existen)...")
    create_db_and_tables()

    db = SessionLocal()
    try:
        # crear usuario admin si no existe
        admin = db.query(User).filter(User.username == "admin").first()
        if not admin:
            print("Creando usuario admin/admin")
            hashed = pwd_context.hash("admin")
            admin_user = User(username="admin", hashed_password=hashed, disabled=False)
            db.add(admin_user)
        else:
            print("Usuario admin ya existe")

        # cargar fixtures.json si existe
        if os.path.exists(fixtures_path):
            print("Leyendo fixtures.json...")
            with open(fixtures_path, "r", encoding="utf-8") as f:
                data = json.load(f)
            for marca_nombre, fixtures in data.items():
                db_marca = db.query(Marca).filter(Marca.nombre == marca_nombre).first()
                if not db_marca:
                    db_marca = Marca(nombre=marca_nombre)
                    db.add(db_marca)
                    db.flush()
                for fx in fixtures:
                    exists = db.query(Fixture).filter(Fixture.nombre == fx.get("nombre"), Fixture.marca_id == db_marca.id).first()
                    if not exists:
                        db_fx = Fixture(nombre=fx.get("nombre"), imagen=fx.get("imagen",""), pdf=fx.get("manual",""), marca_id=db_marca.id)
                        db.add(db_fx)
        else:
            print("No se encontró fixtures.json")
        db.commit()
        print("Migración completada.")
    finally:
        db.close()

if __name__ == "__main__":
    migrate()
