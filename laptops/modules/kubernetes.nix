{...}:

let 
		k8sRole = "disabled";

    kubeMasterIP = "191.4.204.204";
    kubeMasterHostname = "api.kube";
    kubeMasterAPIServerPort = 6443;
    api = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";

    kubernetesModule = if k8sRole == "master" then {

        services.kubernetes = {
            roles = ["master" "node"];
            masterAddress = kubeMasterIP; #documentation says that Hostname should be used
            /* easyCerts = true; 
            apiserver = {
                securePort = kubeMasterAPIServerPort;
                advertiseAddress = kubeMasterIP;
            addons.dns.enable = true;
            }; */
        };
    } else if k8sRole == "worker" then {
        services.kubernetes = {
            roles = ["node"]; 
            masterAddress = kubeMasterIP;
            /* easyCerts = true;
            kubelet.kubeconfig.server = api;
            addons.dns.enable = true;
            kubelet.extraOpts = "--fail-swap-on=false"; */
            # cat /var/lib/kubernetes/secrets/apitoken.secret
            #echo TOKEN | nixos-kubernetes-node-join
        };


    } else {



    };

in {
    services.kubernetes = kubernetesModule;

}



