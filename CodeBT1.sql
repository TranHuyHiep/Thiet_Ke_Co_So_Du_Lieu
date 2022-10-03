--1.In ra danh sách các sách chỉ lấy (MaSach,TenSach) do Nhà xuất bản Giáo Dục xuất bản.
select Masach, TenSach, TenNXB from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
where TenNXB = N'NXB Giáo Dục'
--2. In ra danh sách các sách có tên bắt đầu là “Ngày”.
select MaSach, TenSach from tSach 
where TenSach like N'Ngày%';
--3. In ra danh sách các sách (MaSach,TenSach) do Nhà xuất bản Giáo Dục có giá từ 100.000 đến 150.000.
select Masach, TenSach, TenNXB from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
where TenNXB = N'NXB Giáo Dục' and DonGiaBan >= 100000 and DonGiaBan <= 150000
--4. In ra danh sách các các sách (MaSach,TenSach) do Nhà xuất bản Giáo Dục hoặc Nhà Xuất Bản Trẻ sản xuất có giá từ 90.000 đến 140.000.
select Masach, TenSach, TenNXB from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
where TenNXB = N'NXB Giáo Dục' or TenNXB = N'NXB Trẻ' and DonGiaBan >= 90000 and DonGiaBan <= 140000
--5. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2014 và ngày 31/12/2014.
select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri, NgayBan  
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where NgayBan =  '2014-01-01' and NgayBan =  '2014-12-31' 
group by tHoaDonBan.SoHDB, NgayBan
--6. In ra các số hóa đơn, trị giá hóa đơn trong tháng 4/2014, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri, NgayBan  
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where NgayBan between '2014-04-01' and '2014-04-30'
group by tHoaDonBan.SoHDB, NgayBan
order by NgayBan ASC, Giatri DESC
--7. In ra danh sách các khách hàng (MaKH, TenKH) đã mua hàng trong ngày 10/4/2014.
select tHoaDonBan.MaKH, TenKH  
from tHoaDonBan inner join tKhachHang on tHoaDonBan.MaKH = tKhachHang.MaKH
where NgayBan =  '2014-04-10'
--8. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Trần Huy” lập trong ngày “11/8/2014”
select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri, NgayBan  
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach inner join tNhanVien on tNhanVien.MaNV = tHoaDonBan.MaNV
where NgayBan =  '2014-08-11' and TenNV = N'Trần Huy'
group by tHoaDonBan.SoHDB, NgayBan
--9. In ra danh sách các sách (MaSach,TenSach) được khách hàng có tên “Nguyễn Đình Sơn” mua trong tháng 8/2014.
select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri, NgayBan  
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach inner join tKhachHang on tKhachHang.MaKH = tHoaDonBan.MaKH
where NgayBan between '2014-08-01' and '2014-08-31' and TenKH = N'Nguyễn Đình Sơn'
group by tHoaDonBan.SoHDB, NgayBan
--10. Tìm các số hóa đơn đã mua sách “Cấu trúc dữ liệu và giải thuật”
select SoHDB from tChiTietHDB inner join tSach on tChiTietHDB.MaSach = tSach.MaSach
where TenSach = N'Cấu trúc dữ liệu và giải thuật';
--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “S01” hoặc “S02”, mỗi sản phẩm mua với số lượng từ 10 đến 20.
select SoHDB from tChiTietHDB
where (MaSach = 'S01' or MaSach = 'S02') and (SLBan between 10 and 20)
--12. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “S10” và “S11”, mỗi sản phẩm mua với số lượng từ 5 đến 10.
select tChiTietHDB.SoHDB from tChiTietHDB inner join (select SoHDB from tChiTietHDB where MaSach = 'S02' and SLBan between 5 and 10) as A on tChiTietHDB.SoHDB = A.SoHDB
where MaSach = 'S01' and SLBan between 5 and 10
--13. In ra danh sách các sách không bán được.
select MaSach
from tSach
where MaSach != all(select MaSach from tChiTietHDB)
--14. In ra danh sách các sách không bán được trong năm 2014.
select MaSach
from tSach
where MaSach != all(select MaSach from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB where YEAR(NgayBan) = 2014)
--15. In ra danh sách các sách của NXB Giáo Dục không bán được trong năm 2014.
select MaSach
from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB
where MaSach != all(select MaSach from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB where YEAR(NgayBan) = 2014) and TenNXB = N'NXB Giáo Dục'
--16. Tìm số hóa đơn đã mua tất cả các sách của NXB Giáo Dục.
select SoHDB
from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
where TenNXB = N'NXB Giáo Dục' 
group by SoHDB
having  Count(tSach.MaNXB) = (select COUNT(tSach.MaNXB) 
								from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
								where TenNXB = N'NXB Giáo Dục' group by tSach.MaNXB)

