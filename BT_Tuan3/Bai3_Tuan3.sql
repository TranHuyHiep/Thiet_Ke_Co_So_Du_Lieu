-- Bài tập 3: Cho CSDL về quản lý bán hàng trong file QLSinhVien.sql
-- 1. Tạo login Login1, tạo User1 cho Login1
exec sp_addlogin Login1, 1, QLSinhVien
exec sp_adduser Login1, User1 
-- 2. Phân quyền Select trên bảng DSSinhVien cho User1
grant select on DSSinhVien to User1

-- 3. Đăng nhập để kiểm tra

-- 4. Tạo login Login2, tạo User2 cho Login2
exec sp_addlogin Login2, 1, QLSinhVien
exec sp_adduser Login2, User2


-- 5. Phân quyền Update trên bảng DSSinhVien cho User2, người này có thể cho phép người
-- khác sử dụng quyền này
grant update on DSSinhVien to User2 with grant option

-- 6. Đăng nhập dưới Login2 và trao quyền Update trên bảng DSSinhVien cho User 1
grant update on DSSinhVien to User1

-- 7. Đăng nhập Login 1 để kiểm tra
