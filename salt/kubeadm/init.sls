Install kubeadm service:
  pkg.installed:
    - name: kubernetes-kubeadm

Install containerd service:
  pkg.installed:
    - name: containerd

Deploy certificate ca for kubernetes:
  file.managed:
    - name: /etc/kubernetes/pki/ca.crt
    - user: root
    - group: root
    - mode: 640
    - makedirs: true
    - contents_pillar:
      - kubernetes_unixkingdom_ca

Deploy private key ca for kubernetes:
  file.managed:
    - name: /etc/kubernetes/pki/ca.key
    - user: root
    - group: root
    - mode: 400
    - makedirs: true
    - contents_pillar:
      - kubernetes_unixkingdom_key

Start and enable containerd service:
  service.running:
    - name: docker
    - enable: true

Start and enable kubelet service:
  service.running:
    - name: kubelet
    - enable: true
