-- câu 1
create VIEW cau1 as
SELECT 
ISNULL(sum(case day(NgayNhap) when 1 then (SLNhap * DonGiaBan) end), 0) as Ngay1,
ISNULL(sum(case day(NgayNhap) when 2 then (SLNhap * DonGiaBan) end), 0) as Ngay2,
ISNULL(sum(case day(NgayNhap) when 3 then (SLNhap * DonGiaBan) end), 0) as Ngay3,
ISNULL(sum(case day(NgayNhap) when 4 then (SLNhap * DonGiaBan) end), 0) as Ngay4,
ISNULL(sum(case day(NgayNhap) when 5 then (SLNhap * DonGiaBan) end), 0) as Ngay5,
ISNULL(sum(case day(NgayNhap) when 6 then (SLNhap * DonGiaBan) end), 0) as Ngay6,
ISNULL(sum(case day(NgayNhap) when 7 then (SLNhap * DonGiaBan) end), 0) as Ngay7,
ISNULL(sum(case day(NgayNhap) when 8 then (SLNhap * DonGiaBan) end), 0) as Ngay8,
ISNULL(sum(case day(NgayNhap) when 9 then (SLNhap * DonGiaBan) end), 0) as Ngay9,
ISNULL(sum(case day(NgayNhap) when 10 then (SLNhap * DonGiaBan) end), 0) as Ngay10,
ISNULL(sum(case day(NgayNhap) when 11 then (SLNhap * DonGiaBan) end), 0) as Ngay11,
ISNULL(sum(case day(NgayNhap) when 12 then (SLNhap * DonGiaBan) end), 0) as Ngay12,
ISNULL(sum(case day(NgayNhap) when 13 then (SLNhap * DonGiaBan) end), 0) as Ngay13,
ISNULL(sum(case day(NgayNhap) when 14 then (SLNhap * DonGiaBan) end), 0) as Ngay14,
ISNULL(sum(case day(NgayNhap) when 15 then (SLNhap * DonGiaBan) end), 0) as Ngay15,
ISNULL(sum(case day(NgayNhap) when 16 then (SLNhap * DonGiaBan) end), 0) as Ngay16,
ISNULL(sum(case day(NgayNhap) when 17 then (SLNhap * DonGiaBan) end), 0) as Ngay17,
ISNULL(sum(case day(NgayNhap) when 18 then (SLNhap * DonGiaBan) end), 0) as Ngay18,
ISNULL(sum(case day(NgayNhap) when 19 then (SLNhap * DonGiaBan) end), 0) as Ngay19,
ISNULL(sum(case day(NgayNhap) when 20 then (SLNhap * DonGiaBan) end), 0) as Ngay20,
ISNULL(sum(case day(NgayNhap) when 21 then (SLNhap * DonGiaBan) end), 0) as Ngay21,
ISNULL(sum(case day(NgayNhap) when 22 then (SLNhap * DonGiaBan) end), 0) as Ngay22,
ISNULL(sum(case day(NgayNhap) when 23 then (SLNhap * DonGiaBan) end), 0) as Ngay23,
ISNULL(sum(case day(NgayNhap) when 24 then (SLNhap * DonGiaBan) end), 0) as Ngay24,
ISNULL(sum(case day(NgayNhap) when 25 then (SLNhap * DonGiaBan) end), 0) as Ngay25,
ISNULL(sum(case day(NgayNhap) when 26 then (SLNhap * DonGiaBan) end), 0) as Ngay26,
ISNULL(sum(case day(NgayNhap) when 27 then (SLNhap * DonGiaBan) end), 0) as Ngay27,
ISNULL(sum(case day(NgayNhap) when 28 then (SLNhap * DonGiaBan) end), 0) as Ngay28,
ISNULL(sum(case day(NgayNhap) when 29 then (SLNhap * DonGiaBan) end), 0) as Ngay29,
ISNULL(sum(case day(NgayNhap) when 30 then (SLNhap * DonGiaBan) end), 0) as Ngay30,
ISNULL(sum(case day(NgayNhap) when 31 then (SLNhap * DonGiaBan) end), 0) as Ngay31
FROM dbo.tSach JOIN dbo.tChiTietHDN ON tChiTietHDN.MaSach = tSach.MaSach 
	JOIN dbo.tHoaDonNhap ON tHoaDonNhap.SoHDN = tChiTietHDN.SoHDN
WHERE MONTH(NgayNhap) = 5 AND YEAR(NgayNhap) = 2014

SELECT * FROM cau1
-- câu 2
CREATE FUNCTION	cau2(@tenNCC nvarchar(15)) RETURNS TABLE AS
RETURN(
	SELECT tChiTietHDN.SoHDN, SUM(DonGiaNhap * SLNhap) AS tri_gia
	FROM dbo.tNhaCungCap join dbo.tHoaDonNhap ON tHoaDonNhap.MaNCC = tNhaCungCap.MaNCC 
		JOIN dbo.tChiTietHDN ON tChiTietHDN.SoHDN = tHoaDonNhap.SoHDN
		JOIN dbo.tSach ON tSach.MaSach = tChiTietHDN.MaSach
	WHERE @tenNCC = TenNCC
	GROUP BY tChiTietHDN.SoHDN
)

SELECT * FROM cau2(N'Thái Hà')
-- câu 3
EXEC sp_addlogin PhamKhanhToan, 1, QLBanSach
EXEC sp_adduser PhamKhanhToan, PhamKhanhToan

GRANT SELECT ON cau1 TO PhamKhanhToan WITH GRANT OPTION

EXEC sp_addlogin NguyenManhCuong, 1, QLBanSach
EXEC sp_adduser NguyenManhCuong, NguyenManhCuong
-- câu 4

CREATE VIEW cau4 AS
SELECT TOP 10 WITH TIES tChiTietHDB.MaSach, TenSach, SUM(SLBan) AS TongSoLuongBan
FROM dbo.tSach JOIN dbo.tChiTietHDB ON tChiTietHDB.MaSach = tSach.MaSach
	JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
WHERE YEAR(NgayBan) = 2014
GROUP BY tChiTietHDB.MaSach, TenSach
ORDER BY TongSoLuongBan DESC

SELECT * FROM cau4