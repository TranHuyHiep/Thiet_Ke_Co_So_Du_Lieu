
--1. Tạo view đưa ra thông tin hóa đơn và tổng tiền của mỗi hóa đơn trong các ngày 
-- trong tháng 4 và tổng tiền của tháng 4/2015
CREATE VIEW cau1 AS
SELECT tChiTietHDB.SoHDB, SUM(SLBan * DonGiaBan) AS tong_tien, NgayBan
FROM dbo.tHoaDonBan JOIN dbo.tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
	JOIN dbo.tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE MONTH(NgayBan) = 4 AND YEAR(NgayBan) = 2014
GROUP BY tChiTietHDB.SoHDB, NgayBan

GO

SELECT SUM(giatri)
FROM (SELECT SUM(SLBan * DonGiaBan) AS giatri
FROM dbo.tHoaDonBan JOIN dbo.tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
	JOIN dbo.tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE MONTH(NgayBan) = 4 AND YEAR(NgayBan) = 2014
GROUP BY tChiTietHDB.SoHDB) AS a

--2. Tạo thủ tục có đầu vào là tháng, đầu ra là số tiền và số lượng hóa đơn thu 
-- được trong tháng đó
go
CREATE PROCEDURE cau2 @thang int, @nam int, @tien int OUTPUT, @soluong int OUTPUT AS
BEGIN
	SELECT @tien = SUM(SoSanPham * DonGia), @soluong = count(tChiTietHDB.SoHDB)
	FROM dbo.tChiTietHDB JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
	WHERE MONTH(NgayBan) = @thang AND YEAR(NgayBan) = @nam
END
GO

DECLARE @tien INT, @soluong INT
EXEC cau2 4, 2014, @tien OUTPUT, @soluong OUTPUT
PRINT @tien
PRINT @soluong


--3. Tạo login TranThanhPhong, tạo user TranThanhPhong cho TranThanhPhong trên
-- CSDL QLBanHang
EXEC sp_addlogin TranThanhPhong, 123, QLBanSach
EXEC sp_adduser TranThanhPhong, TranThanhPhong
-- Phân quyền Select ở trên view ở câu 1 cho TranThanhPhong và TranThanhPhong
-- được phép phân quyền cho người khác
GRANT SELECT ON cau1 TO TranThanhPhong WITH GRANT OPTION
-- Đăng nhập TranThanhPhong để kiểm tra
-- Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLBanSach
EXEC sp_addlogin PhamVanNam, 123, QLBanSach
EXEC sp_adduser PhamVanNam, PhamVanNam
-- Đăng nhập PhamVanNam để kiểm tra
-- Từ login TranThanhPhong, phân quyền Select trên view câu 1 cho PhamVanNam
EXEC SELECT ON cau1 TO PhamVanNam
-- Đăng nhập PhamVanNam để kiểm tra

--4. Tạo view danh sách Nhân viên xuất sắc của tháng 5/2014 bao gồm các nhân viên
-- có tổng hóa đơn nhập và bán là cao nhất trong tháng đó
CREATE FUNCTION cau4(@thang int, @nam int) RETURNS TABLE
AS RETURN(
	SELECT TOP(10) tHoaDonBan.MaNV, TenNV, SUM(SLBan * DonGiaBan + SLNhap * DonGiaNhap) AS tong_tien
	FROM dbo.tNhanVien JOIN dbo.tHoaDonBan ON tHoaDonBan.MaNV = tNhanVien.MaNV
		JOIN dbo.tHoaDonNhap ON tHoaDonNhap.MaNV = tNhanVien.MaNV
		JOIN dbo.tChiTietHDN ON tChiTietHDN.SoHDN = tHoaDonNhap.SoHDN
		JOIN dbo.tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
		JOIN dbo.tSach ON tSach.MaSach = tChiTietHDB.MaSach
	WHERE MONTH(NgayBan) = @thang AND YEAR(NgayBan) = @nam
	GROUP BY tHoaDonBan.MaNV, TenNV
	ORDER BY tong_tien DESC)

SELECT * FROM dbo.cau4(5, 2014)
DROP FUNCTION cau4

DROP VIEW cau4