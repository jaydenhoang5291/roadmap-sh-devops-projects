# SSH Remote Server Setup

Project URL: https://roadmap.sh/projects/ssh-remote-server-setup

## Boi canh cua project

Trong repo nay, minh da lam project [11-ec2-instance](../11-ec2-instance/) truoc. Nghia la minh da co san:

- Mot EC2 instance dang chay Ubuntu tren AWS
- Mot public IP de truy cap server
- Mot Security Group da mo port `22` cho SSH
- Mot key pair cu da duoc gan vao EC2 khi launch instance

Vi vay, o project nay minh khong tao lai EC2 moi. Thay vao do, minh se tao them mot key pair moi tren AWS Management Console, roi dua public key cua key pair do vao EC2 hien co de co the SSH bang key moi.

Day la tinh huong rat thuc te trong DevOps: server da ton tai, nhung minh can cap them quyen truy cap SSH cho mot may khac, mot user khac, hoac thay the key cu bang key moi.

## Muc tieu

Muc tieu cua project la hieu cach SSH key hoat dong va biet cach cau hinh server Linux de chap nhan mot SSH key moi.

Sau khi hoan thanh, ban se biet:

- SSH dung public key va private key nhu the nao
- Vi sao tao key pair moi tren AWS khong tu dong them key do vao EC2 da ton tai
- File `~/.ssh/authorized_keys` co vai tro gi
- Cach them public key moi vao server Linux
- Cach kiem tra dang nhap SSH bang key moi
- Cach quan ly quyen truy cap SSH an toan hon

## Diem quan trong can hieu

Khi launch EC2 instance, AWS se lay public key cua key pair ban chon va gan no vao user mac dinh cua server, thuong la user `ubuntu` voi Ubuntu AMI.

Public key do nam trong file:

```bash
~/.ssh/authorized_keys
```

Khi ban SSH vao server, may local giu private key. Server giu public key. Neu private key khop voi mot public key trong `authorized_keys`, server cho phep dang nhap.

Vi vay:

- Tao key pair moi tren AWS chi tao ra mot cap key moi.
- AWS khong tu dong chen public key moi vao EC2 instance da ton tai.
- Muon dung key moi de SSH vao EC2 cu, minh phai them public key moi vao file `~/.ssh/authorized_keys` tren EC2.

## Kien thuc DevOps hoc duoc

### 1. SSH access management

DevOps Engineer thuong phai quan ly viec ai duoc phep truy cap server. Project nay giup hieu cach cap them SSH access ma khong can tao lai server.

### 2. Public key authentication

Ban se thay ro su khac nhau giua:

- Private key: nam tren may local, can giu bi mat
- Public key: co the dat tren server de cho phep dang nhap

Day la nen tang cua SSH, Git over SSH, CI/CD deploy key va server automation.

### 3. Linux user va file permission

SSH rat nhay cam voi permission. Neu thu muc `.ssh` hoac file `authorized_keys` qua mo, SSH co the tu choi dang nhap.

Project nay giup lam quen voi:

- `~/.ssh`
- `authorized_keys`
- `chmod 700 ~/.ssh`
- `chmod 600 ~/.ssh/authorized_keys`

### 4. Cloud va server lifecycle

Ban se hieu mot diem quan trong khi lam viec voi cloud: key pair duoc gan luc launch instance khong co nghia la moi key pair trong AWS deu dung duoc voi moi EC2.

Muon thay doi quyen SSH cua mot server dang ton tai, minh can thao tac tren chinh server do.

## Yeu cau truoc khi lam

- Da hoan thanh project [11-ec2-instance](../11-ec2-instance/)
- EC2 Ubuntu instance dang chay
- Security Group cua EC2 da mo inbound port `22`
- Con giu private key cu de SSH vao EC2
- Co quyen tao key pair moi trong AWS Management Console
- May local co SSH client

## Quy trinh thuc hien

### 1. Tao key pair moi tren AWS Management Console

Vao AWS Console:

1. Mo EC2 Dashboard
2. Vao Network & Security
3. Chon Key Pairs
4. Chon Create key pair
5. Dat ten key, vi du `devops-ssh-key-2`
6. Chon key type `RSA` hoac `ED25519`
7. Chon private key format `.pem`
8. Tai file private key ve may local

Ly do cua buoc nay:

- Tao mot cap key moi de dung cho SSH
- Mo phong tinh huong can cap them hoac thay the SSH credential
- Lam quen voi cach AWS quan ly EC2 key pair

Luu y: AWS chi cho tai private key mot lan luc tao key pair. Neu lam mat file `.pem`, ban khong the tai lai private key do tu AWS.

### 2. Dat permission cho private key moi

Tren Linux hoac macOS:

```bash
chmod 400 devops-ssh-key-2.pem
```

Tren Windows PowerShell, neu SSH bao loi permission qua mo, co the gioi han quyen cho file key bang File Properties hoac `icacls`.

