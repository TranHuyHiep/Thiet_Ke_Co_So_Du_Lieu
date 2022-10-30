--Câu 1: Tạo hàm đưa ra danh sách các nhân viên có địa chỉ cho trước với địa chỉ là 
--tham số đầu vào.
CREATE FUNCTION cau1(@DiaChi NVARCHAR(30)) RETURNS TABLE AS
RETURN
	SELECT *
	FROM tNhanVien
	WHERE DiaChi = @DiaChi
GO

SELECT * from dbo.cau1(N'Hà Nội')
GO

--Câu 2: Tạo thủ tục có đầu vào là tỉnh (thành phố) đầu ra là số nhân viên nam, số nhân 
--viên nữ của tỉnh (thành phố) đó.
ALTER PROCEDURE cau2 @DiaChi NVARCHAR(30), @SoNam INT OUT, @SoNu INT OUT
AS
BEGIN
	SELECT @SoNam = COUNT(MaNV)
	FROM dbo.tNhanVien
	WHERE @DiaChi = DiaChi AND GioiTinh = N'Nam'

	SELECT @SoNu = COUNT(MaNV)
	FROM dbo.tNhanVien
	WHERE @DiaChi = DiaChi AND GioiTinh = N'Nữ'
END
GO

DECLARE @SoNam INT, @SoNu INT
EXEC cau2 N'Hà Nội', @SoNam OUT, @SoNu OUT
PRINT @SoNam
PRINT @SoNu
GO

--Câu 3: 
-- Tạo view 
-- đưa ra thông tin các nhân viên và hóa đơn bán ở HN trong năm 2014
-- đưa ra thông tin các nhân viên và hóa đơn nhập ở HN trong năm 2014
--  nhân viên ở HN trong năm 2014CREATE VIEW cau3 AS	SELECT tNhanVien.MaNV, TenNV, DiaChi, SoHDB AS SoHD, NgayBan AS Ngay	FROM dbo.tNhanVien JOIN dbo.tHoaDonBan ON tHoaDonBan.MaNV = tNhanVien.MaNV	WHERE DiaChi = N'Hà Nội' AND YEAR(NgayBan) = 2014	UNION	SELECT tNhanVien.MaNV, TenNV, DiaChi, SoHDN AS SoHD, NgayNhap AS Ngay	FROM dbo.tNhanVien JOIN dbo.tHoaDonNhap ON tHoaDonNhap.MaNV = tNhanVien.MaNV	WHERE DiaChi = N'Hà Nội' AND YEAR(NgayNhap) = 2014GOSELECT * FROM dbo.cau3--Câu 4: Thêm trường Tổng tiền và bảng nhân viên, cập nhật tự động cho trường này 
--mỗi khi thêm một chi tiết hóa đơn bán
ALTER TABLE dbo.tNhanVien
ADD TongTien MONEY
GO

ALTER TRIGGER cau4 ON tChiTietHDB
FOR INSERT AS 
BEGIN
	DECLARE @SoHDB NVARCHAR(30), @DonGiaBan MONEY, @SoLuong INT, @MaNV NVARCHAR(30)

	SELECT @SoHDB = tHoaDonBan.SoHDB, @SoLuong = SoLuong, @MaNV = MaNV, @DonGiaBan = DonGiaBan
	FROM Inserted JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = Inserted.SoHDB
		JOIN dbo.tSach ON tSach.MaSach = Inserted.MaSach

	UPDATE dbo.tNhanVien
	SET TongTien = isnull(TongTien, 0) + (@SoLuong * @DonGiaBan)
	WHERE MaNV = @MaNV
END	
GO

INSERT INTO dbo.tChiTietHDB
(
    SoHDB,
    MaSach,
    SLBan,
    KhuyenMai
)
VALUES
(   N'HDB01', -- SoHDB - nvarchar(10)
    N'S06', -- MaSach - nvarchar(10)
    5,   -- SLBan - int
    N'0'  -- KhuyenMai - nvarchar(100)
    )

SELECT * FROM dbo.tNhanVien
SELECT * FROM dbo.tChiTietHDB
SELECT * FROM dbo.tHoaDonBan

--Câu 5: Tạo login TranThanhPhong, tạo user TranThanhPhong1 cho TranThanhPhong 
--trên CSDL QLBanSach
EXEC sp_addlogin TranThanhPhong1, 1, Buoi1__QLBanSach
EXEC sp_adduser TranThanhPhong1

--Phân quyền Select, update trên bảng tSach cho TranThanhPhong và TranThanhPhong 
--được phép phân quyền cho người khác
GRANT SELECT, UPDATE ON dbo.tSach TO TranThanhPhong1 WITH GRANT OPTION
--Đăng nhập TranThanhPhong để kiểm tra

--Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLBanSach
EXEC sp_addlogin PhamVanNam1, 1, Buoi1__QLBanSach
EXEC sp_adduser PhamVanNam1
GO
--Đăng nhập PhamVanNam để kiểm tra

--Từ login TranThanhPhong, phân quyền Select trên bảng tSach cho PhamVanNam
--Đăng nhập PhamVanNam để kiểm tra

--Câu 6: Tạo view đưa ra những nhân viên có tổng tiền hóa đơn bán cao nhất và cao nhì 
--trong năm 2014
CREATE VIEW cau6 
AS
	SELECT tHoaDonBan.MaNV, TenNV, SUM(SoLuong * DonGiaBan) AS TongTienBanDuoc
	FROM dbo.tSach JOIN dbo.tChiTietHDB ON tChiTietHDB.MaSach = tSach.MaSach
		JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
		JOIN dbo.tNhanVien ON tNhanVien.MaNV = tHoaDonBan.MaNV
	WHERE YEAR(NgayBan) = 2014
	GROUP BY tHoaDonBan.MaNV, TenNV
	HAVING SUM(SoLuong * DonGiaBan) IN (SELECT DISTINCT TOP(2) SUM(SoLuong * DonGiaBan) AS TongTienBan
		FROM dbo.tSach JOIN dbo.tChiTietHDB ON tChiTietHDB.MaSach = tSach.MaSach
			JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
			JOIN dbo.tNhanVien ON tNhanVien.MaNV = tHoaDonBan.MaNV
		WHERE YEAR(NgayBan) = 2014
		GROUP BY tHoaDonBan.MaNV, TenNV
		ORDER BY TongTienBan DESC)
GO

SELECT * FROM dbo.cau6