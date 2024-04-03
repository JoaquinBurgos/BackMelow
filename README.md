# BackMelow
Secuenciador campaña virtual
# CampaignFlow - Creador de Campañas de Marketing

CampaignFlow es una herramienta interactiva diseñada para facilitar la creación y gestión de campañas de marketing digitales. Con una interfaz dinámica basada en nodos, permite a los usuarios configurar flujos complejos que simulan el recorrido de un cliente dentro de una campaña promocional. 

## Características Principales

- **Creador de Flujos de Nodos**: Define los pasos de una campaña a través de nodos interconectados que representan diferentes acciones.
- **Acciones Diversificadas**: Cada nodo puede realizar acciones específicas, como enviar correos electrónicos (Mailer) o establecer periodos de espera (Wait), permitiendo un seguimiento personalizado de cada cliente.
- **Condiciones Personalizables**: Establece reglas para cada campaña basadas en `last_login`, `created_at`, y `page_visit`, que determinan la participación de los usuarios en la campaña.
- **Simulación de Actividad**: Genera actividades de usuario ficticias para probar y visualizar el flujo de la campaña.
- **Worker Automatizado**: Un proceso en segundo plano (worker) verifica periódicamente si los usuarios cumplen con las condiciones establecidas para avanzar en el flujo de la campaña.

## Uso Ideal

CampaignFlow es ideal para empresas y equipos de marketing que buscan optimizar la interacción con sus clientes a través de campañas automatizadas y altamente personalizables. Su capacidad para simular y evaluar condiciones específicas hace que sea una herramienta valiosa para estrategias de marketing dirigidas y efectivas.

## Cómo Funciona

1. **Crear una Campaña**: Define las características de la campaña y configura los nodos con sus respectivas acciones.
2. **Establecer Condiciones**: Personaliza las condiciones bajo las cuales los usuarios entrarán en el flujo de la campaña.
3. **Simular Actividades**: Crea actividades de usuario simuladas para entender cómo interactúan con la campaña.
4. **Evaluación Automatizada**: El worker ejecuta la lógica de procesamiento para mover a los usuarios a través del flujo basándose en sus actividades y condiciones cumplidas.

Este README proporciona todas las instrucciones necesarias para instalar, configurar y ejecutar CampaignFlow, así como información detallada sobre su arquitectura y capacidades.
