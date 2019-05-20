# We are creating a new user because the default docker user it creates when remapping
# ends up breaking a ton of service accounts

sudo groupadd -g 5000 container-user
sudo useradd -g 5000 -u 5000 -M -N -s /bin/false container-user
/etc/subuid
container-user:5000:65536
/etc/subgid
container-user:5000:65536

sudo nano /etc/docker/daemon.json
{
  "userns-remap": "container-user:container-user"
}
