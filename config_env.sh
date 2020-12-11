#!/bin/bash
##########################################
##                                      ##
##    基于centos7.X的基础环境初始化     ##
##                                      ##
##########################################



# centos7环境初始化
systemctl stop NetworkManager
systemctl disable NetworkManager

systemctl stop firewalld
systemctl disable firewalld

setenforce  0
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux
sed -i "s/^SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/sysconfig/selinux
sed -i "s/^SELINUX=permissive/SELINUX=disabled/g" /etc/selinux/config

echo "net.ipv4.ip_forward = 1" >> /usr/lib/sysctl.d/50-default.conf
sysctl -p
systemctl restart network
echo "UseDNS no" >> /etc/ssh/sshd_config
systemctl  restart sshd


# centos7安装docker
yum remove -y docker docker-ce docker-common docker-selinux docker-engine
yum -y install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#yum install -y docker-ce-18.06.1.ce-3.el7
yum install -y docker-ce
systemctl daemon-reload && systemctl restart docker && systemctl enable docker && systemctl status docker

tee /etc/docker/daemon.json << EOF
{
  "exec-opts": [
      "native.cgroupdriver=systemd"
  ],
  "registry-mirrors": [
      "https://fz5yth0r.mirror.aliyuncs.com",      
      "https://dockerhub.mirrors.nwafu.edu.cn",      
      "https://docker.mirrors.ustc.edu.cn/",      
      "https://reg-mirror.qiniu.com",      
      "http://hub-mirror.c.163.com/",      
      "https://registry.docker-cn.com"      
  ],
  "data-root":"/var/lib/docker",
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  }
}
EOF

systemctl daemon-reload && systemctl restart docker


# centos7安装docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
/usr/local/bin/docker-compose -version
chmod +x /usr/local/bin/docker-compose 
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