--17. Có bao nhiêu đầu sách khác nhau được bán ra trong năm 2014.
select Count(MaSach) as N'Số đầu sách' 
from (select distinct MaSach from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB where YEAR(NgayBan) = 2014) as A
--18. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
select Min(Giatri) as N'Giá trị nhỏ nhất', Max(GiaTri)as N'Giá trị lớn nhất'
from (select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri 
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
group by tHoaDonBan.SoHDB, NgayBan) as A
--19. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2014 là bao nhiêu?
select Sum(Giatri)/Count(Giatri)
from (select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri 
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where YEAR(NgayBan) = 2014
group by tHoaDonBan.SoHDB, NgayBan) as A
--20. Tính doanh thu bán hàng trong năm 2014.
select Sum(Giatri)
from (select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri 
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where YEAR(NgayBan) = 2014
group by tHoaDonBan.SoHDB, NgayBan) as A
--21. Tìm số hóa đơn có trị giá cao nhất trong năm 2014.
select SoHDB, Sum(SLBan * DonGiaBan) as GiaTri
from tChiTietHDB inner join tSach on tSach.MaSach = tChiTietHDB.MaSach
group by SoHDB 
Having Sum(SLBan * DonGiaBan) = (select top 1 Sum(SLBan * DonGiaBan) as GiaTriMax 
								from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB 
												inner join tSach on tChitietHDB.MaSach = tSach.MaSach
								where YEAR(NgayBan) = 2014 group by tHoaDonBan.SoHDB order by GiatriMax DESC)
--22. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2014.
select top 1 TenKH
from (select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where YEAR(NgayBan) = 2014
group by tHoaDonBan.SoHDB, NgayBan) as A inner join tHoaDonBan on A.SoHDB = tHoaDonBan.SoHDB inner join tKhachHang on tHoaDonBan.MaKH = tKhachHang.MaKH
group by A.SoHDB, Giatri, TenKH
order by Giatri DESC
--23. In ra danh sách 3 khách hàng (MaKH, TenKH) có doanh số cao nhất.
select top 3 TenKH
from (select tHoaDonBan.SoHDB, Sum(SLBan * DonGiaBan) as Giatri
from tHoaDonBan inner join tChitietHDB on tHoaDonBan.SoHDB = tChitietHDB.SoHDB inner join tSach on tChitietHDB.MaSach = tSach.MaSach
where YEAR(NgayBan) = 2014
group by tHoaDonBan.SoHDB, NgayBan) as A inner join tHoaDonBan on A.SoHDB = tHoaDonBan.SoHDB inner join tKhachHang on tHoaDonBan.MaKH = tKhachHang.MaKH
group by A.SoHDB, Giatri, TenKH
order by Giatri DESC
--24. In ra danh sách các sách có giá bán bằng 1 trong 3 mức giá cao nhất.
select MaSach, TenSach, DonGiaBan
from tSach
where DonGiaBan = Any (select distinct top 3 DonGiaBan from tSach order by DonGiaBan DESC)
order by DonGiaBan DESC
--25. In ra danh sách các sách do NXB Giáo Dục sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select MaSach, TenSach, DonGiaBan
from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB
where DonGiaBan = Any (select distinct top 3 DonGiaBan from tSach order by DonGiaBan DESC) and TenNXB = N'NXB Giáo Dục'
order by DonGiaBan DESC
--26. Tính tổng số đầu sách do NXB Giáo Dục xuất bản.
select COUNT(tSach.MaNXB) as N'Tổng đầu sách của NXB Giáo Dục'
from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
where TenNXB = N'NXB Giáo Dục' group by tSach.MaNXB
--27. Tính tổng số sách của từng NXB.
select TenNXB, COUNT(tSach.MaNXB) as N'Tổng đầu sách của NXB Giáo Dục'
from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB 
group by tSach.MaNXB, TenNXB
--28. Với từng NXB, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
select MaNXB, Min(DonGiaBan) , Max(DonGiaBan), AVG(DonGiaBan)
from tSach 
group by MaNXB
--29. Tính doanh thu bán hàng mỗi ngày.
select NgayBan,  Sum(SLBan * DonGiaBan)
from tHoaDonBan inner join tChiTietHDB on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB inner join tSach on tChiTietHDB.MaSach = tSach.MaSach
group by NgayBan
--30. Tính tổng số lượng của từng sách bán ra trong tháng 10/2014.
select MaSach, Sum(SLBan) as 'Tổng số lượng bán'
from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
where YEAR(NgayBan) = 2014 and MONTH(NgayBan) = 10
group by MaSach
--31. Tính doanh thu bán hàng của từng tháng trong năm 2014 (kể cả những tháng không có doanh thu, VD: Tháng 1: 0; Tháng 2: 12000000; Tháng 3: 0; Tháng ....)
select MONTH(NgayBan) as 'Tháng', Sum(SLBan * DonGiaBan) as 'Doanh số'
from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
where YEAR(NgayBan) = 2014 
group by MONTH(NgayBan)

