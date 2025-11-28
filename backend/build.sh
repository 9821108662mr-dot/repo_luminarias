#!/bin/bash
# Script de build para Render

echo "📦 Instalando dependencias de Python..."
pip install -r requirements.txt

echo "🗄️ Inicializando base de datos..."
python init_db.py

echo "✅ Build completado"
