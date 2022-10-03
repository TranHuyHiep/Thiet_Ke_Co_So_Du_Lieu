exec sp_addlogin N01, 123
use BT_Tuan2
exec sp_adduser N01, N01user

grant select, update on tSach to N01user
/*
Tạo login A, B
Tạo user userA, userB tương ứng với login A, B
Gán quyền select, update cho userA trên bảng KhachHang của CSDL QLBanHang,  A có quyền trao
	quyền này cho người khác
Đăng nhập A để kiểm tra
Từ A, trao quyền select cho userB trên bảng KachHang của CSDL QLBanHang
Đăng nhập B để kiểm tra
*/
exec sp_addlogin A, 123
exec sp_addlogin B, 123

use BT_Tuan2
exec sp_adduser A, Auser
exec sp_adduser B, Buser

grant select, update on tKhachHang to Auser with grant option