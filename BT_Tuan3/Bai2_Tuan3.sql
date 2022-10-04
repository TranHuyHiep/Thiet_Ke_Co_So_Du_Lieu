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
QLHocSinh
Phân quyền Select trên view DSHS10A1 cho TranThanhPhong
Đăng nhập TranThanhPhong để kiểm tra
Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLHocSinh
Đăng nhập PhamVanNam để kiểm tra
Tạo view DSHS10A2 tương tự như câu 1
Phân quyền Select trên view DSHS10A2 cho PhamVanNam
Đăng nhập PhamVanNam để kiểm tra */

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
