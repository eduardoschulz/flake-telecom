{...}:
{
	services.grafana = {
		enable = true;
		settings.server = {
			domain = "demo3.local";
			http_port = 3000;
			http_addr = "191.4.204.204";
		};
	};
/*

This file is reserved for manually adding grafana sources and dashboards.

*/



}
