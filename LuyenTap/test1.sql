--Sử dụng cơ sở dữ liệu quản lý bán sách.
--Câu 1: Tạo hàm đưa ra danh sách các nhân viên có địa chỉ cho trước với địa chỉ là 
--tham số đầu vào.
CREATE FUNCTION cau1(@DiaChi NVARCHAR(30)) RETURNS TABLE AS 
RETURN 
	SELECT * 
	FROM dbo.tNhanVien
	WHERE @DiaChi = DiaChi
GO

SELECT * FROM cau1(N'Hà Nội')
GO

SELECT * FROM dbo.tNhanVien
--Câu 2: Tạo thủ tục có đầu vào là tỉnh (thành phố) đầu ra là số nhân viên nam, số nhân 
--viên nữ của tỉnh (thành phố) đó.
CREATE PROCEDURE cau2 @Tinh nvarchar(20), @SoNam int OUT, @SoNu int OUT
AS 
BEGIN 
	SELECT @SoNam = COUNT(manv)
	FROM dbo.tNhanVien
	WHERE GioiTinh = N'Nam' AND @Tinh = DiaChi

	SELECT @SoNu = COUNT(manv)
	FROM dbo.tNhanVien
	WHERE GioiTinh = N'Nữ' AND @Tinh = DiaChi
END
GO

DECLARE @SoNam INT, @SoNu INT
EXEC cau2 N'Hà Nội', @SoNam OUT, @SoNu OUT
PRINT @SoNam
PRINT @SoNu
GO
--Câu 3: Tạo view đưa ra thông tin các nhân viên và hóa đơn bán họ đã 
--xử lý của các nhân viên ở HN trong năm 2014

ALTER VIEW Cau3 
AS 
	SELECT tHoaDonBan.MaNV, TenNV, DiaChi, NgayBan
	FROM dbo.tNhanVien JOIN dbo.tHoaDonBan ON tHoaDonBan.MaNV = tNhanVien.MaNV
	WHERE DiaChi = N'Hà Nội' AND YEAR(NgayBan) = 2014

SELECT * FROM Cau3
GO

--Câu 3: Tạo view đưa ra thông tin các nhân viên, hóa đơn nhập và hóa đơn bán họ đã 
--xử lý của các nhân viên ở HN trong năm 2014

SELECT tNhanVien.MaNV, TenNV, DiaChi, SoHDN AS SoHD, 'HDN' AS LoaiHD, NgayNhap AS NgayLapHD
FROM dbo.tNhanVien JOIN dbo.tHoaDonNhap ON tHoaDonNhap.MaNV = tNhanVien.MaNV
WHERE DiaChi = N'Hà Nội' AND YEAR(NgayNhap) = 2014
UNION
SELECT tNhanVien.MaNV, TenNV, DiaChi, SoHDB, 'HDB' AS LoaiHD, NgayBan
FROM dbo.tNhanVien JOIN dbo.tHoaDonBan ON tHoaDonBan.MaNV = tNhanVien.MaNV
WHERE DiaChi = N'Hà Nội' AND YEAR(NgayBan) = 2014

--Câu 4: Thêm trường Tổng tiền vào bảng nhân viên, cập nhật tự động cho trường này 
--mỗi khi thêm một chi tiết hóa đơn bán

ALTER TABLE dbo.tNhanVien
ADD TongTien MONEY
GO

SELECT * FROM dbo.tNhanVien 
SELECT * FROM dbo.tHoaDonBan
SELECT * FROM dbo.tChiTietHDB
GO

ALTER TRIGGER cau4 ON dbo.tChiTietHDB
FOR INSERT AS
BEGIN
	DECLARE @SoHDB NVARCHAR(20), @MaNV NVARCHAR(20), @SoLuong INT, @DonGiaBan MONEY

	SELECT @SoHDB = tHoaDonBan.SoHDB, @SoLuong = SLBan, @MaNV = MaNV, @DonGiaBan = DonGiaBan 
	FROM Inserted JOIN dbo.tSach ON tSach.MaSach = Inserted.MaSach
		JOIN dbo.tHoaDonBan ON tHoaDonBan.SoHDB = Inserted.SoHDB

	UPDATE dbo.tNhanVien
	SET TongTien = ISNULL(TongTien, 0) + (@DonGiaBan * @SoLuong) 
	WHERE @MaNV = MaNV
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
(   N'HDB12', -- SoHDB - nvarchar(10)
    N'S01', -- MaSach - nvarchar(10)
    8,   -- SLBan - int
    N'null'  -- KhuyenMai - nvarchar(100)
    )
GO

--Câu 5: Tạo login TranThanhPhong, tạo user TranThanhPhong cho TranThanhPhong 
--trên CSDL QLBanSach
--Phân quyền Select, update trên bảng tSach cho TranThanhPhong và TranThanhPhong 
--được phép phân quyền cho người khác
--Đăng nhập TranThanhPhong để kiểm tra
--Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLBanSach
--Đăng nhập PhamVanNam để kiểm tra
--Từ login TranThanhPhong, phân quyền Select trên bảng tSach cho PhamVanNam
--Đăng nhập PhamVanNam để kiểm tra
EXEC sp_addlogin TranThanhPhong, 1, QLBanSach
EXEC sp_adduser TranThanhPhong

EXEC sp_addlogin PhamVanNam, 1, QLBanSach
EXEC sp_adduser PhamVanNam

GRANT SELECT, UPDATE ON dbo.tSach TO TranThanhPhong WITH GRANT OPTION

--Câu 6: Tạo view đưa ra những nhân viên có tổng tiền hóa đơn bán cao nhất và cao nhì 
--trong năm 2014 
create or alter view viewCau6
as
select nv.MaNV, nv.TenNV ,nv.NgaySinh , nv.GioiTinh,nv.DiaChi,nv.DienThoai, SUM(SLBan * s.DonGiaBan) as TongTien 
from tNhanVien nv join tHoaDonBan hdb on nv.MaNV=hdb.MaNV
	join tChiTietHDB cthdb on cthdb.SoHDB = hdb.SoHDB
	join tSach s on s.MaSach = cthdb.MaSach
where YEAR(hdb.NgayBan) = 2014
group by nv.MaNV, nv.TenNV ,nv.NgaySinh , nv.GioiTinh,nv.DiaChi,nv.DienThoai
having SUM(SLBan * s.DonGiaBan) in
(
select distinct top(2) SUM(SLBan * s.DonGiaBan) as TongTien 
--distinct để chỉ lấy giá trị cao nhất và cao nhì
from tHoaDonBan hdb join tChiTietHDB cthdb on cthdb.SoHDB = hdb.SoHDB
	join tSach s on s.MaSach = cthdb.MaSach
where YEAR(hdb.NgayBan) = 2014
group by hdb.MaNV
order by TongTien desc
)