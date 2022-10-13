
--1. Tạo view đưa ra thông tin hóa đơn và tổng tiền của mỗi hóa đơn trong các ngày 
-- trong tháng 4 và tổng tiền của tháng 4/2015
SELECT tChiTietHDB.SoHDB, SUM(SLBan * DonGiaBan) AS tong_tien, NgayBan
FROM dbo.tHoaDonBan JOIN dbo.tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
	JOIN dbo.tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE MONTH(NgayBan) = 4 AND YEAR(NgayBan) = 2014
GROUP BY tChiTietHDB.SoHDB, NgayBan

SELECT SUM(giatri)
FROM (SELECT SUM(SLBan * DonGiaBan) AS giatri
FROM dbo.tHoaDonBan JOIN dbo.tChiTietHDB ON tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
	JOIN dbo.tSach ON tSach.MaSach = tChiTietHDB.MaSach
WHERE MONTH(NgayBan) = 4 AND YEAR(NgayBan) = 2014
GROUP BY tChiTietHDB.SoHDB) AS a

--2. Tạo thủ tục có đầu vào là tháng, đầu ra là số tiền và số lượng hóa đơn thu 
-- được trong tháng đó

--3. Tạo login TranThanhPhong, tạo user TranThanhPhong cho TranThanhPhong trên
-- CSDL QLBanHang
-- Phân quyền Select ở trên view ở câu 1 cho TranThanhPhong và TranThanhPhong
-- được phép phân quyền cho người khác
-- Đăng nhập TranThanhPhong để kiểm tra
-- Tạo login PhamVanNam, tạo PhamVanNam cho PhamVanNam trên CSDL QLBanSach
-- Đăng nhập PhamVanNam để kiểm tra
-- Từ login TranThanhPhong, phân quyền Select trên view câu 1 cho PhamVanNam
-- Đăng nhập PhamVanNam để kiểm tra

--4. Tạo view danh sách Nhân viên xuất sắc của tháng 5/2014 bao gồm các nhân viên
-- có tổng hóa đơn nhập và bán là cao nhất trong tháng đó