# How to configure automatic backup and restore
### Please read this: https://github.com/wal-g/wal-g/blob/master/docs/MySQL.md

## You need to configure the environment:
- AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, WALG_PROFILE (prod, dev, or restore), WALG_S3_PREFIX
- WALG_MYSQL_DATASOURCE_NAME, WALG_STREAM_CREATE_COMMAND, WALG_STREAM_RESTORE_COMMAND,  and WALG_MYSQL_BINLOG_REPLAY_COMMAND

    - WALG_PROFILE=restore # Automatic mariadb restore
    - WALG_PROFILE=dev # pass - for devel
    - WALG_PROFILE=prod # Automatic mariadb backup

## You also need to configure cron to run a basebackups
# Cron - sample usage
    # mariadb
    50 */6 * * *   root    /usr/bin/docker exec mariadb /usr/local/bin/backup basebackup && curl -fsS --retry 3 https://healthchecks.sample.com/ping/xxx-xxx > /dev/null
    # MAriadb basebackups cleaner
    0 16 * * 1,3   root    /usr/bin/docker exec mariadb wal-e delete --confirm retain 12 && curl -fsS --retry 3 https://healthchecks.sample.com/ping/yyy-yyy > /dev/null


# How to clean your backups
    wal-g backup-list
    wal-g delete --confirm retain 3
