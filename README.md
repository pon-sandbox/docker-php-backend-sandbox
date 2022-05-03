# docker-php-backend-sandbox

(自分宛)  
src フォルダにアクセスしたい FQDN の末尾の .(dot) を削除した名前でフォルダを作ればそこの index.php を読むよ  
さくらクラウドを使えば Let's Encrypt で127.0.0.1に向いてる自分のドメインを使って証明書発行できるよ  
<https://blog.jxck.io/entries/2020-06-29/https-for-localhost.html>  
phpMyAdmin は <http://localhost:8080> でアクセスできるよ  
.env.example を参考に .env を作って使ってね  
compose.yaml があるディレクトリで `docker compose up -d` でいい感じに動くよ  
M1 Mac でしかテストしてないよ
