----------------------------BÀI 1----------------------------------
-- Câu 1: Tạo View danh sách sinh viên, gồm các thông tin sau:
--Mã sinh viên, Họ sinh viên, Tên sinh viên, Học bổng
create view Cau1 as
select MaSV, HoSV, TenSV, HocBong
from DSSinhVien 
go
select * FROM Cau1
go
-- Câu 2: Tạo view Liệt kê các sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội, gồm
-- các thông tin: Họ tên sinh viên, Mã khoa, Nơi sinh, Học bổng.
create view Cau2 as
select HoSV, TenSV, MaSV, NoiSinh, HocBong
from DSSinhVien
where HocBong >= 150000 and NoiSinh = N'Hà Nội'
go
select * FROM Cau2
GO
-- Câu 3: Tạo view liệt kê những sinh viên nam của khoa Anh văn và khoa tin học, gồm các thông
-- tin: Mã sinh viên, Họ tên sinh viên, tên khoa, Phái
create view Cau3 as
select MaSV, HoSV, TenSV, TenKhoa, Phai
from DSSinhVien join DMKhoa on DSSinhVien.MaKhoa = DMKhoa.MaKhoa
where (TenKhoa = N'Tin Học' or TenKhoa = N'Anh Văn') and Phai = N'Nam'
GO
SELECT * FROM Cau3
GO
-- Câu 4: Tạo view gồm những sinh viên có tuổi từ 20 đến 25, thông tin gồm: Họ tên sinh viên,
-- Tuổi, Tên khoa.
CREATE VIEW Cau4 AS 
SELECT HoSV, TenSV, CONVERT(INT, DATEDIFF(DD, NgaySinh, GETDATE())/365.25) AS tuoi, TenKhoa
FROM DSSinhVien JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
WHERE DATEDIFF(DD, NgaySinh, GETDATE())/365.25 >= 20 
	AND DATEDIFF(DD, NgaySinh, GETDATE())/365.25 <= 25
go
SELECT * FROM Cau4
go
-- Câu 5: Tạo view cho biết thông tin về mức học bổng của các sinh viên, gồm: 
-- Mã sinh viên, Phái, Mã khoa, Mức học bổng. 
-- Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao”
-- nếu giá trị của field học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”
CREATE VIEW Cau5 AS
SELECT MaSV, Phai, MaKhoa, 
(
	CASE 
	WHEN HocBong > 500000 THEN N'Học bổng cao'
	ELSE N'Mức trung bình'
	END
) AS MucHocBong
FROM DSSinhVien
WHERE HocBong > 0
go
SELECT * FROM Cau5
go
-- Câu 6: Tạo view đưa ra thông tin những sinh viên có học bổng lớn hơn bất kỳ học bổng của
-- sinh viên học khóa anh văn
CREATE VIEW Cau6 AS
SELECT MaSV, HoSV, TenSV, HocBong
FROM DSSinhVien INNER JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
WHERE hocbong > (SELECT TOP (1) HocBong
					FROM DSSinhVien JOIN DMKhoa ON DSSinhVien.MaKhoa = DMKhoa.MaKhoa
					WHERE TenKhoa = N'Anh Văn' 
					ORDER BY HocBong DESC)
GO
SELECT * FROM Cau6
go
-- Câu 7: Tạo view đưa ra thôngz tin những sinh viên đạt điểm cao nhất trong từng môn.
CREATE VIEW Cau7
as
SELECT DSSinhVien.MaSV, HoSV, TenSV, Diem, DMMonHoc.MaMH, TenMH
FROM dbo.DSSinhVien INNER JOIN dbo.KetQua ON KetQua.MaSV = DSSinhVien.MaSV
	INNER JOIN dbo.DMMonHoc ON DMMonHoc.MaMH = KetQua.MaMH, 
	(SELECT DMMonHoc.MaMH, MAX(Diem) AS maxDiem
	FROM dbo.DMMonHoc INNER JOIN dbo.KetQua ON KetQua.MaMH = DMMonHoc.MaMH
	GROUP BY DMMonHoc.MaMH) AS temp