select
ISNULL(sum(case Month(NgayBan) when 1 then (SLBan * DonGiaBan) end), 0) as Thang1,
ISNULL(sum(case Month(NgayBan) when 2 then (SLBan * DonGiaBan) end), 0) as Thang2,
ISNULL(sum(case Month(NgayBan) when 3 then (SLBan * DonGiaBan) end), 0) as Thang3,
ISNULL(sum(case Month(NgayBan) when 4 then (SLBan * DonGiaBan) end), 0) as Thang4,
ISNULL(sum(case Month(NgayBan) when 5 then (SLBan * DonGiaBan) end), 0) as Thang5,
ISNULL(sum(case Month(NgayBan) when 6 then (SLBan * DonGiaBan) end), 0) as Thang6,
ISNULL(sum(case Month(NgayBan) when 7 then (SLBan * DonGiaBan) end), 0) as Thang7,
ISNULL(sum(case Month(NgayBan) when 8 then (SLBan * DonGiaBan) end), 0) as Thang8,
ISNULL(sum(case Month(NgayBan) when 9 then (SLBan * DonGiaBan) end), 0) as Thang9,
ISNULL(sum(case Month(NgayBan) when 10 then (SLBan * DonGiaBan) end), 0) as Thang10,
ISNULL(sum(case Month(NgayBan) when 11 then (SLBan * DonGiaBan) end), 0) as Thang11,
ISNULL(sum(case Month(NgayBan) when 12 then (SLBan * DonGiaBan) end), 0) as Thang12
from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
where YEAR(NgayBan) = 2014 

--32. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select tChiTietHDB.SoHDB, Count(distinct MaSach) as SL
from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
group by tChiTietHDB.SoHDB
Having Count(MaSach) >= 4
--33. Tìm hóa đơn có mua 3 sách do NXB Giáo Dục xuất bản (3 sách khác nhau).
select tChiTietHDB.SoHDB, Count(distinct tSach.MaSach) as SL
from tChiTietHDB inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB inner join tSach on tSach.MaSach = tChiTietHDB.MaSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB
where  TenNXB = N'NXB Giáo Dục'
group by tChiTietHDB.SoHDB
Having Count(tSach.MaSach) >= 3
--34. Tìm khách hàng (MaKH, TenKH) có số lần mua hàng nhiều nhất.
select tKhachHang.MaKH, TenKH
from tKhachHang inner join tHoaDonBan on tKhachHang.MaKH = tHoaDonBan.MaKH
group by tKhachHang.MaKH, TenKH
Having COUNT(SoHDB) = all (select top 1 COUNT(SoHDB)
								from tKhachHang inner join tHoaDonBan on tKhachHang.MaKH = tHoaDonBan.MaKH
								group by tKhachHang.MaKH 
								order by COUNT(SoHDB) DESC)
