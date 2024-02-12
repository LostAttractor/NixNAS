_:
{
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 0 * * * lostattractor rsync -rt --delete -v root@47.243.164.28:/var/lib/docker/volumes/ /mnt/Files/Backup/server_backup"
    ];
  };
}