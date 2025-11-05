import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../models/universidad_fb.dart';
import '../../services/universidad_service.dart';

class UniversidadFbFormView extends StatefulWidget {
  final String? id;

  const UniversidadFbFormView({super.key, this.id});

  @override
  State<UniversidadFbFormView> createState() => _UniversidadFbFormViewState();
}

class _UniversidadFbFormViewState extends State<UniversidadFbFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nitController = TextEditingController();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _paginaWebController = TextEditingController();
  bool _camposInicializados = false;
  bool _isLoading = false;

  Future<void> _guardar({String? id}) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Verificar si el NIT ya existe (solo para nuevas universidades o si cambió el NIT)
        final nitExiste = await UniversidadService.existeNit(
          _nitController.text.trim(),
          excludeId: id,
        );

        if (nitExiste && mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ya existe una universidad con este NIT'),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        final universidad = UniversidadFb(
          id: id ?? '',
          nit: _nitController.text.trim(),
          nombre: _nombreController.text.trim(),
          direccion: _direccionController.text.trim(),
          telefono: _telefonoController.text.trim(),
          paginaWeb: _paginaWebController.text.trim(),
        );

        if (widget.id == null) {
          await UniversidadService.addUniversidad(universidad);
        } else {
          await UniversidadService.updateUniversidad(universidad);
        }

        if (mounted) {
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.id == null
                    ? 'Universidad creada exitosamente'
                    : 'Universidad actualizada exitosamente',
              ),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          final colorScheme = Theme.of(context).colorScheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al guardar: $e'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  void _inicializarCampos(UniversidadFb universidad) {
    if (_camposInicializados) return;
    _nitController.text = universidad.nit;
    _nombreController.text = universidad.nombre;
    _direccionController.text = universidad.direccion;
    _telefonoController.text = universidad.telefono;
    _paginaWebController.text = universidad.paginaWeb;
    _camposInicializados = true;
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _paginaWebController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool esNuevo = widget.id == null;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Crear Universidad' : 'Editar Universidad'),
      ),
      body: esNuevo
          ? _buildFormulario(context, id: null)
          : StreamBuilder<UniversidadFb?>(
              stream: UniversidadService.watchUniversidadById(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar universidad',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 60,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Universidad no encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.tonal(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                final universidad = snapshot.data!;
                _inicializarCampos(universidad);
                return _buildFormulario(context, id: universidad.id);
              },
            ),
    );
  }

  Widget _buildFormulario(BuildContext context, {required String? id}) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determinar el ancho máximo según el tamaño del dispositivo
    final double maxWidth = screenWidth > 1200
        ? 800 // Desktop grande
        : screenWidth > 800
        ? 600 // Tablet/Desktop pequeño
        : double.infinity; // Móvil

    // Padding adaptativo
    final double horizontalPadding = screenWidth > 600 ? 24 : 16;
    final double cardPadding = screenWidth > 600 ? 24 : 16;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card con información básica
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información básica',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // NIT
                        TextFormField(
                          controller: _nitController,
                          decoration: InputDecoration(
                            labelText: 'NIT *',
                            hintText: 'Ej: 890123456-7',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\-]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El NIT es requerido';
                            }
                            if (value.trim().length < 5) {
                              return 'El NIT debe tener al menos 5 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Nombre
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre *',
                            hintText: 'Ingresa el nombre de la universidad',
                            prefixIcon: const Icon(Icons.business),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es requerido';
                            }
                            if (value.trim().length < 3) {
                              return 'El nombre debe tener al menos 3 caracteres';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card con información de contacto
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.contact_page_outlined,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Información de contacto',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Dirección
                        TextFormField(
                          controller: _direccionController,
                          decoration: InputDecoration(
                            labelText: 'Dirección *',
                            hintText: 'Ingresa la dirección completa',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La dirección es requerida';
                            }
                            if (value.trim().length < 5) {
                              return 'La dirección debe tener al menos 5 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Teléfono
                        TextFormField(
                          controller: _telefonoController,
                          decoration: InputDecoration(
                            labelText: 'Teléfono *',
                            hintText: 'Ej: +57 300 123 4567',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9+\s\-()]'),
                            ),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El teléfono es requerido';
                            }
                            if (value.trim().length < 7) {
                              return 'El teléfono debe tener al menos 7 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Página Web
                        TextFormField(
                          controller: _paginaWebController,
                          decoration: InputDecoration(
                            labelText: 'Página Web *',
                            hintText: 'https://www.ejemplo.edu.co',
                            prefixIcon: const Icon(Icons.language),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La página web es requerida';
                            }
                            // Validación básica de URL
                            final urlPattern = RegExp(
                              r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/.*)?$',
                            );
                            if (!urlPattern.hasMatch(value.trim())) {
                              return 'Ingresa una URL válida';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nota informativa
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Los campos marcados con * son obligatorios',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : () => _guardar(id: id),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(_isLoading ? 'Guardando...' : 'Guardar'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : () => context.pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