WHERE Diem = temp.maxDiem AND DMMonHoc.MaMH = temp.MaMH
GO
SELECT * FROM Cau7
GO
-- Câu 8: Tạo view đưa ra những sinh viên chưa thi môn cơ sở dữ liệu.
CREATE VIEW Cau8
AS
SELECT * 
FROM dbo.DSSinhVien
WHERE DSSinhVien.MaSV NOT IN (SELECT MaSV
	FROM dbo.KetQua 
	WHERE MaMH = 01
	GROUP BY MaSV)
GO
SELECT * FROM dbo.Cau8
GO
	
-- Câu 9: Tạo view đưa ra thông tin những sinh viên không trượt môn nào.
CREATE VIEW Cau9
as
SELECT *
FROM dbo.DSSinhVien
WHERE MaSV NOT IN (SELECT MaSV
	FROM dbo.KetQua
	WHERE Diem < 4
	GROUP BY MaSV)
GO
SELECT * FROM Cau9
GO

----------------------------BÀI 2----------------------------------
/*1. Tạo view DSHS10A1 gồm thông tin Mã học sinh, họ tên, giới tính (là “Nữ” nếu Nu=1,
ngược lại là “Nam”), các điểm Toán, Lý, Hóa, Văn của các học sinh lớp 10A1 */
CREATE VIEW DSHS10A1
as
SELECT DSHS.MAHS, HO, TEN, 
(
	CASE
	WHEN NU = 1 THEN N'Nữ'
	ELSE N'Nam'
	END
) AS GIOI_TINH, TOAN, LY, HOA, VAN
FROM dbo.DSHS INNER JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
WHERE MALOP = '10A1'
GO
SELECT * FROM dbo.DSHS10A1
GO
/*2. Tạo login TranThanhPhong, tạo user TranThanhPhong cho TranThanhPhong trên CSDL 
QLHocSinh */
exec sp_addlogin TranThanhPhong, 1, QLHocSinh
exec sp_adduser TranThanhPhong
-- Phân quyền Select trên view DSHS10A1 cho TranThanhPhong
grant select on DSHS10A1 to TranThanhPhong
-- Đăng nhập TranThanhPhong để kiểm tra

exec sp_droplogin TranThanhPhong
exec sp_dropuser TranThanhPhong
-- Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLHocSinh
exec sp_addlogin PhamVanNam, 1, QLHocSinh
exec sp_adduser PhamVanNam, PVN
-- Đăng nhập PhamVanNam để kiểm tra

-- Tạo view DSHS10A2 tương tự như câu 1
CREATE VIEW DSHS10A2
as
SELECT DSHS.MAHS, HO, TEN, 
(
	CASE
	WHEN NU = 1 THEN N'Nữ'
	ELSE N'Nam'
	END
) AS GIOI_TINH, TOAN, LY, HOA, VAN
FROM dbo.DSHS INNER JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
WHERE MALOP = '10A2'
GO
SELECT * FROM dbo.DSHS10A2
GO
-- Phân quyền Select trên view DSHS10A2 cho PhamVanNam
grant select on DSHS10A2 to PVN
-- Đăng nhập PhamVanNam để kiểm tra */




/*3. Tạo view báo cáo Kết thúc năm học gồm các thông tin: Mã học sinh, Họ và tên, Ngày sinh, 
Giới tính, Điểm Toán, Lý, Hóa, Văn, Điểm Trung bình, Xếp loại, Sắp xếp theo xếp loại (chọn 
1000 bản ghi đầu). Trong đó:
Điểm trung bình (DTB) = ((Toán + Văn)*2 + Lý + Hóa)/6)
Cách thức xếp loại như sau:
- Xét điểm thấp nhất (DTN) của các 4 môn 
- Nếu DTB>5 và DTN>4 là “Lên Lớp”, ngược lại là lưu ban */