Ly do cua buoc nay:

- SSH yeu cau private key khong duoc doc boi qua nhieu user
- Neu permission qua mo, SSH co the tu choi dung key de dang nhap
- Day la mot co che bao ve private key khoi bi lo tren may local

### 3. Tao public key tu private key moi

Tren may local:

```bash
ssh-keygen -y -f devops-ssh-key-2.pem > devops-ssh-key-2.pub
```

Ly do cua buoc nay:

- EC2 can public key, khong can private key
- Private key phai luon nam tren may local va khong copy len server
- Public key moi la noi dung se duoc them vao `authorized_keys`

### 4. SSH vao EC2 bang key cu

Vi EC2 hien tai chua biet key moi, minh phai dung key cu da hoat dong tu project 11 de dang nhap truoc.

```bash
ssh -i old-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Ly do cua buoc nay:

- Can vao duoc server truoc thi moi sua duoc file `authorized_keys`
- Key cu dong vai tro nhu quyen admin hien tai de cap them quyen truy cap bang key moi

### 5. Chuan bi thu muc SSH tren EC2

Sau khi da SSH vao EC2:

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Ly do cua buoc nay:

- `~/.ssh` la noi Linux user luu cau hinh SSH
- `authorized_keys` la danh sach public key duoc phep dang nhap
- Permission dung giup SSH chap nhan file nay va tranh rui ro bao mat

### 6. Dua public key moi vao EC2

Mo file public key tren may local:

```bash
cat devops-ssh-key-2.pub
```

Copy toan bo output, sau do tren EC2 chay:

```bash
nano ~/.ssh/authorized_keys
```

Dan public key moi vao cuoi file, moi key nam tren mot dong rieng.

Hoac copy file public key len EC2 bang `scp`:

```bash
scp -i old-key.pem devops-ssh-key-2.pub ubuntu@<EC2_PUBLIC_IP>:/tmp/devops-ssh-key-2.pub
```

Sau do SSH vao EC2 bang key cu va append public key moi:

```bash
cat /tmp/devops-ssh-key-2.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
rm /tmp/devops-ssh-key-2.pub
```

Ly do cua buoc nay:

- Them public key moi vao danh sach key duoc phep dang nhap
- Giu lai key cu de tranh tu khoa minh khoi server neu key moi chua test thanh cong
- Moi public key trong `authorized_keys` tuong ung voi mot private key co the dang nhap vao user `ubuntu`

### 7. Kiem tra SSH bang key moi

Mo terminal moi tren may local va chay:

```bash
ssh -i devops-ssh-key-2.pem ubuntu@<EC2_PUBLIC_IP>
```

Neu dang nhap thanh cong, key moi da duoc cau hinh dung.

Ly do cua buoc nay:

- Xac nhan public key moi da nam dung trong `authorized_keys`
- Xac nhan private key moi tren local khop voi public key tren server
- Dam bao co the dung key moi truoc khi nghi den viec xoa key cu

### 8. Tuy chon: xoa key cu neu khong con dung

Chi lam buoc nay sau khi da test key moi thanh cong.

Tren EC2:

```bash
nano ~/.ssh/authorized_keys
```

Xoa dong public key cu, giu lai public key moi.

Ly do cua buoc nay:

- Giam so luong credential con hieu luc
- Thu hoi quyen truy cap cua key cu neu key do khong con can thiet
- Day la mot phan cua SSH key rotation trong thuc te

## Neu khong con key cu thi sao?

Neu ban da mat private key cu va khong the SSH vao EC2, viec them key moi se phuc tap hon. Mot so cach xu ly:

- Dung EC2 Instance Connect neu AMI va region ho tro
- Dung AWS Systems Manager Session Manager neu instance da cau hinh SSM Agent va IAM role
- Stop instance, detach root volume, gan volume sang instance khac, sua file `authorized_keys`, roi gan lai volume

Trong project nay, vi minh da lam project 11 truoc va van con key cu, cach don gian va dung muc tieu nhat la SSH bang key cu roi them public key moi vao `authorized_keys`.

## Luu y bao mat

- Khong bao gio copy private key len EC2
- Khong commit file `.pem` vao Git
- Gioi han inbound SSH port `22` theo IP ca nhan neu co the
- Xoa key khong con su dung khoi `authorized_keys`
- Dung ten key ro rang de biet key nao phuc vu muc dich nao
- Neu lam trong team, moi nguoi nen co key rieng thay vi dung chung mot private key

## Tong ket

Project nay giup hieu ro hon ve SSH trong thuc te DevOps. AWS key pair chi la cach ban dau de nap public key vao EC2 khi launch instance. Khi instance da ton tai, muon them key pair moi thi can dua public key moi vao file `~/.ssh/authorized_keys` tren server.

Sau project nay, ban se nam duoc mot ky nang rat quan trong: quan ly SSH access cho Linux server dang chay tren cloud.
