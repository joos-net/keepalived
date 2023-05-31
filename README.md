# Домашнее задание к занятию 
# "`Disaster Recovery. FHRP и Keepalived`"
# `Островский Евгений`

### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

### Задание 1

- Дана схема для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.


![Router1](https://github.com/joos-net/keepalived/blob/main/files/Router1.png)

![Router2](https://github.com/joos-net/keepalived/blob/main/files/Router2.png)

![ping1](https://github.com/joos-net/keepalived/blob/main/files/ping1.png)

![ping2](https://github.com/joos-net/keepalived/blob/main/files/ping2.png)

![ping3](https://github.com/joos-net/keepalived/blob/main/files/ping3.png)

---

### Задание 2

- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного файла.
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

### bash.sh
```bash
my_index=`test -f /var/www/html/index.html && echo $?`
my_port=`bash -c "</dev/tcp/localhost/80" && echo $?`

if [ $my_index -eq 0 ] && [ $my_port -eq 0 ]; then
        exit 0
else
        exit 1
fi
```
### keepalived.conf
```
global_defs {
    enable_script_security
}

vrrp_script b_check {
    script "/usr/local/bin/bash.sh"
    interval 3
    rise 3
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s5
    virtual_router_id 15
    priority 205
    advert_int 1
    virtual_ipaddress {
        10.103.7.15/24
    }
    track_script {
        b_check
    }
}
```

![task21](https://github.com/joos-net/keepalived/blob/main/files/task21.png)

![task22](https://github.com/joos-net/keepalived/blob/main/files/task22.png)

![task23](https://github.com/joos-net/keepalived/blob/main/files/task23.png)

![task24](https://github.com/joos-net/keepalived/blob/main/files/task24.png)


---
## Дополнительные задания (со звездочкой*)

Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

### Задание 3

- Изучите дополнительно возможность Keepalived, которая называется vrrp_track_file
- Напишите bash-скрипт, который будет менять приоритет внутри файла в зависимости от нагрузки на виртуальную машину (можно разместить данный скрипт в cron и запускать каждую минуту). Рассчитывать приоритет можно, например, на основании Load average.
- Настройте Keepalived на отслеживание данного файла.
- Нагрузите одну из виртуальных машин, которая находится в состоянии MASTER и имеет активный виртуальный IP и проверьте, чтобы через некоторое время она перешла в состояние SLAVE из-за высокой нагрузки и виртуальный IP переехал на другой, менее нагруженный сервер.
- Попробуйте выполнить настройку keepalived на третьем сервере и скорректировать при необходимости формулу так, чтобы плавающий ip адрес всегда был прикреплен к серверу, имеющему наименьшую нагрузку.
- На проверку отправьте получившийся bash-скрипт и конфигурационный файл keepalived, а также скриншоты логов keepalived с серверов при разных нагрузках

### la.sh
```bash
my_la=`cat /proc/loadavg |awk {'print $1'}`
la=$(echo $my_la*100 | bc)

new_weight=$(echo ${la%.*}/-2 | bc)
echo $new_weight > /usr/local/bin/check
```
### keepalived.conf
```
vrrp_track_file track_file {
      file /usr/local/bin/check
}

vrrp_instance VI_1 {
    state MASTER
    interface enp0s5
    virtual_router_id 15
    priority 205
    advert_int 1
    virtual_ipaddress {
        10.103.7.15/24
    }

      track_file {
         track_file
   }
}
```

![task31](https://github.com/joos-net/keepalived/blob/main/files/task31.png)

![task32](https://github.com/joos-net/keepalived/blob/main/files/task32.png)

![task33](https://github.com/joos-net/keepalived/blob/main/files/task33.png)
