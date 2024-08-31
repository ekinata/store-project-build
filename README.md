# Toolbox Script Kullanım Kılavuzu

Bu kılavuz, `toolbox.sh` scriptini nasıl kullanacağınızı açıklamaktadır. Bu script, Laravel ve Next.js projelerinizi yönetmek için çeşitli işlevler sunar.

## Kullanım

Script, aşağıdaki komutlar ile çalıştırılabilir:

```bash
./toolbox.sh [komut]
```

## Komutlar ve Açıklamaları

### `run`
Projeleri çalıştırır. Laravel ve Next.js projelerini arka planda başlatır. Çıkış yapmak için `CTRL+C` tuş kombinasyonunu kullanabilirsiniz.

```bash
./toolbox.sh run
```

### `dev`
Projeleri geliştirme modunda çalıştırır. Laravel ve Next.js projelerini arka planda geliştirme modunda başlatır. Çıkış yapmak için `CTRL+C` tuş kombinasyonunu kullanabilirsiniz.

```bash
./toolbox.sh dev
```

### `retrieve`
Depoları klonlar, bağımlılıkları yükler ve ortamı hazırlar. Laravel ve Next.js projeleri için gerekli dosyaları indirir.

```bash
./toolbox.sh retrieve
```

### `build`
Projeleri klonlar, bağımlılıkları yükler, ortamı hazırlar ve projeyi dağıtır. Bu komut, `retrieve` ve `deploy` adımlarını birleştirir.

```bash
./toolbox.sh build
```

### `update`
Depolardan en son değişiklikleri çeker ve güncellemeleri uygular. Laravel ve Next.js projeleri için en son değişiklikleri alır ve gerekli güncellemeleri yapar.

```bash
./toolbox.sh update
```

### `docker-build`
Docker yapı sürecini gerçekleştirir. Docker build komutlarınızı bu bölüme ekleyebilirsiniz. Mevcut projeleri Docker ile inşa eder.

```bash
./toolbox.sh docker-build
```

### `fresh`
Yapı mirasını temizler ve projeyi sıfırdan inşa eder. `clean`, `retrieve` ve `deploy` adımlarını birleştirir.

```bash
./toolbox.sh fresh
```

### `clean`
Yapı mirasını temizler. Laravel ve Next.js projeleri için oluşturulmuş dosya ve klasörleri siler.

```bash
./toolbox.sh clean
```

### `push`
Kodları depoya gönderir. Laravel, Next.js ve proje yapı dosyalarındaki değişiklikleri depoya gönderir.

```bash
./toolbox.sh push "commit mesajı"
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

Kodları depoya göndermek için:

```bash
./toolbox.sh push "Yaptığınız değişikliklere dair açıklama"
```