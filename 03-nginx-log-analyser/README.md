# Nginx Log Analyser

Project URL: https://roadmap.sh/projects/nginx-log-analyser

## Mục tiêu

Project này dùng Bash để phân tích file log của Nginx và in ra các thống kê cơ bản:

- Top 5 địa chỉ IP truy cập nhiều nhất
- Top 5 path được request nhiều nhất
- Top 5 HTTP status code xuất hiện nhiều nhất
- Top 5 user agent xuất hiện nhiều nhất

File chính của project là:

```text
nginx-log-analyser.sh
```

File log mẫu là:

```text
access.log
```

## Ý nghĩa DevOps của project

Trong thực tế, DevOps Engineer thường phải đọc log để hiểu hệ thống đang xảy ra chuyện gì. Một file access log của Nginx có thể giúp trả lời nhiều câu hỏi quan trọng:

- IP nào đang truy cập nhiều bất thường?
- Endpoint nào được gọi nhiều nhất?
- Website/API có nhiều lỗi `404`, `400`, `500` không?
- Traffic đến từ browser thật, uptime checker, bot hay scanner?

Project này giúp luyện các kỹ năng nền tảng:

- Làm việc với Linux command line
- Xử lý text file bằng pipeline
- Dùng `awk`, `sort`, `uniq`, `head`
- Hiểu cấu trúc Nginx access log
- Biến log thô thành thông tin có thể quan sát được

## Cách chạy

Di chuyển vào thư mục project:

```bash
cd 03-nginx-log-analyser
```

Cấp quyền execute cho script:

```bash
chmod +x nginx-log-analyser.sh
```

Chạy script:

```bash
./nginx-log-analyser.sh
```

Nếu dùng Git Bash trên Windows, có thể chạy:

```bash
bash nginx-log-analyser.sh
```

## Code của script

```bash
#!/bin/bash

LOG_FILE="access.log"

echo "Top 5 IP addresses:"
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 requested paths:"
awk -F'"' '{print $2}' $LOG_FILE | awk '{print $2}' | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 status codes:"
awk -F'"' '{print $3}' $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | head -5

echo ""
echo "Top 5 user agents:"
awk -F'"' '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | head -5
```

## Giải thích từng cú pháp

### 1. Shebang

```bash
#!/bin/bash
```

Dòng này gọi là shebang.

Ý nghĩa:

- Báo cho hệ điều hành biết script này nên được chạy bằng Bash
- Khi chạy `./nginx-log-analyser.sh`, Linux sẽ dùng `/bin/bash` để thực thi file

Nếu không có dòng này, bạn vẫn có thể chạy script bằng:

```bash
bash nginx-log-analyser.sh
```

### 2. Khai báo biến

```bash
LOG_FILE="access.log"
```

Dòng này tạo biến `LOG_FILE` và gán giá trị là `access.log`.

Ý nghĩa:

- Giúp không phải lặp lại tên file log nhiều lần
- Nếu muốn phân tích file khác, chỉ cần đổi giá trị biến này

Ví dụ:

```bash
LOG_FILE="/var/log/nginx/access.log"
```

Khi dùng biến trong Bash, ta thêm dấu `$` phía trước:

```bash
$LOG_FILE
```

Trong script, `$LOG_FILE` sẽ được thay bằng `access.log`.

### 3. In text ra terminal bằng `echo`

```bash
echo "Top 5 IP addresses:"
```

`echo` dùng để in nội dung ra màn hình.

Ví dụ:

```bash
echo "Hello"
```

Output:

```text
Hello
```

Dòng này:

```bash
echo ""
```

dùng để in một dòng trống, giúp output dễ đọc hơn.

## Hiểu cấu trúc Nginx access log

Một dòng log mẫu:

```text
178.128.94.113 - - [04/Oct/2024:00:00:18 +0000] "GET /v1-health HTTP/1.1" 200 51 "-" "DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)"
```

Có thể hiểu đơn giản:

```text
IP - - [time] "METHOD PATH HTTP_VERSION" STATUS_CODE BODY_SIZE "REFERER" "USER_AGENT"
```

Trong ví dụ trên:

- IP là `178.128.94.113`
- Request là `GET /v1-health HTTP/1.1`
- Path là `/v1-health`
- Status code là `200`
- User agent là `DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)`

## Pipeline là gì?

Trong Bash, dấu pipe `|` dùng để đưa output của lệnh bên trái làm input cho lệnh bên phải.

Ví dụ:

```bash
awk '{print $1}' access.log | sort
```

Ý nghĩa:

1. `awk '{print $1}' access.log` lấy cột đầu tiên trong file log
2. Output đó được đưa sang `sort`
3. `sort` sắp xếp các dòng

Pipeline giúp ghép nhiều lệnh nhỏ lại thành một luồng xử lý dữ liệu.

## Các lệnh được dùng trong script

### `awk`

`awk` dùng để đọc và xử lý text theo từng dòng.

Ví dụ:

```bash
awk '{print $1}' access.log
```

Ý nghĩa:

- Đọc file `access.log`
- Mỗi dòng được tách thành nhiều cột theo khoảng trắng
- `$1` là cột thứ nhất
- `print $1` in ra cột thứ nhất

Với dòng log:

```text
178.128.94.113 - - [04/Oct/2024:00:00:18 +0000] "GET /v1-health HTTP/1.1" 200 51 "-" "DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)"
```

Lệnh:

```bash
awk '{print $1}' access.log
```

sẽ lấy:

```text
178.128.94.113
```

### `awk -F`

Tuỳ chọn `-F` dùng để chỉ định ký tự phân tách field.

Ví dụ:

```bash
awk -F'"' '{print $2}' access.log
```

Ở đây `-F'"'` nghĩa là tách dòng log bằng dấu nháy kép `"`.

Với dòng log mẫu, nếu tách bằng dấu `"`, ta có:

```text
Field 1: 178.128.94.113 - - [04/Oct/2024:00:00:18 +0000]
Field 2: GET /v1-health HTTP/1.1
Field 3:  200 51 
Field 4: -
Field 5:  
Field 6: DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)
```

Vì vậy:

```bash
awk -F'"' '{print $2}' access.log
```

sẽ lấy phần request:

```text
GET /v1-health HTTP/1.1
```

Còn:

```bash
awk -F'"' '{print $6}' access.log
```

sẽ lấy user agent:

```text
DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)
```

### `sort`

`sort` dùng để sắp xếp các dòng theo thứ tự.

Ví dụ:

```bash
sort
```

Nếu input là:

```text
b
a
c
```

Output sẽ là:

```text
a
b
c
```

Trong script, `sort` được dùng trước `uniq -c` vì `uniq` chỉ đếm chính xác các dòng giống nhau khi chúng nằm cạnh nhau.

### `uniq -c`

`uniq` dùng để gộp các dòng trùng lặp liên tiếp.

Tuỳ chọn `-c` dùng để đếm số lần xuất hiện.

Ví dụ:

```text
200
200
404
```

Sau khi chạy:

```bash
uniq -c
```

Output:

```text
2 200
1 404
```

### `sort -nr`

```bash
sort -nr
```

Ý nghĩa:

- `-n`: sort theo số, không sort theo chữ
- `-r`: reverse, tức là sắp xếp giảm dần

Sau `uniq -c`, output có dạng:

```text
1087 178.128.94.113
277 86.134.118.70
5740 200
```

Ta dùng `sort -nr` để số lớn nhất đứng đầu.

### `head -5`

```bash
head -5
```

Lệnh này lấy 5 dòng đầu tiên.

Trong script, sau khi đã đếm và sort giảm dần, `head -5` giúp lấy top 5 kết quả.

## Giải thích từng phần thống kê

### 1. Top 5 IP addresses

```bash
awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -5
```

Ý nghĩa từng bước:

```bash
awk '{print $1}' $LOG_FILE
```

Lấy cột đầu tiên của mỗi dòng log, chính là IP client.

```bash
sort
```

Sắp xếp danh sách IP để các IP giống nhau nằm cạnh nhau.

```bash
uniq -c
```

Đếm mỗi IP xuất hiện bao nhiêu lần.

```bash
sort -nr
```

Sắp xếp số lần xuất hiện từ cao xuống thấp.

```bash
head -5
```

Lấy 5 IP nhiều nhất.

Ví dụ output:

```text
1087 178.128.94.113
1087 142.93.136.176
1087 138.68.248.85
1086 159.89.185.30
 277 86.134.118.70
```

Ý nghĩa: IP `178.128.94.113` xuất hiện `1087` lần trong log.

### 2. Top 5 requested paths

```bash
awk -F'"' '{print $2}' $LOG_FILE | awk '{print $2}' | sort | uniq -c | sort -nr | head -5
```

Pipeline này có hai lần dùng `awk`.

Bước 1:

```bash
awk -F'"' '{print $2}' $LOG_FILE
```

Lấy phần request nằm trong dấu nháy kép.

Ví dụ:

```text
GET /v1-health HTTP/1.1
```

Bước 2:

```bash
awk '{print $2}'
```

