{{- define "murano-conf" }}
[DEFAULT]
bind_host=0.0.0.0
admin_role=Admin

[database]
connection_recycle_time=600

[oslo_messaging_rabbit]
amqp_durable_queues=True
heartbeat_in_pthread=True
heartbeat_timeout_threshold=60
ssl=True

[oslo_messaging_notifications]
driver=messagingv2

[oslo_policy]
policy_file=/etc/murano/policy.yaml

[keystone_authtoken]
auth_url={{ .Values.conf.keystone.auth_url }}
www_authenticate_uri={{ .Values.conf.keystone.auth_url }}
username={{ .Values.conf.keystone.username }}
project_name={{ .Values.conf.keystone.project_name }}
user_domain_name=Default
project_domain_name=Default
auth_type=password
{{- if .Values.conf.keystone.memcached_servers }}
memcached_servers={{ join "," .Values.conf.keystone.memcached_servers }}
{{- end }}
service_type=application-catalog

[murano]
url={{ .Values.conf.murano.url }}
api_workers=1

[networking]
external_network=public
create_router=True
driver=neutron

[rabbitmq]
host={{ .Values.conf.rabbitmq.host }}
port={{ .Values.conf.rabbitmq.port }}
login={{ .Values.conf.rabbitmq.login }}
virtual_host={{ .Values.conf.rabbitmq.virtual_host }}
ssl=True
ca_certs=/etc/ssl/certs/ca-certificates.crt

[engine]
engine_workers=1
use_trusts=False

[murano_auth]
auth_url = {{ .Values.conf.keystone.auth_url }}
www_authenticate_uri = {{ .Values.conf.keystone.auth_url }}
username = {{ .Values.conf.keystone.username }}
project_name = {{ .Values.conf.keystone.project_name }}
project_domain_name = Default
user_domain_name = Default
auth_type = password

{{- end }}
