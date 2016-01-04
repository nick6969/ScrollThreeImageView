# ScrollThreeImageView

這是一個簡單的封裝

效果是一般在scrollView裡面自動輪播圖片

只用三個 imageView 以節省記憶體的使用

只是把 Code 封裝成一個繼承 UIView 的 Class

方便取用


使用方法如下

let scroll = ScrollThreeImageView(frame: frame, imageName: imageName, duration: 3)


參數說明如下
frame :     CGRect  整個scrollView的大小
imageName : Array<String> 這是一個放置圖片檔案名稱的Array
duration :  Double 這是每次輪播的秒數

特別注意的是，因為基本是用三個ImageView，所以imageName的Array.count不能少於3