Từ request trên, tách theo khoảng trắng:

```text
Field 1: GET
Field 2: /v1-health
Field 3: HTTP/1.1
```

`print $2` sẽ lấy path:

```text
/v1-health
```

Các bước còn lại:

```bash
sort | uniq -c | sort -nr | head -5
```

dùng để đếm, sắp xếp giảm dần và lấy top 5.

Ví dụ output:

```text
4560 /v1-health
 270 /
 232 /v1-me
 127 /v1-list-workspaces
  75 /v1-list-timezone-teams
```

Ý nghĩa: endpoint `/v1-health` được request `4560` lần.

### 3. Top 5 status codes

```bash
awk -F'"' '{print $3}' $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | head -5
```

Bước 1:

```bash
awk -F'"' '{print $3}' $LOG_FILE
```

Sau khi tách dòng log bằng dấu `"`, field thứ 3 chứa phần sau request:

```text
 200 51 
```

Bước 2:

```bash
awk '{print $1}'
```

Lấy field đầu tiên trong phần đó, chính là HTTP status code:

```text
200
```

Các bước sau tiếp tục đếm và lấy top 5.

Ví dụ output:

```text
5740 200
 937 404
 621 304
 260 400
  23 403
```

Ý nghĩa:

- `200`: request thành công
- `304`: client dùng cache, không cần tải lại nội dung
- `400`: bad request
- `403`: forbidden
- `404`: không tìm thấy resource

Nếu `404` hoặc `400` tăng cao, DevOps cần kiểm tra traffic, route, bot scan hoặc lỗi cấu hình.

### 4. Top 5 user agents

```bash
awk -F'"' '{print $6}' $LOG_FILE | sort | uniq -c | sort -nr | head -5
```

Bước 1:

```bash
awk -F'"' '{print $6}' $LOG_FILE
```

Lấy field thứ 6 sau khi tách bằng dấu `"`, chính là user agent.

User agent cho biết client là gì, ví dụ:

- Browser
- Bot
- Uptime checker
- HTTP client
- Security scanner

Các bước sau:

```bash
sort | uniq -c | sort -nr | head -5
```

dùng để đếm user agent nào xuất hiện nhiều nhất.

Ví dụ output:

```text
4347 DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)
 513 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36
 332 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36
 294 Custom-AsyncHttpClient
 282 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36
```

Ý nghĩa: phần lớn request trong log đến từ `DigitalOcean Uptime Probe`, tức là một hệ thống kiểm tra uptime tự động.

## Output đầy đủ khi chạy script

Ví dụ output từ file `access.log` trong project:

```text
Top 5 IP addresses:
   1087 178.128.94.113
   1087 142.93.136.176
   1087 138.68.248.85
   1086 159.89.185.30
    277 86.134.118.70

Top 5 requested paths:
   4560 /v1-health
    270 /
    232 /v1-me
    127 /v1-list-workspaces
     75 /v1-list-timezone-teams

Top 5 status codes:
   5740 200
    937 404
    621 304
    260 400
     23 403

Top 5 user agents:
   4347 DigitalOcean Uptime Probe 0.22.0 (https://digitalocean.com)
    513 Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36
    332 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36
    294 Custom-AsyncHttpClient
    282 Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36
```

## Một cải tiến nhỏ nên biết

Trong script hiện tại, biến `$LOG_FILE` chưa được đặt trong dấu nháy kép:

```bash
awk '{print $1}' $LOG_FILE
```

Với file tên đơn giản như `access.log`, cách này vẫn chạy tốt.

Nhưng trong Bash, thói quen tốt là bọc biến bằng dấu nháy kép:

```bash
awk '{print $1}' "$LOG_FILE"
```

Lý do:

- Tránh lỗi nếu đường dẫn file có khoảng trắng
- Tránh Bash tách sai tên file thành nhiều phần
- Giúp script an toàn và ổn định hơn

Ví dụ nếu file log nằm ở:

```text
logs/nginx access.log
```

thì dùng `"$LOG_FILE"` sẽ an toàn hơn `$LOG_FILE`.

## Tổng kết

Script này là một ví dụ rất tốt về cách dùng Linux pipeline để phân tích log. Thay vì mở file log lớn và đọc thủ công, ta dùng các lệnh nhỏ ghép lại:

```bash
awk -> sort -> uniq -c -> sort -nr -> head
```

Đây là kỹ năng rất quan trọng trong DevOps vì log thường là nơi đầu tiên cần xem khi debug lỗi, điều tra traffic bất thường hoặc kiểm tra sức khỏe hệ thống.
