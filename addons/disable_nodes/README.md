# Disable Nodes Plugin for Godot 4.3

## Description / Descripción

This plugin for Godot 4.3 allows you to disable nodes in the scene directly from the Inspector. Unlike simply setting a node's visibility to false, this plugin provides a more comprehensive deactivation by disabling various aspects of a node's functionality, including processing, physics interactions, and other relevant properties.

When you select a node, additional options appear in the Inspector, allowing you to choose how to disable it. You can either disable the node's functionality while keeping its name unchanged or disable it while modifying its name to indicate its disabled state.

Este plugin para Godot 4.3 permite deshabilitar nodos en la escena directamente desde el Inspector. A diferencia de simplemente establecer la visibilidad de un nodo en falso, este plugin ofrece una desactivación más completa al inhabilitar varios aspectos de la funcionalidad del nodo, incluyendo el procesamiento, las interacciones físicas y otras propiedades relevantes.

Al seleccionar un nodo, aparecen opciones adicionales en el Inspector que permiten elegir cómo deshabilitarlo. Puedes optar por desactivar la funcionalidad del nodo sin cambiar su nombre o desactivarlo modificando su nombre para indicar su estado deshabilitado.

## Features / Características

- Disables the node's visibility and its children's visibility.
- Disables the node's processing functions such as `_process()`, `_physics_process()`, `_input()`, `_unhandled_input()`, and `_unhandled_key_input()`.
- Disables physics interactions for `CollisionObject2D` and `CollisionObject3D` nodes.
- Stops particle emission if the node has an `emitting` property.
- Pauses animations, streams, and physics interactions for compatible nodes.
- Changes the node's name (optional) to indicate its disabled status.
- Ensures all modifications are reversible by restoring the original state upon reactivation.
- Provides two checkbox options in the Inspector to toggle these behaviors.

- Desactiva la visibilidad del nodo y de sus hijos.
- Desactiva las funciones de procesamiento del nodo como `_process()`, `_physics_process()`, `_input()`, `_unhandled_input()` y `_unhandled_key_input()`.
- Deshabilita las interacciones físicas de los nodos `CollisionObject2D` y `CollisionObject3D`.
- Detiene la emisión de partículas si el nodo tiene una propiedad `emitting`.
- Pausa animaciones, flujos de audio y físicas en nodos compatibles.
- Cambia el nombre del nodo (opcionalmente) para indicar su estado deshabilitado.
- Asegura que todas las modificaciones sean reversibles restaurando el estado original al reactivar el nodo.
- Proporciona dos opciones en forma de casillas de verificación en el Inspector para alternar estos comportamientos.

## Installation / Instalación

1. Copy the `addons/disable_nodes` folder into your Godot project.
2. Enable the plugin from the `Project > Project Settings > Plugins` menu.
3. Select a node in your scene, and new options will appear in the Inspector to enable or disable it.

1. Copia la carpeta `addons/disable_nodes` en tu proyecto de Godot.
2. Habilita el plugin desde el menú `Project > Project Settings > Plugins`.
3. Selecciona un nodo en tu escena y aparecerán nuevas opciones en el Inspector para habilitarlo o deshabilitarlo.

## Usage / Uso

Once the plugin is enabled, you can disable any node directly from the Inspector:

1. Select a node in your scene.
2. In the Inspector, you will see a new section with two checkboxes:
   - "Disable Node (functionality only)": Disables the node's processing and physics while keeping its name unchanged.
   - "Disable Node (with name change)": Disables the node's functionality and modifies its name to indicate that it is disabled.
3. Checking either box will disable the node and its children according to the chosen method.
4. Unchecking the box will restore the node's original state.

Una vez que el plugin está habilitado, puedes deshabilitar cualquier nodo directamente desde el Inspector:

1. Selecciona un nodo en tu escena.
2. En el Inspector, verás una nueva sección con dos casillas de verificación:
   - "Disable Node (functionality only)": Deshabilita el procesamiento y las físicas del nodo sin cambiar su nombre.
   - "Disable Node (with name change)": Deshabilita la funcionalidad del nodo y modifica su nombre para indicar que está deshabilitado.
3. Activar cualquiera de estas casillas deshabilitará el nodo y sus hijos según el método elegido.
4. Desactivar la casilla restaurará el estado original del nodo.

## How It Works / Cómo Funciona

The plugin operates by applying a series of predefined actions to disable various properties of the selected node. These actions include:

- Setting process functions to false (`set_process`, `set_physics_process`, etc.).
- Disabling visibility (`set_visible`).
- Pausing animations and streams (`set_paused`, `set_stream_paused`).
- Freezing physics interactions (`set_physics_active`, `set_avoidance_enabled`).
- Temporarily modifying properties that control interactivity (`set_disabled`, `set_monitorable`).
- Changing the node name if the corresponding option is selected.

When re-enabling a node, the plugin restores all properties to their previous values, ensuring that the node resumes functioning exactly as before.

El plugin funciona aplicando una serie de acciones predefinidas para deshabilitar varias propiedades del nodo seleccionado. Estas acciones incluyen:

- Configurar las funciones de procesamiento en falso (`set_process`, `set_physics_process`, etc.).
- Deshabilitar la visibilidad (`set_visible`).
- Pausar animaciones y flujos de audio (`set_paused`, `set_stream_paused`).
- Congelar interacciones físicas (`set_physics_active`, `set_avoidance_enabled`).
- Modificar temporalmente propiedades que controlan la interactividad (`set_disabled`, `set_monitorable`).
- Cambiar el nombre del nodo si se selecciona la opción correspondiente.

Al volver a habilitar un nodo, el plugin restaura todas las propiedades a sus valores anteriores, asegurando que el nodo funcione exactamente como antes.

## Limitations / Limitaciones

- If a node is found using `get_node()` by its name, renaming it may cause issues. A warning label is displayed in the Inspector to inform users of this potential problem.
- Certain nodes may have unique behaviors that require additional handling. If you notice any incompatibilities, consider customizing the plugin.

- Si un nodo es buscado mediante `get_node()` por su nombre, cambiar su nombre puede causar problemas. Una etiqueta de advertencia aparece en el Inspector para informar a los usuarios sobre este posible inconveniente.
- Algunos nodos pueden tener comportamientos únicos que requieran un manejo adicional. Si notas alguna incompatibilidad, considera personalizar el plugin.

## License / Licencia

This plugin is distributed under the MIT License. You can use, modify, distribute, and adapt it freely, with no need to provide attribution. 

Este plugin se distribuye bajo la Licencia MIT. Puedes usarlo, modificarlo, distribuirlo y adaptarlo de forma libre, sin necesidad de dar créditos.

## Contributions / Contribuciones

If you want to contribute improvements or fixes, feel free to do so. Create a fork and open a pull request for review.

Si deseas contribuir con mejoras o correcciones, eres bienvenido a hacerlo. Crea un fork y abre un pull request para su revisión.
