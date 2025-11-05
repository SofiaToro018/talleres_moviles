# 📱 Taller Firebase - Gestión de Universidades

Aplicación móvil desarrollada en Flutter que implementa un CRUD completo de universidades con Firebase Firestore, permitiendo la gestión en tiempo real de información universitaria.

## 🎯 Objetivo

Implementar una aplicación que permita **Crear, Leer, Actualizar y Eliminar** (CRUD) información de universidades, almacenando los datos en Firebase Firestore con sincronización en tiempo real.

---

## 🏗️ Arquitectura

### Patrón de Diseño
La aplicación sigue una arquitectura **Model-Service-View**:

```
lib/
├── models/
│   └── universidad_fb.dart          # Modelo de datos
├── services/
│   └── universidad_service.dart     # Lógica de negocio y Firebase
├── views/
│   └── firebase/
│       ├── universidad_fb_list_view.dart   # Lista (Read)
│       └── universidad_fb_form_view.dart   # Formulario (Create/Update)
├── routes/
│   └── app_router.dart              # Configuración de rutas
└── widgets/
    └── custom_drawer.dart           # Menú de navegación
```

### Capas de la Aplicación

1. **Model (Modelo)**: Define la estructura de datos de Universidad
2. **Service (Servicio)**: Gestiona la comunicación con Firebase Firestore
3. **View (Vista)**: Interfaces de usuario para listar y gestionar universidades

---

## 🔥 Conexión con Firebase

### Configuración

#### 1. Dependencias en `pubspec.yaml`
```yaml
dependencies:
  firebase_core: ^4.2.0
  cloud_firestore: ^6.0.3
```

#### 2. Inicialización de Firebase
```dart
// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### Colección en Firestore

**Nombre de la colección**: `universidades`

**Estructura de documentos**:
```javascript
{
  "id": "string",           // ID autogenerado
  "nit": "string",          // NIT único (validado)
  "nombre": "string",       // Nombre de la universidad
  "direccion": "string",    // Dirección física
  "telefono": "string",     // Número de contacto
  "pagina_web": "string"     // URL del sitio web (validada)
}
```

---

## ✨ Funcionalidades Implementadas

### 1. **Read (Listar) - Vista Principal**
- Lista en tiempo real con `StreamBuilder`
- Sincronización automática con Firebase
- Diseño responsive con gradiente personalizado
- Cards con información completa (NIT, dirección, teléfono, web)

**📸 Captura 1 - UI Lista de Universidades Creadas**:

![lista](<listUni.png>)
---

### 2. **Create (Crear) - Formulario de Registro**
- Formulario con validación de campos
- Validación de NIT único en Firestore
- Validación de formato URL para página web
- Campos obligatorios: NIT y nombre
- Diseño en dos secciones: Información Básica y Contacto

**📸 Captura 2 - Vista del Formulario**:
![crear form](<formUni.png>)

---

### 3. **Validaciones de Campos**
- Validación de campos no vacíos
- Mensajes de error descriptivos
- Validación en tiempo real al escribir
- Bloqueo de envío si hay errores

**📸 Captura 3 - Validación de Campos No Vacíos**:
![Campos Vacios](<CVacios.png>)
---

### 4. **Persistencia en Firebase - Datos Guardados**
- Guardado exitoso en Firestore
- Estructura de datos completa
- ID autogenerado por Firebase
- Sincronización inmediata con la app

**📸 Captura 4 - Base de Datos Firebase (Universidad Creada)**:
![Firebase](<Bd.png>)

---

### 5. **Delete (Eliminar) - Confirmación**
- Diálogo de confirmación antes de eliminar
- Vista previa de los datos a eliminar
- Botones de cancelar/confirmar
- Prevención de eliminaciones accidentales

**📸 Captura 5 - Mensaje de Confirmación de Eliminación**:
![Eliminar universidad](<eliminar.png>)
---

## 🔍 Validaciones Implementadas

### Validación de Campos
```dart
// 1. Campos obligatorios
validator: (value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es obligatorio';
  }
  return null;
}

// 2. Validación de URL
validator: (value) {
  if (value != null && value.isNotEmpty) {
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Ingresa una URL válida';
    }
  }
  return null;
}

// 3. Validación de NIT único
Future<bool> existeNit(String nit, [String? universidadId]) async {
  final query = await _ref.where('nit', isEqualTo: nit).get();
  
  if (query.docs.isEmpty) return false;
  
  if (universidadId != null) {
    return query.docs.any((doc) => doc.id != universidadId);
  }
  
  return true;
}
```

---

## 📊 Sincronización en Tiempo Real

La aplicación utiliza **StreamBuilder** para mantener los datos sincronizados automáticamente con Firebase Firestore:

```dart
StreamBuilder<List<UniversidadFb>>(
  stream: UniversidadService.watchUniversidades(),
  builder: (context, snapshot) {
    // Actualización automática cuando cambia la BD
    final universidades = snapshot.data ?? [];
    return ListView.builder(
      itemCount: universidades.length,
      itemBuilder: (context, index) => UniversidadCard(...),
    );
  },
)
```

**Ventajas de la sincronización en tiempo real:**
- ✅ Los cambios en Firebase se reflejan instantáneamente en la app
- ✅ Múltiples dispositivos pueden ver los mismos datos actualizados
- ✅ No requiere recargar manualmente la lista
- ✅ Experiencia de usuario fluida y moderna

---

## 🚀 Cómo Ejecutar el Proyecto

### Requisitos Previos
- Flutter SDK (^3.9.2)
- Dart SDK
- Cuenta de Firebase
- Editor: VS Code / Android Studio

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/SofiaToro018/talleres_moviles.git
cd talleres_moviles
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar Firebase** (si no está configurado)
```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase
flutterfire configure
```

4. **Ejecutar la aplicación**
```bash
flutter run
```

---

## 📦 Dependencias Principales

| Paquete | Versión | Uso |
|---------|---------|-----|
| `firebase_core` | ^4.2.0 | Inicialización de Firebase |
| `cloud_firestore` | ^6.0.3 | Base de datos en tiempo real |
| `go_router` | ^16.2.4 | Navegación |
| `provider` | ^6.1.1 | Gestión de estado |

---

## 🎨 Características Adicionales

- ✅ **Diseño Material Design 3** con gradientes personalizados
- ✅ **Responsive Design** (Móvil, Tablet, Desktop)
- ✅ **Animaciones** en botones y transiciones
- ✅ **Loading States** durante operaciones asíncronas
- ✅ **Error Handling** con mensajes descriptivos
- ✅ **Empty States** con iconografía clara

---

## 👥 Autor

**Laura Sofía Toro**
- GitHub: [@SofiaToro018](https://github.com/SofiaToro018)
- Proyecto: Electiva Profesional I - 7° Semestre
- Rama: feature/taller_firebase_universidades

---

## Notas Finales

Este proyecto demuestra la implementación completa de un CRUD con Firebase Firestore, incluyendo:
- ✅ Sincronización en tiempo real
- ✅ Validaciones robustas de datos
- ✅ Diseño responsive y moderno
- ✅ Manejo de estados y errores
- ✅ Arquitectura escalable y mantenible
