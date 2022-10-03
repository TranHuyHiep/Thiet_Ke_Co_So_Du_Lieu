--10.	 Tạo hàm đưa ra tổng số tiền đã nhập sách trong một năm với tham số đầu vào là năm
create function tongTien(@nam int) returns int 
	begin
		declare @tong int
		select @tong = TongTien from (select sum(SLBan * DonGiaBan) as TongTien
									from tSach join tChiTietHDB on tSach.MaSach = tChiTietHDB.MaSach
										join tHoaDonBan on tHoaDonBan.SoHDB = tChiTietHDB.SoHDB
										where year(tHoaDonBan.NgayBan) = @nam) as b
		return @tong
	end

select dbo.tongTien(2014)

--11.	Tạo hàm đưa ra danh sách 10 đầu sách bán chạy nhất trong tháng nào đó (tháng là tham số đầu vào)
create function top10sach(@month int, @year int) returns table 
	as
		return (select top(10) MaSach, sum(SLBan) as tongSLBan
					from tHoaDonBan join tChiTietHDB on tHoaDonBan.SoHDB =  tChiTietHDB.SoHDB
					where month(NgayBan) = @month and year(NgayBan) = @year
					group by MaSach
					order by sum(SLBan) desc) 
go 

select * 
from dbo.top10sach(5, 2014)
--12.	 Tạo hàm đưa ra danh sách n nhân viên có doanh thu cao nhất trong một năm với n và năm là tham số đầu vào
create function topNhanVien(@year int, @n int) returns table
as
	return (select top(@n) tNhanVien.MaNV, tNhanVien.TenNV, sum(SLBan * SoLuong) as Tong
				from tNhanVien join tHoaDonBan on tNhanVien.MaNV = tHoaDonBan.MaNV
					join tChiTietHDB on tChiTietHDB.SoHDB = tHoaDonBan.SoHDB
					join tSach on tSach.MaSach = tChiTietHDB.MaSach
				where year(NgayBan) = @year
				group by tNhanVien.MaNV, tNhanVien.TenNV
				order by sum(SLBan * SoLuong) desc) 
go
select *
from topNhanVien(2014, 15)

--13.	Tạo hàm đưa ra thông tin nhân viên (sinh nhật trong ngày là tham số nhập vào)
create function timSinhNhat(@ngay int, @thang int, @nam int) returns table as
	return (select * from tNhanVien
			where DAY(NgaySinh) = @ngay and month(ngaysinh) = @thang and year(ngaysinh) = @nam)
go

select *
from timSinhNhat(12,08,1991)

--14.	Tạo hàm đưa ra danh sách tồn trong kho quá 2 năm 
