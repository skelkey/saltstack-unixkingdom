Install kubeadm service:
  pkg.installed:
    - name: kubernetes-kubeadm

Install containerd service:
  pkg.installed:
    - name: containerd

Start and enable containerd service:
  service.running:
    - name: docker
    - enable: true

Start and enable kubelet service:
  service.running:
    - name: kubelet
    - enable: true
