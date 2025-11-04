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
  "paginaWeb": "string"     // URL del sitio web (validada)
}
```

---

## ✨ Funcionalidades Implementadas

### 1. **Create (Crear)**
- Formulario con validación de campos
- Validación de NIT único en Firestore
- Validación de formato URL para página web
- Campos obligatorios: NIT y nombre

**Captura - Formulario de Creación**:
<!-- Insertar captura del formulario aquí -->

---

### 2. **Read (Listar)**
- Lista en tiempo real con `StreamBuilder`
- Sincronización automática con Firebase
- Diseño responsive (Grid/Lista según dispositivo)
- Estado vacío con mensaje informativo

**Captura - Lista de Universidades**:
<!-- Insertar captura de la lista aquí -->

---

### 3. **Update (Actualizar)**
- Edición de universidades existentes
- Pre-carga de datos en el formulario
- Validación al actualizar (excepto NIT)

**Captura - Edición de Universidad**:
<!-- Insertar captura del formulario de edición aquí -->

---

### 4. **Delete (Eliminar)**
- Diálogo de confirmación antes de eliminar
- Vista previa de los datos a eliminar
- Feedback visual con SnackBar

**Captura - Diálogo de Confirmación**:
<!-- Insertar captura del diálogo aquí -->

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

## 📊 Vista de Evidencia - Base de Datos en Vivo

La aplicación muestra datos en **tiempo real** utilizando `StreamBuilder`:

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

**Captura - Firebase Console (Firestore)**:
<!-- Insertar captura de Firebase Console mostrando la colección 'universidades' aquí -->

**Captura - Sincronización en Tiempo Real**:
<!-- Insertar captura mostrando cambios en tiempo real en la app aquí -->

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

## 📸 Galería de Capturas

### Vista Principal
<!-- Insertar captura aquí -->

### Formulario de Registro
<!-- Insertar captura aquí -->

### Base de Datos Firestore
<!-- Insertar captura aquí -->

### Sincronización en Tiempo Real
<!-- Insertar captura aquí -->
