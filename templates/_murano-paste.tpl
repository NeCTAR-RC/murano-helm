{{- define "murano-paste" }}
[pipeline:murano]
pipeline = healthcheck request_id versionnegotiation faultwrap authtoken context rootapp

[filter:context]
paste.filter_factory = murano.api.middleware.context:ContextMiddleware.factory

#For more information see Auth-Token Middleware with Username and Password
#https://docs.openstack.org/keystone/latest/configuration.html#service-catalog
[filter:authtoken]
paste.filter_factory = keystonemiddleware.auth_token:filter_factory

[composite:rootapp]
use = egg:Paste#urlmap
/: apiversions
/v1: apiv1app

[app:apiversions]
paste.app_factory = murano.api.versions:create_resource

[app:apiv1app]
paste.app_factory = murano.api.v1.router:API.factory

[filter:versionnegotiation]
paste.filter_factory = murano.api.middleware.version_negotiation:VersionNegotiationFilter.factory

[filter:faultwrap]
paste.filter_factory = murano.api.middleware.fault:FaultWrapper.factory

# Middleware to set x-openstack-request-id in http response header
[filter:request_id]
paste.filter_factory = oslo_middleware.request_id:RequestId.factory

[filter:cors]
paste.filter_factory = oslo_middleware.cors:filter_factory
oslo_config_project = murano

[filter:http_proxy_to_wsgi]
paste.filter_factory = oslo_middleware.http_proxy_to_wsgi:HTTPProxyToWSGI.factory
oslo_config_project = murano

[filter:healthcheck]
paste.filter_factory=oslo_middleware:Healthcheck.factory
path=/healthcheck
backends=disable_by_file
disable_by_file_path=/etc/murano/healthcheck_disable
{{- end }}
