FROM ubuntu:18.04

EXPOSE 25578

RUN mkdir -p /iisserver
RUN mkdir -p /iisserver/logs
RUN mkdir -p /iisserver/crash-reports
RUN mkdir -p /iisserver/IISPerfect
RUN mkdir -p /iisserver/backups

VOLUME /iisserver/logs
VOLUME /iisserver/crash-reports
VOLUME /iisserver/backups
VOLUME /iisserver/IISPerfect

WORKDIR /iisserver

COPY ./ ./

RUN mv ./mods/CustomMainMenu-MC1.7.10-1.9.2.jar ./mods/CustomMainMenu-MC1.7.10-1.9.2.jar.disable || :
RUN mv ./mods/ResourceLoader-MC1.7.10-1.3.jar ./mods/ResourceLoader-MC1.7.10-1.3.jar.disable || :

RUN mv ./mods/Aroma1997Core-1.7.10-1.0.2.16.jar.disabled ./mods/Aroma1997Core-1.7.10-1.0.2.16.jar || :
RUN mv ./mods/AromaBackup-1.7.10-0.1.0.0.jar.disabled ./mods/AromaBackup-1.7.10-0.1.0.0.jar || :

RUN  sed -i -E "s/(^.+keep\=)(.+)($)/\148\3/g" ./config/aroma1997/AromaBackup.cfg || :
RUN  sed -i -E "s/(^.+skipbackup\=)(.+)($)/\1true\3/g" ./config/aroma1997/AromaBackup.cfg || :

RUN apt-get update
RUN apt-get install -y openjdk-8-jdk

ENTRYPOINT java -Xmx8G -Xmn1G -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -jar ./forge-1.7.10-10.13.4.1614-1.7.10-universal.jar nogui
