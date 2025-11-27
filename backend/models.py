from pydantic import BaseModel

# --- Modelos de Datos Pydantic (para la API) ---

class FixtureBase(BaseModel):
    nombre: str
    imagen: str
    pdf: str | None = None

class Fixture(FixtureBase):
    id: int
    marca_id: int

    class Config:
        orm_mode = True # FastAPI <3 Pydantic

class MarcaBase(BaseModel):
    nombre: str

class Marca(MarcaBase):
    id: int
    fixtures: list[Fixture] = []

    class Config:
        orm_mode = True

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: str | None = None

class User(BaseModel):
    username: str
    disabled: bool | None = None
