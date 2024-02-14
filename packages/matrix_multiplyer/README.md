# Шаги по созданию federated plugin

> **Важно**
> Инструкция написана применительно к примеру с перемножением матриц

#### шаг 1

Создаем необходимые пакеты
```
flutter create matrix_multiplyer --template=package && 
flutter create matrix_multiplyer_platform_interface --template=package &&
flutter create matrix_multiplyer_android --template=plugin --platforms android &&
flutter create matrix_multiplyer_ios --template=plugin --platforms ios &&
```

matrix_multiplyer - app-facing package
matrix_multiplyer_platform_interface - platform interface package

и 2 плагина для платформ iOS, Android:
matrix_multiplyer_ios
matrix_multiplyer_android

Пакеты помечаются флагом ``--template=package``, плагины - ``--template=plugin``
Для задания платформы плагина используется флаг ``--platforms``
Платформы можно перечислять через запятую, это не обязательно должна быть одна платформа, но для federated plugin намеренно создаем отдельный плагин под каждую платформу

Пример: ``--platforms=android, ios, macos, windows``
#### шаг 2

Добавить зависимость ```plugin_platform_interface: ^2.1.8 // or higher``` в pubspec.yaml для пакета **matrix_multiplyer_platform_interface** 

Затем связать плагины с пакетом platform interface package, т.е. 
1. добавить зависимость в matrix_multiplyer_android и matrix_multiplyer_ios
```
matrix_multiplyer_platform_interface:
   path: ../platform_info_platform_interface
```
2. добавить для объекта flutter в yaml указание что это federated plugin который реализует app-facing package matrix_multiplyer
Например, для Android
```
flutter:
 plugin:
   implements: matrix_multiplyer
   platforms:
     android:
       package: plugin.matrix_multiplyer
       pluginClass: MatrixMultiplyerPlugin #Главный класс Android кода
       dartPluginClass: MatrixMultiplyerAndroid #Главный класс Dart кода
```

#### Шаг 3

Расширить (``extends``) в плагинах абстрактный класс MatrixMultiplyerPlatform

В нем будет лежать логика по взаимодействию с нативом Android

Для iOS аналогично

#### Шаг 4

Настроить app-facing package.

В пакете matrix_multiplyer в pubspec.yaml нужно добавить:

```
dependencies:
 flutter:
   sdk: flutter
 matrix_multiplyer_android:
   path: ../matrix_multiplyer_android
 matrix_multiplyer_ios:
   path: ../matrix_multiplyer_ios
 matrix_multiplyer_platform_interface:
   path: ../matrix_multiplyer_platform_interface

flutter:
 plugin:
   platforms:
     android:
       default_package: matrix_multiplyer_android
     ios:
       default_package: matrix_multiplyer_ios
```

И создаем синглтон класс который проксирует вызовы в MatrixMultiplyerPlatform