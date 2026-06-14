# NeuroDrive - Aplicación Móvil

Este repositorio contiene el código fuente de la aplicación móvil de **NeuroDrive: Sistema Inteligente de Monitoreo de Fatiga e Integración IoT**, desarrollada con el SDK de Flutter para el proyecto integrador de Ingeniería en Software.

## Stack Tecnológico
* **Framework:** Flutter (Dart)
* **Sensores:** Integración nativa de cámara frontal (`camera` plugin)

## Estructura Inicial del Proyecto
```text
lib/
├── core/          # Configuraciones globales, temas y utilidades estables
├── data/          # Capa de datos (Modelos y proveedores de servicios/API)
├── domain/        # Capa de negocio (Entidades y lógica pura)
└── presentation/  # Capa visual (Vistas/Screens y Widgets compartidos)
```

## Políticas de Contribución
Para mantener la integridad del código fuente, este repositorio sigue estrictas reglas de control de versiones:
1. Queda estrictamente prohibido realizar commits directos a la rama main.
2. Todo desarrollo de nuevas interfaces o funciones debe realizarse en una rama aislada (ej. feature/maquetacion-login).
3. La integración del código a main se realizará exclusivamente mediante un Pull Request (PR), el cual requiere revisión y aprobación obligatoria.

## InnovaTech - 2026
