CREATE DATABASE BTL_NHOM3_QLBanSach

CREATE TABLE tChucVu (
	MaChucVu NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tChucVu_MaChucVu PRIMARY KEY,
	TenChucVu NVARCHAR(20)
);

CREATE TABLE tNhanVien (
	MaNhanVien NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tNhanVien_MaNhanVien PRIMARY KEY,
	TenNhanVien NVARCHAR(20),
	GioiTinh BIT,
	NgaySinh DATE,
	SDT NVARCHAR(11),
	DiaChi NVARCHAR(30),
	MaChucVu NVARCHAR(15) NOT NULL
	CONSTRAINT FK_tNhanVien_MaChucVu FOREIGN KEY(MaChucVu) REFERENCES tChucVu(MaChucVu)
);

CREATE TABLE tKhachHang (
	MaKhachHang NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tKhachHang_MaKhachHang PRIMARY KEY,
	TenKhachHang NVARCHAR(20),
	SDT NVARCHAR(11),
	Email NVARCHAR(30),
	DiaChi NVARCHAR(30)
);

CREATE TABLE tTheLoai (
	MaTheLoai NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tTheLoai_MaTheLoai PRIMARY KEY,
	TenTheLoai NVARCHAR(20)
);

CREATE TABLE tNhaXuatBan (
	MaNXB NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tNhaXuatBan_MaNXB PRIMARY KEY,
	TenNXB NVARCHAR(20),
	Email NVARCHAR(30),
	DiaChi NVARCHAR(50)
);

CREATE TABLE tSach (
	MaSach NVARCHAR(15) NOT NULL
	CONSTRAINT PK_tSach_MaSach PRIMARY KEY,
	TenSach NVARCHAR(20),
	TacGia NVARCHAR(20),
	MaNXB NVARCHAR(15) NOT NULL,
	MaTheLoai NVARCHAR(15) NOT NULL,
	TenDichGia NVARCHAR(20),
	SoTrang INT,
	KhoSach VARCHAR(20),
	NgayPhatHanh DATE,
	SoLuong INT,
	DonGiaBan MONEY,
	DonGiaNhap MONEY,
	CONSTRAINT FK_tSach_MaNXB
				FOREIGN KEY(MaNXB)
				REFERENCES tNhaXuatBan(MaNXB),
	CONSTRAINT FK_tSach_MaTheLoai
				FOREIGN KEY(MaTheLoai) 
				REFERENCES tTheLoai(MaTheLoai),
);

CREATE TABLE tHoaDonBan (
	MaHDB NVARCHAR(15) NOT NULL
	CONSTRAINT PK_HoaDonBan_MaHDB PRIMARY KEY,
	MaNhanVien NVARCHAR(15) NOT NULL,
	MaKhachHang NVARCHAR(15) NOT NULL,
	NgayBan DATE,
	TongTien MONEY,
	CONSTRAINT FK_tHoaDonBan_MaNhanVien
				FOREIGN KEY(MaNhanVien)
				REFERENCES tNhanVien(MaNhanVien),
	CONSTRAINT FK_tHoaDonBan_MaKhachHang
				FOREIGN KEY(MaKhachHang) 
				REFERENCES tKhachHang(MaKhachHang),
);

create table tNhaCungCap(
	MaNCC NVARCHAR(15) NOT NULL
	CONSTRAINT PK_NhaCungCap_MaNCC PRIMARY KEY,
	TenNCC NVARCHAR(20)
);

CREATE TABLE tChiTietHoaDonBan (
	MaHDB NVARCHAR(15) NOT NULL,
	MaSach NVARCHAR(15) NOT NULL,
	SoLuong INT,
	DonGiaBan MONEY,
	GiamGia FLOAT,
	ThanhTien MONEY,
	CONSTRAINT PK_tChiTietHoaDonBan PRIMARY KEY(MaHDB, MaSach),
	CONSTRAINT FK_tChiTietHoaDonBan_MaHoaDon
				FOREIGN KEY(MaHDB)
				REFERENCES tHoaDonBan(MaHDB),
	CONSTRAINT FK_tChiTietHoaDonBan_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);

CREATE TABLE tHoaDonNhap (
	MaHDN NVARCHAR(15) NOT NULL 
	CONSTRAINT PK_tHoaDonNhap_MaHDN PRIMARY KEY,
	MaNhanVien NVARCHAR(15) NOT NULL,
	NgayNhap DATE,
	DonGiaNhap MONEY,
	TongTien MONEY,
	MaNCC NVARCHAR(15),
	CONSTRAINT FK_tHoaDonNhap_MaNCC
				FOREIGN KEY(MaNCC)
				REFERENCES tNhaCungCap(MaNCC),
	CONSTRAINT FK_tHoaDonNhap_MaNhanVien
			FOREIGN KEY(MaNhanVien)
			REFERENCES tNhanVien(MaNhanVien)

);

CREATE TABLE tChiTietHoaDonNhap (
	MaHDN NVARCHAR(15) NOT NULL,
	MaSach NVARCHAR(15) NOT NULL,
	SoLuong INT,
	DonGiaNhap MONEY,
	GiamGia FLOAT,
	ThanhTien MONEY,
	CONSTRAINT PK_tChiTietHoaDonNhap PRIMARY KEY(MaHDN, MaSach),
	CONSTRAINT FK_tChiTietHoaDonNhap_MaHDN
				FOREIGN KEY(MaHDN)
				REFERENCES tHoaDonNhap(MaHDN),
	CONSTRAINT FK_tChiTietHoaDonNhap_MaSach 
				FOREIGN KEY(MaSach) 
				REFERENCES tSach(MaSach)
);