CREATE FUNCTION diemNhoNhat(@toan FLOAT, @ly FLOAT, @hoa FLOAT, @van FLOAT) RETURNS FLOAT AS
BEGIN
	DECLARE @min FLOAT
	SET @min = @toan
	IF @min > @ly SET @min = @ly
	IF @min > @hoa SET @min = @hoa
	IF @min > @van SET @min = @van
	RETURN @min
END
GO

CREATE FUNCTION diemTrungBinh(@toan FLOAT, @ly FLOAT, @hoa FLOAT, @van FLOAT) RETURNS FLOAT AS
BEGIN
	RETURN ROUND((((@toan + @van) * 2) + @ly + @hoa) / 6, 2)
END
GO

CREATE VIEW BaoCaoKetThucNamHoc
as
	SELECT DSHS.MAHS, HO, TEN, NGAYSINH, 
	(
		CASE
		WHEN NU = 1 THEN N'Nữ'
		ELSE N'Nam'
		END
	) AS GIOI_TINH, TOAN, LY, HOA, VAN, 
	DTB = dbo.diemTrungBinh(TOAN, LY, HOA, VAN),
	(
		CASE 
		WHEN dbo.diemTrungBinh(TOAN, LY, HOA, VAN) > 5 
			AND dbo.diemNhoNhat(TOAN, LY, HO, VAN) > 4 THEN N'Lên Lớp'
		ELSE N'Lưu ban'
		END
	) AS Xep_Loai
	FROM dbo.DSHS INNER JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
GO

SELECT * FROM dbo.BaoCaoKetThucNamHoc
GO	
/*4. Tạo view danh sách HOC SINH XUAT SAC bao gồm các học sinh có DTB>=8.5 và 
DTN>=8 với các trường: Lop, Mahs, Hoten, Namsinh (năm sinh), Nu, Toan, Ly, Hoa, Van, 
DTN, DTB */
CREATE VIEW HocSinhXuatSac as
SELECT DSHS.MALOP, DSHS.MAHS, ho, TEN, NGAYSINH, NU, TOAN, LY, HOA, VAN, 
dbo.diemNhoNhat(TOAN, LY, HOA, VAN) as DTN, dbo.diemTrungBinh(TOAN, LY, HOA, VAN) AS DTB
FROM dbo.DSHS JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
	INNER JOIN dbo.LOP ON LOP.MALOP = DSHS.MALOP
WHERE dbo.diemTrungBinh(TOAN, LY, HOA, VAN) >= 8.5 AND
	dbo.diemNhoNhat(TOAN, LY, HOA, VAN) >= 8
GO

SELECT * FROM HocSinhXuatSac
go
/*5. Tạo view danh sách HOC SINH DAT THU KHOA KY THI bao gồm các học sinh xuất 
sắc có DTB lớn nhất với các trường: Lop, Mahs, Hoten, Namsinh, Nu, Toan, Ly, Hoa, Van, 
DTB */
CREATE VIEW HocSinhDatThuKhoaKyThi 
as
SELECT DSHS.MALOP, DSHS.MAHS, HO, TEN, NGAYSINH, NU, TOAN, LY, HOA, VAN, 
	DTB = dbo.diemTrungBinh(TOAN, LY, HOA, VAN)
FROM dbo.DSHS INNER JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
	INNER JOIN dbo.LOP ON LOP.MALOP = DSHS.MALOP
WHERE dbo.diemTrungBinh(TOAN, LY, HOA, VAN) = (SELECT TOP (1) dbo.diemTrungBinh(TOAN, LY, HOA, VAN)
		FROM dbo.DSHS INNER JOIN dbo.DIEM ON DIEM.MAHS = DSHS.MAHS
			INNER JOIN dbo.LOP ON LOP.MALOP = DSHS.MALOP
		ORDER BY dbo.diemTrungBinh(TOAN, LY, HOA, VAN) desc)
GO

SELECT * FROM HocSinhDatThuKhoaKyThi
go

----------------------------BÀI 3----------------------------------
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