--35. Tháng mấy trong năm 2014, doanh số bán hàng cao nhất ?
select Month(NgayBan) as 'Tháng'
from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
where YEAR(NgayBan) = 2014 
group by MONTH(NgayBan)
Having Sum(SLBan * DonGiaBan) = (select top 1 Sum(SLBan * DonGiaBan)
														from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach 
																	inner join tHoaDonBan on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
														where YEAR(NgayBan) = 2014 
														group by MONTH(NgayBan)
														order by Sum(SLBan * DonGiaBan) DESC)

--36. Tìm sách có tổng số lượng bán ra thấp nhất trong năm 2014.
select MaSach, Sum(SLBan)
from tHoaDonBan inner join tChiTietHDB on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
where YEAR(NgayBan) = 2014
group by MaSach
Having Sum(SLBan) = (select top 1 Sum(SLBan)
								from tHoaDonBan inner join tChiTietHDB on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
								where YEAR(NgayBan) = 2014
								group by MaSach
								order by Sum(SLBan) ASC)
--37. Mỗi NXB, tìm sách (MaSach,TenSach) có giá bán cao nhất.
Select B.MaNXB, TenSach, MaSach
from tSach  inner join (select tSach.MaNXB, Max(DonGiaBan) as DonGia		
							from tSach inner join tNhaXuatBan on tNhaXuatBan.MaNXB = tSach.MaNXB 
							group by tSach.MaNXB) B on tSach.MaNXB = B.MaNXB where DonGiaBan = DonGia
--38. Giảm giá sách 10% cho các sách của NXB Giáo Dục
update tSach set DonGiaBan = DonGiaBan * 0.9 
where MaSach = any(select MaSach from tSach inner join tNhaXuatBan on tSach.MaNXB = tNhaXuatBan.MaNXB where TenNXB = N'NXB Giáo Dục')
--39. Thêm trưởng tổng tiền cho bảng tHoaDonBan rồi cập nhật tổng tiền của hóa đơn cho trường này.
alter table tHoaDonBan
add TongTien money
update tHoaDonBan set TongTien = DoanhSo from (select SoHDB, Sum(SLBan * DonGiaBan) as DoanhSo
									from tSach inner join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach
									group by SoHDB) bangA
where tHoaDonBan.SoHDB = bangA.SoHDB
--40. Giảm 10% trên tổng hóa đơn cho các hóa đơn có trị giá trên 500.000 trong tháng 9/2014
update tHoaDonBan set TongTien = TongTien * 0.9 
where TongTien > 500000 and YEAR(NgayBan) = 2014 and MONTH(NgayBan) = 09
--41. Tính tổng số lượng sách nhập trong năm 2014
select Sum(SLNhap) as 'Tổng nhập'
from tHoaDonNhap inner join tChiTietHDN on tHoaDonNhap.SoHDN = tChiTietHDN.SoHDN
where YEAR(NgayNhap) = 2014
--42. Tính tổng số lượng sách bán trong năm 2014
select Sum(SLBan) as 'Tổng nhập'
from tHoaDonBan inner join tChiTietHDB on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
where YEAR(NgayBan) = 2014
--43. Tính tổng tiền đã bán trong năm 2014
select Sum(TongTien)
from tHoaDonBan 
where YEAR(NgayBan) = 2014
--44. Tính tổng tiền đã nhập trong năm 2014
select Sum(SLNhap * DonGiaNhap)
from tHoaDonNhap inner join tChiTietHDN on tHoaDonNhap.SoHDN = tChiTietHDN.SoHDN inner join tSach on tSach.MaSach = tChiTietHDN.MaSach
where YEAR(NgayNhap) = 2014
--45. Xóa những hóa đơn do nhân viên "Trần Huy" lập (lưu ý xóa chi tiết hóa đơn trước)
Delete tChitietHDB where SoHDB = any (select tHoaDonBan.SoHDB from tHoaDonBan inner join tNhanVien on tNhanVien.MaNV = tHoaDonBan.MaNV where TenNV = N'Trần Huy')
Delete tHoaDonBan where SoHDB = any (select tHoaDonBan.SoHDB from tHoaDonBan inner join tNhanVien on tNhanVien.MaNV = tHoaDonBan.MaNV where TenNV = N'Trần Huy')
--46. Đổi tên "NXB Thăng Long" thành "NXB Văn học
update tNhaXuatBan set TenNXB = 'NXB Văn Học' where TenNXB = N'NXB Thăng Long'