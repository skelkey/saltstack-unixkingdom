Install kubeadm service:
  pkg.installed:
    - name: kubernetes-kubeadm

Install docker service:
  pkg.installed:
    - name: docker

Start and enable docker service:
  service.running:
    - name: docker
    - enable: true

Start and enable kubelet service:
  service.running:
    - name: kubelet
    - enable: true
