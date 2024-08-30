# Toolbox Script Kullanım Kılavuzu

Bu kılavuz, `toolbox.sh` scriptini nasıl kullanacağınızı açıklamaktadır. Bu script, Laravel ve Next.js projelerinizi yönetmek için çeşitli işlevler sunar.

## Kullanım

Script, aşağıdaki komutlar ile çalıştırılabilir:

```bash
./toolbox.sh [komut]
```

## Komutlar ve Açıklamaları

### `run`
Projeleri çalıştırır. Laravel ve Next.js projelerini arka planda başlatır.

```bash
./toolbox.sh run
```

### `dev`
Projeleri geliştirme modunda çalıştırır. Laravel ve Next.js projelerini arka planda geliştirme modunda başlatır.

```bash
./toolbox.sh dev
```

### `retrieve`
Depoları klonlar, bağımlılıkları yükler ve ortamı hazırlar.

```bash
./toolbox.sh retrieve
```

### `build`
Projeleri klonlar, bağımlılıkları yükler, ortamı hazırlar ve projeyi dağıtır.

```bash
./toolbox.sh build
```

### `update`
Depolardan en son değişiklikleri çeker ve güncellemeleri uygular.

```bash
./toolbox.sh update
```

### `docker-build`
Docker yapı sürecini gerçekleştirir. Docker build komutlarınızı bu bölüme ekleyebilirsiniz.

```bash
./toolbox.sh docker-build
```

### `fresh`
Yapı artifaktlarını temizler ve projeyi sıfırdan inşa eder.

```bash
./toolbox.sh fresh
```

### `clean`
Yapı artifaktlarını temizler.

```bash
./toolbox.sh clean
```

### `help`
Yardım bilgilerini görüntüler. Bu, komutların her birine dair kısa bir açıklama sağlar.

```bash
./toolbox.sh help
```

## Örnek Kullanımlar

Projeyi sıfırdan inşa etmek ve çalıştırmak için:

```bash
./toolbox.sh fresh
./toolbox.sh run
```

Geliştirme modunda projeyi çalıştırmak için:

```bash
./toolbox.sh dev
```

En son değişiklikleri çekmek ve projeyi güncellemek için:

```bash
./toolbox.sh update
```
```