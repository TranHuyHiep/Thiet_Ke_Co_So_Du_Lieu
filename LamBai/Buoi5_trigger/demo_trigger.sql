
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


create trigger C4TongHoaDon on tHoaDonBan
for insert, update,  delete as
begin
	declare @inmakh nvarchar(10), @delmakh nvarchar(10), @in int, @de int
	select @inmakh = makh, @in = 1 from inserted
	select @delmakh = makh, @de = 1 from deleted
	update tKhachHang set TongHoaDon = isnull(TongHoaDon, 0) + isnull(@in, 0) where makh = @inmakh
	update tKhachHang set TongHoaDon = isnull(TongHoaDon, 0) - isnull(@de, 0) where makh = @delmakh
end

select * from tHoaDonBan
select * from tKhachHang
insert into tHoaDonBan values
	('HDB37', 'NV03', '2014-08-11 00:00:00.000', 'KH01', NULL)

select * from tKhachHang where makh = 'KH01'
update tHoaDonBan set manv = 'NV06' where SoHDB = 'HDB37'
select * from tKhachHang where MaKH = 'KH01'

update tHoaDonBan set MaKH = 'KH02' where SoHDB = 'HDB37'
select * from tKhachHang where MaKH = 'KH01'
select * from tKhachHang where MaKH = 'KH02'


select * from tKhachHang where MaKH = 'KH06'
delete from tHoaDonBan where SoHDB = 'HDB37'
select * from tKhachHang where MaKH = 'KH06'

drop trigger C4TongHoaDon

-- Câu 5: Thêm trường số sản phẩm vào bảng hóa đơn bán, cập nhật tự động cho trường này mỗi khi thêm, xóa ,sửa
--	chi tiết hóa đơn
CREATE TRIGGER cau5 ON tChiTietHDB
FOR INSERT, UPDATE, DELETE AS
BEGIN
	DECLARE @insohdb NVARCHAR(10), @insoluong INT, @desohdb NVARCHAR(10), @desoluong INT
	SELECT @insohdb = SoHDb, @insoluong = SLBan FROM Inserted
	SELECT @desohdb = SoHDb, @desoluong = SLBan FROM Deleted
	UPDATE dbo.tHoaDonBan SET SoHDB = ISNULL(SoSanPham, 0) + ISNULL(@insoluong, 0) - ISNULL(@desoluong)
END

SELECT * FROM dbo.tChiTietHDB
SELECT * FROM dbo.tHoaDonBan

INSERT INTO dbo.tChiTietHDB
(
    SoHDB,
    MaSach,
    SLBan,
    KhuyenMai,
    ThanhTien,
    DonGia
)
VALUES
(   N'HDB12',  -- SoHDB - nvarchar(10)
    N'S01',  -- MaSach - nvarchar(10)
    5,    -- SLBan - int
    N'1',  -- KhuyenMai - nvarchar(100)
    NULL, -- ThanhTien - money
    NULL  -- DonGia - money
    )


DROP TRIGGER cau5
-- view, ham, thu tuc, phan quyen


-- Câu 6: Thêm trường tổng tiền cho hóa đơn bán, cập nhật tự động cho trường này mỗi khi thêm, xóa, xửa 
-- chi tiết hóa đơn bán
ALTER TABLE dbo.tHoaDonBan
ADD tongtien INT

CREATE TRIGGER cau6 ON tChiTietHDB
FOR INSERT, UPDATE, DELETE AS 
BEGIN
	DECLARE @inmahdb NVARCHAR(10), @demahdb NVARCHAR(10), @intien INT, @detien INT
	SELECT @inmahdb = Inserted.SoHDB, @intien = SLBan * tSach.DonGiaBan FROM Inserted JOIN dbo.tSach 
		ON Inserted.maSach = dbo.tSach.MaSach
	SELECT @inmahdb = Deleted.SoHDB, @detien = SLBan * tSach.DonGiaBan FROM Deleted JOIN dbo.tSach 
		ON Deleted.maSach = dbo.tSach.MaSach
	update dbo.tHoaDonBan SET tongtien = ISNULL(tongtien, 0) + ISNULL(@intien, 0) - ISNULL(@detien, 0)
	WHERE SoHDB = ISNULL(@inmahdb, @demahdb)
END

DROP TRIGGER cau6