# init_db.py
# Script para inicializar la base de datos y crear usuarios
import database
import auth

if __name__ == "__main__":
    print("Creando tablas en la base de datos...")
    database.create_db_and_tables()
    print("✓ Tablas creadas")
    
    # Crear usuarios por defecto
    db = database.SessionLocal()
    
    try:
        # Usuario admin
        admin_user = auth.get_user(db, "admin")
        hashed_pwd = auth.get_password_hash("admin")
        
        if not admin_user:
            print("Creando usuario admin...")
            admin_user = database.User(
                username="admin",
                hashed_password=hashed_pwd,
                disabled=False
            )
            db.add(admin_user)
            print("✓ Usuario admin creado")
        else:
            print("Actualizando contraseña de admin...")
            admin_user.hashed_password = hashed_pwd
            print("✓ Contraseña de admin actualizada")
            
        db.commit()
        
        # Usuario normal
        if not auth.get_user(db, "user"):
            print("Creando usuario normal...")
            hashed_pwd = auth.get_password_hash("1234")
            normal_user = database.User(
                username="user",
                hashed_password=hashed_pwd,
                disabled=False
            )
            db.add(normal_user)
            db.commit()
            print("✓ Usuario user creado (usuario: user, contraseña: 1234)")
        else:
            print("✓ Usuario user ya existe")
            
    finally:
        db.close()
    
    print("\n✅ Base de datos inicializada correctamente")
