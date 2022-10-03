-- 1. tạo view in ra danh sách các sách của nhà xuất bản giáo dục nhap trong năm 2021
create view SachNXBGD as
select tNhaXuatBan.MaNXB, tSach.TenSach
from tSach join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
	join tChiTietHDN on tSach.MaSach = tChiTietHDN.MaSach
	join tHoaDonNhap on tHoaDonNhap.SoHDN = tChiTietHDN.SoHDN
where tNhaXuatBan.TenNXB = N'NXB Giáo Dục' and year(tHoaDonNhap.NgayNhap) = 2014;

-- 2. Tạo view thống kê các sách không bán được trong năm 2021

create view SachKBDC2021 as
select *
from tSach
where tSach.MaSach not in(
	select tSach.MaSach
	from tSach join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach
		join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB 
	where year(tHoaDonBan.NgayBan) = 2014
	group by tSach.MaSach)

select *
from SachKBDC2021
-- 3. Tạo view thống kê số khách hàng có trong hóa đơn cao nhất trong năm 2021
select top 10 tKhachHang.MaKH, sum(tChiTietHDB.SLBan * tSach.DonGiaBan) as TongChiTieu
from tKhachHang join tHoaDonBan on tKhachHang.MaKH = tHoaDonBan.MaKH
	join tChiTietHDB on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
	join tSach on tSach.MaSach = tChiTietHDB.MaSach
where year(tHoaDonBan.NgayBan) = 2014
group by tKhachHang.MaKH
order by TongChiTieu DESC
-- 4. Tạo view thống kê số lượng sách bán được trong năm 2021 và số lượng sách còn lại trong kho
-- tồn kho ứng với mỗi đầu sách
select tSach.MaSach
from tSach join tChiTietHDN on tSach.MaSach = tChiTietHDN.MaSach
	join tHoaDonNhap on tChiTietHDN.SoHDN = tChiTietHDN.SoHDN
where year(tHoaDonNhap.NgayNhap) < 2014
group by tSach.MaSach

select tSach.MaSach
from tSach join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach
	join tHoaDonBan on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
where year(tHoaDonBan.NgayBan) = 2014
group by tSach.MaSach