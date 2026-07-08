# EC2 Instance

Project URL: https://roadmap.sh/projects/ec2-instance

## Mục tiêu

Project này hướng dẫn cách tạo một Linux server trên AWS EC2 và deploy một static website đơn giản bằng Nginx.

Thông qua project này, bạn sẽ làm quen với quy trình cơ bản mà một DevOps Engineer thường gặp: tạo hạ tầng cloud, cấu hình truy cập mạng, kết nối vào server, cài đặt web server, deploy source code và kiểm tra ứng dụng chạy trên môi trường thật.

## Project này giúp học được gì?

### 1. Cloud Computing cơ bản

Bạn sẽ hiểu EC2 là gì và vì sao EC2 được dùng để chạy server trên cloud.

Các kiến thức chính:

- AWS account và AWS Management Console
- Region, Availability Zone
- EC2 instance
- AMI, ví dụ Ubuntu Server AMI
- Instance type, ví dụ `t2.micro`
- Public IP dùng để truy cập server từ internet

### 2. Linux Server

Sau khi tạo EC2 instance, bạn sẽ kết nối vào server Ubuntu bằng SSH.

Các kiến thức chính:

- SSH vào Linux server
- Dùng private key để xác thực
- Cập nhật package bằng `apt`
- Cài đặt và kiểm tra service
- Làm việc với thư mục deploy như `/var/www/html`

### 3. Networking cho DevOps

Project này giúp bạn hiểu cách một server được public ra internet.

Các kiến thức chính:

- VPC mặc định
- Subnet mặc định
- Security Group như một firewall ở tầng cloud
- Inbound rule
- Port `22` cho SSH
- Port `80` cho HTTP
- Sự khác nhau giữa truy cập server qua SSH và truy cập website qua browser

### 4. Web Server và Static Website

Bạn sẽ dùng Nginx để serve file HTML tĩnh.

Các kiến thức chính:

- Web server là gì
- Nginx hoạt động như thế nào ở mức cơ bản
- Document root của Nginx
- Deploy file `index.html`
- Kiểm tra website bằng public IP

### 5. Quy trình Deploy cơ bản

Project này mô phỏng một flow deploy rất nhỏ nhưng thực tế:

1. Chuẩn bị server
2. Mở đúng port cần thiết
3. SSH vào server
4. Cài runtime hoặc web server
5. Copy source code lên server
6. Restart hoặc reload service nếu cần
7. Kiểm tra ứng dụng từ browser

Đây là nền tảng để học tiếp các chủ đề lớn hơn như CI/CD, Docker, Infrastructure as Code, monitoring và production deployment.

## Yêu cầu

- Có AWS account
- Có quyền tạo EC2 instance
- Có SSH client trên máy local
- Có private key `.pem` để kết nối vào EC2
- EC2 instance sử dụng Ubuntu Server AMI
- Instance type: `t2.micro`
- Security Group mở inbound:
  - `22` cho SSH
  - `80` cho HTTP
- Instance có public IP

## File trong project

```text
11-ec2-instance/
├── README.md
└── index.html
```

File `index.html` là static website mẫu sẽ được deploy lên EC2.

## Các bước thực hiện

### 1. Tạo hoặc đăng nhập AWS account

Truy cập AWS Management Console và đăng nhập vào tài khoản AWS.

Nếu chưa có tài khoản, hãy tạo account mới và bật các cảnh báo chi phí nếu cần để tránh phát sinh chi phí ngoài ý muốn.

### 2. Launch EC2 instance

Trong AWS Console:

1. Vào EC2 Dashboard
2. Chọn Launch Instance
3. Chọn Ubuntu Server AMI
4. Chọn instance type `t2.micro`
5. Chọn default VPC và default subnet
6. Bật Auto-assign Public IP
7. Tạo key pair mới hoặc dùng key pair có sẵn
8. Tạo Security Group cho phép:
   - SSH từ máy cá nhân của bạn qua port `22`
   - HTTP từ internet qua port `80`
9. Launch instance

### 3. Kết nối vào EC2 bằng SSH

Ví dụ:

```bash
chmod 400 my-key.pem
ssh -i my-key.pem ubuntu@<EC2_PUBLIC_IP>
```

Thay:

- `my-key.pem` bằng file private key của bạn
- `<EC2_PUBLIC_IP>` bằng public IP của EC2 instance

### 4. Cập nhật server và cài Nginx

Trên EC2 instance:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install nginx -y
```

Kiểm tra Nginx:

```bash
sudo systemctl status nginx
```

Nếu Nginx đang chạy, bạn có thể mở browser và truy cập:

```text
http://<EC2_PUBLIC_IP>
```

### 5. Deploy static website

Copy nội dung file `index.html` vào document root mặc định của Nginx:

```bash
sudo nano /var/www/html/index.html
```

Dán nội dung HTML sau:

```html
<!DOCTYPE html>
<html>
<head>
  <title>My AWS Website</title>
</head>
<body>
  <h1>Hello from AWS EC2</h1>
  <p>This static website is deployed on an Ubuntu server using Nginx.</p>
</body>
</html>
```

Hoặc copy file từ máy local lên EC2 bằng `scp`:

```bash
scp -i my-key.pem index.html ubuntu@<EC2_PUBLIC_IP>:/tmp/index.html
ssh -i my-key.pem ubuntu@<EC2_PUBLIC_IP>
sudo cp /tmp/index.html /var/www/html/index.html
```

### 6. Kiểm tra website

Truy cập website bằng browser:

```text
http://<EC2_PUBLIC_IP>
```

Nếu thấy dòng `Hello from AWS EC2`, nghĩa là static website đã được deploy thành công.

## Lưu ý bảo mật

- Không commit file private key `.pem` lên Git.
- Chỉ mở port cần thiết.
- Với port `22`, nên giới hạn source IP là IP cá nhân của bạn thay vì mở cho toàn internet.
- Sau khi học xong, nên stop hoặc terminate EC2 instance nếu không dùng nữa để tránh phát sinh chi phí.

## Tổng kết

Sau khi hoàn thành project này, bạn sẽ nắm được một workflow DevOps rất căn bản: tạo server cloud, cấu hình network, truy cập bằng SSH, cài Nginx và deploy một website tĩnh. Đây là bước nền quan trọng trước khi đi tiếp sang automation, Docker, CI/CD và Infrastructure as Code.
