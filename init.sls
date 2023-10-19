curl:
  pkg.installed

gpg:
  pkg.installed

curl_gpg:
  cmd.run:
    - name: curl -fsSL https://packages.redis.io/gpg | tac | tac | gpg --dearmor --batch --yes -o /usr/share/keyrings/redis-archive-keyring.gpg

echo_tee:
  cmd.run:
    - name: echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

redis:
  pkg.installed:
    - name: redis-server

/etc/redis/redis.conf:
  file.managed:
    - source: salt://{{ slspath }}/redis.conf
    - user: redis
    - group: redis
    - mode: 640

/var/lib/redis:
  file.directory:
    - user: redis
    - group: redis
    - mode: 750

redis-server:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: redis
