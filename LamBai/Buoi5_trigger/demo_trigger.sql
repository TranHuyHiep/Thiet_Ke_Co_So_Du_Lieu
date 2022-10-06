
alter table tchitiethdb
add ThanhTien money
go

create trigger ThanhTien on dbo.tChiTietHDB
for insert,  update as
begin
declare @sohdb nvarchar(10), @dongia money, @thanhtien money, @masach nvarchar(10)
select @sohdb = sohdb, @masach = masach from inserted
select @dongia = dongiaban from tsach where MaSach = @masach
update tChiTietHDB set ThanhTien = SLBan * @dongia 
where SoHDB = @sohdb and MaSach = @masach
end
go

drop trigger ThanhTien
go

----------------------- don gia ------------------------------------
alter table tchitiethdb
add DonGia money
go

create trigger UpdateDonGia on dbo.tchitiethdb
for insert, update as
begin
declare @masach nvarchar(10), @dongia money, @sohdb nvarchar(10)
select @masach = MaSach, @sohdb = SoHDB from inserted
select @dongia = DonGiaBan from tSach where MaSach = @masach
update tChiTietHDB set DonGia = @dongia where SoHDB = @sohdb and MaSach = @masach 
end
go

drop trigger UpdateDonGia
go
-- Câu 3: Thêm trường tổng hóa đơn vào bảng khách hàng vầ cập nhật tự động cho trường này mỗi khi thêm hóa đơn
alter table tKhachHang
add TongHoaDon int
go

create trigger TongHoaDon on tHoaDonBan
for insert as
begin
declare @makh nvarchar(10)
select @makh = makh from inserted
update tKhachHang set TongHoaDon = isnull(TongHoaDon, 0) + 1
where MaKH = @makh
end

select * from tHoaDonBan
select * from tKhachHang
insert into tHoaDonBan values
	('HDB24', 'NV02', '2014-08-11 00:00:00.000', 'KH04', NULL)
-- Câu 4: Thêm trường số sản phẩm vào bảng hóa đơn bán, 
-- cập nhật tự động cho trường này mỗi khi thêm, xóa, sửa chi tiết hóa đơn
alter table tHoaDonBan
add SoSanPham int

create trigger CapNhatSoSanPham on dbo.tChiTietHDB
for insert, update as
begin 
declare @sohdb nvarchar(10)
select @sohdb from inserted
update tHoaDonBan set SoSanPham = A.TT
from (select count(*) + 1 as TT
	from tChiTietHDB where @sohdb = SoHDB) as A
where Sohdb = @sohdb 
end

drop trigger CapNhatSoSanPham