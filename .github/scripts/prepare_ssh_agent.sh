ssh-agent -a /tmp/ssh-auth.sock
export SSH_AUTH_SOCK="/tmp/ssh-auth.sock"
ssh-add /github/home/.ssh/id_rsa
mkdir -p /root/.ssh/
echo "Host *" > /root/.ssh/config
echo "  StrictHostKeyChecking no" >> /root/.ssh/config
echo "Host *" >> /etc/ssh/ssh_config
echo "StrictHostKeyChecking no\n\n" >> /etc/ssh/ssh_config
