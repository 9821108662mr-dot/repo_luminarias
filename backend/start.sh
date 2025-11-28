#!/bin/bash
# Script de inicialización para Render

echo "Instalando dependencias..."
pip install -r requirements.txt

echo "Iniciando aplicación..."
python app.py
