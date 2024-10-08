{{- define "murano-cfapi-paste" }}
[pipeline:cloudfoundry]
pipeline = cors http_proxy_to_wsgi request_id ext_context authtoken context cloudfoundryapi

[filter:context]
paste.filter_factory = murano.api.middleware.context:ContextMiddleware.factory

#For more information see Auth-Token Middleware with Username and Password
#https://docs.openstack.org/keystone/latest/configuration.html#service-catalog
[filter:authtoken]
paste.filter_factory = keystonemiddleware.auth_token:filter_factory

[app:cloudfoundryapi]
paste.app_factory = murano.cfapi.router:API.factory

[filter:faultwrap]
paste.filter_factory = murano.api.middleware.fault:FaultWrapper.factory

# Middleware to set x-openstack-request-id in http response header
[filter:request_id]
paste.filter_factory = oslo_middleware.request_id:RequestId.factory

[filter:ext_context]
paste.filter_factory = murano.api.middleware.ext_context:ExternalContextMiddleware.factory

[filter:cors]
paste.filter_factory = oslo_middleware.cors:filter_factory
oslo_config_project = murano

[filter:http_proxy_to_wsgi]
paste.filter_factory = oslo_middleware.http_proxy_to_wsgi:HTTPProxyToWSGI.factory
oslo_config_project = murano
{{- end }}
