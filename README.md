# Shell-скрипты для создания фотоальбома в группе

## [web-photos-new-album.sh](web-photos-new-album.sh)

Скрипт для создания нового фотоальбома в группе через API использующийся на веб-страницах ВКонтакте.

*Зависимости:* curl, pcregrep

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

## [api-photos-create-album.sh](api-photos-create-album.sh)

Скрипт для создания нового фотоальбома в группе через официально предоставляемый API ВКонтакте.

*Зависимости:* curl, jq, sponge

*Входные данные:*

| Длинная опция | Короткая опция | Описание                                                       |
| ------------- | -------------- | -------------------------------------------------------------- |
| --group_id    | -g             | Идентификатор группы в которой нужно создать новый фотоальбом. |
| --title       | -t             | Заголовок для нового фотоальбома.                              |
| --description | -d             | Описание для нового фотоальбома.                               |
| --access      | -a             | Ключ доступа - токен.                                          |
| --output      | -o             | Имя результирующего файла или путь к нему.                     |
| --interval    | -i             | Тайм-аут между обращениями к API ВКонтакте.                    |

*Выходные данные:*

Выходные данные добавляются в указанный JSON-файл. Это обязательно должен быть файл в формате JSON.

```bash
$ ./api-photos-create-album.sh --title="Название" --description="Описание" --group_id=123456789 --output="VKontakte-albums.json" --interval=5 --access=51eff86578a3bbbcb5c7043a122a69fd04dca057ac821dd7afd7c2d8e35b60172d45a26599c08034cc40a
$ cat VKontakte-albums.json
{
  "Название": {
    "response": {                                                                                                                 
      "aid": 247721602,                                                                                                           
      "thumb_id": 0,                                                                                                              
      "owner_id": -123456789,
      "title": "Название",
      "description": "Описание",
      "created": 1503416055,
      "updated": 1503416055,
      "privacy": null,
      "comment_privacy": null,
      "size": 0,
      "can_upload": 1
    }
  }
}
```

В результате **aid** - это идентификатор нового альбома, а **owner_id** будет таким же как и аргумент переданный через опцию **--group_id** (или **-g**, если в коротком в варианте).
Новый альбом будет доступен по адресу https://vk.com/album-123456789_247721602.

# Вопросы и ответы

## Как получить токен ВКонтакте?

Откройте новую вкладку в браузере и введите в адресную строку следующий URL:

```
https://oauth.vk.com/authorize?client_id=5791134&display=page&redirect_uri=https://oauth.vk.com/blank.html&scope=photos&response_type=token&v=5.52
```

Число *5791134* в запросе - это **API_ID** приложения [vk-sh](https://vk.com/app5791134).

Нажмите Enter. Откроется окно с запросом прав. В нем отображаются название приложения, иконки прав доступа, и ваши имя с фамилией.

Нажмите «Разрешить». Вы попадёте на новую страницу с предупреждением о том, что токен нельзя копировать и передавать третьим лицам. В адресной строке будет URL https://oauth.vk.com/blank.html, а после # вы увидите дополнительные параметры — **access_token**, **expires_in** и **user_id**. Токен может выглядеть, например, так:

```
51eff86578a3bbbcb5c7043a122a69fd04dca057ac821dd7afd7c2d8e35b60172d45a26599c08034cc40a
```

Токен — это ваш ключ доступа. При выполнении определенных условий человек, получивший ваш токен, может нанести существенный ущерб вашим данным и данным других людей. Поэтому очень важно не передавать свой токен третьим лицам.

Поле **expires_in** содержит время жизни токена в секундах. 86400 секунд — это ровно сутки. Через сутки полученный токен перестанет действовать, для продолжения работы нужно будет получить новый. Есть возможность получить токен без срока действия — для этого в **scope** добавьте значение *offline*. Вы можете принудительно отозвать токен (например, в том случае, если он стал известен постороннему), сбросив сеансы в настройках безопасности вашего аккаунта или сменив пароль. Также, если речь идет о токене не из вашего собственного приложения, можно просто [удалить приложение из настроек](https://vk.com/settings?act=apps).

Поле **user_id** содержит id пользователя, для которого получен токен.

# Ссылки

ВКонтакте:

- [vk.com/dev/photos.createAlbum](https://vk.com/dev/photos.createAlbum)
- [vk.com/support?act=new_api](https://vk.com/support?act=new_api)

Bash:

- [stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash](http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)
- [stackoverflow.com/questions/9084257/bash-array-with-spaces-in-elements](http://stackoverflow.com/questions/9084257/bash-array-with-spaces-in-elements)
- [askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file](http://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file)
- [serverfault.com/questions/135507/linux-how-to-use-a-file-as-input-and-output-at-the-same-time](http://serverfault.com/questions/135507/linux-how-to-use-a-file-as-input-and-output-at-the-same-time)

cURL:

- [superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request](https://superuser.com/questions/149329/what-is-the-curl-command-line-syntax-to-do-a-post-request)
- [stackoverflow.com/questions/866946/how-can-i-see-the-request-headers-made-by-curl-when-sending-a-request-to-the-ser](http://stackoverflow.com/questions/866946/how-can-i-see-the-request-headers-made-by-curl-when-sending-a-request-to-the-ser)
- [stackoverflow.com/questions/18983719/is-there-any-way-to-get-curl-to-decompress-a-response-without-sending-the-accept](http://stackoverflow.com/questions/18983719/is-there-any-way-to-get-curl-to-decompress-a-response-without-sending-the-accept)
- [stackoverflow.com/questions/7373752/how-do-i-get-curl-to-not-show-the-progress-bar](http://stackoverflow.com/questions/7373752/how-do-i-get-curl-to-not-show-the-progress-bar)

Регулярные выражения:

- [stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex](http://stackoverflow.com/questions/1891797/capturing-groups-from-a-grep-regex)
- [stackoverflow.com/questions/7254509/how-to-escape-single-quotes-in-bash-grep](http://stackoverflow.com/questions/7254509/how-to-escape-single-quotes-in-bash-grep)
