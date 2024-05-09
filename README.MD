# Medium Article
Full setup guide [here](https://medium.com/@zep283/kubernetes-hardware-accelerated-home-streamer-a2b12104e24e?source=rss-8f1469682ad5------2)

## Media Server Stack Helm Install
` helm upgrade --install mss . --values values.yaml --namespace media-server`

## GPU Transcoding Enable
1. helm repo add nfd https://kubernetes-sigs.github.io/node-feature-discovery/charts
2. helm install nfd/node-feature-discovery --namespace nfd --create-namespace --generate-name
3. kubectl apply -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/nfd/overlays/node-feature-rules' 
4. kubectl apply -k 'https://github.com/intel/intel-device-plugins-for-kubernetes/deployments/gpu_plugin/overlays/nfd_labeled_nodes'
    - verify:  kubectl get nodes -o=jsonpath="{range .items[*]}{.metadata.name}{'\n'}{' i915: '}{.status.allocatable.gpu\.intel\.com/i915}{'\n'}"
    - /usr/lib/jellyfin-ffmpeg/vainfo 
    - may need to change group id to match /dev/dri if it keeps reseting

## Certificate - Cert Manager
1. helm repo add jetstack https://charts.jetstack.io
2. helm upgrade --install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --values helm/cert-manager/values.yaml --set installCRDs=true

## Tips
- Get public IP  
`curl https://ipinfo.io/ip`
    this is the DNS A record value
- Get Ip range for LOCAL_NETWORK in transmission (result is under default gateway)  
`ipconfig`
- Recover cmdline.txt  
`cat /proc/cmdline`
- Get ~/.kube/config file from k3s master node  
`sudo cat /etc/rancher/k3s/k3s.yaml`
- Access WSL filesystem with this path  
`\\wsl$`
