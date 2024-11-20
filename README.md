# sunday_get_storage
Un stockage clé-valeur rapide, ultra léger et synchrone en mémoire, qui sauvegarde les données sur le disque à chaque opération.
Il est entièrement écrit en Dart et s'intègre facilement avec le framework Get de Flutter.

Prend en charge Android, iOS, Web, Mac, Linux, Fuchsia et Windows**.
Peut stocker des String, int, double, Map et List

### Ajoutez-le à votre pubspec :
```
dependencies:
  sunday_get_storage:
```
### Installez-le

Vous pouvez installer les packages depuis la ligne de commande :

avec `Flutter` :

```css
$  flutter packages get
```

### Importez-le

Maintenant, dans votre code `Dart`, vous pouvez utiliser :

````dart
import 'package:sunday_get_storage/sunday_get_storage.dart';
````

### Initialisez le pilote de stockage avec await :
```dart
main() async {
  await GetStorage.init();
  runApp(App());
}
```
#### Utilisez GetStorage via une instance ou utilisez directement `GetStorage().read('key')`
```dart
final box = GetStorage();
```
#### Pour écrire des informations, vous devez utiliser `write` :
```dart
box.write('quote', 'GetX est le meilleur');
```

#### Pour lire des valeurs, utilisez `read` :
```dart
print(box.read('quote'));
// sortie : GetX est le meilleur
```
#### Pour supprimer une clé, vous pouvez utiliser `remove` :

```dart
box.remove('quote');
```

#### Pour écouter les changements, vous pouvez utiliser `listen` :
```dart
Function? disposeListen;
disposeListen = box.listen((){
  print('la boîte a changé');
});
```
#### Si vous vous abonnez à des événements, assurez-vous de les disposer lors de l'utilisation :
```dart
disposeListen?.call();
```
#### Pour écouter les changements sur une clé, vous pouvez utiliser `listenKey` :

```dart
box.listenKey('key', (value){
  print('nouvelle valeur de la clé : $value');
});
```

#### Pour effacer votre conteneur :
```dart
box.erase();
```

#### Si vous souhaitez créer différents conteneurs, donnez simplement un nom. Vous pouvez écouter des conteneurs spécifiques, et aussi les supprimer.

```dart
GetStorage g = GetStorage('MyStorage');
```

#### Pour initialiser un conteneur spécifique :
```dart
await GetStorage.init('MyStorage');
```

## Implémentation de SharedPreferences
```dart
class MyPref {
  static final _otherBox = () => GetStorage('MyPref');

  final username = ''.val('username');
  final age = 0.val('age');
  final price = 1000.val('price', getBox: _otherBox);

  // ou
  final username2 = ReadWriteValue('username', '');
  final age2 = ReadWriteValue('age', 0);
  final price2 = ReadWriteValue('price', '', _otherBox);
}

...

void updateAge() {
  final age = 0.val('age');
  // ou 
  final age = ReadWriteValue('age', 0, () => box);
  // ou 
  final age = Get.find<MyPref>().age;

  age.val = 1; // sera sauvegardé dans la boîte
  final realAge = age.val; // sera lu depuis la boîte
}
```

## Résultat du Benchmark :
**GetStorage n'est pas rapide, il est incroyablement rapide pour être basé sur la mémoire. Toutes ses opérations sont instantanées. Une sauvegarde de chaque opération est placée dans un conteneur sur le disque. Chaque conteneur a son propre fichier.**

![](delete.png)
![](write.png)
![](read.png)

## Ce qu'est GetStorage :
Un stockage clé/valeur persistant pour Android, iOS, Web, Linux, Mac, Fuchsia et Windows, qui combine un accès rapide en mémoire avec un stockage persistant.
## Ce que GetStorage N'EST PAS :
Une base de données. Get est super compact pour vous offrir une solution de stockage en lecture/écriture ultra-légère et à haute vitesse pour fonctionner de manière synchrone. Si vous souhaitez stocker des données de manière persistante sur le disque avec un accès immédiat à la mémoire, utilisez-le. Si vous voulez une base de données, avec indexation et outils de stockage spécifiques sur le disque, il existe des solutions incroyables déjà disponibles, comme Hive et Sqflite/Moor.

Dès que vous déclarez "write", le fichier est immédiatement écrit en mémoire et peut maintenant être accédé immédiatement avec `box.read()`. Vous pouvez également attendre le callback indiquant qu'il a été écrit sur le disque en utilisant `await box.write()`.

## Quand utiliser GetStorage :
  - Stockage simple de Maps.
  - Cache des requêtes HTTP
  - Stockage d'informations utilisateur simples.
  - Stockage d'état simple et persistant
  - Toute situation où vous utilisez actuellement sharedPreferences.

## Quand ne pas utiliser GetStorage :
  - vous avez besoin d'index.
  -  lorsque vous devez toujours vérifier si le fichier a été écrit sur le disque de stockage avant de commencer une autre opération (le stockage en mémoire est fait instantanément et peut être lu instantanément avec box.read(), et la sauvegarde sur le disque est faite en arrière-plan. Pour s'assurer que la sauvegarde est complète, vous pouvez utiliser await, mais si vous devez appeler await tout le temps, il n'a pas de sens d'utiliser un stockage en mémoire).

### Vous pouvez utiliser cette librairie même comme un gestionnaire d'état persistant modeste en utilisant Getx SimpleBuilder