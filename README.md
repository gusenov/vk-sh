# Shell-скрипты для автоматизации действий ВКонтакте

## [web-photos-new-album.sh](https://github.com/gusenov/vk-sh/blob/master/web-photos-new-album.sh)

Скрипт для создания нового фотоальбома через API использующийся на веб-страницах ВКонтакте.

*Входные данные:*

| Длинная опция | Короткая опция | Описание                                                       |
| ------------- | -------------- | -------------------------------------------------------------- |
| --group_id    | -g             | Идентификатор группы в которой нужно создать новый фотоальбом. |
| --title       | -t             | Заголовок для нового фотоальбома.                              |
| --remixsid    | -r             | Значение cookie-параметра **remixsid**. Нужно для доступа.     |

*Выходные данные:*

Если всё в порядке, то скрипт выводит с помощью команды **echo** идентификатор созданного фотоальбома:

```bash
$ ./web-photos-new-album.sh --group_id=123456789 --title="Название" --remixsid=56d6e73gd04118606eed8f9f7899g487fd17dfd82bf80c43e565b
247709439
$ ./web-photos-new-album.sh -g=123456789 -t="Название" -r=56d6e73gd04118606eed8f9f7899g490fd17dfd82bf80c43e565b
247709498
```

В случае ошибок скрипт осуществляет пустой вывод:

```bash
$ ./web-photos-new-album.sh -g=987654321 -t="Название" -r=56d6e73gd04118606eed8f9f7800g490fd17dfd82bf80c43e565b


```

# Ссылки

Bash:

- [stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash](http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)

cURL:

- [superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request](https://superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request)
- [stackoverflow.com/questions/866946/how-can-i-see-the-request-headers-made-by-curl-when-sending-a-request-to-the-ser](http://stackoverflow.com/questions/866946/how-can-i-see-the-request-headers-made-by-curl-when-sending-a-request-to-the-ser)
- [stackoverflow.com/questions/18983719/is-there-any-way-to-get-curl-to-decompress-a-response-without-sending-the-accept](http://stackoverflow.com/questions/18983719/is-there-any-way-to-get-curl-to-decompress-a-response-without-sending-the-accept)

Регулярные выражения:

- [stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex](http://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex)
- [stackoverflow.com/questions/7254509/how-to-escape-single-quotes-in-bash-grep](http://stackoverflow.com/questions/7254509/how-to-escape-single-quotes-in-bash-grep)
