Install kubeadm service:
  pkg.installed:
    - name: kubernetes-kubeadm

Install containerd service:
  pkg.installed:
    - name: containerd

Deploy certificate for kubernetes:
  file.managed:
    - name: /etc/kubernetes/pki/euw2a-prd-unixkingdom-kubeadm-1.crt
    - user: root
    - group: root
    - mode: 640
    - contents_pillar:
      - kubeadm_crt
      - server_unixkingdom_ca
      - unixkingdom_ca

Deploy private key for kubernetes:
  file.managed:
    - name: /etc/kubernetes/pki/euw2a-prd-unixkingdom-kubeadm-1.key
    - user: root
    - group: root
    - mode: 400
    - contents_pillar:
      - kubeadm_key

Start and enable containerd service:
  service.running:
    - name: docker
    - enable: true

Start and enable kubelet service:
  service.running:
    - name: kubelet
    - enable: true