/*Thêm dữ liệu vào bảng chi tiết hóa đơn bán*/
INSERT INTO dbo.tChiTietHoaDonBan
(
    MaHDB,
    MaSach,
    SoLuong,
    DonGiaBan,
    GiamGia,
    ThanhTien
)
VALUES
(   N'HDB01',  -- MaHDB - nvarchar(15)
    N'S01',  -- MaSach - nvarchar(15)
    10,    -- SoLuong - int
    0, -- DonGiaBan - money
    10.0,  -- GiamGia - float
    NULL  -- ThanhTien - money
    )

/*Thêm dữ liệu vào bảng thể loại */
INSERT dbo.tTheLoai
(
    MaTheLoai,
    TenTheLoai
)
VALUES
(   N'TL01', -- MaTheLoai - nvarchar(15)
    N'Tiểu thuyết'  -- TenTheLoai - nvarchar(20)
    )
GO

/*Thêm dữ liệu vào bảng nhà xuất bản */
INSERT dbo.tNhaXuatBan
(
    MaNXB,
    TenNXB,
    Email,
    DiaChi
)
VALUES
(   N'NXB01', -- MaNXB - nvarchar(15)
    N'NXB Trẻ', -- TenNXB - nvarchar(20)
    N'tre@gmail.com', -- Email - nvarchar(15)
    N'Hà Nội'  -- DiaChi - nvarchar(50)
    )
GO

/*Thêm dữ liệu vào bảng sách */
INSERT dbo.tSach
(
    MaSach,
    TenSach,
    TacGia,
    MaNXB,
    MaTheLoai,
    TenDichGia,
    SoTrang,
    KhoSach,
    NgayPhatHanh,
    SoLuong,
    DonGiaBan,
    DonGiaNhap
)
VALUES
(   N'S01',       -- MaSach - nvarchar(15)
	N'Cha giàu cha nghèo', 
    N'Robert T.Kiyosaki',       -- TacGia - nvarchar(20)
    N'NXB01',       -- MaNXB - nvarchar(15)
    N'TL01',       -- MaTheLoai - nvarchar(15)
    N'Tạ Nguyễn Tấn Trương',       -- TenDichGia - nvarchar(20)
    414,         -- SoTrang - int
    '14x20cm',        -- KhoSach - varchar(20)
    '2010-09-12', -- NgayPhatHanh - date
    100,         -- SoLuong - int
    145000,      -- DonGiaBan - money
    120000       -- DonGiaNhap - money
    )
GO

/*Thêm dữ liệu vào nhân viên*/
INSERT INTO dbo.tChucVu
(
    MaChucVu,
    TenChucVu
)
VALUES
(   N'CV01', -- MaChucVu - nvarchar(15)
    N'Nhân viên'  -- TenChucVu - nvarchar(20)
    ),
(   N'CV02', -- MaChucVu - nvarchar(15)
    N'Quản lý'  -- TenChucVu - nvarchar(20)
    )

/*Thêm dữ liệu vào nhân viên*/
INSERT INTO dbo.tNhanVien
(
    MaNhanVien,
    TenNhanVien,
    GioiTinh,
    NgaySinh,
    SDT,
    DiaChi,
    MaChucVu
)
VALUES
(   N'NV01',       -- MaNhanVien - nvarchar(15)
    N'Nguyễn Việt Anh',       -- TenNhanVien - nvarchar(20)
    1,      -- GioiTinh - bit
    '2002-01-01', -- NgaySinh - date
    N'0987654321',       -- SDT - nvarchar(11)
    N'Hà Nội',       -- DiaChi - nvarchar(30)
    N'CV02'        -- MaChucVu - nvarchar(15)
    ),
(   N'NV02',       -- MaNhanVien - nvarchar(15)
    N'Phan Văn Thường',       -- TenNhanVien - nvarchar(20)
    0,      -- GioiTinh - bit
    '2002-01-02', -- NgaySinh - date
    N'099999999',       -- SDT - nvarchar(11)
    N'Hà Nội',       -- DiaChi - nvarchar(30)
    N'CV01'        -- MaChucVu - nvarchar(15)
    )
GO

/*Thêm dữ liệu vào bảng khách hàng*/
INSERT INTO dbo.tKhachHang
(
    MaKhachHang,
    TenKhachHang,
    SDT,
    Email,
    DiaChi
)
VALUES
(   N'KH01', -- MaKhachHang - nvarchar(15)
    N'Trần Huy Hiệp', -- TenKhachHang - nvarchar(20)
    N'0912421088', -- SDT - nvarchar(11)
    N'hi@gmail.com', -- Email - nvarchar(15)
    N'Hà Giang'  -- DiaChi - nvarchar(30)
    )

/*Thêm dữ liệu vào hóa đơn bán*/
INSERT INTO dbo.tHoaDonBan
(
    MaHDB,
    MaNhanVien,
    MaKhachHang,
    NgayBan,
    TongTien
)
VALUES
(   N'HDB01',       -- MaHDB - nvarchar(15)
    N'NV01',       -- MaNhanVien - nvarchar(15)
    N'KH01',       -- MaKhachHang - nvarchar(15)
    '2022-10-30', -- NgayBan - date
    NULL       -- TongTien - money
    )
GO


SELECT * FROM dbo.tHoaDonBan
SELECT * FROM dbo.tChiTietHoaDonBan
SELECT * FROM dbo.tSach
