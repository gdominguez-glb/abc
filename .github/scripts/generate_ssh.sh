mkdir -p  /github/home/.ssh/
openssl enc -d -aes-256-cbc -md sha512 -salt -in ./.github/actions/ruby-action/ssh_key -out /github/home/.ssh/id_rsa -k "$SSH_KEY" -a -pbkdf2
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
chmod 600 /github/home/.ssh/id_rsa
