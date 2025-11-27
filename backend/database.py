import os
from sqlalchemy import create_engine, Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import sessionmaker, relationship
from sqlalchemy.ext.declarative import declarative_base

# --- Configuración de la Base de Datos ---
# Construye la ruta a la base de datos relativa a la ubicación de este archivo.
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Intentar obtener URL de base de datos de variable de entorno (Render)
# Si no existe, usar SQLite local
DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL and DATABASE_URL.startswith("postgres://"):
    # Fix para SQLAlchemy que requiere postgresql:// en lugar de postgres://
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

if not DATABASE_URL:
    DATABASE_URL = f"sqlite:///{os.path.join(BASE_DIR, 'luminarias.db')}"
    connect_args = {"check_same_thread": False} # Necesario para SQLite
else:
    connect_args = {} # No necesario para Postgres

engine = create_engine(
    DATABASE_URL, 
    connect_args=connect_args
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# --- Modelos de la Base de Datos (SQLAlchemy) ---
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    disabled = Column(Boolean, default=False)

class Marca(Base):
    __tablename__ = "marcas"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, unique=True, index=True)

    fixtures = relationship("Fixture", back_populates="marca")

class Fixture(Base):
    __tablename__ = "fixtures"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, index=True)
    imagen = Column(String) # Ruta a la imagen
    manual = Column(String) # Ruta al PDF
    tipo = Column(String)   # Tipo de fixture (Beam, Spot, etc)
    libreria = Column(String) # Ruta a la libreria
    marca_id = Column(Integer, ForeignKey("marcas.id"))

    marca = relationship("Marca", back_populates="fixtures")

# --- Función para crear la base de datos y las tablas ---
def create_db_and_tables():
    # Esto crea la base de datos y todas las tablas definidas arriba.
    Base.metadata.create_all(bind=engine)

# --- Dependencia para obtener la sesión de la base de datos ---
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
